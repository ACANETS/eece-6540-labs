module dma_core_dma_write_master #(
		parameter DATA_WIDTH                     = 512,
		parameter LENGTH_WIDTH                   = 24,
		parameter FIFO_DEPTH                     = 128,
		parameter STRIDE_ENABLE                  = 0,
		parameter BURST_ENABLE                   = 1,
		parameter WRITE_RESPONSE_ENABLE          = 0,
		parameter PACKET_ENABLE                  = 0,
		parameter ERROR_ENABLE                   = 0,
		parameter ERROR_WIDTH                    = 8,
		parameter BYTE_ENABLE_WIDTH              = 64,
		parameter BYTE_ENABLE_WIDTH_LOG2         = 6,
		parameter NO_BYTEENABLES                 = 0,
		parameter ADDRESS_WIDTH                  = 50,
		parameter FIFO_DEPTH_LOG2                = 7,
		parameter SYMBOL_WIDTH                   = 8,
		parameter NUMBER_OF_SYMBOLS              = 64,
		parameter NUMBER_OF_SYMBOLS_LOG2         = 6,
		parameter MAX_BURST_COUNT_WIDTH          = 3,
		parameter UNALIGNED_ACCESSES_ENABLE      = 0,
		parameter ONLY_FULL_ACCESS_ENABLE        = 1,
		parameter BURST_WRAPPING_SUPPORT         = 0,
		parameter PROGRAMMABLE_BURST_ENABLE      = 1,
		parameter MAX_BURST_COUNT                = 4,
		parameter FIFO_SPEED_OPTIMIZATION        = 1,
		parameter STRIDE_WIDTH                   = 1,
		parameter ACTUAL_BYTES_TRANSFERRED_WIDTH = 32
	) (
		input  wire         clk,                //             Clock.clk
		input  wire         reset,              //       Clock_reset.reset
		output wire [49:0]  master_address,     // Data_Write_Master.address
		output wire         master_write,       //                  .write
		output wire [63:0]  master_byteenable,  //                  .byteenable
		output wire [511:0] master_writedata,   //                  .writedata
		input  wire         master_waitrequest, //                  .waitrequest
		output wire [2:0]   master_burstcount,  //                  .burstcount
		input  wire [511:0] snk_data,           //         Data_Sink.data
		input  wire         snk_valid,          //                  .valid
		output wire         snk_ready,          //                  .ready
		input  wire [255:0] snk_command_data,   //      Command_Sink.data
		input  wire         snk_command_valid,  //                  .valid
		output wire         snk_command_ready,  //                  .ready
		output wire [255:0] src_response_data,  //   Response_Source.data
		output wire         src_response_valid, //                  .valid
		input  wire         src_response_ready  //                  .ready
	);
endmodule

