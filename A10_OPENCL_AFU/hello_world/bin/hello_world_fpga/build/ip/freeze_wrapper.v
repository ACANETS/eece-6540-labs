// ***************************************************************************
// Copyright (c) 2019, Intel Corporation
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

`ifndef OPENCL_MEMORY_ADDR_WIDTH
`define OPENCL_MEMORY_ADDR_WIDTH 26
`endif

module freeze_wrapper(

    input         freeze,
    
    //////// board ports //////////
    input             board_kernel_clk_clk,
    input             board_kernel_clk2x_clk,
    input             board_kernel_reset_reset_n,
    output [0:0]      board_kernel_irq_irq,
    output            board_kernel_cra_waitrequest,
    output [63:0]     board_kernel_cra_readdata,
    output            board_kernel_cra_readdatavalid,
    input   [0:0]     board_kernel_cra_burstcount,
    input  [63:0]     board_kernel_cra_writedata,
    input  [29:0]     board_kernel_cra_address,
    input             board_kernel_cra_write,
    input             board_kernel_cra_read,
    input   [7:0]     board_kernel_cra_byteenable,
    input             board_kernel_cra_debugaccess,
    
    input   [`OPENCL_MEMORY_ADDR_WIDTH+6:0] acl_internal_snoop_data,
    input             acl_internal_snoop_valid,
    output            acl_internal_snoop_ready,
    
    input             kernel_ddr4a_waitrequest,
    input   [511:0]   kernel_ddr4a_readdata,
    input             kernel_ddr4a_readdatavalid,
    output  [4:0]     kernel_ddr4a_burstcount,
    output  [511:0]   kernel_ddr4a_writedata,
    output  [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4a_address,
    output            kernel_ddr4a_write,
    output            kernel_ddr4a_read,
    output  [63:0]    kernel_ddr4a_byteenable,
    output            kernel_ddr4a_debugaccess,
    
    input             kernel_ddr4b_waitrequest,
    input   [511:0]   kernel_ddr4b_readdata,
    input             kernel_ddr4b_readdatavalid,
    output  [4:0]     kernel_ddr4b_burstcount,
    output  [511:0]   kernel_ddr4b_writedata,
    output  [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4b_address,
    output            kernel_ddr4b_write,
    output            kernel_ddr4b_read,
    output  [63:0]    kernel_ddr4b_byteenable,
    output            kernel_ddr4b_debugaccess
);

wire kernel_system_kernel_irq_irq;
wire kernel_system_kernel_cra_waitrequest;
wire kernel_system_kernel_cra_readdatavalid;

assign board_kernel_irq_irq             = kernel_system_kernel_irq_irq;
assign board_kernel_cra_waitrequest     = kernel_system_kernel_cra_waitrequest;
assign board_kernel_cra_readdatavalid   = kernel_system_kernel_cra_readdatavalid;

// Signals not used
assign kernel_ddr4a_debugaccess = 1'b0;
assign kernel_ddr4b_debugaccess = 1'b0;

//=======================================================
//  pr_region instantiation
//=======================================================
pr_region pr_region_inst (
    .clock_reset_clk(board_kernel_clk_clk),
    .clock_reset2x_clk(board_kernel_clk2x_clk),
    .clock_reset_reset_reset_n(board_kernel_reset_reset_n),
    .kernel_irq_irq(kernel_system_kernel_irq_irq),
    .kernel_cra_waitrequest(kernel_system_kernel_cra_waitrequest),
    .kernel_cra_readdata(board_kernel_cra_readdata),
    .kernel_cra_readdatavalid(kernel_system_kernel_cra_readdatavalid),
    .kernel_cra_burstcount(board_kernel_cra_burstcount),
    .kernel_cra_writedata(board_kernel_cra_writedata),
    .kernel_cra_address(board_kernel_cra_address),
    .kernel_cra_write(board_kernel_cra_write),
    .kernel_cra_read(board_kernel_cra_read),
    .kernel_cra_byteenable(board_kernel_cra_byteenable),
    .kernel_cra_debugaccess(board_kernel_cra_debugaccess),
  
    .acl_internal_snoop_data(acl_internal_snoop_data),
    .acl_internal_snoop_valid(acl_internal_snoop_valid),
    .acl_internal_snoop_ready(acl_internal_snoop_ready),
    
    .kernel_ddr4a_waitrequest(kernel_ddr4a_waitrequest),
    .kernel_ddr4a_readdata(kernel_ddr4a_readdata),
    .kernel_ddr4a_readdatavalid(kernel_ddr4a_readdatavalid),
    .kernel_ddr4a_burstcount(kernel_ddr4a_burstcount),
    .kernel_ddr4a_writedata(kernel_ddr4a_writedata),
    .kernel_ddr4a_address(kernel_ddr4a_address),
    .kernel_ddr4a_write(kernel_ddr4a_write),
    .kernel_ddr4a_read(kernel_ddr4a_read),
    .kernel_ddr4a_byteenable(kernel_ddr4a_byteenable),
    
    .kernel_ddr4b_waitrequest(kernel_ddr4b_waitrequest),
    .kernel_ddr4b_readdata(kernel_ddr4b_readdata),
    .kernel_ddr4b_readdatavalid(kernel_ddr4b_readdatavalid),
    .kernel_ddr4b_burstcount(kernel_ddr4b_burstcount),
    .kernel_ddr4b_writedata(kernel_ddr4b_writedata),
    .kernel_ddr4b_address(kernel_ddr4b_address),
    .kernel_ddr4b_write(kernel_ddr4b_write),
    .kernel_ddr4b_read(kernel_ddr4b_read),
    .kernel_ddr4b_byteenable(kernel_ddr4b_byteenable)
);

endmodule
