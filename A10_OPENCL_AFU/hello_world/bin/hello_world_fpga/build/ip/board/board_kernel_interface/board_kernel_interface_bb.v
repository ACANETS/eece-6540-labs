module board_kernel_interface (
		input  wire        kernel_cra_waitrequest,        //               kernel_cra.waitrequest
		input  wire [63:0] kernel_cra_readdata,           //                         .readdata
		input  wire        kernel_cra_readdatavalid,      //                         .readdatavalid
		output wire [0:0]  kernel_cra_burstcount,         //                         .burstcount
		output wire [63:0] kernel_cra_writedata,          //                         .writedata
		output wire [29:0] kernel_cra_address,            //                         .address
		output wire        kernel_cra_write,              //                         .write
		output wire        kernel_cra_read,               //                         .read
		output wire [7:0]  kernel_cra_byteenable,         //                         .byteenable
		output wire        kernel_cra_debugaccess,        //                         .debugaccess
		output wire        ctrl_waitrequest,              //                     ctrl.waitrequest
		output wire [31:0] ctrl_readdata,                 //                         .readdata
		output wire        ctrl_readdatavalid,            //                         .readdatavalid
		input  wire [0:0]  ctrl_burstcount,               //                         .burstcount
		input  wire [31:0] ctrl_writedata,                //                         .writedata
		input  wire [13:0] ctrl_address,                  //                         .address
		input  wire        ctrl_write,                    //                         .write
		input  wire        ctrl_read,                     //                         .read
		input  wire [3:0]  ctrl_byteenable,               //                         .byteenable
		input  wire        ctrl_debugaccess,              //                         .debugaccess
		output wire [1:0]  acl_bsp_memorg_host0x018_mode, // acl_bsp_memorg_host0x018.mode
		input  wire        clk_clk,                       //                      clk.clk
		input  wire        reset_reset_n,                 //                    reset.reset_n
		input  wire [0:0]  kernel_irq_from_kernel_irq,    //   kernel_irq_from_kernel.irq
		output wire        kernel_irq_to_host_irq,        //       kernel_irq_to_host.irq
		input  wire        sw_reset_in_reset,             //              sw_reset_in.reset
		input  wire        kernel_clk_clk,                //               kernel_clk.clk
		output wire        kernel_reset_reset_n,          //             kernel_reset.reset_n
		output wire        sw_reset_export_reset_n        //          sw_reset_export.reset_n
	);
endmodule

