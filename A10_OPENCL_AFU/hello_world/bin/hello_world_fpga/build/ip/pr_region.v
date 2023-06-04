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

// kernel wrapper
// This is the PR boundary ports for kernel
// using kernel wrapper instead of kernel_system, since kernel_system is auto generated
// kernel_system introduces boundary ports that are not used, and in PR, it gets preserved

`ifndef OPENCL_MEMORY_ADDR_WIDTH
`define OPENCL_MEMORY_ADDR_WIDTH 26
`endif

module pr_region(
  input	      	clock_reset_clk,
  input	        clock_reset2x_clk,
  input        	clock_reset_reset_reset_n,
  output        kernel_irq_irq,
  output        kernel_cra_waitrequest,
  output [63:0] kernel_cra_readdata,
  output        kernel_cra_readdatavalid,
  input   [0:0] kernel_cra_burstcount,
  input  [63:0] kernel_cra_writedata,
  input  [29:0] kernel_cra_address,
  input         kernel_cra_write,
  input         kernel_cra_read,
  input   [7:0] kernel_cra_byteenable,
  input         kernel_cra_debugaccess,
  
  input	[`OPENCL_MEMORY_ADDR_WIDTH+6:0]	acl_internal_snoop_data,
  input		acl_internal_snoop_valid,
  output	acl_internal_snoop_ready,
  
  input		kernel_ddr4a_waitrequest,
  input	[511:0]	kernel_ddr4a_readdata,
  input		kernel_ddr4a_readdatavalid,
  output [4:0]	kernel_ddr4a_burstcount,
  output [511:0] kernel_ddr4a_writedata,
  output [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4a_address,
  output	kernel_ddr4a_write,
  output	kernel_ddr4a_read,
  output [63:0]	kernel_ddr4a_byteenable,

  input		kernel_ddr4b_waitrequest,
  input	[511:0]	kernel_ddr4b_readdata,
  input		kernel_ddr4b_readdatavalid,
  output [4:0]	kernel_ddr4b_burstcount,
  output [511:0] kernel_ddr4b_writedata,
  output [`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] kernel_ddr4b_address,
  output	kernel_ddr4b_write,
  output	kernel_ddr4b_read,
  output [63:0]	kernel_ddr4b_byteenable
);

  wire          pipelined_kernel_ddr4a_s0_waitrequest;
  wire  [511:0] pipelined_kernel_ddr4a_s0_readdata;
  wire          pipelined_kernel_ddr4a_s0_readdatavalid;
  wire    [4:0] pipelined_kernel_ddr4a_s0_burstcount;
  wire  [511:0] pipelined_kernel_ddr4a_s0_writedata;
  wire 	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] pipelined_kernel_ddr4a_s0_address;
  wire          pipelined_kernel_ddr4a_s0_write;
  wire          pipelined_kernel_ddr4a_s0_read;
  wire   [63:0] pipelined_kernel_ddr4a_s0_byteenable;

  wire          pipelined_kernel_ddr4a_s1_waitrequest;
  wire  [511:0] pipelined_kernel_ddr4a_s1_readdata;
  wire          pipelined_kernel_ddr4a_s1_readdatavalid;
  wire    [4:0] pipelined_kernel_ddr4a_s1_burstcount;
  wire  [511:0] pipelined_kernel_ddr4a_s1_writedata;
  wire 	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] pipelined_kernel_ddr4a_s1_address;
  wire          pipelined_kernel_ddr4a_s1_write;
  wire          pipelined_kernel_ddr4a_s1_read;
  wire   [63:0] pipelined_kernel_ddr4a_s1_byteenable;

  wire          pipelined_kernel_ddr4b_s0_waitrequest;
  wire  [511:0] pipelined_kernel_ddr4b_s0_readdata;
  wire          pipelined_kernel_ddr4b_s0_readdatavalid;
  wire    [4:0] pipelined_kernel_ddr4b_s0_burstcount;
  wire  [511:0] pipelined_kernel_ddr4b_s0_writedata;
  wire 	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] pipelined_kernel_ddr4b_s0_address;
  wire          pipelined_kernel_ddr4b_s0_write;
  wire          pipelined_kernel_ddr4b_s0_read;
  wire   [63:0] pipelined_kernel_ddr4b_s0_byteenable;
  
  wire          pipelined_kernel_ddr4b_s1_waitrequest;
  wire  [511:0] pipelined_kernel_ddr4b_s1_readdata;
  wire          pipelined_kernel_ddr4b_s1_readdatavalid;
  wire    [4:0] pipelined_kernel_ddr4b_s1_burstcount;
  wire  [511:0] pipelined_kernel_ddr4b_s1_writedata;
  wire 	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0] pipelined_kernel_ddr4b_s1_address;
  wire          pipelined_kernel_ddr4b_s1_write;
  wire          pipelined_kernel_ddr4b_s1_read;
  wire   [63:0] pipelined_kernel_ddr4b_s1_byteenable;

//=======================================================
//  kernel_ddr4a pipeline stage instantiation
//=======================================================
kernel_mem_mm_bridge kernel_ddr4a_inst_stage1(
  .clk(clock_reset_clk), 
  .m0_waitrequest(kernel_ddr4a_waitrequest),
  .m0_readdata(kernel_ddr4a_readdata),
  .m0_readdatavalid(kernel_ddr4a_readdatavalid),
  .m0_burstcount(kernel_ddr4a_burstcount),
  .m0_writedata(kernel_ddr4a_writedata),
  .m0_address(kernel_ddr4a_address),
  .m0_write(kernel_ddr4a_write),
  .m0_read(kernel_ddr4a_read),
  .m0_byteenable(kernel_ddr4a_byteenable),
  .reset(~clock_reset_reset_reset_n),
  .s0_waitrequest(pipelined_kernel_ddr4a_s1_waitrequest),
  .s0_readdata(pipelined_kernel_ddr4a_s1_readdata),
  .s0_readdatavalid(pipelined_kernel_ddr4a_s1_readdatavalid),
  .s0_burstcount(pipelined_kernel_ddr4a_s1_burstcount),
  .s0_writedata(pipelined_kernel_ddr4a_s1_writedata),
  .s0_address(pipelined_kernel_ddr4a_s1_address),
  .s0_write(pipelined_kernel_ddr4a_s1_write),
  .s0_read(pipelined_kernel_ddr4a_s1_read),
  .s0_byteenable(pipelined_kernel_ddr4a_s1_byteenable)
);
kernel_mem_mm_bridge kernel_ddr4a_inst_stage0(
  .clk(clock_reset_clk), 
  .m0_waitrequest(pipelined_kernel_ddr4a_s1_waitrequest),
  .m0_readdata(pipelined_kernel_ddr4a_s1_readdata),
  .m0_readdatavalid(pipelined_kernel_ddr4a_s1_readdatavalid),
  .m0_burstcount(pipelined_kernel_ddr4a_s1_burstcount),
  .m0_writedata(pipelined_kernel_ddr4a_s1_writedata),
  .m0_address(pipelined_kernel_ddr4a_s1_address),
  .m0_write(pipelined_kernel_ddr4a_s1_write),
  .m0_read(pipelined_kernel_ddr4a_s1_read),
  .m0_byteenable(pipelined_kernel_ddr4a_s1_byteenable),
  .reset(~clock_reset_reset_reset_n),
  .s0_waitrequest(pipelined_kernel_ddr4a_s0_waitrequest),
  .s0_readdata(pipelined_kernel_ddr4a_s0_readdata),
  .s0_readdatavalid(pipelined_kernel_ddr4a_s0_readdatavalid),
  .s0_burstcount(pipelined_kernel_ddr4a_s0_burstcount),
  .s0_writedata(pipelined_kernel_ddr4a_s0_writedata),
  .s0_address(pipelined_kernel_ddr4a_s0_address),
  .s0_write(pipelined_kernel_ddr4a_s0_write),
  .s0_read(pipelined_kernel_ddr4a_s0_read),
  .s0_byteenable(pipelined_kernel_ddr4a_s0_byteenable)
);

//=======================================================
//  kernel_ddr4b pipeline stage instantiation
//=======================================================
kernel_mem_mm_bridge kernel_ddr4b_inst_stage1(
  .clk(clock_reset_clk), 
  .m0_waitrequest(kernel_ddr4b_waitrequest),
  .m0_readdata(kernel_ddr4b_readdata),
  .m0_readdatavalid(kernel_ddr4b_readdatavalid),
  .m0_burstcount(kernel_ddr4b_burstcount),
  .m0_writedata(kernel_ddr4b_writedata),
  .m0_address(kernel_ddr4b_address),
  .m0_write(kernel_ddr4b_write),
  .m0_read(kernel_ddr4b_read),
  .m0_byteenable(kernel_ddr4b_byteenable),
  .reset(~clock_reset_reset_reset_n),
  .s0_waitrequest(pipelined_kernel_ddr4b_s1_waitrequest),
  .s0_readdata(pipelined_kernel_ddr4b_s1_readdata),
  .s0_readdatavalid(pipelined_kernel_ddr4b_s1_readdatavalid),
  .s0_burstcount(pipelined_kernel_ddr4b_s1_burstcount),
  .s0_writedata(pipelined_kernel_ddr4b_s1_writedata),
  .s0_address(pipelined_kernel_ddr4b_s1_address),
  .s0_write(pipelined_kernel_ddr4b_s1_write),
  .s0_read(pipelined_kernel_ddr4b_s1_read),
  .s0_byteenable(pipelined_kernel_ddr4b_s1_byteenable)
);

kernel_mem_mm_bridge kernel_ddr4b_inst_stage0(
  .clk(clock_reset_clk), 
  .m0_waitrequest(pipelined_kernel_ddr4b_s1_waitrequest),
  .m0_readdata(pipelined_kernel_ddr4b_s1_readdata),
  .m0_readdatavalid(pipelined_kernel_ddr4b_s1_readdatavalid),
  .m0_burstcount(pipelined_kernel_ddr4b_s1_burstcount),
  .m0_writedata(pipelined_kernel_ddr4b_s1_writedata),
  .m0_address(pipelined_kernel_ddr4b_s1_address),
  .m0_write(pipelined_kernel_ddr4b_s1_write),
  .m0_read(pipelined_kernel_ddr4b_s1_read),
  .m0_byteenable(pipelined_kernel_ddr4b_s1_byteenable),
  .reset(~clock_reset_reset_reset_n),
  .s0_waitrequest(pipelined_kernel_ddr4b_s0_waitrequest),
  .s0_readdata(pipelined_kernel_ddr4b_s0_readdata),
  .s0_readdatavalid(pipelined_kernel_ddr4b_s0_readdatavalid),
  .s0_burstcount(pipelined_kernel_ddr4b_s0_burstcount),
  .s0_writedata(pipelined_kernel_ddr4b_s0_writedata),
  .s0_address(pipelined_kernel_ddr4b_s0_address),
  .s0_write(pipelined_kernel_ddr4b_s0_write),
  .s0_read(pipelined_kernel_ddr4b_s0_read),
  .s0_byteenable(pipelined_kernel_ddr4b_s0_byteenable)
);

//=======================================================
//  kernel_system instantiation
//=======================================================
kernel_system kernel_system_inst (
  .clock_reset_clk(clock_reset_clk),
  .clock_reset2x_clk(clock_reset2x_clk),
  .clock_reset_reset_reset_n(clock_reset_reset_reset_n),
  .kernel_irq_irq(kernel_irq_irq),
  .kernel_cra_waitrequest(kernel_cra_waitrequest),
  .kernel_cra_readdata(kernel_cra_readdata),
  .kernel_cra_readdatavalid(kernel_cra_readdatavalid),
  .kernel_cra_burstcount(kernel_cra_burstcount),
  .kernel_cra_writedata(kernel_cra_writedata),
  .kernel_cra_address(kernel_cra_address),
  .kernel_cra_write(kernel_cra_write),
  .kernel_cra_read(kernel_cra_read),
  .kernel_cra_byteenable(kernel_cra_byteenable),
  .kernel_cra_debugaccess(kernel_cra_debugaccess),

  .cc_snoop_clk_clk(clock_reset_clk),
  .cc_snoop_data(acl_internal_snoop_data),
  .cc_snoop_valid(acl_internal_snoop_valid),
  .cc_snoop_ready(acl_internal_snoop_ready),
  
  .kernel_ddr4a_waitrequest(pipelined_kernel_ddr4a_s0_waitrequest),
  .kernel_ddr4a_readdata(pipelined_kernel_ddr4a_s0_readdata),
  .kernel_ddr4a_readdatavalid(pipelined_kernel_ddr4a_s0_readdatavalid),
  .kernel_ddr4a_burstcount(pipelined_kernel_ddr4a_s0_burstcount),
  .kernel_ddr4a_writedata(pipelined_kernel_ddr4a_s0_writedata),
  .kernel_ddr4a_address(pipelined_kernel_ddr4a_s0_address),
  .kernel_ddr4a_write(pipelined_kernel_ddr4a_s0_write),
  .kernel_ddr4a_read(pipelined_kernel_ddr4a_s0_read),
  .kernel_ddr4a_byteenable(pipelined_kernel_ddr4a_s0_byteenable),

  .kernel_ddr4b_waitrequest(pipelined_kernel_ddr4b_s0_waitrequest),
  .kernel_ddr4b_readdata(pipelined_kernel_ddr4b_s0_readdata),
  .kernel_ddr4b_readdatavalid(pipelined_kernel_ddr4b_s0_readdatavalid),
  .kernel_ddr4b_burstcount(pipelined_kernel_ddr4b_s0_burstcount),
  .kernel_ddr4b_writedata(pipelined_kernel_ddr4b_s0_writedata),
  .kernel_ddr4b_address(pipelined_kernel_ddr4b_s0_address),
  .kernel_ddr4b_write(pipelined_kernel_ddr4b_s0_write),
  .kernel_ddr4b_read(pipelined_kernel_ddr4b_s0_read),
  .kernel_ddr4b_byteenable(pipelined_kernel_ddr4b_s0_byteenable)
);

endmodule
