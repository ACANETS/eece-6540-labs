	board_afu_id_avmm_slave_0 u0 (
		.clk            (_connected_to_clk_),            //   input,   width = 1,         clock.clk
		.reset          (_connected_to_reset_),          //   input,   width = 1,         reset.reset
		.avmm_readdata  (_connected_to_avmm_readdata_),  //  output,  width = 64, afu_cfg_slave.readdata
		.avmm_writedata (_connected_to_avmm_writedata_), //   input,  width = 64,              .writedata
		.avmm_address   (_connected_to_avmm_address_),   //   input,   width = 3,              .address
		.avmm_write     (_connected_to_avmm_write_),     //   input,   width = 1,              .write
		.avmm_read      (_connected_to_avmm_read_)       //   input,   width = 1,              .read
	);

