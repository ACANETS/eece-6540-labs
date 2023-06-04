module ddr_board_afu_id_avmm_slave_0 (
		input  wire        clk,            //         clock.clk
		input  wire        reset,          //         reset.reset
		output wire [63:0] avmm_readdata,  // afu_cfg_slave.readdata
		input  wire [63:0] avmm_writedata, //              .writedata
		input  wire [2:0]  avmm_address,   //              .address
		input  wire        avmm_write,     //              .write
		input  wire        avmm_read       //              .read
	);
endmodule

