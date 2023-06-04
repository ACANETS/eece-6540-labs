module board_irq_ctrl_0 (
		input  wire        IrqRead_i,         //     IRQ_Read_Slave.read
		output wire [31:0] IrqReadData_o,     //                   .readdata
		input  wire        MaskWrite_i,       //     IRQ_Mask_Slave.write
		input  wire [31:0] MaskWritedata_i,   //                   .writedata
		input  wire [3:0]  MaskByteenable_i,  //                   .byteenable
		input  wire        MaskRead_i,        //                   .read
		output wire [31:0] MaskReaddata_o,    //                   .readdata
		output wire        MaskWaitrequest_o, //                   .waitrequest
		input  wire        Clk_i,             //              Clock.clk
		input  wire        Rstn_i,            //             Resetn.reset_n
		input  wire [31:0] Irq_i,             // interrupt_receiver.irq
		output wire        Irq_o              //   interrupt_sender.irq
	);
endmodule

