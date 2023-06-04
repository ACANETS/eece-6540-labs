module board (
		output wire         host_kernel_irq_irq,                  //        host_kernel_irq.irq
		input  wire         clk_200_clk,                          //                clk_200.clk
		input  wire         emif_ddr4a_clk_clk,                   //         emif_ddr4a_clk.clk
		input  wire         emif_ddr4b_clk_clk,                   //         emif_ddr4b_clk.clk
		input  wire         global_reset_reset,                   //           global_reset.reset
		output wire         kernel_clk_clk,                       //             kernel_clk.clk
		output wire         kernel_reset_reset_n,                 //           kernel_reset.reset_n
		input  wire         kernel_clk_in_clk,                    //          kernel_clk_in.clk
		input  wire         kernel_cra_waitrequest,               //             kernel_cra.waitrequest
		input  wire [63:0]  kernel_cra_readdata,                  //                       .readdata
		input  wire         kernel_cra_readdatavalid,             //                       .readdatavalid
		output wire [0:0]   kernel_cra_burstcount,                //                       .burstcount
		output wire [63:0]  kernel_cra_writedata,                 //                       .writedata
		output wire [29:0]  kernel_cra_address,                   //                       .address
		output wire         kernel_cra_write,                     //                       .write
		output wire         kernel_cra_read,                      //                       .read
		output wire [7:0]   kernel_cra_byteenable,                //                       .byteenable
		output wire         kernel_cra_debugaccess,               //                       .debugaccess
		input  wire [0:0]   kernel_irq_irq,                       //             kernel_irq.irq
		input  wire         ccip_avmm_requestor_rd_waitrequest,   // ccip_avmm_requestor_rd.waitrequest
		input  wire [511:0] ccip_avmm_requestor_rd_readdata,      //                       .readdata
		input  wire         ccip_avmm_requestor_rd_readdatavalid, //                       .readdatavalid
		output wire [2:0]   ccip_avmm_requestor_rd_burstcount,    //                       .burstcount
		output wire [511:0] ccip_avmm_requestor_rd_writedata,     //                       .writedata
		output wire [47:0]  ccip_avmm_requestor_rd_address,       //                       .address
		output wire         ccip_avmm_requestor_rd_write,         //                       .write
		output wire         ccip_avmm_requestor_rd_read,          //                       .read
		output wire [63:0]  ccip_avmm_requestor_rd_byteenable,    //                       .byteenable
		output wire         ccip_avmm_requestor_rd_debugaccess,   //                       .debugaccess
		input  wire         ccip_avmm_requestor_wr_waitrequest,   // ccip_avmm_requestor_wr.waitrequest
		input  wire [511:0] ccip_avmm_requestor_wr_readdata,      //                       .readdata
		input  wire         ccip_avmm_requestor_wr_readdatavalid, //                       .readdatavalid
		output wire [2:0]   ccip_avmm_requestor_wr_burstcount,    //                       .burstcount
		output wire [511:0] ccip_avmm_requestor_wr_writedata,     //                       .writedata
		output wire [47:0]  ccip_avmm_requestor_wr_address,       //                       .address
		output wire         ccip_avmm_requestor_wr_write,         //                       .write
		output wire         ccip_avmm_requestor_wr_read,          //                       .read
		output wire [63:0]  ccip_avmm_requestor_wr_byteenable,    //                       .byteenable
		output wire         ccip_avmm_requestor_wr_debugaccess,   //                       .debugaccess
		output wire         ccip_avmm_mmio_waitrequest,           //         ccip_avmm_mmio.waitrequest
		output wire [63:0]  ccip_avmm_mmio_readdata,              //                       .readdata
		output wire         ccip_avmm_mmio_readdatavalid,         //                       .readdatavalid
		input  wire [0:0]   ccip_avmm_mmio_burstcount,            //                       .burstcount
		input  wire [63:0]  ccip_avmm_mmio_writedata,             //                       .writedata
		input  wire [17:0]  ccip_avmm_mmio_address,               //                       .address
		input  wire         ccip_avmm_mmio_write,                 //                       .write
		input  wire         ccip_avmm_mmio_read,                  //                       .read
		input  wire [7:0]   ccip_avmm_mmio_byteenable,            //                       .byteenable
		input  wire         ccip_avmm_mmio_debugaccess,           //                       .debugaccess
		output wire         kernel_ddr4a_waitrequest,             //           kernel_ddr4a.waitrequest
		output wire [511:0] kernel_ddr4a_readdata,                //                       .readdata
		output wire         kernel_ddr4a_readdatavalid,           //                       .readdatavalid
		input  wire [4:0]   kernel_ddr4a_burstcount,              //                       .burstcount
		input  wire [511:0] kernel_ddr4a_writedata,               //                       .writedata
		input  wire [31:0]  kernel_ddr4a_address,                 //                       .address
		input  wire         kernel_ddr4a_write,                   //                       .write
		input  wire         kernel_ddr4a_read,                    //                       .read
		input  wire [63:0]  kernel_ddr4a_byteenable,              //                       .byteenable
		input  wire         kernel_ddr4a_debugaccess,             //                       .debugaccess
		input  wire         emif_ddr4a_waitrequest,               //             emif_ddr4a.waitrequest
		input  wire [511:0] emif_ddr4a_readdata,                  //                       .readdata
		input  wire         emif_ddr4a_readdatavalid,             //                       .readdatavalid
		output wire [6:0]   emif_ddr4a_burstcount,                //                       .burstcount
		output wire [511:0] emif_ddr4a_writedata,                 //                       .writedata
		output wire [31:0]  emif_ddr4a_address,                   //                       .address
		output wire         emif_ddr4a_write,                     //                       .write
		output wire         emif_ddr4a_read,                      //                       .read
		output wire [63:0]  emif_ddr4a_byteenable,                //                       .byteenable
		output wire         emif_ddr4a_debugaccess,               //                       .debugaccess
		output wire         kernel_ddr4b_waitrequest,             //           kernel_ddr4b.waitrequest
		output wire [511:0] kernel_ddr4b_readdata,                //                       .readdata
		output wire         kernel_ddr4b_readdatavalid,           //                       .readdatavalid
		input  wire [4:0]   kernel_ddr4b_burstcount,              //                       .burstcount
		input  wire [511:0] kernel_ddr4b_writedata,               //                       .writedata
		input  wire [31:0]  kernel_ddr4b_address,                 //                       .address
		input  wire         kernel_ddr4b_write,                   //                       .write
		input  wire         kernel_ddr4b_read,                    //                       .read
		input  wire [63:0]  kernel_ddr4b_byteenable,              //                       .byteenable
		input  wire         kernel_ddr4b_debugaccess,             //                       .debugaccess
		input  wire         emif_ddr4b_waitrequest,               //             emif_ddr4b.waitrequest
		input  wire [511:0] emif_ddr4b_readdata,                  //                       .readdata
		input  wire         emif_ddr4b_readdatavalid,             //                       .readdatavalid
		output wire [6:0]   emif_ddr4b_burstcount,                //                       .burstcount
		output wire [511:0] emif_ddr4b_writedata,                 //                       .writedata
		output wire [31:0]  emif_ddr4b_address,                   //                       .address
		output wire         emif_ddr4b_write,                     //                       .write
		output wire         emif_ddr4b_read,                      //                       .read
		output wire [63:0]  emif_ddr4b_byteenable,                //                       .byteenable
		output wire         emif_ddr4b_debugaccess,               //                       .debugaccess
		output wire [32:0]  acl_internal_snoop_data,              //     acl_internal_snoop.data
		output wire         acl_internal_snoop_valid,             //                       .valid
		input  wire         acl_internal_snoop_ready,             //                       .ready
		output wire         msgdma_bbb_0_dma_irq_irq,             //   msgdma_bbb_0_dma_irq.irq
		output wire         msgdma_bbb_1_dma_irq_irq              //   msgdma_bbb_1_dma_irq.irq
	);
endmodule

