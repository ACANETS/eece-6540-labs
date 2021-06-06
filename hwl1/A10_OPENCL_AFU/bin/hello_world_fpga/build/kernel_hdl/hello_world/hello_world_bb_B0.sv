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

// SystemVerilog created from hello_world_bb_B0
// SystemVerilog created on Sat Jun  5 10:26:34 2021


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_bb_B0 (
    input wire [63:0] in_acl_global_id_0_0,
    input wire [0:0] in_flush,
    input wire [255:0] in_printf_addr_hello_world_avm_readdata,
    input wire [0:0] in_printf_addr_hello_world_avm_readdatavalid,
    input wire [0:0] in_printf_addr_hello_world_avm_waitrequest,
    input wire [0:0] in_printf_addr_hello_world_avm_writeack,
    input wire [0:0] in_stall_in_0,
    input wire [31:0] in_thread_id_from_which_to_print_message,
    input wire [511:0] in_unnamed_hello_world0_hello_world_avm_readdata,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_readdatavalid,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_waitrequest,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_writeack,
    input wire [0:0] in_valid_in_0,
    output wire [0:0] out_lsu_unnamed_hello_world0_o_active,
    output wire [31:0] out_printf_addr_hello_world_avm_address,
    output wire [5:0] out_printf_addr_hello_world_avm_burstcount,
    output wire [31:0] out_printf_addr_hello_world_avm_byteenable,
    output wire [0:0] out_printf_addr_hello_world_avm_enable,
    output wire [0:0] out_printf_addr_hello_world_avm_read,
    output wire [0:0] out_printf_addr_hello_world_avm_write,
    output wire [255:0] out_printf_addr_hello_world_avm_writedata,
    output wire [0:0] out_stall_out_0,
    output wire [32:0] out_unnamed_hello_world0_hello_world_avm_address,
    output wire [4:0] out_unnamed_hello_world0_hello_world_avm_burstcount,
    output wire [63:0] out_unnamed_hello_world0_hello_world_avm_byteenable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_enable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_read,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_write,
    output wire [511:0] out_unnamed_hello_world0_hello_world_avm_writedata,
    output wire [0:0] out_valid_out_0,
    input wire clock,
    input wire resetn
    );

    wire [0:0] bb_hello_world_B0_stall_region_out_lsu_unnamed_hello_world0_o_active;
    wire [31:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_address;
    wire [5:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_burstcount;
    wire [31:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_byteenable;
    wire [0:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_enable;
    wire [0:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_read;
    wire [0:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_write;
    wire [255:0] bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_writedata;
    wire [0:0] bb_hello_world_B0_stall_region_out_stall_out;
    wire [32:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_address;
    wire [4:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_burstcount;
    wire [63:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_byteenable;
    wire [0:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_enable;
    wire [0:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_read;
    wire [0:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_write;
    wire [511:0] bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_writedata;
    wire [0:0] bb_hello_world_B0_stall_region_out_valid_out;
    wire [0:0] hello_world_B0_branch_out_stall_out;
    wire [0:0] hello_world_B0_branch_out_valid_out_0;
    wire [63:0] hello_world_B0_merge_out_acl_global_id_0;
    wire [0:0] hello_world_B0_merge_out_stall_out_0;
    wire [0:0] hello_world_B0_merge_out_valid_out;


    // hello_world_B0_branch(BLACKBOX,3)
    hello_world_B0_branch thehello_world_B0_branch (
        .in_stall_in_0(in_stall_in_0),
        .in_valid_in(bb_hello_world_B0_stall_region_out_valid_out),
        .out_stall_out(hello_world_B0_branch_out_stall_out),
        .out_valid_out_0(hello_world_B0_branch_out_valid_out_0),
        .clock(clock),
        .resetn(resetn)
    );

    // hello_world_B0_merge(BLACKBOX,4)
    hello_world_B0_merge thehello_world_B0_merge (
        .in_acl_global_id_0_0(in_acl_global_id_0_0),
        .in_stall_in(bb_hello_world_B0_stall_region_out_stall_out),
        .in_valid_in_0(in_valid_in_0),
        .out_acl_global_id_0(hello_world_B0_merge_out_acl_global_id_0),
        .out_stall_out_0(hello_world_B0_merge_out_stall_out_0),
        .out_valid_out(hello_world_B0_merge_out_valid_out),
        .clock(clock),
        .resetn(resetn)
    );

    // bb_hello_world_B0_stall_region(BLACKBOX,2)
    hello_world_bb_B0_stall_region thebb_hello_world_B0_stall_region (
        .in_acl_global_id_0(hello_world_B0_merge_out_acl_global_id_0),
        .in_flush(in_flush),
        .in_printf_addr_hello_world_avm_readdata(in_printf_addr_hello_world_avm_readdata),
        .in_printf_addr_hello_world_avm_readdatavalid(in_printf_addr_hello_world_avm_readdatavalid),
        .in_printf_addr_hello_world_avm_waitrequest(in_printf_addr_hello_world_avm_waitrequest),
        .in_printf_addr_hello_world_avm_writeack(in_printf_addr_hello_world_avm_writeack),
        .in_stall_in(hello_world_B0_branch_out_stall_out),
        .in_thread_id_from_which_to_print_message(in_thread_id_from_which_to_print_message),
        .in_unnamed_hello_world0_hello_world_avm_readdata(in_unnamed_hello_world0_hello_world_avm_readdata),
        .in_unnamed_hello_world0_hello_world_avm_readdatavalid(in_unnamed_hello_world0_hello_world_avm_readdatavalid),
        .in_unnamed_hello_world0_hello_world_avm_waitrequest(in_unnamed_hello_world0_hello_world_avm_waitrequest),
        .in_unnamed_hello_world0_hello_world_avm_writeack(in_unnamed_hello_world0_hello_world_avm_writeack),
        .in_valid_in(hello_world_B0_merge_out_valid_out),
        .out_lsu_unnamed_hello_world0_o_active(bb_hello_world_B0_stall_region_out_lsu_unnamed_hello_world0_o_active),
        .out_printf_addr_hello_world_avm_address(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_address),
        .out_printf_addr_hello_world_avm_burstcount(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_burstcount),
        .out_printf_addr_hello_world_avm_byteenable(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_byteenable),
        .out_printf_addr_hello_world_avm_enable(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_enable),
        .out_printf_addr_hello_world_avm_read(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_read),
        .out_printf_addr_hello_world_avm_write(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_write),
        .out_printf_addr_hello_world_avm_writedata(bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_writedata),
        .out_stall_out(bb_hello_world_B0_stall_region_out_stall_out),
        .out_unnamed_hello_world0_hello_world_avm_address(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_address),
        .out_unnamed_hello_world0_hello_world_avm_burstcount(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_burstcount),
        .out_unnamed_hello_world0_hello_world_avm_byteenable(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_byteenable),
        .out_unnamed_hello_world0_hello_world_avm_enable(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_enable),
        .out_unnamed_hello_world0_hello_world_avm_read(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_read),
        .out_unnamed_hello_world0_hello_world_avm_write(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_write),
        .out_unnamed_hello_world0_hello_world_avm_writedata(bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_writedata),
        .out_valid_out(bb_hello_world_B0_stall_region_out_valid_out),
        .clock(clock),
        .resetn(resetn)
    );

    // out_lsu_unnamed_hello_world0_o_active(GPOUT,18)
    assign out_lsu_unnamed_hello_world0_o_active = bb_hello_world_B0_stall_region_out_lsu_unnamed_hello_world0_o_active;

    // out_printf_addr_hello_world_avm_address(GPOUT,19)
    assign out_printf_addr_hello_world_avm_address = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_address;

    // out_printf_addr_hello_world_avm_burstcount(GPOUT,20)
    assign out_printf_addr_hello_world_avm_burstcount = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_burstcount;

    // out_printf_addr_hello_world_avm_byteenable(GPOUT,21)
    assign out_printf_addr_hello_world_avm_byteenable = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_byteenable;

    // out_printf_addr_hello_world_avm_enable(GPOUT,22)
    assign out_printf_addr_hello_world_avm_enable = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_enable;

    // out_printf_addr_hello_world_avm_read(GPOUT,23)
    assign out_printf_addr_hello_world_avm_read = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_read;

    // out_printf_addr_hello_world_avm_write(GPOUT,24)
    assign out_printf_addr_hello_world_avm_write = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_write;

    // out_printf_addr_hello_world_avm_writedata(GPOUT,25)
    assign out_printf_addr_hello_world_avm_writedata = bb_hello_world_B0_stall_region_out_printf_addr_hello_world_avm_writedata;

    // out_stall_out_0(GPOUT,26)
    assign out_stall_out_0 = hello_world_B0_merge_out_stall_out_0;

    // out_unnamed_hello_world0_hello_world_avm_address(GPOUT,27)
    assign out_unnamed_hello_world0_hello_world_avm_address = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_address;

    // out_unnamed_hello_world0_hello_world_avm_burstcount(GPOUT,28)
    assign out_unnamed_hello_world0_hello_world_avm_burstcount = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_burstcount;

    // out_unnamed_hello_world0_hello_world_avm_byteenable(GPOUT,29)
    assign out_unnamed_hello_world0_hello_world_avm_byteenable = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_byteenable;

    // out_unnamed_hello_world0_hello_world_avm_enable(GPOUT,30)
    assign out_unnamed_hello_world0_hello_world_avm_enable = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_enable;

    // out_unnamed_hello_world0_hello_world_avm_read(GPOUT,31)
    assign out_unnamed_hello_world0_hello_world_avm_read = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_read;

    // out_unnamed_hello_world0_hello_world_avm_write(GPOUT,32)
    assign out_unnamed_hello_world0_hello_world_avm_write = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_write;

    // out_unnamed_hello_world0_hello_world_avm_writedata(GPOUT,33)
    assign out_unnamed_hello_world0_hello_world_avm_writedata = bb_hello_world_B0_stall_region_out_unnamed_hello_world0_hello_world_avm_writedata;

    // out_valid_out_0(GPOUT,34)
    assign out_valid_out_0 = hello_world_B0_branch_out_valid_out_0;

endmodule
