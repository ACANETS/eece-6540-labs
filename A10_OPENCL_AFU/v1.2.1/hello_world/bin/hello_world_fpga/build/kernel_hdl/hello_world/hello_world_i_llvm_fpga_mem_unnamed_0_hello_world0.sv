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

// SystemVerilog created from hello_world_i_llvm_fpga_mem_unnamed_0_hello_world0
// SystemVerilog created on Sun Jun  4 09:53:46 2023


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007; -name MESSAGE_DISABLE 10958" *)
module hello_world_i_llvm_fpga_mem_unnamed_0_hello_world0 (
    input wire [0:0] in_flush,
    input wire [511:0] in_unnamed_hello_world0_hello_world_avm_readdata,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_readdatavalid,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_waitrequest,
    input wire [0:0] in_unnamed_hello_world0_hello_world_avm_writeack,
    output wire [0:0] out_lsu_unnamed_hello_world0_o_active,
    input wire [0:0] in_i_stall,
    output wire [0:0] out_o_stall,
    input wire [63:0] in_i_address,
    input wire [0:0] in_i_predicate,
    input wire [0:0] in_i_valid,
    input wire [255:0] in_i_writedata,
    output wire [32:0] out_unnamed_hello_world0_hello_world_avm_address,
    output wire [0:0] out_o_valid,
    output wire [4:0] out_unnamed_hello_world0_hello_world_avm_burstcount,
    output wire [63:0] out_unnamed_hello_world0_hello_world_avm_byteenable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_enable,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_read,
    output wire [0:0] out_unnamed_hello_world0_hello_world_avm_write,
    output wire [511:0] out_unnamed_hello_world0_hello_world_avm_writedata,
    input wire clock,
    input wire resetn
    );

    wire [0:0] GND_q;
    wire [32:0] addr_trunc_in;
    wire [32:0] addr_trunc_q;
    wire [255:0] c_i256_08_q;
    wire [31:0] c_i32_06_q;
    wire [31:0] c_i32_13_q;
    wire [32:0] c_i33_02_q;
    wire [2:0] c_i3_07_q;
    wire [511:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdata;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush_bitsignaltemp;
    wire [32:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_address;
    wire [2:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_atomic_op;
    wire [32:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_bitwiseor;
    wire [31:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_byteenable;
    wire [255:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_cmpdata;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid_bitsignaltemp;
    wire [255:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_writedata;
    wire [32:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_base_addr;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset_bitsignaltemp;
    wire [31:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_size;
    wire [32:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_address;
    wire [4:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_burstcount;
    wire [63:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_byteenable;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write_bitsignaltemp;
    wire [511:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writedata;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active_bitsignaltemp;
    wire [4:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_input_fifo_depth;
    wire [255:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_readdata;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid_bitsignaltemp;
    wire [0:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_writeack;
    wire i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_writeack_bitsignaltemp;
    wire [31:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_profile_avm_burstcount_total_incr;
    wire [31:0] i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_profile_bw_incr;


    // c_i32_06(CONSTANT,5)
    assign c_i32_06_q = $unsigned(32'b00000000000000000000000000000000);

    // c_i256_08(CONSTANT,4)
    assign c_i256_08_q = $unsigned(256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);

    // c_i32_13(CONSTANT,6)
    assign c_i32_13_q = $unsigned(32'b11111111111111111111111111111111);

    // c_i33_02(CONSTANT,7)
    assign c_i33_02_q = $unsigned(33'b000000000000000000000000000000000);

    // c_i3_07(CONSTANT,9)
    assign c_i3_07_q = $unsigned(3'b000);

    // addr_trunc(ROUND,2)
    assign addr_trunc_in = in_i_address[32:0];
    assign addr_trunc_q = addr_trunc_in[32:0];

    // GND(CONSTANT,0)
    assign GND_q = $unsigned(1'b0);

    // i_llvm_fpga_mem_unnamed_hello_world0_hello_world1(EXTIFACE,10)
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdata = in_unnamed_hello_world0_hello_world_avm_readdata;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid = in_unnamed_hello_world0_hello_world_avm_readdatavalid;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest = in_unnamed_hello_world0_hello_world_avm_waitrequest;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack = in_unnamed_hello_world0_hello_world_avm_writeack;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x = GND_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush = in_flush;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_address = addr_trunc_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_atomic_op = c_i3_07_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_bitwiseor = c_i33_02_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_byteenable = c_i32_13_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_cmpdata = c_i256_08_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate = in_i_predicate;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall = in_i_stall;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid = in_i_valid;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_writedata = in_i_writedata;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_base_addr = c_i33_02_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset = GND_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_size = c_i32_06_q;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset_bitsignaltemp = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset[0];
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid_bitsignaltemp;
    assign i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_writeack[0] = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_writeack_bitsignaltemp;
    lsu_top #(
        .ABITS_PER_LMEM_BANK(0),
        .ADDRSPACE(1024),
        .ALIGNMENT_BYTES(32),
        .ALLOW_HIGH_SPEED_FIFO_USAGE(0),
        .ASYNC_RESET(1),
        .ATOMIC(0),
        .ATOMIC_WIDTH(3),
        .AVM_READ_DATA_LATENESS(0),
        .AVM_WRITE_DATA_LATENESS(0),
        .AWIDTH(33),
        .BURSTCOUNT_WIDTH(5),
        .ENABLE_BANKED_MEMORY(0),
        .FORCE_NOP_SUPPORT(0),
        .HIGH_FMAX(1),
        .INPUTFIFO_USEDW_MAXBITS(5),
        .KERNEL_SIDE_MEM_LATENCY(2),
        .LMEM_ADDR_PERMUTATION_STYLE(0),
        .MEMORY_SIDE_MEM_LATENCY(32),
        .MWIDTH_BYTES(64),
        .NUMBER_BANKS(1),
        .PROFILE_ADDR_TOGGLE(0),
        .READ(0),
        .STALLFREE(0),
        .STYLE("BURST-COALESCED"),
        .SYNCHRONIZE_RESET(1),
        .USECACHING(0),
        .USEINPUTFIFO(0),
        .USEOUTPUTFIFO(1),
        .USE_BYTE_EN(0),
        .USE_STALL_LATENCY(0),
        .USE_WRITE_ACK(0),
        .WIDE_DATA_SLICING(0),
        .WIDTH_BYTES(32),
        .WRITEDATAWIDTH_BYTES(64)
    ) thei_llvm_fpga_mem_unnamed_hello_world0_hello_world1 (
        .avm_readdata(in_unnamed_hello_world0_hello_world_avm_readdata),
        .avm_readdatavalid(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_readdatavalid_bitsignaltemp),
        .avm_waitrequest(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_waitrequest_bitsignaltemp),
        .avm_writeack(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writeack_bitsignaltemp),
        .clock2x(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_clock2x_bitsignaltemp),
        .flush(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_flush_bitsignaltemp),
        .i_address(addr_trunc_q),
        .i_atomic_op(c_i3_07_q),
        .i_bitwiseor(c_i33_02_q),
        .i_byteenable(c_i32_13_q),
        .i_cmpdata(c_i256_08_q),
        .i_predicate(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_predicate_bitsignaltemp),
        .i_stall(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_stall_bitsignaltemp),
        .i_valid(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_i_valid_bitsignaltemp),
        .i_writedata(in_i_writedata),
        .stream_base_addr(c_i33_02_q),
        .stream_reset(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_stream_reset_bitsignaltemp),
        .stream_size(c_i32_06_q),
        .avm_address(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_address),
        .avm_burstcount(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_burstcount),
        .avm_byteenable(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_byteenable),
        .avm_enable(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable_bitsignaltemp),
        .avm_read(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read_bitsignaltemp),
        .avm_write(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write_bitsignaltemp),
        .avm_writedata(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writedata),
        .o_active(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active_bitsignaltemp),
        .o_input_fifo_depth(),
        .o_readdata(),
        .o_stall(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall_bitsignaltemp),
        .o_valid(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid_bitsignaltemp),
        .o_writeack(i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_writeack_bitsignaltemp),
        .profile_avm_burstcount_total_incr(),
        .profile_bw_incr(),
        .clock(clock),
        .resetn(resetn)
    );

    // regfree_osync(GPOUT,16)
    assign out_lsu_unnamed_hello_world0_o_active = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_active;

    // sync_out(GPOUT,18)@20000000
    assign out_o_stall = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_stall;

    // dupName_0_regfree_osync_x(GPOUT,20)
    assign out_unnamed_hello_world0_hello_world_avm_address = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_address;

    // dupName_0_sync_out_x(GPOUT,21)@5
    assign out_o_valid = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_o_valid;

    // dupName_1_regfree_osync_x(GPOUT,22)
    assign out_unnamed_hello_world0_hello_world_avm_burstcount = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_burstcount;

    // dupName_2_regfree_osync_x(GPOUT,23)
    assign out_unnamed_hello_world0_hello_world_avm_byteenable = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_byteenable;

    // dupName_3_regfree_osync_x(GPOUT,24)
    assign out_unnamed_hello_world0_hello_world_avm_enable = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_enable;

    // dupName_4_regfree_osync_x(GPOUT,25)
    assign out_unnamed_hello_world0_hello_world_avm_read = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_read;

    // dupName_5_regfree_osync_x(GPOUT,26)
    assign out_unnamed_hello_world0_hello_world_avm_write = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_write;

    // dupName_6_regfree_osync_x(GPOUT,27)
    assign out_unnamed_hello_world0_hello_world_avm_writedata = i_llvm_fpga_mem_unnamed_hello_world0_hello_world1_avm_writedata;

endmodule
