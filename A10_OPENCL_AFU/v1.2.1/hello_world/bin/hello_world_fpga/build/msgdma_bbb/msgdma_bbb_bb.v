module msgdma_bbb (
		input  wire         clk_clk,               //     clk.clk
		input  wire         reset_reset_n,         //   reset.reset_n
		output wire         csr_waitrequest,       //     csr.waitrequest
		output wire [63:0]  csr_readdata,          //        .readdata
		output wire         csr_readdatavalid,     //        .readdatavalid
		input  wire [0:0]   csr_burstcount,        //        .burstcount
		input  wire [63:0]  csr_writedata,         //        .writedata
		input  wire [6:0]   csr_address,           //        .address
		input  wire         csr_write,             //        .write
		input  wire         csr_read,              //        .read
		input  wire [7:0]   csr_byteenable,        //        .byteenable
		input  wire         csr_debugaccess,       //        .debugaccess
		output wire         dma_irq_irq,           // dma_irq.irq
		input  wire         host_rd_waitrequest,   // host_rd.waitrequest
		input  wire [511:0] host_rd_readdata,      //        .readdata
		input  wire         host_rd_readdatavalid, //        .readdatavalid
		output wire [2:0]   host_rd_burstcount,    //        .burstcount
		output wire [511:0] host_rd_writedata,     //        .writedata
		output wire [47:0]  host_rd_address,       //        .address
		output wire         host_rd_write,         //        .write
		output wire         host_rd_read,          //        .read
		output wire [63:0]  host_rd_byteenable,    //        .byteenable
		output wire         host_rd_debugaccess,   //        .debugaccess
		input  wire         host_wr_waitrequest,   // host_wr.waitrequest
		input  wire [511:0] host_wr_readdata,      //        .readdata
		input  wire         host_wr_readdatavalid, //        .readdatavalid
		output wire [2:0]   host_wr_burstcount,    //        .burstcount
		output wire [511:0] host_wr_writedata,     //        .writedata
		output wire [48:0]  host_wr_address,       //        .address
		output wire         host_wr_write,         //        .write
		output wire         host_wr_read,          //        .read
		output wire [63:0]  host_wr_byteenable,    //        .byteenable
		output wire         host_wr_debugaccess,   //        .debugaccess
		input  wire         mem_waitrequest,       //     mem.waitrequest
		input  wire [511:0] mem_readdata,          //        .readdata
		input  wire         mem_readdatavalid,     //        .readdatavalid
		output wire [2:0]   mem_burstcount,        //        .burstcount
		output wire [511:0] mem_writedata,         //        .writedata
		output wire [47:0]  mem_address,           //        .address
		output wire         mem_write,             //        .write
		output wire         mem_read,              //        .read
		output wire [63:0]  mem_byteenable,        //        .byteenable
		output wire         mem_debugaccess        //        .debugaccess
	);
endmodule

