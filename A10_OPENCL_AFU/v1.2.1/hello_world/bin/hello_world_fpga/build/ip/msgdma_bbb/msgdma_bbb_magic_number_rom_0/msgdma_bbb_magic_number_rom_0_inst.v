	msgdma_bbb_magic_number_rom_0 #(
		.MAGIC_NUMBER_LOW  (INTEGER_VALUE_FOR_MAGIC_NUMBER_LOW),
		.MAGIC_NUMBER_HIGH (INTEGER_VALUE_FOR_MAGIC_NUMBER_HIGH)
	) u0 (
		.clk           (_connected_to_clk_),           //   input,    width = 1,   clk.clk
		.reset         (_connected_to_reset_),         //   input,    width = 1, reset.reset
		.address       (_connected_to_address_),       //   input,    width = 2, slave.address
		.burst         (_connected_to_burst_),         //   input,    width = 3,      .burstcount
		.read          (_connected_to_read_),          //   input,    width = 1,      .read
		.readdata      (_connected_to_readdata_),      //  output,  width = 512,      .readdata
		.waitrequest   (_connected_to_waitrequest_),   //  output,    width = 1,      .waitrequest
		.readdatavalid (_connected_to_readdatavalid_)  //  output,    width = 1,      .readdatavalid
	);

