	ddr_board_acl_memory_bank_divider_0 u0 (
		.clk_clk                  (_connected_to_clk_clk_),                  //   input,    width = 1,                 clk.clk
		.reset_reset_n            (_connected_to_reset_reset_n_),            //   input,    width = 1,               reset.reset_n
		.acl_bsp_snoop_data       (_connected_to_acl_bsp_snoop_data_),       //  output,   width = 33,       acl_bsp_snoop.data
		.acl_bsp_snoop_valid      (_connected_to_acl_bsp_snoop_valid_),      //  output,    width = 1,                    .valid
		.acl_bsp_snoop_ready      (_connected_to_acl_bsp_snoop_ready_),      //   input,    width = 1,                    .ready
		.kernel_clk_clk           (_connected_to_kernel_clk_clk_),           //   input,    width = 1,          kernel_clk.clk
		.kernel_reset_reset_n     (_connected_to_kernel_reset_reset_n_),     //   input,    width = 1,        kernel_reset.reset_n
		.s_writedata              (_connected_to_s_writedata_),              //   input,  width = 512,                   s.writedata
		.s_read                   (_connected_to_s_read_),                   //   input,    width = 1,                    .read
		.s_write                  (_connected_to_s_write_),                  //   input,    width = 1,                    .write
		.s_burstcount             (_connected_to_s_burstcount_),             //   input,    width = 5,                    .burstcount
		.s_byteenable             (_connected_to_s_byteenable_),             //   input,   width = 64,                    .byteenable
		.s_waitrequest            (_connected_to_s_waitrequest_),            //  output,    width = 1,                    .waitrequest
		.s_readdata               (_connected_to_s_readdata_),               //  output,  width = 512,                    .readdata
		.s_readdatavalid          (_connected_to_s_readdatavalid_),          //  output,    width = 1,                    .readdatavalid
		.s_address                (_connected_to_s_address_),                //   input,   width = 27,                    .address
		.acl_bsp_memorg_host_mode (_connected_to_acl_bsp_memorg_host_mode_), //   input,    width = 2, acl_bsp_memorg_host.mode
		.bank1_address            (_connected_to_bank1_address_),            //  output,   width = 32,               bank1.address
		.bank1_writedata          (_connected_to_bank1_writedata_),          //  output,  width = 512,                    .writedata
		.bank1_read               (_connected_to_bank1_read_),               //  output,    width = 1,                    .read
		.bank1_write              (_connected_to_bank1_write_),              //  output,    width = 1,                    .write
		.bank1_burstcount         (_connected_to_bank1_burstcount_),         //  output,    width = 5,                    .burstcount
		.bank1_byteenable         (_connected_to_bank1_byteenable_),         //  output,   width = 64,                    .byteenable
		.bank1_waitrequest        (_connected_to_bank1_waitrequest_),        //   input,    width = 1,                    .waitrequest
		.bank1_readdata           (_connected_to_bank1_readdata_),           //   input,  width = 512,                    .readdata
		.bank1_readdatavalid      (_connected_to_bank1_readdatavalid_),      //   input,    width = 1,                    .readdatavalid
		.bank2_address            (_connected_to_bank2_address_),            //  output,   width = 32,               bank2.address
		.bank2_writedata          (_connected_to_bank2_writedata_),          //  output,  width = 512,                    .writedata
		.bank2_read               (_connected_to_bank2_read_),               //  output,    width = 1,                    .read
		.bank2_write              (_connected_to_bank2_write_),              //  output,    width = 1,                    .write
		.bank2_burstcount         (_connected_to_bank2_burstcount_),         //  output,    width = 5,                    .burstcount
		.bank2_byteenable         (_connected_to_bank2_byteenable_),         //  output,   width = 64,                    .byteenable
		.bank2_waitrequest        (_connected_to_bank2_waitrequest_),        //   input,    width = 1,                    .waitrequest
		.bank2_readdata           (_connected_to_bank2_readdata_),           //   input,  width = 512,                    .readdata
		.bank2_readdatavalid      (_connected_to_bank2_readdatavalid_)       //   input,    width = 1,                    .readdatavalid
	);

