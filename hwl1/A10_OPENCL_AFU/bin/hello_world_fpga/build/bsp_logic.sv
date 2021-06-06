// ***************************************************************************
//
//        Copyright (C) 2008-2015 Intel Corporation All Rights Reserved.
//
// Engineer :           Pratik Marolia
// Creation Date :	20-05-2015
// Last Modified :	Wed 20 May 2015 03:03:09 PM PDT
// Module Name :	ccip_std_afu
// Project :        ccip afu top (work in progress)
// Description :    This module instantiates CCI-P compliant AFU

// ***************************************************************************

`include "cci_mpf_if.vh"
import ccip_avmm_pkg::*;
import bsp_pkg::*;

`ifndef OPENCL_MEMORY_ADDR_WIDTH
`define OPENCL_MEMORY_ADDR_WIDTH 26
`endif

module bsp_logic #(
	parameter MMIO_BYPASS_ADDRESS = 0,
	parameter MMIO_BYPASS_SIZE = 0
) 
(
	// CCI-P Clocks and Resets
	input           logic             clk,          // 200MHz - CCI-P clock domain.
	input           logic             reset,      // CCI-P ACTIVE HIGH Soft Reset
	
	// Interface structures
	input           t_if_ccip_Rx      pck_cp2af_sRx,        // CCI-P Rx Port
	input           t_if_ccip_c0_Rx   cp2af_mmio_c0rx,
	output          t_if_ccip_Tx      pck_af2cp_sTx,        // CCI-P Tx Port
	
	// kernel interface
	
	// kernel interface
	
	//////// board ports //////////
	output  logic      		board_kernel_reset_reset_n,
	input logic    	board_kernel_irq_irq,
	input logic          board_kernel_cra_waitrequest,
	input logic [63:0]		board_kernel_cra_readdata,
	input logic         	board_kernel_cra_readdatavalid,
	output logic     board_kernel_cra_burstcount,
	output logic  [63:0]   board_kernel_cra_writedata,
	output logic  [29:0]   board_kernel_cra_address,
	output logic         	board_kernel_cra_write,
	output logic         	board_kernel_cra_read,
	output logic   [7:0]  	board_kernel_cra_byteenable,
	output logic         	board_kernel_cra_debugaccess,
	
	output	[`OPENCL_MEMORY_ADDR_WIDTH+6:0]	acl_internal_snoop_data,
	output		acl_internal_snoop_valid,
	input		acl_internal_snoop_ready,
	
	input emif_ddr4a_clk,
	input emif_ddr4b_clk,
	
	input		emif_ddr4a_waitrequest,
	input	[511:0]	emif_ddr4a_readdata,
	input		emif_ddr4a_readdatavalid,
	output	[6:0]	emif_ddr4a_burstcount,
	output	[511:0]	emif_ddr4a_writedata,
	output	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0]	emif_ddr4a_address,
	output		emif_ddr4a_write,
	output		emif_ddr4a_read,
	output	[63:0]	emif_ddr4a_byteenable,
	output		emif_ddr4a_debugaccess,
	
	input		emif_ddr4b_waitrequest,
	input	[511:0]	emif_ddr4b_readdata,
	input		emif_ddr4b_readdatavalid,
	output	[6:0]	emif_ddr4b_burstcount,
	output	[511:0]	emif_ddr4b_writedata,
	output	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0]	emif_ddr4b_address,
	output		emif_ddr4b_write,
	output		emif_ddr4b_read,
	output	[63:0]	emif_ddr4b_byteenable,
	output		emif_ddr4b_debugaccess,
	
	output		kernel_ddr4a_waitrequest,
	output	[511:0]	kernel_ddr4a_readdata,
	output		kernel_ddr4a_readdatavalid,
	input	[4:0]	kernel_ddr4a_burstcount,
	input	[511:0]	kernel_ddr4a_writedata,
	input	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0]	kernel_ddr4a_address,
	input		kernel_ddr4a_write,
	input		kernel_ddr4a_read,
	input	[63:0]	kernel_ddr4a_byteenable,
	input		kernel_ddr4a_debugaccess,
	
	output		kernel_ddr4b_waitrequest,
	output	[511:0]	kernel_ddr4b_readdata,
	output		kernel_ddr4b_readdatavalid,
	input	[4:0]	kernel_ddr4b_burstcount,
	input	[511:0]	kernel_ddr4b_writedata,
	input	[`OPENCL_MEMORY_ADDR_WIDTH+6-1:0]	kernel_ddr4b_address,
	input		kernel_ddr4b_write,
	input		kernel_ddr4b_read,
	input	[63:0]	kernel_ddr4b_byteenable,
	input		kernel_ddr4b_debugaccess,
	
	input kernel_clk
);
	//ccip avmm signals
	wire requestor_avmm_wr_waitrequest;
	wire [CCIP_AVMM_REQUESTOR_DATA_WIDTH-1:0]	requestor_avmm_wr_writedata;
	wire [CCIP_AVMM_REQUESTOR_WR_ADDR_WIDTH-1:0]	requestor_avmm_wr_address;
	wire requestor_avmm_wr_write;
	wire [CCIP_AVMM_REQUESTOR_BURST_WIDTH-1:0]	requestor_avmm_wr_burstcount;
	
	wire requestor_avmm_rd_waitrequest;
	wire [CCIP_AVMM_REQUESTOR_DATA_WIDTH-1:0]	requestor_avmm_rd_readdata;
	wire requestor_avmm_rd_readdatavalid;
	wire [CCIP_AVMM_REQUESTOR_DATA_WIDTH-1:0]	requestor_avmm_rd_writedata;
	wire [CCIP_AVMM_REQUESTOR_RD_ADDR_WIDTH-1:0]	requestor_avmm_rd_address;
	wire requestor_avmm_rd_write;
	wire requestor_avmm_rd_read;
	wire [CCIP_AVMM_REQUESTOR_BURST_WIDTH-1:0]	requestor_avmm_rd_burstcount;
	
	wire mmio_avmm_waitrequest;
	wire [CCIP_AVMM_MMIO_DATA_WIDTH-1:0]	mmio_avmm_readdata;
	wire mmio_avmm_readdatavalid;
	wire [CCIP_AVMM_MMIO_DATA_WIDTH-1:0]	mmio_avmm_writedata;
	wire [CCIP_AVMM_MMIO_ADDR_WIDTH-1:0]	mmio_avmm_address;
	wire mmio_avmm_write;
	wire mmio_avmm_read;
	wire [(CCIP_AVMM_MMIO_DATA_WIDTH/8)-1:0]	mmio_avmm_byteenable;

	wire [CCIP_AVMM_NUM_INTERRUPT_LINES-1:0] ccip_irq;

	board board_inst (
		.clk_200_clk                        (clk),                                     //      psl_clk.clk
		.global_reset_reset                 (reset),                            // global_reset.reset_n
		.kernel_clk_clk                     (),                            //   kernel_clk.clk
		.kernel_cra_waitrequest             (board_kernel_cra_waitrequest),                    //   kernel_cra.waitrequest
		.kernel_cra_readdata                (board_kernel_cra_readdata),                       //             .readdata
		.kernel_cra_readdatavalid           (board_kernel_cra_readdatavalid),                  //             .readdatavalid
		.kernel_cra_burstcount              (board_kernel_cra_burstcount),                     //             .burstcount
		.kernel_cra_writedata               (board_kernel_cra_writedata),                      //             .writedata
		.kernel_cra_address                 (board_kernel_cra_address),                        //             .address
		.kernel_cra_write                   (board_kernel_cra_write),                          //             .write
		.kernel_cra_read                    (board_kernel_cra_read),                           //             .read
		.kernel_cra_byteenable              (board_kernel_cra_byteenable),                     //             .byteenable
		.kernel_cra_debugaccess             (board_kernel_cra_debugaccess),                    //             .debugaccess
		.kernel_irq_irq                     (board_kernel_irq_irq),                            //   kernel_irq.irq
		.kernel_reset_reset_n               (board_kernel_reset_reset_n),                        // kernel_reset.reset_n
		
		.acl_internal_snoop_data(acl_internal_snoop_data),
		.acl_internal_snoop_valid(acl_internal_snoop_valid),
		.acl_internal_snoop_ready(acl_internal_snoop_ready),
			
		.emif_ddr4a_clk_clk(emif_ddr4a_clk),
		.emif_ddr4b_clk_clk(emif_ddr4b_clk),
		
		.emif_ddr4a_waitrequest(emif_ddr4a_waitrequest),
		.emif_ddr4a_readdata(emif_ddr4a_readdata),
		.emif_ddr4a_readdatavalid(emif_ddr4a_readdatavalid),
		.emif_ddr4a_burstcount(emif_ddr4a_burstcount),
		.emif_ddr4a_writedata(emif_ddr4a_writedata),
		.emif_ddr4a_address(emif_ddr4a_address),
		.emif_ddr4a_write(emif_ddr4a_write),
		.emif_ddr4a_read(emif_ddr4a_read),
		.emif_ddr4a_byteenable(emif_ddr4a_byteenable),
		.emif_ddr4a_debugaccess(emif_ddr4a_debugaccess),
		
		.emif_ddr4b_waitrequest(emif_ddr4b_waitrequest),
		.emif_ddr4b_readdata(emif_ddr4b_readdata),
		.emif_ddr4b_readdatavalid(emif_ddr4b_readdatavalid),
		.emif_ddr4b_burstcount(emif_ddr4b_burstcount),
		.emif_ddr4b_writedata(emif_ddr4b_writedata),
		.emif_ddr4b_address(emif_ddr4b_address),
		.emif_ddr4b_write(emif_ddr4b_write),
		.emif_ddr4b_read(emif_ddr4b_read),
		.emif_ddr4b_byteenable(emif_ddr4b_byteenable),
		.emif_ddr4b_debugaccess(emif_ddr4b_debugaccess),
		
		.kernel_ddr4a_waitrequest(kernel_ddr4a_waitrequest),
		.kernel_ddr4a_readdata(kernel_ddr4a_readdata),
		.kernel_ddr4a_readdatavalid(kernel_ddr4a_readdatavalid),
		.kernel_ddr4a_burstcount(kernel_ddr4a_burstcount),
		.kernel_ddr4a_writedata(kernel_ddr4a_writedata),
		.kernel_ddr4a_address(kernel_ddr4a_address),
		.kernel_ddr4a_write(kernel_ddr4a_write),
		.kernel_ddr4a_read(kernel_ddr4a_read),
		.kernel_ddr4a_byteenable(kernel_ddr4a_byteenable),
		.kernel_ddr4a_debugaccess(kernel_ddr4a_debugaccess),
		
		.kernel_ddr4b_waitrequest(kernel_ddr4b_waitrequest),
		.kernel_ddr4b_readdata(kernel_ddr4b_readdata),
		.kernel_ddr4b_readdatavalid(kernel_ddr4b_readdatavalid),
		.kernel_ddr4b_burstcount(kernel_ddr4b_burstcount),
		.kernel_ddr4b_writedata(kernel_ddr4b_writedata),
		.kernel_ddr4b_address(kernel_ddr4b_address),
		.kernel_ddr4b_write(kernel_ddr4b_write),
		.kernel_ddr4b_read(kernel_ddr4b_read),
		.kernel_ddr4b_byteenable(kernel_ddr4b_byteenable),
		.kernel_ddr4b_debugaccess(kernel_ddr4b_debugaccess),

		.msgdma_bbb_0_dma_irq_irq(ccip_irq[CCIP_DMA_0_IRQ_BIT]),
		.msgdma_bbb_1_dma_irq_irq(ccip_irq[CCIP_DMA_1_IRQ_BIT]),
		.host_kernel_irq_irq     (ccip_irq[CCIP_KERNEL_IRQ_BIT]),
		
        .ccip_avmm_mmio_waitrequest         (mmio_avmm_waitrequest),         //       ccip_avm_mmio.waitrequest
        .ccip_avmm_mmio_readdata            (mmio_avmm_readdata),            //                    .readdata
        .ccip_avmm_mmio_readdatavalid       (mmio_avmm_readdatavalid),       //                    .readdatavalid
        .ccip_avmm_mmio_burstcount          (1'b1),          //                    .burstcount
        .ccip_avmm_mmio_writedata           (mmio_avmm_writedata),           //                    .writedata
        .ccip_avmm_mmio_address             (mmio_avmm_address),             //                    .address
        .ccip_avmm_mmio_write               (mmio_avmm_write),               //                    .write
        .ccip_avmm_mmio_read                (mmio_avmm_read),                //                    .read
        .ccip_avmm_mmio_byteenable          (mmio_avmm_byteenable),          //                    .byteenable
        .ccip_avmm_mmio_debugaccess         (),         //                    .debugaccess

        .ccip_avmm_requestor_wr_waitrequest   (requestor_avmm_wr_waitrequest),   // ccip_avmm_requestor.waitrequest
        .ccip_avmm_requestor_wr_readdata      (),      //                    .readdata
        .ccip_avmm_requestor_wr_readdatavalid (), //                    .readdatavalid
        .ccip_avmm_requestor_wr_burstcount    (requestor_avmm_wr_burstcount),    //                    .burstcount
        .ccip_avmm_requestor_wr_writedata     (requestor_avmm_wr_writedata),     //                    .writedata
        .ccip_avmm_requestor_wr_address       (requestor_avmm_wr_address),       //                    .address
        .ccip_avmm_requestor_wr_write         (requestor_avmm_wr_write),         //                    .write
        .ccip_avmm_requestor_wr_read          (),          //                    .read
        .ccip_avmm_requestor_wr_byteenable    (),    //                    .byteenable
        .ccip_avmm_requestor_wr_debugaccess   (),   //                    .debugaccess
        
        .ccip_avmm_requestor_rd_waitrequest   (requestor_avmm_rd_waitrequest),   // ccip_avmm_requestor.waitrequest
        .ccip_avmm_requestor_rd_readdata      (requestor_avmm_rd_readdata),      //                    .readdata
        .ccip_avmm_requestor_rd_readdatavalid (requestor_avmm_rd_readdatavalid), //                    .readdatavalid
        .ccip_avmm_requestor_rd_burstcount    (requestor_avmm_rd_burstcount),    //                    .burstcount
        .ccip_avmm_requestor_rd_writedata     (),     //                    .writedata
        .ccip_avmm_requestor_rd_address       (requestor_avmm_rd_address),       //                    .address
        .ccip_avmm_requestor_rd_write         (),         //                    .write
        .ccip_avmm_requestor_rd_read          (requestor_avmm_rd_read),          //                    .read
        .ccip_avmm_requestor_rd_byteenable    (),    //                    .byteenable
        .ccip_avmm_requestor_rd_debugaccess   (),   //                    .debugaccess
        
        .kernel_clk_in_clk(kernel_clk)
	);

	//set unused interrupt lines to 0
	genvar i;
	generate
		for (i = CCIP_AVMM_NUM_IRQ_USED; i < CCIP_AVMM_NUM_INTERRUPT_LINES ; i = i + 1) begin
			assign ccip_irq[i] = 1'b0;
		end
	endgenerate 
	
	avmm_ccip_host_wr #(
		.ENABLE_INTR(1)
	) avmm_ccip_host_wr_inst (
		.clk            (clk),            //   clk.clk
		.reset        (reset),         // reset.reset
		
		.irq(ccip_irq),
		
		.avmm_waitrequest(requestor_avmm_wr_waitrequest),
		.avmm_writedata(requestor_avmm_wr_writedata),
		.avmm_address(requestor_avmm_wr_address),
		.avmm_write(requestor_avmm_wr_write),
		.avmm_burstcount(requestor_avmm_wr_burstcount),
		.avmm_write_response(),
		.avmm_write_responsevalid(),  
		
		.c1TxAlmFull(pck_cp2af_sRx.c1TxAlmFull),
		.c1rx(pck_cp2af_sRx.c1),	//write response (needs to be connected even though DMA doesn't consume write responses)
		.c1tx(pck_af2cp_sTx.c1)
	);
	
	avmm_ccip_host_rd avmm_ccip_host_rd_inst (
		.clk            (clk),            //   clk.clk
		.reset        (reset),         // reset.reset
		
		.avmm_waitrequest(requestor_avmm_rd_waitrequest),
		.avmm_readdata(requestor_avmm_rd_readdata),
		.avmm_readdatavalid(requestor_avmm_rd_readdatavalid),
		.avmm_address(requestor_avmm_rd_address),
		.avmm_read(requestor_avmm_rd_read),
		.avmm_burstcount(requestor_avmm_rd_burstcount),
		
		.c0TxAlmFull(pck_cp2af_sRx.c0TxAlmFull),
		.c0rx(pck_cp2af_sRx.c0),
		.c0tx(pck_af2cp_sTx.c0)
	);
	
	ccip_avmm_mmio ccip_avmm_mmio_inst (
		.avmm_waitrequest(mmio_avmm_waitrequest),
		.avmm_readdata(mmio_avmm_readdata),
		.avmm_readdatavalid(mmio_avmm_readdatavalid),
		.avmm_writedata(mmio_avmm_writedata),
		.avmm_address(mmio_avmm_address),
		.avmm_write(mmio_avmm_write),
		.avmm_read(mmio_avmm_read),
		.avmm_byteenable(mmio_avmm_byteenable),
	
		.clk            (clk),            //   clk.clk
		.reset        (reset),         // reset.reset
		
		.c0rx(cp2af_mmio_c0rx),
		.c2tx(pck_af2cp_sTx.c2)
	);


endmodule

