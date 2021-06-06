module ddr_board (
		output wire         kernel_ddr4a_waitrequest,            //          kernel_ddr4a.waitrequest
		output wire [511:0] kernel_ddr4a_readdata,               //                      .readdata
		output wire         kernel_ddr4a_readdatavalid,          //                      .readdatavalid
		input  wire [4:0]   kernel_ddr4a_burstcount,             //                      .burstcount
		input  wire [511:0] kernel_ddr4a_writedata,              //                      .writedata
		input  wire [31:0]  kernel_ddr4a_address,                //                      .address
		input  wire         kernel_ddr4a_write,                  //                      .write
		input  wire         kernel_ddr4a_read,                   //                      .read
		input  wire [63:0]  kernel_ddr4a_byteenable,             //                      .byteenable
		input  wire         kernel_ddr4a_debugaccess,            //                      .debugaccess
		input  wire         emif_ddr4a_waitrequest,              //            emif_ddr4a.waitrequest
		input  wire [511:0] emif_ddr4a_readdata,                 //                      .readdata
		input  wire         emif_ddr4a_readdatavalid,            //                      .readdatavalid
		output wire [6:0]   emif_ddr4a_burstcount,               //                      .burstcount
		output wire [511:0] emif_ddr4a_writedata,                //                      .writedata
		output wire [31:0]  emif_ddr4a_address,                  //                      .address
		output wire         emif_ddr4a_write,                    //                      .write
		output wire         emif_ddr4a_read,                     //                      .read
		output wire [63:0]  emif_ddr4a_byteenable,               //                      .byteenable
		output wire         emif_ddr4a_debugaccess,              //                      .debugaccess
		output wire         kernel_ddr4b_waitrequest,            //          kernel_ddr4b.waitrequest
		output wire [511:0] kernel_ddr4b_readdata,               //                      .readdata
		output wire         kernel_ddr4b_readdatavalid,          //                      .readdatavalid
		input  wire [4:0]   kernel_ddr4b_burstcount,             //                      .burstcount
		input  wire [511:0] kernel_ddr4b_writedata,              //                      .writedata
		input  wire [31:0]  kernel_ddr4b_address,                //                      .address
		input  wire         kernel_ddr4b_write,                  //                      .write
		input  wire         kernel_ddr4b_read,                   //                      .read
		input  wire [63:0]  kernel_ddr4b_byteenable,             //                      .byteenable
		input  wire         kernel_ddr4b_debugaccess,            //                      .debugaccess
		input  wire         emif_ddr4b_waitrequest,              //            emif_ddr4b.waitrequest
		input  wire [511:0] emif_ddr4b_readdata,                 //                      .readdata
		input  wire         emif_ddr4b_readdatavalid,            //                      .readdatavalid
		output wire [6:0]   emif_ddr4b_burstcount,               //                      .burstcount
		output wire [511:0] emif_ddr4b_writedata,                //                      .writedata
		output wire [31:0]  emif_ddr4b_address,                  //                      .address
		output wire         emif_ddr4b_write,                    //                      .write
		output wire         emif_ddr4b_read,                     //                      .read
		output wire [63:0]  emif_ddr4b_byteenable,               //                      .byteenable
		output wire         emif_ddr4b_debugaccess,              //                      .debugaccess
		input  wire [1:0]   acl_bsp_memorg_host_mode,            //   acl_bsp_memorg_host.mode
		output wire [32:0]  acl_bsp_snoop_data,                  //         acl_bsp_snoop.data
		output wire         acl_bsp_snoop_valid,                 //                      .valid
		input  wire         acl_bsp_snoop_ready,                 //                      .ready
		input  wire         ddr_clk_a_clk,                       //             ddr_clk_a.clk
		input  wire         ddr_clk_b_clk,                       //             ddr_clk_b.clk
		input  wire         host_rd_waitrequest,                 //               host_rd.waitrequest
		input  wire [511:0] host_rd_readdata,                    //                      .readdata
		input  wire         host_rd_readdatavalid,               //                      .readdatavalid
		output wire [2:0]   host_rd_burstcount,                  //                      .burstcount
		output wire [511:0] host_rd_writedata,                   //                      .writedata
		output wire [47:0]  host_rd_address,                     //                      .address
		output wire         host_rd_write,                       //                      .write
		output wire         host_rd_read,                        //                      .read
		output wire [63:0]  host_rd_byteenable,                  //                      .byteenable
		output wire         host_rd_debugaccess,                 //                      .debugaccess
		input  wire         host_wr_waitrequest,                 //               host_wr.waitrequest
		input  wire [511:0] host_wr_readdata,                    //                      .readdata
		input  wire         host_wr_readdatavalid,               //                      .readdatavalid
		output wire [2:0]   host_wr_burstcount,                  //                      .burstcount
		output wire [511:0] host_wr_writedata,                   //                      .writedata
		output wire [48:0]  host_wr_address,                     //                      .address
		output wire         host_wr_write,                       //                      .write
		output wire         host_wr_read,                        //                      .read
		output wire [63:0]  host_wr_byteenable,                  //                      .byteenable
		output wire         host_wr_debugaccess,                 //                      .debugaccess
		input  wire         global_reset_reset,                  //          global_reset.reset
		input  wire         host_clk_clk,                        //              host_clk.clk
		input  wire         kernel_clk_clk,                      //            kernel_clk.clk
		input  wire         kernel_reset_reset,                  //          kernel_reset.reset
		output wire [63:0]  null_dfh_afu_id_readdata,            //       null_dfh_afu_id.readdata
		input  wire [63:0]  null_dfh_afu_id_writedata,           //                      .writedata
		input  wire [2:0]   null_dfh_afu_id_address,             //                      .address
		input  wire         null_dfh_afu_id_write,               //                      .write
		input  wire         null_dfh_afu_id_read,                //                      .read
		output wire         ase_0_avmm_pipe_slave_waitrequest,   // ase_0_avmm_pipe_slave.waitrequest
		output wire [63:0]  ase_0_avmm_pipe_slave_readdata,      //                      .readdata
		output wire         ase_0_avmm_pipe_slave_readdatavalid, //                      .readdatavalid
		input  wire [0:0]   ase_0_avmm_pipe_slave_burstcount,    //                      .burstcount
		input  wire [63:0]  ase_0_avmm_pipe_slave_writedata,     //                      .writedata
		input  wire [12:0]  ase_0_avmm_pipe_slave_address,       //                      .address
		input  wire         ase_0_avmm_pipe_slave_write,         //                      .write
		input  wire         ase_0_avmm_pipe_slave_read,          //                      .read
		input  wire [7:0]   ase_0_avmm_pipe_slave_byteenable,    //                      .byteenable
		input  wire         ase_0_avmm_pipe_slave_debugaccess,   //                      .debugaccess
		output wire         msgdma_bbb_0_csr_waitrequest,        //      msgdma_bbb_0_csr.waitrequest
		output wire [63:0]  msgdma_bbb_0_csr_readdata,           //                      .readdata
		output wire         msgdma_bbb_0_csr_readdatavalid,      //                      .readdatavalid
		input  wire [0:0]   msgdma_bbb_0_csr_burstcount,         //                      .burstcount
		input  wire [63:0]  msgdma_bbb_0_csr_writedata,          //                      .writedata
		input  wire [6:0]   msgdma_bbb_0_csr_address,            //                      .address
		input  wire         msgdma_bbb_0_csr_write,              //                      .write
		input  wire         msgdma_bbb_0_csr_read,               //                      .read
		input  wire [7:0]   msgdma_bbb_0_csr_byteenable,         //                      .byteenable
		input  wire         msgdma_bbb_0_csr_debugaccess,        //                      .debugaccess
		output wire         msgdma_bbb_0_dma_irq_irq,            //  msgdma_bbb_0_dma_irq.irq
		output wire         msgdma_bbb_1_csr_waitrequest,        //      msgdma_bbb_1_csr.waitrequest
		output wire [63:0]  msgdma_bbb_1_csr_readdata,           //                      .readdata
		output wire         msgdma_bbb_1_csr_readdatavalid,      //                      .readdatavalid
		input  wire [0:0]   msgdma_bbb_1_csr_burstcount,         //                      .burstcount
		input  wire [63:0]  msgdma_bbb_1_csr_writedata,          //                      .writedata
		input  wire [6:0]   msgdma_bbb_1_csr_address,            //                      .address
		input  wire         msgdma_bbb_1_csr_write,              //                      .write
		input  wire         msgdma_bbb_1_csr_read,               //                      .read
		input  wire [7:0]   msgdma_bbb_1_csr_byteenable,         //                      .byteenable
		input  wire         msgdma_bbb_1_csr_debugaccess,        //                      .debugaccess
		output wire         msgdma_bbb_1_dma_irq_irq             //  msgdma_bbb_1_dma_irq.irq
	);
endmodule

