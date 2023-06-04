	board_kernel_interface u0 (
		.kernel_cra_waitrequest        (_connected_to_kernel_cra_waitrequest_),        //   input,   width = 1,               kernel_cra.waitrequest
		.kernel_cra_readdata           (_connected_to_kernel_cra_readdata_),           //   input,  width = 64,                         .readdata
		.kernel_cra_readdatavalid      (_connected_to_kernel_cra_readdatavalid_),      //   input,   width = 1,                         .readdatavalid
		.kernel_cra_burstcount         (_connected_to_kernel_cra_burstcount_),         //  output,   width = 1,                         .burstcount
		.kernel_cra_writedata          (_connected_to_kernel_cra_writedata_),          //  output,  width = 64,                         .writedata
		.kernel_cra_address            (_connected_to_kernel_cra_address_),            //  output,  width = 30,                         .address
		.kernel_cra_write              (_connected_to_kernel_cra_write_),              //  output,   width = 1,                         .write
		.kernel_cra_read               (_connected_to_kernel_cra_read_),               //  output,   width = 1,                         .read
		.kernel_cra_byteenable         (_connected_to_kernel_cra_byteenable_),         //  output,   width = 8,                         .byteenable
		.kernel_cra_debugaccess        (_connected_to_kernel_cra_debugaccess_),        //  output,   width = 1,                         .debugaccess
		.ctrl_waitrequest              (_connected_to_ctrl_waitrequest_),              //  output,   width = 1,                     ctrl.waitrequest
		.ctrl_readdata                 (_connected_to_ctrl_readdata_),                 //  output,  width = 32,                         .readdata
		.ctrl_readdatavalid            (_connected_to_ctrl_readdatavalid_),            //  output,   width = 1,                         .readdatavalid
		.ctrl_burstcount               (_connected_to_ctrl_burstcount_),               //   input,   width = 1,                         .burstcount
		.ctrl_writedata                (_connected_to_ctrl_writedata_),                //   input,  width = 32,                         .writedata
		.ctrl_address                  (_connected_to_ctrl_address_),                  //   input,  width = 14,                         .address
		.ctrl_write                    (_connected_to_ctrl_write_),                    //   input,   width = 1,                         .write
		.ctrl_read                     (_connected_to_ctrl_read_),                     //   input,   width = 1,                         .read
		.ctrl_byteenable               (_connected_to_ctrl_byteenable_),               //   input,   width = 4,                         .byteenable
		.ctrl_debugaccess              (_connected_to_ctrl_debugaccess_),              //   input,   width = 1,                         .debugaccess
		.acl_bsp_memorg_host0x018_mode (_connected_to_acl_bsp_memorg_host0x018_mode_), //  output,   width = 2, acl_bsp_memorg_host0x018.mode
		.clk_clk                       (_connected_to_clk_clk_),                       //   input,   width = 1,                      clk.clk
		.reset_reset_n                 (_connected_to_reset_reset_n_),                 //   input,   width = 1,                    reset.reset_n
		.kernel_irq_from_kernel_irq    (_connected_to_kernel_irq_from_kernel_irq_),    //   input,   width = 1,   kernel_irq_from_kernel.irq
		.kernel_irq_to_host_irq        (_connected_to_kernel_irq_to_host_irq_),        //  output,   width = 1,       kernel_irq_to_host.irq
		.sw_reset_in_reset             (_connected_to_sw_reset_in_reset_),             //   input,   width = 1,              sw_reset_in.reset
		.kernel_clk_clk                (_connected_to_kernel_clk_clk_),                //   input,   width = 1,               kernel_clk.clk
		.kernel_reset_reset_n          (_connected_to_kernel_reset_reset_n_),          //  output,   width = 1,             kernel_reset.reset_n
		.sw_reset_export_reset_n       (_connected_to_sw_reset_export_reset_n_)        //  output,   width = 1,          sw_reset_export.reset_n
	);

