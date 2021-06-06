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

// SystemVerilog created from hello_world_i_llvm_fpga_printf_p1024i8_printf_addr_0
// SystemVerilog created on Sat Jun  5 10:26:34 2021


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_i_llvm_fpga_printf_p1024i8_printf_addr_0 (
    input wire [255:0] in_printf_addr_hello_world_avm_readdata,
    input wire [0:0] in_printf_addr_hello_world_avm_readdatavalid,
    input wire [0:0] in_printf_addr_hello_world_avm_waitrequest,
    input wire [0:0] in_printf_addr_hello_world_avm_writeack,
    output wire [31:0] out_printf_addr_hello_world_avm_address,
    input wire [0:0] in_i_stall,
    output wire [0:0] out_o_stall,
    input wire [63:0] in_i_globalid0,
    input wire [31:0] in_i_increment,
    input wire [0:0] in_i_predicate,
    input wire [0:0] in_i_valid,
    output wire [5:0] out_printf_addr_hello_world_avm_burstcount,
    output wire [63:0] out_o_result,
    output wire [0:0] out_o_valid,
    output wire [31:0] out_printf_addr_hello_world_avm_byteenable,
    output wire [0:0] out_printf_addr_hello_world_avm_enable,
    output wire [0:0] out_printf_addr_hello_world_avm_read,
    output wire [0:0] out_printf_addr_hello_world_avm_write,
    output wire [255:0] out_printf_addr_hello_world_avm_writedata,
    input wire clock,
    input wire resetn
    );

    wire [255:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdata;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack_bitsignaltemp;
    wire [63:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_globalid0;
    wire [31:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_increment;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid_bitsignaltemp;
    wire [31:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_address;
    wire [5:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_burstcount;
    wire [31:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_byteenable;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write_bitsignaltemp;
    wire [255:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writedata;
    wire [63:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_result;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall_bitsignaltemp;
    wire [0:0] i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid;
    wire i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid_bitsignaltemp;


    // i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1(EXTIFACE,2)
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdata = in_printf_addr_hello_world_avm_readdata;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid = in_printf_addr_hello_world_avm_readdatavalid;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest = in_printf_addr_hello_world_avm_waitrequest;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack = in_printf_addr_hello_world_avm_writeack;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_globalid0 = in_i_globalid0;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_increment = in_i_increment;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate = in_i_predicate;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall = in_i_stall;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid = in_i_valid;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid_bitsignaltemp = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid[0];
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable[0] = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable_bitsignaltemp;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read[0] = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read_bitsignaltemp;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write[0] = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write_bitsignaltemp;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall[0] = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall_bitsignaltemp;
    assign i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid[0] = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid_bitsignaltemp;
    acl_printf_buffer_address_generator #(
        .ASYNC_RESET(1),
        .SYNCHRONIZE_RESET(0)
    ) thei_llvm_fpga_printf_p1024i8_printf_addr_hello_world1 (
        .avm_readdata(in_printf_addr_hello_world_avm_readdata),
        .avm_readdatavalid(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_readdatavalid_bitsignaltemp),
        .avm_waitrequest(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_waitrequest_bitsignaltemp),
        .avm_writeack(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writeack_bitsignaltemp),
        .i_globalid0(in_i_globalid0),
        .i_increment(in_i_increment),
        .i_predicate(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_predicate_bitsignaltemp),
        .i_stall(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_stall_bitsignaltemp),
        .i_valid(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_i_valid_bitsignaltemp),
        .avm_address(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_address),
        .avm_burstcount(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_burstcount),
        .avm_byteenable(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_byteenable),
        .avm_enable(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable_bitsignaltemp),
        .avm_read(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read_bitsignaltemp),
        .avm_write(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write_bitsignaltemp),
        .avm_writedata(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writedata),
        .o_result(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_result),
        .o_stall(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall_bitsignaltemp),
        .o_valid(i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid_bitsignaltemp),
        .clock(clock),
        .resetn(resetn)
    );

    // regfree_osync(GPOUT,7)
    assign out_printf_addr_hello_world_avm_address = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_address;

    // sync_out(GPOUT,9)@20000000
    assign out_o_stall = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_stall;

    // dupName_0_regfree_osync_x(GPOUT,11)
    assign out_printf_addr_hello_world_avm_burstcount = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_burstcount;

    // dupName_0_sync_out_x(GPOUT,12)@3
    assign out_o_result = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_result;
    assign out_o_valid = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_o_valid;

    // dupName_1_regfree_osync_x(GPOUT,13)
    assign out_printf_addr_hello_world_avm_byteenable = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_byteenable;

    // dupName_2_regfree_osync_x(GPOUT,14)
    assign out_printf_addr_hello_world_avm_enable = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_enable;

    // dupName_3_regfree_osync_x(GPOUT,15)
    assign out_printf_addr_hello_world_avm_read = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_read;

    // dupName_4_regfree_osync_x(GPOUT,16)
    assign out_printf_addr_hello_world_avm_write = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_write;

    // dupName_5_regfree_osync_x(GPOUT,17)
    assign out_printf_addr_hello_world_avm_writedata = i_llvm_fpga_printf_p1024i8_printf_addr_hello_world1_avm_writedata;

endmodule
