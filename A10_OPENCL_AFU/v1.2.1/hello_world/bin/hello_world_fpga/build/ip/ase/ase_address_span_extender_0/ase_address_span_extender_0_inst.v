	ase_address_span_extender_0 #(
		.SYNC_RESET (INTEGER_VALUE_FOR_SYNC_RESET)
	) u0 (
		.clk                  (_connected_to_clk_),                  //   input,    width = 1,           clock.clk
		.reset                (_connected_to_reset_),                //   input,    width = 1,           reset.reset
		.avs_s0_address       (_connected_to_avs_s0_address_),       //   input,    width = 6,  windowed_slave.address
		.avs_s0_read          (_connected_to_avs_s0_read_),          //   input,    width = 1,                .read
		.avs_s0_readdata      (_connected_to_avs_s0_readdata_),      //  output,  width = 512,                .readdata
		.avs_s0_write         (_connected_to_avs_s0_write_),         //   input,    width = 1,                .write
		.avs_s0_writedata     (_connected_to_avs_s0_writedata_),     //   input,  width = 512,                .writedata
		.avs_s0_readdatavalid (_connected_to_avs_s0_readdatavalid_), //  output,    width = 1,                .readdatavalid
		.avs_s0_waitrequest   (_connected_to_avs_s0_waitrequest_),   //  output,    width = 1,                .waitrequest
		.avs_s0_byteenable    (_connected_to_avs_s0_byteenable_),    //   input,   width = 64,                .byteenable
		.avs_s0_burstcount    (_connected_to_avs_s0_burstcount_),    //   input,    width = 4,                .burstcount
		.avm_m0_address       (_connected_to_avm_m0_address_),       //  output,   width = 48, expanded_master.address
		.avm_m0_read          (_connected_to_avm_m0_read_),          //  output,    width = 1,                .read
		.avm_m0_waitrequest   (_connected_to_avm_m0_waitrequest_),   //   input,    width = 1,                .waitrequest
		.avm_m0_readdata      (_connected_to_avm_m0_readdata_),      //   input,  width = 512,                .readdata
		.avm_m0_write         (_connected_to_avm_m0_write_),         //  output,    width = 1,                .write
		.avm_m0_writedata     (_connected_to_avm_m0_writedata_),     //  output,  width = 512,                .writedata
		.avm_m0_readdatavalid (_connected_to_avm_m0_readdatavalid_), //   input,    width = 1,                .readdatavalid
		.avm_m0_byteenable    (_connected_to_avm_m0_byteenable_),    //  output,   width = 64,                .byteenable
		.avm_m0_burstcount    (_connected_to_avm_m0_burstcount_),    //  output,    width = 4,                .burstcount
		.avs_cntl_read        (_connected_to_avs_cntl_read_),        //   input,    width = 1,            cntl.read
		.avs_cntl_readdata    (_connected_to_avs_cntl_readdata_),    //  output,   width = 64,                .readdata
		.avs_cntl_write       (_connected_to_avs_cntl_write_),       //   input,    width = 1,                .write
		.avs_cntl_writedata   (_connected_to_avs_cntl_writedata_),   //   input,   width = 64,                .writedata
		.avs_cntl_byteenable  (_connected_to_avs_cntl_byteenable_)   //   input,    width = 8,                .byteenable
	);

