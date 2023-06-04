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

// SystemVerilog created from hello_world_bb_B0_stall_region
// SystemVerilog created on Sun Jun  4 09:53:46 2023


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_bb_B0_stall_region (
    input wire [255:0] in_printf_addr_hello_world_avm_readdata,
    input wire [0:0] in_printf_addr_hello_world_avm_writeack,
    input wire [0:0] in_printf_addr_hello_world_avm_waitrequest,
    input wire [0:0] in_printf_addr_hello_world_avm_readdatavalid,
    output wire [31:0] out_printf_addr_hello_world_avm_address,
    output wire [0:0] out_printf_addr_hello_world_avm_enable,
    output wire [0:0] out_printf_addr_hello_world_avm_read,
    output wire [0:0] out_printf_addr_hello_world_avm_write,
    output wire [255:0] out_printf_addr_hello_world_avm_writedata,
    output wire [31:0] out_printf_addr_hello_world_avm_byteenable,
    output wire [5:0] out_printf_addr_hello_world_avm_burstcount,
    input wire [0:0] in_flush,
    input wire [31:0] in_thread_id_from_which_to_print_message,
    input wire [0:0] in_stall_in,
    output wire [0:0] out_stall_out,
    input wire [63:0] in_acl_global_id_0,
    input wire [0:0] in_valid_in,
    input wire [511:0] in_unnamed_hello_world0_hello_world_avm_readdata,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_writeack,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_waitrequest,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_readdatavalid,
    output wire [32:0] out_unnamed_hello_world0_hello_world_avm_address,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_enable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_read,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_write,
    output wire [511:0] out_unnamed_hello_world0_hello_world_avm_writedata,
    output wire [63:0] out_unnamed_hello_world0_hello_world_avm_byteenable,
    output wire [4:0] out_unnamed_hello_world0_hello_world_avm_burstcount,
    output wire [0:0] out_valid_out,
    output wire [0:0] out_lsu_unnamed_hello_world0_o_active,
    input wire clock,
    input wire resetn
    );

    wire [0:0] GND_q;
    wire [0:0] VCC_q;
    wire [255:0] c_i256_114_q;
    wire [31:0] c_i32_3212_q;
    wire [0:0] i_cmp_hello_world2_q;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_lsu_unnamed_hello_world0_o_active;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_stall;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_valid;
    wire [32:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_address;
    wire [4:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_burstcount;
    wire [63:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_byteenable;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_enable;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_read;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_write;
    wire [511:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_writedata;
    wire [63:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_result;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_stall;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_valid;
    wire [31:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_address;
    wire [5:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_burstcount;
    wire [31:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_byteenable;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_enable;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_read;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_write;
    wire [255:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_writedata;
    wire [31:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_buffer_out;
    wire [0:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_stall_out;
    wire [0:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_valid_out;
    wire [31:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_buffer_out;
    wire [0:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_stall_out;
    wire [0:0] i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_valid_out;
    wire [255:0] i_or_hello_world8_q;
    wire [191:0] i_or_hello_world8_vt_const_255_q;
    wire [31:0] i_or_hello_world8_vt_const_31_q;
    wire [255:0] i_or_hello_world8_vt_join_q;
    wire [31:0] i_or_hello_world8_vt_select_63_b;
    wire [31:0] i_s_align_hello_world7_vt_const_31_q;
    wire [255:0] i_s_align_hello_world7_vt_join_q;
    wire [31:0] i_s_align_hello_world7_vt_select_63_b;
    wire [223:0] i_zext3_hello_world6_vt_const_255_q;
    wire [255:0] i_zext3_hello_world6_vt_join_q;
    wire [31:0] i_zext3_hello_world6_vt_select_31_b;
    wire [0:0] hello_world_B0_merge_reg_aunroll_x_out_stall_out;
    wire [0:0] hello_world_B0_merge_reg_aunroll_x_out_valid_out;
    wire [63:0] hello_world_B0_merge_reg_aunroll_x_out_data_out_0_tpl;
    wire [31:0] i_conv_hello_world0_sel_x_b;
    wire [255:0] i_zext3_hello_world6_sel_x_b;
    wire [223:0] leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_in;
    wire [223:0] leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_b;
    wire [255:0] leftShiftStage0Idx1_uid67_i_s_align_hello_world0_shift_x_q;
    wire [0:0] leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_s;
    reg [255:0] leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_q;
    reg [0:0] redist0_i_cmp_hello_world2_q_2_0_q;
    reg [0:0] redist0_i_cmp_hello_world2_q_2_1_q;
    wire [63:0] bubble_join_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_q;
    wire [63:0] bubble_select_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_b;
    wire [31:0] bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_q;
    wire [31:0] bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_b;
    wire [31:0] bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_q;
    wire [31:0] bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_b;
    wire [63:0] bubble_join_stall_entry_q;
    wire [63:0] bubble_select_stall_entry_b;
    wire [63:0] bubble_join_hello_world_B0_merge_reg_aunroll_x_q;
    wire [63:0] bubble_select_hello_world_B0_merge_reg_aunroll_x_b;
    wire [0:0] SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_wireValid;
    wire [0:0] SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_backStall;
    wire [0:0] SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_V0;
    wire [0:0] SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid;
    wire [0:0] SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_and0;
    wire [0:0] SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall;
    wire [0:0] SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0;
    wire [0:0] SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid;
    wire [0:0] SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall;
    wire [0:0] SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_wireValid;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and1;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_backStall;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_V0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireStall;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_StallValid;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg0;
    reg [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg1;
    reg [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg1;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed1;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_and0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_or0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_backStall;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V0;
    wire [0:0] SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V1;
    wire [0:0] SE_stall_entry_wireValid;
    wire [0:0] SE_stall_entry_backStall;
    wire [0:0] SE_stall_entry_V0;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_wireStall;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_toReg0;
    reg [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg0;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_consumed0;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_toReg1;
    reg [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg1;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_consumed1;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_toReg2;
    reg [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg2;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_consumed2;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_toReg3;
    reg [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg3;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_consumed3;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_or0;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_or1;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_or2;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_backStall;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_V0;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_V1;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_V2;
    wire [0:0] SE_out_hello_world_B0_merge_reg_aunroll_x_V3;
    reg [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_v_s_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_s_tv_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_backEN;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_backStall;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_0_V0;
    reg [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_v_s_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_s_tv_0;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_backEN;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_backStall;
    wire [0:0] SE_redist0_i_cmp_hello_world2_q_2_1_V0;
    wire [0:0] SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_wireValid;
    wire [0:0] SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_backStall;
    wire [0:0] SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_V0;
    wire [0:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in;
    wire bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in_bitsignaltemp;
    wire [0:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in;
    wire bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in_bitsignaltemp;
    wire [63:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_data_in;
    wire [0:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out;
    wire bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out_bitsignaltemp;
    wire [0:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out;
    wire bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out_bitsignaltemp;
    wire [63:0] bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_data_out;
    wire [0:0] bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in;
    wire bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in_bitsignaltemp;
    wire [0:0] bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in;
    wire bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in_bitsignaltemp;
    wire [0:0] bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out;
    wire bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out_bitsignaltemp;
    wire [0:0] bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out;
    wire bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out_bitsignaltemp;


    // i_or_hello_world8_vt_const_255(CONSTANT,17)
    assign i_or_hello_world8_vt_const_255_q = $unsigned(192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);

    // c_i256_114(CONSTANT,3)
    assign c_i256_114_q = $unsigned(256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001);

    // leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x(BITSELECT,65)@3
    assign leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_in = i_zext3_hello_world6_vt_join_q[223:0];
    assign leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_b = leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_in[223:0];

    // leftShiftStage0Idx1_uid67_i_s_align_hello_world0_shift_x(BITJOIN,66)@3
    assign leftShiftStage0Idx1_uid67_i_s_align_hello_world0_shift_x_q = {leftShiftStage0Idx1Rng32_uid66_i_s_align_hello_world0_shift_x_b, i_s_align_hello_world7_vt_const_31_q};

    // i_zext3_hello_world6_vt_const_255(CONSTANT,26)
    assign i_zext3_hello_world6_vt_const_255_q = $unsigned(224'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);

    // bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5(BITJOIN,78)
    assign bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_q = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_buffer_out;

    // bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5(BITSELECT,79)
    assign bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_b = $unsigned(bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_q[31:0]);

    // i_zext3_hello_world6_sel_x(BITSELECT,58)@3
    assign i_zext3_hello_world6_sel_x_b = {224'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000, bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_b[31:0]};

    // i_zext3_hello_world6_vt_select_31(BITSELECT,28)@3
    assign i_zext3_hello_world6_vt_select_31_b = i_zext3_hello_world6_sel_x_b[31:0];

    // i_zext3_hello_world6_vt_join(BITJOIN,27)@3
    assign i_zext3_hello_world6_vt_join_q = {i_zext3_hello_world6_vt_const_255_q, i_zext3_hello_world6_vt_select_31_b};

    // VCC(CONSTANT,1)
    assign VCC_q = $unsigned(1'b1);

    // leftShiftStage0_uid69_i_s_align_hello_world0_shift_x(MUX,68)@3
    assign leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_s = VCC_q;
    always @(leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_s or i_zext3_hello_world6_vt_join_q or leftShiftStage0Idx1_uid67_i_s_align_hello_world0_shift_x_q)
    begin
        unique case (leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_s)
            1'b0 : leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_q = i_zext3_hello_world6_vt_join_q;
            1'b1 : leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_q = leftShiftStage0Idx1_uid67_i_s_align_hello_world0_shift_x_q;
            default : leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_q = 256'b0;
        endcase
    end

    // i_s_align_hello_world7_vt_select_63(BITSELECT,24)@3
    assign i_s_align_hello_world7_vt_select_63_b = leftShiftStage0_uid69_i_s_align_hello_world0_shift_x_q[63:32];

    // i_s_align_hello_world7_vt_const_31(CONSTANT,22)
    assign i_s_align_hello_world7_vt_const_31_q = $unsigned(32'b00000000000000000000000000000000);

    // i_s_align_hello_world7_vt_join(BITJOIN,23)@3
    assign i_s_align_hello_world7_vt_join_q = {i_or_hello_world8_vt_const_255_q, i_s_align_hello_world7_vt_select_63_b, i_s_align_hello_world7_vt_const_31_q};

    // i_or_hello_world8(LOGICAL,16)@3
    assign i_or_hello_world8_q = i_s_align_hello_world7_vt_join_q | c_i256_114_q;

    // i_or_hello_world8_vt_select_63(BITSELECT,20)@3
    assign i_or_hello_world8_vt_select_63_b = i_or_hello_world8_q[63:32];

    // i_or_hello_world8_vt_const_31(CONSTANT,18)
    assign i_or_hello_world8_vt_const_31_q = $unsigned(32'b00000000000000000000000000000001);

    // i_or_hello_world8_vt_join(BITJOIN,19)@3
    assign i_or_hello_world8_vt_join_q = {i_or_hello_world8_vt_const_255_q, i_or_hello_world8_vt_select_63_b, i_or_hello_world8_vt_const_31_q};

    // SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10(STALLENABLE,94)
    // Valid signal propagation
    assign SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_V0 = SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_wireValid;
    // Backward Stall generation
    assign SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_backStall = in_stall_in | ~ (SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_wireValid);
    // Computing multiple Valid(s)
    assign SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_wireValid = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_valid;

    // SE_redist0_i_cmp_hello_world2_q_2_0(STALLENABLE,117)
    // Valid signal propagation
    assign SE_redist0_i_cmp_hello_world2_q_2_0_V0 = SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0;
    // Stall signal propagation
    assign SE_redist0_i_cmp_hello_world2_q_2_0_s_tv_0 = SE_redist0_i_cmp_hello_world2_q_2_1_backStall & SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0;
    // Backward Enable generation
    assign SE_redist0_i_cmp_hello_world2_q_2_0_backEN = ~ (SE_redist0_i_cmp_hello_world2_q_2_0_s_tv_0);
    // Determine whether to write valid data into the first register stage
    assign SE_redist0_i_cmp_hello_world2_q_2_0_v_s_0 = SE_redist0_i_cmp_hello_world2_q_2_0_backEN & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V1;
    // Backward Stall generation
    assign SE_redist0_i_cmp_hello_world2_q_2_0_backStall = ~ (SE_redist0_i_cmp_hello_world2_q_2_0_v_s_0);
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0 <= 1'b0;
        end
        else
        begin
            if (SE_redist0_i_cmp_hello_world2_q_2_0_backEN == 1'b0)
            begin
                SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0 <= SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0 & SE_redist0_i_cmp_hello_world2_q_2_0_s_tv_0;
            end
            else
            begin
                SE_redist0_i_cmp_hello_world2_q_2_0_R_v_0 <= SE_redist0_i_cmp_hello_world2_q_2_0_v_s_0;
            end

        end
    end

    // redist0_i_cmp_hello_world2_q_2_0(REG,71)
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            redist0_i_cmp_hello_world2_q_2_0_q <= $unsigned(1'b0);
        end
        else if (SE_redist0_i_cmp_hello_world2_q_2_0_backEN == 1'b1)
        begin
            redist0_i_cmp_hello_world2_q_2_0_q <= $unsigned(i_cmp_hello_world2_q);
        end
    end

    // redist0_i_cmp_hello_world2_q_2_1(REG,72)
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            redist0_i_cmp_hello_world2_q_2_1_q <= $unsigned(1'b0);
        end
        else if (SE_redist0_i_cmp_hello_world2_q_2_1_backEN == 1'b1)
        begin
            redist0_i_cmp_hello_world2_q_2_1_q <= $unsigned(redist0_i_cmp_hello_world2_q_2_0_q);
        end
    end

    // bubble_select_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4(BITSELECT,76)
    assign bubble_select_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_b = $unsigned(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_data_out[63:0]);

    // i_llvm_fpga_mem_unnamed_hello_world0_hello_world10(BLACKBOX,12)@3
    // in in_i_stall@20000000
    // out out_lsu_unnamed_hello_world0_o_active@20000000
    // out out_o_stall@20000000
    // out out_o_valid@5
    // out out_unnamed_hello_world0_hello_world_avm_address@20000000
    // out out_unnamed_hello_world0_hello_world_avm_burstcount@20000000
    // out out_unnamed_hello_world0_hello_world_avm_byteenable@20000000
    // out out_unnamed_hello_world0_hello_world_avm_enable@20000000
    // out out_unnamed_hello_world0_hello_world_avm_read@20000000
    // out out_unnamed_hello_world0_hello_world_avm_write@20000000
    // out out_unnamed_hello_world0_hello_world_avm_writedata@20000000
    hello_world_i_llvm_fpga_mem_unnamed_0_hello_world0 thei_llvm_fpga_mem_unnamed_hello_world0_hello_world10 (
        .in_flush(in_flush),
        .in_i_address(bubble_select_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_b),
        .in_i_predicate(redist0_i_cmp_hello_world2_q_2_1_q),
        .in_i_stall(SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_backStall),
        .in_i_valid(SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_V0),
        .in_i_writedata(i_or_hello_world8_vt_join_q),
        .in_unnamed_hello_world0_hello_world_avm_readdata(in_unnamed_hello_world0_hello_world_avm_readdata),
        .in_unnamed_hello_world0_hello_world_avm_readdatavalid(in_unnamed_hello_world0_hello_world_avm_readdatavalid),
        .in_unnamed_hello_world0_hello_world_avm_waitrequest(in_unnamed_hello_world0_hello_world_avm_waitrequest),
        .in_unnamed_hello_world0_hello_world_avm_writeack(in_unnamed_hello_world0_hello_world_avm_writeack),
        .out_lsu_unnamed_hello_world0_o_active(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_lsu_unnamed_hello_world0_o_active),
        .out_o_stall(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_stall),
        .out_o_valid(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_valid),
        .out_unnamed_hello_world0_hello_world_avm_address(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_address),
        .out_unnamed_hello_world0_hello_world_avm_burstcount(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_burstcount),
        .out_unnamed_hello_world0_hello_world_avm_byteenable(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_byteenable),
        .out_unnamed_hello_world0_hello_world_avm_enable(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_enable),
        .out_unnamed_hello_world0_hello_world_avm_read(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_read),
        .out_unnamed_hello_world0_hello_world_avm_write(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_write),
        .out_unnamed_hello_world0_hello_world_avm_writedata(i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_writedata),
        .clock(clock),
        .resetn(resetn)
    );

    // SE_redist0_i_cmp_hello_world2_q_2_1(STALLENABLE,118)
    // Valid signal propagation
    assign SE_redist0_i_cmp_hello_world2_q_2_1_V0 = SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0;
    // Stall signal propagation
    assign SE_redist0_i_cmp_hello_world2_q_2_1_s_tv_0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_backStall & SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0;
    // Backward Enable generation
    assign SE_redist0_i_cmp_hello_world2_q_2_1_backEN = ~ (SE_redist0_i_cmp_hello_world2_q_2_1_s_tv_0);
    // Determine whether to write valid data into the first register stage
    assign SE_redist0_i_cmp_hello_world2_q_2_1_v_s_0 = SE_redist0_i_cmp_hello_world2_q_2_1_backEN & SE_redist0_i_cmp_hello_world2_q_2_0_V0;
    // Backward Stall generation
    assign SE_redist0_i_cmp_hello_world2_q_2_1_backStall = ~ (SE_redist0_i_cmp_hello_world2_q_2_1_v_s_0);
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0 <= 1'b0;
        end
        else
        begin
            if (SE_redist0_i_cmp_hello_world2_q_2_1_backEN == 1'b0)
            begin
                SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0 <= SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0 & SE_redist0_i_cmp_hello_world2_q_2_1_s_tv_0;
            end
            else
            begin
                SE_redist0_i_cmp_hello_world2_q_2_1_R_v_0 <= SE_redist0_i_cmp_hello_world2_q_2_1_v_s_0;
            end

        end
    end

    // bubble_join_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4(BITJOIN,75)
    assign bubble_join_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_q = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_result;

    // bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg(STALLFIFO,147)
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in = SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0;
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_backStall;
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_data_in = bubble_join_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_q;
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in_bitsignaltemp = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in[0];
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in_bitsignaltemp = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in[0];
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out[0] = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out_bitsignaltemp;
    assign bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out[0] = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out_bitsignaltemp;
    acl_data_fifo #(
        .DEPTH(3),
        .STRICT_DEPTH(0),
        .ALLOW_FULL_WRITE(0),
        .DATA_WIDTH(64),
        .IMPL("zl_reg")
    ) thebubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg (
        .valid_in(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_in_bitsignaltemp),
        .stall_in(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_in_bitsignaltemp),
        .data_in(bubble_join_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_q),
        .valid_out(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out_bitsignaltemp),
        .stall_out(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out_bitsignaltemp),
        .data_out(bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_data_out),
        .clock(clock),
        .resetn(resetn)
    );

    // SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5(STALLENABLE,98)
    // Valid signal propagation
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_V0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_wireValid;
    // Backward Stall generation
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_backStall = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_o_stall | ~ (SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_wireValid);
    // Computing multiple Valid(s)
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and0 = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_valid_out;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and1 = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_valid_out & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and0;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_wireValid = SE_redist0_i_cmp_hello_world2_q_2_1_V0 & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_and1;

    // GND(CONSTANT,0)
    assign GND_q = $unsigned(1'b0);

    // i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5(BLACKBOX,14)@3
    // in in_stall_in@20000000
    // out out_stall_out@20000000
    hello_world_i_llvm_fpga_sync_buffer_i32_A000000Zssage_sync_buffer1_0 thei_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5 (
        .in_buffer_in(in_thread_id_from_which_to_print_message),
        .in_i_dependence(GND_q),
        .in_stall_in(SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_backStall),
        .in_valid_in(SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_V0),
        .out_buffer_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_buffer_out),
        .out_stall_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_stall_out),
        .out_valid_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_valid_out),
        .clock(clock),
        .resetn(resetn)
    );

    // SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2(STALLENABLE,146)
    // Valid signal propagation
    assign SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_V0 = SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_wireValid;
    // Backward Stall generation
    assign SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_backStall = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer1_hello_world5_out_stall_out | ~ (SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_wireValid);
    // Computing multiple Valid(s)
    assign SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_wireValid = bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out;

    // bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg(STALLFIFO,148)
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in = SE_out_hello_world_B0_merge_reg_aunroll_x_V1;
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in = SE_out_bubble_out_hello_world_B0_merge_reg_aunroll_x_2_backStall;
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in_bitsignaltemp = bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in[0];
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in_bitsignaltemp = bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in[0];
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out[0] = bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out_bitsignaltemp;
    assign bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out[0] = bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out_bitsignaltemp;
    acl_valid_fifo_counter #(
        .DEPTH(3),
        .STRICT_DEPTH(0),
        .ALLOW_FULL_WRITE(0),
        .ASYNC_RESET(1)
    ) thebubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg (
        .valid_in(bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_in_bitsignaltemp),
        .stall_in(bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_in_bitsignaltemp),
        .valid_out(bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_valid_out_bitsignaltemp),
        .stall_out(bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out_bitsignaltemp),
        .clock(clock),
        .resetn(resetn)
    );

    // i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1(BLACKBOX,15)@1
    // in in_stall_in@20000000
    // out out_stall_out@20000000
    hello_world_i_llvm_fpga_sync_buffer_i32_A000000Zessage_sync_buffer_0 thei_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1 (
        .in_buffer_in(in_thread_id_from_which_to_print_message),
        .in_i_dependence(GND_q),
        .in_stall_in(SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_backStall),
        .in_valid_in(SE_out_hello_world_B0_merge_reg_aunroll_x_V0),
        .out_buffer_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_buffer_out),
        .out_stall_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_stall_out),
        .out_valid_out(i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_valid_out),
        .clock(clock),
        .resetn(resetn)
    );

    // bubble_join_stall_entry(BITJOIN,84)
    assign bubble_join_stall_entry_q = in_acl_global_id_0;

    // bubble_select_stall_entry(BITSELECT,85)
    assign bubble_select_stall_entry_b = $unsigned(bubble_join_stall_entry_q[63:0]);

    // SE_stall_entry(STALLENABLE,108)
    // Valid signal propagation
    assign SE_stall_entry_V0 = SE_stall_entry_wireValid;
    // Backward Stall generation
    assign SE_stall_entry_backStall = hello_world_B0_merge_reg_aunroll_x_out_stall_out | ~ (SE_stall_entry_wireValid);
    // Computing multiple Valid(s)
    assign SE_stall_entry_wireValid = in_valid_in;

    // hello_world_B0_merge_reg_aunroll_x(BLACKBOX,52)@0
    // in in_stall_in@20000000
    // out out_stall_out@20000000
    // out out_valid_out@1
    // out out_data_out_0_tpl@1
    hello_world_B0_merge_reg thehello_world_B0_merge_reg_aunroll_x (
        .in_stall_in(SE_out_hello_world_B0_merge_reg_aunroll_x_backStall),
        .in_valid_in(SE_stall_entry_V0),
        .in_data_in_0_tpl(bubble_select_stall_entry_b),
        .out_stall_out(hello_world_B0_merge_reg_aunroll_x_out_stall_out),
        .out_valid_out(hello_world_B0_merge_reg_aunroll_x_out_valid_out),
        .out_data_out_0_tpl(hello_world_B0_merge_reg_aunroll_x_out_data_out_0_tpl),
        .clock(clock),
        .resetn(resetn)
    );

    // SE_out_hello_world_B0_merge_reg_aunroll_x(STALLENABLE,111)
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg0 <= '0;
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg1 <= '0;
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg2 <= '0;
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg3 <= '0;
        end
        else
        begin
            // Successor 0
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg0 <= SE_out_hello_world_B0_merge_reg_aunroll_x_toReg0;
            // Successor 1
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg1 <= SE_out_hello_world_B0_merge_reg_aunroll_x_toReg1;
            // Successor 2
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg2 <= SE_out_hello_world_B0_merge_reg_aunroll_x_toReg2;
            // Successor 3
            SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg3 <= SE_out_hello_world_B0_merge_reg_aunroll_x_toReg3;
        end
    end
    // Input Stall processing
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_consumed0 = (~ (i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_stall_out) & SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid) | SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg0;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_consumed1 = (~ (bubble_out_hello_world_B0_merge_reg_aunroll_x_2_reg_stall_out) & SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid) | SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg1;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_consumed2 = (~ (SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall) & SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid) | SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg2;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_consumed3 = (~ (SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_backStall) & SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid) | SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg3;
    // Consuming
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid = SE_out_hello_world_B0_merge_reg_aunroll_x_backStall & SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_toReg0 = SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid & SE_out_hello_world_B0_merge_reg_aunroll_x_consumed0;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_toReg1 = SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid & SE_out_hello_world_B0_merge_reg_aunroll_x_consumed1;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_toReg2 = SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid & SE_out_hello_world_B0_merge_reg_aunroll_x_consumed2;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_toReg3 = SE_out_hello_world_B0_merge_reg_aunroll_x_StallValid & SE_out_hello_world_B0_merge_reg_aunroll_x_consumed3;
    // Backward Stall generation
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_or0 = SE_out_hello_world_B0_merge_reg_aunroll_x_consumed0;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_or1 = SE_out_hello_world_B0_merge_reg_aunroll_x_consumed1 & SE_out_hello_world_B0_merge_reg_aunroll_x_or0;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_or2 = SE_out_hello_world_B0_merge_reg_aunroll_x_consumed2 & SE_out_hello_world_B0_merge_reg_aunroll_x_or1;
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_wireStall = ~ (SE_out_hello_world_B0_merge_reg_aunroll_x_consumed3 & SE_out_hello_world_B0_merge_reg_aunroll_x_or2);
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_backStall = SE_out_hello_world_B0_merge_reg_aunroll_x_wireStall;
    // Valid signal propagation
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_V0 = SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid & ~ (SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg0);
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_V1 = SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid & ~ (SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg1);
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_V2 = SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid & ~ (SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg2);
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_V3 = SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid & ~ (SE_out_hello_world_B0_merge_reg_aunroll_x_fromReg3);
    // Computing multiple Valid(s)
    assign SE_out_hello_world_B0_merge_reg_aunroll_x_wireValid = hello_world_B0_merge_reg_aunroll_x_out_valid_out;

    // SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1(STALLENABLE,100)
    always @ (posedge clock or negedge resetn)
    begin
        if (!resetn)
        begin
            SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg0 <= '0;
            SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg1 <= '0;
        end
        else
        begin
            // Successor 0
            SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg0 <= SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg0;
            // Successor 1
            SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg1 <= SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg1;
        end
    end
    // Input Stall processing
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed0 = (~ (SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall) & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid) | SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg0;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed1 = (~ (SE_redist0_i_cmp_hello_world2_q_2_0_backStall) & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid) | SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg1;
    // Consuming
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_StallValid = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_backStall & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_StallValid & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed0;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_toReg1 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_StallValid & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed1;
    // Backward Stall generation
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_or0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed0;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireStall = ~ (SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_consumed1 & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_or0);
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_backStall = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireStall;
    // Valid signal propagation
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid & ~ (SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg0);
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V1 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid & ~ (SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_fromReg1);
    // Computing multiple Valid(s)
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_and0 = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_valid_out;
    assign SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_wireValid = SE_out_hello_world_B0_merge_reg_aunroll_x_V3 & SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_and0;

    // SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4(STALLENABLE,95)
    // Valid signal propagation
    assign SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0 = SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid;
    // Backward Stall generation
    assign SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_stall | ~ (SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid);
    // Computing multiple Valid(s)
    assign SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_and0 = SE_out_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_V0;
    assign SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid = SE_out_hello_world_B0_merge_reg_aunroll_x_V2 & SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_and0;

    // SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4(STALLENABLE,96)
    // Valid signal propagation
    assign SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0 = SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid;
    // Backward Stall generation
    assign SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall = bubble_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_data_reg_stall_out | ~ (SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid);
    // Computing multiple Valid(s)
    assign SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_wireValid = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_valid;

    // bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1(BITJOIN,81)
    assign bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_q = i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_out_buffer_out;

    // bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1(BITSELECT,82)
    assign bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_b = $unsigned(bubble_join_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_q[31:0]);

    // i_conv_hello_world0_sel_x(BITSELECT,53)@1
    assign i_conv_hello_world0_sel_x_b = bubble_select_hello_world_B0_merge_reg_aunroll_x_b[31:0];

    // i_cmp_hello_world2(LOGICAL,10)@1
    assign i_cmp_hello_world2_q = $unsigned(i_conv_hello_world0_sel_x_b != bubble_select_i_llvm_fpga_sync_buffer_i32_thread_id_from_which_to_print_message_sync_buffer_hello_world1_b ? 1'b1 : 1'b0);

    // c_i32_3212(CONSTANT,5)
    assign c_i32_3212_q = $unsigned(32'b00000000000000000000000000100000);

    // bubble_join_hello_world_B0_merge_reg_aunroll_x(BITJOIN,88)
    assign bubble_join_hello_world_B0_merge_reg_aunroll_x_q = hello_world_B0_merge_reg_aunroll_x_out_data_out_0_tpl;

    // bubble_select_hello_world_B0_merge_reg_aunroll_x(BITSELECT,89)
    assign bubble_select_hello_world_B0_merge_reg_aunroll_x_b = $unsigned(bubble_join_hello_world_B0_merge_reg_aunroll_x_q[63:0]);

    // i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4(BLACKBOX,13)@1
    // in in_i_stall@20000000
    // out out_o_result@3
    // out out_o_stall@20000000
    // out out_o_valid@3
    // out out_printf_addr_hello_world_avm_address@20000000
    // out out_printf_addr_hello_world_avm_burstcount@20000000
    // out out_printf_addr_hello_world_avm_byteenable@20000000
    // out out_printf_addr_hello_world_avm_enable@20000000
    // out out_printf_addr_hello_world_avm_read@20000000
    // out out_printf_addr_hello_world_avm_write@20000000
    // out out_printf_addr_hello_world_avm_writedata@20000000
    hello_world_i_llvm_fpga_printf_p1024i8_printf_addr_0 thei_llvm_fpga_printf_p1024i8_printf_addr_hello_world4 (
        .in_i_globalid0(bubble_select_hello_world_B0_merge_reg_aunroll_x_b),
        .in_i_increment(c_i32_3212_q),
        .in_i_predicate(i_cmp_hello_world2_q),
        .in_i_stall(SE_out_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_backStall),
        .in_i_valid(SE_in_i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_V0),
        .in_printf_addr_hello_world_avm_readdata(in_printf_addr_hello_world_avm_readdata),
        .in_printf_addr_hello_world_avm_readdatavalid(in_printf_addr_hello_world_avm_readdatavalid),
        .in_printf_addr_hello_world_avm_waitrequest(in_printf_addr_hello_world_avm_waitrequest),
        .in_printf_addr_hello_world_avm_writeack(in_printf_addr_hello_world_avm_writeack),
        .out_o_result(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_result),
        .out_o_stall(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_stall),
        .out_o_valid(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_o_valid),
        .out_printf_addr_hello_world_avm_address(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_address),
        .out_printf_addr_hello_world_avm_burstcount(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_burstcount),
        .out_printf_addr_hello_world_avm_byteenable(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_byteenable),
        .out_printf_addr_hello_world_avm_enable(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_enable),
        .out_printf_addr_hello_world_avm_read(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_read),
        .out_printf_addr_hello_world_avm_write(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_write),
        .out_printf_addr_hello_world_avm_writedata(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_writedata),
        .clock(clock),
        .resetn(resetn)
    );

    // ext_sig_sync_out(GPOUT,9)
    assign out_printf_addr_hello_world_avm_address = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_address;
    assign out_printf_addr_hello_world_avm_enable = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_enable;
    assign out_printf_addr_hello_world_avm_read = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_read;
    assign out_printf_addr_hello_world_avm_write = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_write;
    assign out_printf_addr_hello_world_avm_writedata = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_writedata;
    assign out_printf_addr_hello_world_avm_byteenable = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_byteenable;
    assign out_printf_addr_hello_world_avm_burstcount = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world4_out_printf_addr_hello_world_avm_burstcount;

    // sync_out(GPOUT,46)@0
    assign out_stall_out = SE_stall_entry_backStall;

    // dupName_0_ext_sig_sync_out_x(GPOUT,49)
    assign out_unnamed_hello_world0_hello_world_avm_address = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_address;
    assign out_unnamed_hello_world0_hello_world_avm_enable = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_enable;
    assign out_unnamed_hello_world0_hello_world_avm_read = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_read;
    assign out_unnamed_hello_world0_hello_world_avm_write = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_write;
    assign out_unnamed_hello_world0_hello_world_avm_writedata = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_writedata;
    assign out_unnamed_hello_world0_hello_world_avm_byteenable = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_byteenable;
    assign out_unnamed_hello_world0_hello_world_avm_burstcount = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_unnamed_hello_world0_hello_world_avm_burstcount;

    // dupName_0_sync_out_x(GPOUT,50)@5
    assign out_valid_out = SE_out_i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_V0;

    // dupName_1_ext_sig_sync_out_x(GPOUT,51)
    assign out_lsu_unnamed_hello_world0_o_active = i_llvm_fpga_mem_unnamed_hello_world0_hello_world10_out_lsu_unnamed_hello_world0_o_active;

endmodule
