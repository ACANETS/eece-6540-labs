// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Altera IRQ Bridge
//
// Parameters
//   IRQ_WIDTH        : $IRQ_WIDTH
//
// -------------------------------------------------------

//------------------------------------------
// Message Supression Used
// QIS Warnings
// 15610 - Warning: Design contains x input pin(s) that do not drive logic
//------------------------------------------


`timescale 1 ns / 1 ns

module board_kernel_interface_altera_irq_bridge_191_bwtdp3y 
#(
	parameter IRQ_WIDTH	= 32
)
(
	(*altera_attribute = "-name MESSAGE_DISABLE 15610" *) // setting message suppression on clk
	input				clk,
	(*altera_attribute = "-name MESSAGE_DISABLE 15610" *) // setting message suppression on reset
	input				reset,
	input [IRQ_WIDTH - 1:0]		receiver_irq,
	output 				sender31_irq,
        output                          sender30_irq,
        output                          sender29_irq,
        output                          sender28_irq,
        output                          sender27_irq,
        output                          sender26_irq,
        output                          sender25_irq,
        output                          sender24_irq,
        output                          sender23_irq,
        output                          sender22_irq,
        output                          sender21_irq,
        output                          sender20_irq,
        output                          sender19_irq,
        output                          sender18_irq,
        output                          sender17_irq,
        output                          sender16_irq,
        output                          sender15_irq,
        output                          sender14_irq,
        output                          sender13_irq,
        output                          sender12_irq,
        output                          sender11_irq,
        output                          sender10_irq,
        output                          sender9_irq,
        output                          sender8_irq,
        output                          sender7_irq,
        output                          sender6_irq,
        output                          sender5_irq,
        output                          sender4_irq,
        output                          sender3_irq,
        output                          sender2_irq,
        output                          sender1_irq,
        output                          sender0_irq
);

	wire [31:0]                     receiver_temp_irq;
	assign receiver_temp_irq = {{(32 - IRQ_WIDTH){1'b0}}, receiver_irq};  //to align a non-32bit receiver interface with 32 interfaces of the receiver

	assign sender0_irq = receiver_temp_irq[0];
        assign sender1_irq = receiver_temp_irq[1];
        assign sender2_irq = receiver_temp_irq[2];
        assign sender3_irq = receiver_temp_irq[3];
        assign sender4_irq = receiver_temp_irq[4];
        assign sender5_irq = receiver_temp_irq[5];
        assign sender6_irq = receiver_temp_irq[6];
        assign sender7_irq = receiver_temp_irq[7];
        assign sender8_irq = receiver_temp_irq[8];
        assign sender9_irq = receiver_temp_irq[9];
        assign sender10_irq = receiver_temp_irq[10];
        assign sender11_irq = receiver_temp_irq[11];
        assign sender12_irq = receiver_temp_irq[12];
        assign sender13_irq = receiver_temp_irq[13];
        assign sender14_irq = receiver_temp_irq[14];
        assign sender15_irq = receiver_temp_irq[15];
        assign sender16_irq = receiver_temp_irq[16];
        assign sender17_irq = receiver_temp_irq[17];
        assign sender18_irq = receiver_temp_irq[18];
        assign sender19_irq = receiver_temp_irq[19];
        assign sender20_irq = receiver_temp_irq[20];
        assign sender21_irq = receiver_temp_irq[21];
        assign sender22_irq = receiver_temp_irq[22];
        assign sender23_irq = receiver_temp_irq[23];
        assign sender24_irq = receiver_temp_irq[24];
        assign sender25_irq = receiver_temp_irq[25];
        assign sender26_irq = receiver_temp_irq[26];
        assign sender27_irq = receiver_temp_irq[27];
        assign sender28_irq = receiver_temp_irq[28];
        assign sender29_irq = receiver_temp_irq[29];
        assign sender30_irq = receiver_temp_irq[30];
        assign sender31_irq = receiver_temp_irq[31];

endmodule

