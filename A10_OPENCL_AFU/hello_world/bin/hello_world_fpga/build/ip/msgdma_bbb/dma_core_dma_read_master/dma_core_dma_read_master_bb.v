module dma_core_dma_read_master #(
		parameter DATA_WIDTH                = 512,
		parameter LENGTH_WIDTH              = 24,
		parameter FIFO_DEPTH                = 128,
		parameter STRIDE_ENABLE             = 0,
		parameter BURST_ENABLE              = 1,
		parameter PACKET_ENABLE             = 0,
		parameter ERROR_ENABLE              = 0,
		parameter ERROR_WIDTH               = 8,
		parameter CHANNEL_ENABLE            = 0,
		parameter CHANNEL_WIDTH             = 8,
		parameter BYTE_ENABLE_WIDTH         = 64,
		parameter BYTE_ENABLE_WIDTH_LOG2    = 6,
		parameter ADDRESS_WIDTH             = 50,
		parameter FIFO_DEPTH_LOG2           = 7,
		parameter SYMBOL_WIDTH              = 8,
		parameter NUMBER_OF_SYMBOLS         = 64,
		parameter NUMBER_OF_SYMBOLS_LOG2    = 6,
		parameter MAX_BURST_COUNT_WIDTH     = 3,
		parameter UNALIGNED_ACCESSES_ENABLE = 0,
		parameter ONLY_FULL_ACCESS_ENABLE   = 1,
		parameter BURST_WRAPPING_SUPPORT    = 0,
		parameter PROGRAMMABLE_BURST_ENABLE = 1,
		parameter MAX_BURST_COUNT           = 4,
		parameter FIFO_SPEED_OPTIMIZATION   = 1,
		parameter STRIDE_WIDTH              = 1
	) (
		input  wire         clk,                  //            Clock.clk
		input  wire         reset,                //      Clock_reset.reset
		output wire [49:0]  master_address,       // Data_Read_Master.address
		output wire         master_read,          //                 .read
		output wire [63:0]  master_byteenable,    //                 .byteenable
		input  wire [511:0] master_readdata,      //                 .readdata
		input  wire         master_waitrequest,   //                 .waitrequest
		input  wire         master_readdatavalid, //                 .readdatavalid
		output wire [2:0]   master_burstcount,    //                 .burstcount
		output wire [511:0] src_data,             //      Data_Source.data
		output wire         src_valid,            //                 .valid
		input  wire         src_ready,            //                 .ready
		input  wire [255:0] snk_command_data,     //     Command_Sink.data
		input  wire         snk_command_valid,    //                 .valid
		output wire         snk_command_ready,    //                 .ready
		output wire [255:0] src_response_data,    //  Response_Source.data
		output wire         src_response_valid,   //                 .valid
		input  wire         src_response_ready    //                 .ready
	);
endmodule

