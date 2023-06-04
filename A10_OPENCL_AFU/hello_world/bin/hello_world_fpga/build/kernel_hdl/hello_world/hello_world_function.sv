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

// SystemVerilog created from hello_world_function
// SystemVerilog created on Sun Jun  4 07:38:25 2023


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_function (
    input wire [63:0] in_arg_acl_global_id_0,
    input wire [63:0] in_arg_acl_global_size_0,
    input wire [63:0] in_arg_acl_global_size_1,
    input wire [63:0] in_arg_acl_global_size_2,
    input wire [31:0] in_arg_acl_local_size_0,
    input wire [31:0] in_arg_acl_local_size_1,
    input wire [31:0] in_arg_acl_local_size_2,
    input wire [31:0] in_arg_llvm_fpga_printf_buffer_size,
    input wire [63:0] in_arg_llvm_fpga_printf_buffer_start,
    input wire [31:0] in_arg_thread_id_from_which_to_print_message,
    input wire [255:0] in_printf_addr_hello_world_avm_readdata,
    input wire [0:0] in_printf_addr_hello_world_avm_readdatavalid,
    input wire [0:0] in_printf_addr_hello_world_avm_waitrequest,
    input wire [0:0] in_printf_addr_hello_world_avm_writeack,
    input wire [0:0] in_stall_in,
    input wire [0:0] in_start,
    input wire [511:0] in_unnamed_hello_world0_hello_world_avm_readdata,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_readdatavalid,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_waitrequest,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_writeack,
    input wire [0:0] in_valid_in,
    output wire [0:0] out_o_active_unnamed_hello_world0,
    output wire [31:0] out_printf_addr_hello_world_avm_address,
    output wire [5:0] out_printf_addr_hello_world_avm_burstcount,
    output wire [31:0] out_printf_addr_hello_world_avm_byteenable,
    output wire [0:0] out_printf_addr_hello_world_avm_enable,
    output wire [0:0] out_printf_addr_hello_world_avm_read,
    output wire [0:0] out_printf_addr_hello_world_avm_write,
    output wire [255:0] out_printf_addr_hello_world_avm_writedata,
    output wire [0:0] out_stall_out,
    output wire [32:0] out_unnamed_hello_world0_hello_world_avm_address,
    output wire [4:0] out_unnamed_hello_world0_hello_world_avm_burstcount,
    output wire [63:0] out_unnamed_hello_world0_hello_world_avm_byteenable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_enable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_read,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_write,
    output wire [511:0] out_unnamed_hello_world0_hello_world_avm_writedata,
    output wire [0:0] out_valid_out,
    input wire clock,
    input wire resetn
    );

    wire [0:0] bb_hello_world_B0_out_lsu_unnamed_hello_world0_o_active;
    wire [31:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_address;
    wire [5:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_burstcount;
    wire [31:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_byteenable;
    wire [0:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_enable;
    wire [0:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_read;
    wire [0:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_write;
    wire [255:0] bb_hello_world_B0_out_printf_addr_hello_world_avm_writedata;
    wire [0:0] bb_hello_world_B0_out_stall_out_0;
    wire [32:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_address;
    wire [4:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_burstcount;
    wire [63:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_byteenable;
    wire [0:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_enable;
    wire [0:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_read;
    wire [0:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_write;
    wire [511:0] bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_writedata;
    wire [0:0] bb_hello_world_B0_out_valid_out_0;


    // bb_hello_world_B0(BLACKBOX,2)
    hello_world_bb_B0 thebb_hello_world_B0 (
        .in_acl_global_id_0_0(in_arg_acl_global_id_0),
        .in_flush(in_start),
        .in_printf_addr_hello_world_avm_readdata(in_printf_addr_hello_world_avm_readdata),
        .in_printf_addr_hello_world_avm_readdatavalid(in_printf_addr_hello_world_avm_readdatavalid),
        .in_printf_addr_hello_world_avm_waitrequest(in_printf_addr_hello_world_avm_waitrequest),
        .in_printf_addr_hello_world_avm_writeack(in_printf_addr_hello_world_avm_writeack),
        .in_stall_in_0(in_stall_in),
        .in_thread_id_from_which_to_print_message(in_arg_thread_id_from_which_to_print_message),
        .in_unnamed_hello_world0_hello_world_avm_readdata(in_unnamed_hello_world0_hello_world_avm_readdata),
        .in_unnamed_hello_world0_hello_world_avm_readdatavalid(in_unnamed_hello_world0_hello_world_avm_readdatavalid),
        .in_unnamed_hello_world0_hello_world_avm_waitrequest(in_unnamed_hello_world0_hello_world_avm_waitrequest),
        .in_unnamed_hello_world0_hello_world_avm_writeack(in_unnamed_hello_world0_hello_world_avm_writeack),
        .in_valid_in_0(in_valid_in),
        .out_lsu_unnamed_hello_world0_o_active(bb_hello_world_B0_out_lsu_unnamed_hello_world0_o_active),
        .out_printf_addr_hello_world_avm_address(bb_hello_world_B0_out_printf_addr_hello_world_avm_address),
        .out_printf_addr_hello_world_avm_burstcount(bb_hello_world_B0_out_printf_addr_hello_world_avm_burstcount),
        .out_printf_addr_hello_world_avm_byteenable(bb_hello_world_B0_out_printf_addr_hello_world_avm_byteenable),
        .out_printf_addr_hello_world_avm_enable(bb_hello_world_B0_out_printf_addr_hello_world_avm_enable),
        .out_printf_addr_hello_world_avm_read(bb_hello_world_B0_out_printf_addr_hello_world_avm_read),
        .out_printf_addr_hello_world_avm_write(bb_hello_world_B0_out_printf_addr_hello_world_avm_write),
        .out_printf_addr_hello_world_avm_writedata(bb_hello_world_B0_out_printf_addr_hello_world_avm_writedata),
        .out_stall_out_0(bb_hello_world_B0_out_stall_out_0),
        .out_unnamed_hello_world0_hello_world_avm_address(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_address),
        .out_unnamed_hello_world0_hello_world_avm_burstcount(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_burstcount),
        .out_unnamed_hello_world0_hello_world_avm_byteenable(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_byteenable),
        .out_unnamed_hello_world0_hello_world_avm_enable(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_enable),
        .out_unnamed_hello_world0_hello_world_avm_read(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_read),
        .out_unnamed_hello_world0_hello_world_avm_write(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_write),
        .out_unnamed_hello_world0_hello_world_avm_writedata(bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_writedata),
        .out_valid_out_0(bb_hello_world_B0_out_valid_out_0),
        .clock(clock),
        .resetn(resetn)
    );

    // out_o_active_unnamed_hello_world0(GPOUT,24)
    assign out_o_active_unnamed_hello_world0 = bb_hello_world_B0_out_lsu_unnamed_hello_world0_o_active;

    // out_printf_addr_hello_world_avm_address(GPOUT,25)
    assign out_printf_addr_hello_world_avm_address = bb_hello_world_B0_out_printf_addr_hello_world_avm_address;

    // out_printf_addr_hello_world_avm_burstcount(GPOUT,26)
    assign out_printf_addr_hello_world_avm_burstcount = bb_hello_world_B0_out_printf_addr_hello_world_avm_burstcount;

    // out_printf_addr_hello_world_avm_byteenable(GPOUT,27)
    assign out_printf_addr_hello_world_avm_byteenable = bb_hello_world_B0_out_printf_addr_hello_world_avm_byteenable;

    // out_printf_addr_hello_world_avm_enable(GPOUT,28)
    assign out_printf_addr_hello_world_avm_enable = bb_hello_world_B0_out_printf_addr_hello_world_avm_enable;

    // out_printf_addr_hello_world_avm_read(GPOUT,29)
    assign out_printf_addr_hello_world_avm_read = bb_hello_world_B0_out_printf_addr_hello_world_avm_read;

    // out_printf_addr_hello_world_avm_write(GPOUT,30)
    assign out_printf_addr_hello_world_avm_write = bb_hello_world_B0_out_printf_addr_hello_world_avm_write;

    // out_printf_addr_hello_world_avm_writedata(GPOUT,31)
    assign out_printf_addr_hello_world_avm_writedata = bb_hello_world_B0_out_printf_addr_hello_world_avm_writedata;

    // out_stall_out(GPOUT,32)
    assign out_stall_out = bb_hello_world_B0_out_stall_out_0;

    // out_unnamed_hello_world0_hello_world_avm_address(GPOUT,33)
    assign out_unnamed_hello_world0_hello_world_avm_address = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_address;

    // out_unnamed_hello_world0_hello_world_avm_burstcount(GPOUT,34)
    assign out_unnamed_hello_world0_hello_world_avm_burstcount = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_burstcount;

    // out_unnamed_hello_world0_hello_world_avm_byteenable(GPOUT,35)
    assign out_unnamed_hello_world0_hello_world_avm_byteenable = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_byteenable;

    // out_unnamed_hello_world0_hello_world_avm_enable(GPOUT,36)
    assign out_unnamed_hello_world0_hello_world_avm_enable = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_enable;

    // out_unnamed_hello_world0_hello_world_avm_read(GPOUT,37)
    assign out_unnamed_hello_world0_hello_world_avm_read = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_read;

    // out_unnamed_hello_world0_hello_world_avm_write(GPOUT,38)
    assign out_unnamed_hello_world0_hello_world_avm_write = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_write;

    // out_unnamed_hello_world0_hello_world_avm_writedata(GPOUT,39)
    assign out_unnamed_hello_world0_hello_world_avm_writedata = bb_hello_world_B0_out_unnamed_hello_world0_hello_world_avm_writedata;

    // out_valid_out(GPOUT,40)
    assign out_valid_out = bb_hello_world_B0_out_valid_out_0;

endmodule
