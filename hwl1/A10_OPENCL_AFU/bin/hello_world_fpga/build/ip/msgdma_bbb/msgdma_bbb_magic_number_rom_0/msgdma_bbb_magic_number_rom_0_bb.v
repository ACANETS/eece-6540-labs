module msgdma_bbb_magic_number_rom_0 #(
		parameter MAGIC_NUMBER_LOW  = 1400467043,
		parameter MAGIC_NUMBER_HIGH = 1467118687
	) (
		input  wire         clk,           //   clk.clk
		input  wire         reset,         // reset.reset
		input  wire [1:0]   address,       // slave.address
		input  wire [2:0]   burst,         //      .burstcount
		input  wire         read,          //      .read
		output wire [511:0] readdata,      //      .readdata
		output wire         waitrequest,   //      .waitrequest
		output wire         readdatavalid  //      .readdatavalid
	);
endmodule

