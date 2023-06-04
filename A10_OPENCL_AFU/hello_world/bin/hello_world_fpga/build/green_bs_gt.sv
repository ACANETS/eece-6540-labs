// ***************************************************************************
// Copyright (c) 2013-2017, Intel Corporation
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// * Neither the name of Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// ***************************************************************************

`include "fpga_defines.vh"

//
// platform_if.vh defines many required components, including both top-level
// SystemVerilog interfaces and the platform/AFU configuration parameters
// required to match the interfaces offered by the platform to the needs
// of the AFU.
//
// Most preprocessor variables used in this file come from this.
//
`include "platform_if.vh"

`ifdef INCLUDE_ETHERNET
`include "pr_hssi_if.vh"
`endif
parameter CCIP_TXPORT_WIDTH = $bits(t_if_ccip_Tx);  // TODO: Move this to ccip_if_pkg
parameter CCIP_RXPORT_WIDTH = $bits(t_if_ccip_Rx);  // TODO: Move this to ccip_if_pkg

`ifndef OPENCL_MEMORY_ADDR_WIDTH
`define OPENCL_MEMORY_ADDR_WIDTH 26
`endif

module green_bs
(
    // CCI-P Interface
    input   logic                         Clk_400,             // Core clock. CCI interface is synchronous to this clock.
    input   logic                         Clk_200,             // Core clock. CCI interface is synchronous to this clock.
    input   logic                         Clk_100,             // Core clock. CCI interface is synchronous to this clock.
    input   logic                         uClk_usr,
    input   logic                         uClk_usrDiv2,
    input   logic                         SoftReset,           // CCI interface reset. The Accelerator IP must use this Reset. ACTIVE HIGH
    input   logic [1:0]                   pck_cp2af_pwrState,
    input   logic                         pck_cp2af_error,
    output  logic [CCIP_TXPORT_WIDTH-1:0] bus_ccip_Tx,         // CCI-P TX port
    input   logic [CCIP_RXPORT_WIDTH-1:0] bus_ccip_Rx,         // CCI-P RX port

`ifdef INCLUDE_DDR4
    input  logic                          DDR4a_USERCLK,
    input  logic                          DDR4a_waitrequest,
    input  logic [511:0]                  DDR4a_readdata,
    input  logic                          DDR4a_readdatavalid,
    output logic [6:0]                    DDR4a_burstcount,
    output logic [511:0]                  DDR4a_writedata,
    output logic [26:0]                   DDR4a_address,
    output logic                          DDR4a_write,
    output logic                          DDR4a_read,
    output logic [63:0]                   DDR4a_byteenable,
    input  logic                          DDR4b_USERCLK,
    input  logic                          DDR4b_waitrequest,
    input  logic [511:0]                  DDR4b_readdata,
    input  logic                          DDR4b_readdatavalid,
    output logic [6:0]                    DDR4b_burstcount,
    output logic [511:0]                  DDR4b_writedata,
    output logic [26:0]                   DDR4b_address,
    output logic                          DDR4b_write,
    output logic                          DDR4b_read,
    output logic [63:0]                   DDR4b_byteenable,
`endif

`ifdef INCLUDE_ETHERNET
    pr_hssi_if.to_fiu              hssi,
`endif // INCLUDE_ETHERNET

    // BIP Interface - unused in the OpenCL BSP
    input                 tcm_mmio_clk,
    input                 tcm_mmio_rst_n,
    input       [8:0]     tcm_mmio_address,
    input                 tcm_mmio_rd,
    input                 tcm_mmio_wr,
    output                tcm_mmio_waitreq,
    input      [31:0]     tcm_mmio_writedata,
    output     [31:0]     tcm_mmio_readdata,
    output                tcm_mmio_readdatavalid,

    // JTAG Interface for PR region debug
    input   logic            sr2pr_tms,
    input   logic            sr2pr_tdi,
    output  logic            pr2sr_tdo,
    input   logic            sr2pr_tck,
    input   logic            sr2pr_tckena
);

  wire                      board_kernel_reset_reset_n;
  wire [0:0]                board_kernel_irq_irq;
  wire                      board_kernel_cra_waitrequest;
  wire [63:0]               board_kernel_cra_readdata;
  wire                      board_kernel_cra_readdatavalid;
  wire [0:0]                board_kernel_cra_burstcount;
  wire [63:0]               board_kernel_cra_writedata;
  wire [29:0]               board_kernel_cra_address;
  wire                      board_kernel_cra_write;
  wire                      board_kernel_cra_read;
  wire [7:0]                board_kernel_cra_byteenable;
  wire                      board_kernel_cra_debugaccess;
  
  wire [`OPENCL_MEMORY_ADDR_WIDTH+6:0] acl_internal_snoop_data;
  wire                      acl_internal_snoop_valid;
  wire                      acl_internal_snoop_ready;
  
  wire                      kernel_ddr4a_waitrequest;
  wire [511:0]              kernel_ddr4a_readdata;
  wire                      kernel_ddr4a_readdatavalid;
  wire [4:0]                kernel_ddr4a_burstcount;
  wire [511:0]              kernel_ddr4a_writedata;
  wire [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4a_address;
  wire                      kernel_ddr4a_write;
  wire                      kernel_ddr4a_read;
  wire [63:0]               kernel_ddr4a_byteenable;
  wire                      kernel_ddr4a_debugaccess;
    
  wire                      kernel_ddr4b_waitrequest;
  wire [511:0]              kernel_ddr4b_readdata;
  wire                      kernel_ddr4b_readdatavalid;
  wire [4:0]                kernel_ddr4b_burstcount;
  wire [511:0]              kernel_ddr4b_writedata;
  wire [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4b_address;
  wire                      kernel_ddr4b_write;
  wire                      kernel_ddr4b_read;
  wire [63:0]               kernel_ddr4b_byteenable;
  wire                      kernel_ddr4b_debugaccess;

  bsp_interface #(
        .CCIP_TXPORT_WIDTH(CCIP_TXPORT_WIDTH),
        .CCIP_RXPORT_WIDTH(CCIP_RXPORT_WIDTH)
    ) bsp_interface_inst (
    .Clk_400            (Clk_400),
    .Clk_200            (Clk_200),
    .Clk_100            (Clk_100),
    .uClk_usr           (uClk_usr),
    .uClk_usrDiv2       (uClk_usrDiv2),
    .SoftReset          (SoftReset),
    .pck_cp2af_pwrState (pck_cp2af_pwrState),
    .pck_cp2af_error    (pck_cp2af_error),
    .bus_ccip_Tx        (bus_ccip_Tx),
    .bus_ccip_Rx        (bus_ccip_Rx),

`ifdef INCLUDE_DDR4
    .DDR4a_USERCLK          (DDR4a_USERCLK),
    .DDR4a_waitrequest      (DDR4a_waitrequest),
    .DDR4a_readdata         (DDR4a_readdata),
    .DDR4a_readdatavalid    (DDR4a_readdatavalid),
    .DDR4a_burstcount       (DDR4a_burstcount),
    .DDR4a_writedata        (DDR4a_writedata),
    .DDR4a_address          (DDR4a_address),
    .DDR4a_write            (DDR4a_write),
    .DDR4a_read             (DDR4a_read),
    .DDR4a_byteenable       (DDR4a_byteenable),
    .DDR4b_USERCLK          (DDR4b_USERCLK),
    .DDR4b_waitrequest      (DDR4b_waitrequest),
    .DDR4b_readdata         (DDR4b_readdata),
    .DDR4b_readdatavalid    (DDR4b_readdatavalid),
    .DDR4b_burstcount       (DDR4b_burstcount),
    .DDR4b_writedata        (DDR4b_writedata),
    .DDR4b_address          (DDR4b_address),
    .DDR4b_write            (DDR4b_write),
    .DDR4b_read             (DDR4b_read),
    .DDR4b_byteenable       (DDR4b_byteenable),
`endif

`ifdef INCLUDE_ETHERNET
    .hssi               (hssi),
`endif

   // JTAG Interface for PR region debug
   .sr2pr_tms           (sr2pr_tms),
   .sr2pr_tdi           (sr2pr_tdi),
   .pr2sr_tdo           (pr2sr_tdo),
   .sr2pr_tck           (sr2pr_tck),
   .sr2pr_tckena        (sr2pr_tckena),

  // to OpenCL kernel logic
  .board_kernel_reset_reset_n   (board_kernel_reset_reset_n),
  .board_kernel_irq_irq         (board_kernel_irq_irq),

  .board_kernel_cra_waitrequest     (board_kernel_cra_waitrequest),
  .board_kernel_cra_readdata        (board_kernel_cra_readdata),
  .board_kernel_cra_readdatavalid   (board_kernel_cra_readdatavalid),
  .board_kernel_cra_burstcount      (board_kernel_cra_burstcount),
  .board_kernel_cra_writedata       (board_kernel_cra_writedata),
  .board_kernel_cra_address         (board_kernel_cra_address),
  .board_kernel_cra_write           (board_kernel_cra_write),
  .board_kernel_cra_read            (board_kernel_cra_read),
  .board_kernel_cra_byteenable      (board_kernel_cra_byteenable),
  .board_kernel_cra_debugaccess     (board_kernel_cra_debugaccess),
        
  .acl_internal_snoop_data      (acl_internal_snoop_data),
  .acl_internal_snoop_valid     (acl_internal_snoop_valid),
  .acl_internal_snoop_ready     (acl_internal_snoop_ready),

  .kernel_ddr4a_waitrequest     (kernel_ddr4a_waitrequest),
  .kernel_ddr4a_readdata        (kernel_ddr4a_readdata),
  .kernel_ddr4a_readdatavalid   (kernel_ddr4a_readdatavalid),
  .kernel_ddr4a_burstcount      (kernel_ddr4a_burstcount),
  .kernel_ddr4a_writedata       (kernel_ddr4a_writedata),
  .kernel_ddr4a_address         (kernel_ddr4a_address),
  .kernel_ddr4a_write           (kernel_ddr4a_write),
  .kernel_ddr4a_read            (kernel_ddr4a_read),
  .kernel_ddr4a_byteenable      (kernel_ddr4a_byteenable),
  .kernel_ddr4a_debugaccess     (kernel_ddr4a_debugaccess),
        
  .kernel_ddr4b_waitrequest     (kernel_ddr4b_waitrequest),
  .kernel_ddr4b_readdata        (kernel_ddr4b_readdata),
  .kernel_ddr4b_readdatavalid   (kernel_ddr4b_readdatavalid),
  .kernel_ddr4b_burstcount      (kernel_ddr4b_burstcount),
  .kernel_ddr4b_writedata       (kernel_ddr4b_writedata),
  .kernel_ddr4b_address         (kernel_ddr4b_address),
  .kernel_ddr4b_write           (kernel_ddr4b_write),
  .kernel_ddr4b_read            (kernel_ddr4b_read),
  .kernel_ddr4b_byteenable      (kernel_ddr4b_byteenable),
  .kernel_ddr4b_debugaccess     (kernel_ddr4b_debugaccess)
  );

  freeze_wrapper freeze_wrapper_inst (
    .board_kernel_clk_clk               (uClk_usrDiv2),
    .board_kernel_clk2x_clk             (uClk_usr),
    .board_kernel_reset_reset_n         (board_kernel_reset_reset_n),
    .board_kernel_irq_irq               (board_kernel_irq_irq),
    .board_kernel_cra_waitrequest       (board_kernel_cra_waitrequest),
    .board_kernel_cra_readdata          (board_kernel_cra_readdata),
    .board_kernel_cra_readdatavalid     (board_kernel_cra_readdatavalid),
    .board_kernel_cra_burstcount        (board_kernel_cra_burstcount),
    .board_kernel_cra_writedata         (board_kernel_cra_writedata),
    .board_kernel_cra_address           (board_kernel_cra_address),
    .board_kernel_cra_write             (board_kernel_cra_write),
    .board_kernel_cra_read              (board_kernel_cra_read),
    .board_kernel_cra_byteenable        (board_kernel_cra_byteenable),
    .board_kernel_cra_debugaccess       (board_kernel_cra_debugaccess),
    
    .acl_internal_snoop_data            (acl_internal_snoop_data),
    .acl_internal_snoop_valid           (acl_internal_snoop_valid),
    .acl_internal_snoop_ready           (acl_internal_snoop_ready),
    
    .kernel_ddr4a_waitrequest           (kernel_ddr4a_waitrequest),
    .kernel_ddr4a_readdata              (kernel_ddr4a_readdata),
    .kernel_ddr4a_readdatavalid         (kernel_ddr4a_readdatavalid),
    .kernel_ddr4a_burstcount            (kernel_ddr4a_burstcount),
    .kernel_ddr4a_writedata             (kernel_ddr4a_writedata),
    .kernel_ddr4a_address               (kernel_ddr4a_address),
    .kernel_ddr4a_write                 (kernel_ddr4a_write),
    .kernel_ddr4a_read                  (kernel_ddr4a_read),
    .kernel_ddr4a_byteenable            (kernel_ddr4a_byteenable),
    .kernel_ddr4a_debugaccess           (kernel_ddr4a_debugaccess),
        
    .kernel_ddr4b_waitrequest           (kernel_ddr4b_waitrequest),
    .kernel_ddr4b_readdata              (kernel_ddr4b_readdata),
    .kernel_ddr4b_readdatavalid         (kernel_ddr4b_readdatavalid),
    .kernel_ddr4b_burstcount            (kernel_ddr4b_burstcount),
    .kernel_ddr4b_writedata             (kernel_ddr4b_writedata),
    .kernel_ddr4b_address               (kernel_ddr4b_address),
    .kernel_ddr4b_write                 (kernel_ddr4b_write),
    .kernel_ddr4b_read                  (kernel_ddr4b_read),
    .kernel_ddr4b_byteenable            (kernel_ddr4b_byteenable),
    .kernel_ddr4b_debugaccess           (kernel_ddr4b_debugaccess)
  );

endmodule : green_bs
