module ase (
		output wire [47:0]  expanded_master_address,       // expanded_master.address
		output wire         expanded_master_read,          //                .read
		input  wire         expanded_master_waitrequest,   //                .waitrequest
		input  wire [511:0] expanded_master_readdata,      //                .readdata
		output wire         expanded_master_write,         //                .write
		output wire [511:0] expanded_master_writedata,     //                .writedata
		input  wire         expanded_master_readdatavalid, //                .readdatavalid
		output wire [63:0]  expanded_master_byteenable,    //                .byteenable
		output wire [3:0]   expanded_master_burstcount,    //                .burstcount
		output wire         avmm_pipe_slave_waitrequest,   // avmm_pipe_slave.waitrequest
		output wire [63:0]  avmm_pipe_slave_readdata,      //                .readdata
		output wire         avmm_pipe_slave_readdatavalid, //                .readdatavalid
		input  wire [0:0]   avmm_pipe_slave_burstcount,    //                .burstcount
		input  wire [63:0]  avmm_pipe_slave_writedata,     //                .writedata
		input  wire [12:0]  avmm_pipe_slave_address,       //                .address
		input  wire         avmm_pipe_slave_write,         //                .write
		input  wire         avmm_pipe_slave_read,          //                .read
		input  wire [7:0]   avmm_pipe_slave_byteenable,    //                .byteenable
		input  wire         avmm_pipe_slave_debugaccess,   //                .debugaccess
		input  wire         clk_clk,                       //             clk.clk
		input  wire         reset_reset                    //           reset.reset
	);
endmodule

