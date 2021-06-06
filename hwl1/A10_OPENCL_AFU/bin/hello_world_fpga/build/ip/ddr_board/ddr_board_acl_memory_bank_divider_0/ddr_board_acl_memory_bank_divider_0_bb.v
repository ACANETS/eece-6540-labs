module ddr_board_acl_memory_bank_divider_0 (
		input  wire         clk_clk,                  //                 clk.clk
		input  wire         reset_reset_n,            //               reset.reset_n
		output wire [32:0]  acl_bsp_snoop_data,       //       acl_bsp_snoop.data
		output wire         acl_bsp_snoop_valid,      //                    .valid
		input  wire         acl_bsp_snoop_ready,      //                    .ready
		input  wire         kernel_clk_clk,           //          kernel_clk.clk
		input  wire         kernel_reset_reset_n,     //        kernel_reset.reset_n
		input  wire [511:0] s_writedata,              //                   s.writedata
		input  wire         s_read,                   //                    .read
		input  wire         s_write,                  //                    .write
		input  wire [4:0]   s_burstcount,             //                    .burstcount
		input  wire [63:0]  s_byteenable,             //                    .byteenable
		output wire         s_waitrequest,            //                    .waitrequest
		output wire [511:0] s_readdata,               //                    .readdata
		output wire         s_readdatavalid,          //                    .readdatavalid
		input  wire [26:0]  s_address,                //                    .address
		input  wire [1:0]   acl_bsp_memorg_host_mode, // acl_bsp_memorg_host.mode
		output wire [31:0]  bank1_address,            //               bank1.address
		output wire [511:0] bank1_writedata,          //                    .writedata
		output wire         bank1_read,               //                    .read
		output wire         bank1_write,              //                    .write
		output wire [4:0]   bank1_burstcount,         //                    .burstcount
		output wire [63:0]  bank1_byteenable,         //                    .byteenable
		input  wire         bank1_waitrequest,        //                    .waitrequest
		input  wire [511:0] bank1_readdata,           //                    .readdata
		input  wire         bank1_readdatavalid,      //                    .readdatavalid
		output wire [31:0]  bank2_address,            //               bank2.address
		output wire [511:0] bank2_writedata,          //                    .writedata
		output wire         bank2_read,               //                    .read
		output wire         bank2_write,              //                    .write
		output wire [4:0]   bank2_burstcount,         //                    .burstcount
		output wire [63:0]  bank2_byteenable,         //                    .byteenable
		input  wire         bank2_waitrequest,        //                    .waitrequest
		input  wire [511:0] bank2_readdata,           //                    .readdata
		input  wire         bank2_readdatavalid       //                    .readdatavalid
	);
endmodule

