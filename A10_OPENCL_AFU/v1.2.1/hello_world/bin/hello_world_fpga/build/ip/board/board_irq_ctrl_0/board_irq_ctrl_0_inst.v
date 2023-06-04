	board_irq_ctrl_0 u0 (
		.IrqRead_i         (_connected_to_IrqRead_i_),         //   input,   width = 1,     IRQ_Read_Slave.read
		.IrqReadData_o     (_connected_to_IrqReadData_o_),     //  output,  width = 32,                   .readdata
		.MaskWrite_i       (_connected_to_MaskWrite_i_),       //   input,   width = 1,     IRQ_Mask_Slave.write
		.MaskWritedata_i   (_connected_to_MaskWritedata_i_),   //   input,  width = 32,                   .writedata
		.MaskByteenable_i  (_connected_to_MaskByteenable_i_),  //   input,   width = 4,                   .byteenable
		.MaskRead_i        (_connected_to_MaskRead_i_),        //   input,   width = 1,                   .read
		.MaskReaddata_o    (_connected_to_MaskReaddata_o_),    //  output,  width = 32,                   .readdata
		.MaskWaitrequest_o (_connected_to_MaskWaitrequest_o_), //  output,   width = 1,                   .waitrequest
		.Clk_i             (_connected_to_Clk_i_),             //   input,   width = 1,              Clock.clk
		.Rstn_i            (_connected_to_Rstn_i_),            //   input,   width = 1,             Resetn.reset_n
		.Irq_i             (_connected_to_Irq_i_),             //   input,  width = 32, interrupt_receiver.irq
		.Irq_o             (_connected_to_Irq_o_)              //  output,   width = 1,   interrupt_sender.irq
	);

