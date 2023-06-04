/* ****************************************************************************
 * Copyright(c) 2017, Intel Corporation
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * * Neither the name of Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * **************************************************************************/
// Compliant with HSSI interface spec v0.4
// Date: April/24/2017
 
`ifndef PR_HSSI_IF_VH
`define PR_HSSI_IF_VH

interface pr_hssi_if 
#(
    parameter NUM_LN = 4 // Number of HSSI lanes
) ();
    // clocks and lock flags
    logic f2a_tx_clk;
    logic f2a_tx_clkx2;
    logic f2a_tx_locked;
          
    logic f2a_rx_clk_ln0;
    logic f2a_rx_clkx2_ln0;
    logic f2a_rx_locked_ln0;
    logic f2a_rx_clk_ln4;
    logic f2a_rx_locked_ln4;
    
    // reset signals
    logic [NUM_LN-1:0] a2f_tx_analogreset;
    logic [NUM_LN-1:0] a2f_tx_digitalreset;
    logic [NUM_LN-1:0] a2f_rx_analogreset;
    logic [NUM_LN-1:0] a2f_rx_digitalreset;

    // lock control signals
    logic [NUM_LN-1:0] a2f_rx_seriallpbken;
    logic [NUM_LN-1:0] a2f_rx_set_locktoref;
    logic [NUM_LN-1:0] a2f_rx_set_locktodata;

    // lock flags
    logic              f2a_tx_cal_busy;
    logic              f2a_tx_pll_locked;
    logic              f2a_rx_cal_busy;
    logic [NUM_LN-1:0] f2a_rx_is_lockedtoref;
    logic [NUM_LN-1:0] f2a_rx_is_lockedtodata;

    // parallel data
    logic [NUM_LN*128-1:0] a2f_tx_parallel_data;
    logic [NUM_LN* 18-1:0] a2f_tx_control;
    logic [NUM_LN*128-1:0] f2a_rx_parallel_data;
    logic [NUM_LN* 20-1:0] f2a_rx_control;

    // enhanced interface status
    logic [NUM_LN-1:0] f2a_tx_enh_fifo_full;
    logic [NUM_LN-1:0] f2a_tx_enh_fifo_pfull;
    logic [NUM_LN-1:0] f2a_tx_enh_fifo_empty;
    logic [NUM_LN-1:0] f2a_tx_enh_fifo_pempty;
    logic [NUM_LN-1:0] f2a_rx_enh_data_valid;
    logic [NUM_LN-1:0] f2a_rx_enh_fifo_full;
    logic [NUM_LN-1:0] f2a_rx_enh_fifo_pfull;
    logic [NUM_LN-1:0] f2a_rx_enh_fifo_empty;
    logic [NUM_LN-1:0] f2a_rx_enh_fifo_pempty;
    logic [NUM_LN-1:0] f2a_rx_enh_blk_lock;
    logic  [NUM_LN-1:0] f2a_rx_enh_highber;
    logic [NUM_LN-1:0] a2f_rx_enh_fifo_rd_en;
    logic [NUM_LN-1:0] a2f_tx_enh_data_valid;

    // HSSI GBS logic initialization
    logic        a2f_init_start;
    logic        f2a_init_done;

    logic        a2f_prmgmt_fatal_err;
    logic [31:0] a2f_prmgmt_dout;

    logic        f2a_prmgmt_ctrl_clk;
    logic [15:0] f2a_prmgmt_cmd;
    logic [15:0] f2a_prmgmt_addr;
    logic [31:0] f2a_prmgmt_din;
    logic        f2a_prmgmt_freeze;
    logic        f2a_prmgmt_arst;
    logic        f2a_prmgmt_ram_ena;

modport to_afu (
    output f2a_tx_clk,
    output f2a_tx_clkx2,
    output f2a_tx_locked,
          
    output f2a_rx_clk_ln0,
    output f2a_rx_clkx2_ln0,
    output f2a_rx_locked_ln0,
    output f2a_rx_clk_ln4,
    output f2a_rx_locked_ln4,
    
    input  a2f_tx_analogreset,
    input  a2f_tx_digitalreset,
    input  a2f_rx_analogreset,
    input  a2f_rx_digitalreset,

    input  a2f_rx_seriallpbken,
    input  a2f_rx_set_locktoref,
    input  a2f_rx_set_locktodata,

    output f2a_tx_cal_busy,
    output f2a_tx_pll_locked,
    output f2a_rx_cal_busy,
    output f2a_rx_is_lockedtoref,
    output f2a_rx_is_lockedtodata,

    input  a2f_tx_parallel_data,
    input  a2f_tx_control,
    output f2a_rx_parallel_data,
    output f2a_rx_control,

    output f2a_tx_enh_fifo_full,
    output f2a_tx_enh_fifo_pfull,
    output f2a_tx_enh_fifo_empty,
    output f2a_tx_enh_fifo_pempty,
    output f2a_rx_enh_data_valid,
    output f2a_rx_enh_fifo_full,
    output f2a_rx_enh_fifo_pfull,
    output f2a_rx_enh_fifo_empty,
    output f2a_rx_enh_fifo_pempty,
    output f2a_rx_enh_blk_lock,
    output f2a_rx_enh_highber,
    input  a2f_rx_enh_fifo_rd_en,
    input  a2f_tx_enh_data_valid,

    input  a2f_init_start,
    output f2a_init_done,

    input  a2f_prmgmt_fatal_err,
    input  a2f_prmgmt_dout,
    output f2a_prmgmt_ctrl_clk,
    output f2a_prmgmt_cmd,
    output f2a_prmgmt_addr,
    output f2a_prmgmt_din,
    output f2a_prmgmt_freeze,
    output f2a_prmgmt_arst,
    output f2a_prmgmt_ram_ena
);

modport to_fiu (
    input  f2a_tx_clk,
    input  f2a_tx_clkx2,
    input  f2a_tx_locked,
       
    input  f2a_rx_clk_ln0,
    input  f2a_rx_clkx2_ln0,
    input  f2a_rx_locked_ln0,
    input  f2a_rx_clk_ln4,
    input  f2a_rx_locked_ln4,
    
    output a2f_tx_analogreset,
    output a2f_tx_digitalreset,
    output a2f_rx_analogreset,
    output a2f_rx_digitalreset,

    output a2f_rx_seriallpbken,
    output a2f_rx_set_locktoref,
    output a2f_rx_set_locktodata,

    input  f2a_tx_cal_busy,
    input  f2a_tx_pll_locked,
    input  f2a_rx_cal_busy,
    input  f2a_rx_is_lockedtoref,
    input  f2a_rx_is_lockedtodata,

    output a2f_tx_parallel_data,
    output a2f_tx_control,
    input  f2a_rx_parallel_data,
    input  f2a_rx_control,

    input  f2a_tx_enh_fifo_full,
    input  f2a_tx_enh_fifo_pfull,
    input  f2a_tx_enh_fifo_empty,
    input  f2a_tx_enh_fifo_pempty,
    input  f2a_rx_enh_data_valid,
    input  f2a_rx_enh_fifo_full,
    input  f2a_rx_enh_fifo_pfull,
    input  f2a_rx_enh_fifo_empty,
    input  f2a_rx_enh_fifo_pempty,
    input  f2a_rx_enh_blk_lock,
    input  f2a_rx_enh_highber,
    output a2f_rx_enh_fifo_rd_en,
    output a2f_tx_enh_data_valid,

    output a2f_init_start,
    input  f2a_init_done,

    output a2f_prmgmt_fatal_err,
    output a2f_prmgmt_dout,
    input  f2a_prmgmt_ctrl_clk,
    input  f2a_prmgmt_cmd,
    input  f2a_prmgmt_addr,
    input  f2a_prmgmt_din,
    input  f2a_prmgmt_freeze,
    input  f2a_prmgmt_arst,
    input  f2a_prmgmt_ram_ena
);

endinterface

`endif // PR_HSSI_IF_VH
