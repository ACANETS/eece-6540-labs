// ------------------------------------------------------------------------- 
// High Level Design Compiler for Intel(R) FPGAs Version 19.4 (Release Build #64)
// 
// Legal Notice: Copyright 2019 Intel Corporation.  All rights reserved.
// Your use of  Intel Corporation's design tools,  logic functions and other
// software and  tools, and its AMPP partner logic functions, and any output
// files any  of the foregoing (including  device programming  or simulation
// files), and  any associated  documentation  or information  are expressly
// subject  to the terms and  conditions of the  Intel FPGA Software License
// Agreement, Intel MegaCore Function License Agreement, or other applicable
// license agreement,  including,  without limitation,  that your use is for
// the  sole  purpose of  programming  logic devices  manufactured by  Intel
// and  sold by Intel  or its authorized  distributors. Please refer  to the
// applicable agreement for further details.
// ---------------------------------------------------------------------------

// SystemVerilog created from hello_world_i_llvm_fpga_sync_buffer_i32_A000000Zssage_sync_buffer1_0
// SystemVerilog created on Sun Jun  4 07:38:25 2023


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_i_llvm_fpga_sync_buffer_i32_A000000Zssage_sync_buffer1_0 (
    input wire [31:0] in_buffer_in,
    input wire [0:0] in_stall_in,
    output wire [0:0] out_stall_out,
    input wire [0:0] in_i_dependence,
    input wire [0:0] in_valid_in,
    output wire [31:0] out_buffer_out,
    output wire [0:0] out_valid_out,
    input wire clock,
    input wire resetn
    );

    wire [31:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1_buffer_in;
    wire [31:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1_buffer_out;


    // sync_out(GPOUT,6)@20000000
    assign out_stall_out = in_stall_in;

    // i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1(EXTIFACE,2)
    assign i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1_buffer_in = in_buffer_in;
    acl_dspba_buffer #(
        .WIDTH(32)
    ) thei_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1 (
        .buffer_in(in_buffer_in),
        .buffer_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1_buffer_out)
    );

    // dupName_0_sync_out_x(GPOUT,8)@3
    assign out_buffer_out = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world1_buffer_out;
    assign out_valid_out = in_valid_in;

endmodule
