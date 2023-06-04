	ase u0 (
		.expanded_master_address       (_connected_to_expanded_master_address_),       //  output,   width = 48, expanded_master.address
		.expanded_master_read          (_connected_to_expanded_master_read_),          //  output,    width = 1,                .read
		.expanded_master_waitrequest   (_connected_to_expanded_master_waitrequest_),   //   input,    width = 1,                .waitrequest
		.expanded_master_readdata      (_connected_to_expanded_master_readdata_),      //   input,  width = 512,                .readdata
		.expanded_master_write         (_connected_to_expanded_master_write_),         //  output,    width = 1,                .write
		.expanded_master_writedata     (_connected_to_expanded_master_writedata_),     //  output,  width = 512,                .writedata
		.expanded_master_readdatavalid (_connected_to_expanded_master_readdatavalid_), //   input,    width = 1,                .readdatavalid
		.expanded_master_byteenable    (_connected_to_expanded_master_byteenable_),    //  output,   width = 64,                .byteenable
		.expanded_master_burstcount    (_connected_to_expanded_master_burstcount_),    //  output,    width = 4,                .burstcount
		.avmm_pipe_slave_waitrequest   (_connected_to_avmm_pipe_slave_waitrequest_),   //  output,    width = 1, avmm_pipe_slave.waitrequest
		.avmm_pipe_slave_readdata      (_connected_to_avmm_pipe_slave_readdata_),      //  output,   width = 64,                .readdata
		.avmm_pipe_slave_readdatavalid (_connected_to_avmm_pipe_slave_readdatavalid_), //  output,    width = 1,                .readdatavalid
		.avmm_pipe_slave_burstcount    (_connected_to_avmm_pipe_slave_burstcount_),    //   input,    width = 1,                .burstcount
		.avmm_pipe_slave_writedata     (_connected_to_avmm_pipe_slave_writedata_),     //   input,   width = 64,                .writedata
		.avmm_pipe_slave_address       (_connected_to_avmm_pipe_slave_address_),       //   input,   width = 13,                .address
		.avmm_pipe_slave_write         (_connected_to_avmm_pipe_slave_write_),         //   input,    width = 1,                .write
		.avmm_pipe_slave_read          (_connected_to_avmm_pipe_slave_read_),          //   input,    width = 1,                .read
		.avmm_pipe_slave_byteenable    (_connected_to_avmm_pipe_slave_byteenable_),    //   input,    width = 8,                .byteenable
		.avmm_pipe_slave_debugaccess   (_connected_to_avmm_pipe_slave_debugaccess_),   //   input,    width = 1,                .debugaccess
		.clk_clk                       (_connected_to_clk_clk_),                       //   input,    width = 1,             clk.clk
		.reset_reset                   (_connected_to_reset_reset_)                    //   input,    width = 1,           reset.reset
	);

