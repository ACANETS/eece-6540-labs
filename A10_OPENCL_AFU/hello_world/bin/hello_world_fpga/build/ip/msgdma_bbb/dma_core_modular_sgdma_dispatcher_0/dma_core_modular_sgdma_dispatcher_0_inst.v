	dma_core_modular_sgdma_dispatcher_0 u0 (
		.clk                    (_connected_to_clk_),                    //   input,    width = 1,                clock.clk
		.reset                  (_connected_to_reset_),                  //   input,    width = 1,          clock_reset.reset
		.csr_writedata          (_connected_to_csr_writedata_),          //   input,   width = 32,                  CSR.writedata
		.csr_write              (_connected_to_csr_write_),              //   input,    width = 1,                     .write
		.csr_byteenable         (_connected_to_csr_byteenable_),         //   input,    width = 4,                     .byteenable
		.csr_readdata           (_connected_to_csr_readdata_),           //  output,   width = 32,                     .readdata
		.csr_read               (_connected_to_csr_read_),               //   input,    width = 1,                     .read
		.csr_address            (_connected_to_csr_address_),            //   input,    width = 3,                     .address
		.descriptor_write       (_connected_to_descriptor_write_),       //   input,    width = 1,     Descriptor_Slave.write
		.descriptor_waitrequest (_connected_to_descriptor_waitrequest_), //  output,    width = 1,                     .waitrequest
		.descriptor_writedata   (_connected_to_descriptor_writedata_),   //   input,  width = 256,                     .writedata
		.descriptor_byteenable  (_connected_to_descriptor_byteenable_),  //   input,   width = 32,                     .byteenable
		.src_write_master_data  (_connected_to_src_write_master_data_),  //  output,  width = 256, Write_Command_Source.data
		.src_write_master_valid (_connected_to_src_write_master_valid_), //  output,    width = 1,                     .valid
		.src_write_master_ready (_connected_to_src_write_master_ready_), //   input,    width = 1,                     .ready
		.snk_write_master_data  (_connected_to_snk_write_master_data_),  //   input,  width = 256,  Write_Response_Sink.data
		.snk_write_master_valid (_connected_to_snk_write_master_valid_), //   input,    width = 1,                     .valid
		.snk_write_master_ready (_connected_to_snk_write_master_ready_), //  output,    width = 1,                     .ready
		.src_read_master_data   (_connected_to_src_read_master_data_),   //  output,  width = 256,  Read_Command_Source.data
		.src_read_master_valid  (_connected_to_src_read_master_valid_),  //  output,    width = 1,                     .valid
		.src_read_master_ready  (_connected_to_src_read_master_ready_),  //   input,    width = 1,                     .ready
		.snk_read_master_data   (_connected_to_snk_read_master_data_),   //   input,  width = 256,   Read_Response_Sink.data
		.snk_read_master_valid  (_connected_to_snk_read_master_valid_),  //   input,    width = 1,                     .valid
		.snk_read_master_ready  (_connected_to_snk_read_master_ready_),  //  output,    width = 1,                     .ready
		.csr_irq                (_connected_to_csr_irq_)                 //  output,    width = 1,              csr_irq.irq
	);

