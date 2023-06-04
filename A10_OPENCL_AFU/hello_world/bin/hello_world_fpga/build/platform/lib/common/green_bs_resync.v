// ***************************************************************************
// Copyright (c) 2013-2016, Intel Corporation
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// * Neither the name of Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Module: resync
//
// Description:
//  A general purpose resynchronization module that uses the recommended altera_std_synchronizer 
//  and altera_std_synchronizer_nocut synchronizer
//  
//  Parameters:
//    SYNC_CHAIN_LENGTH
//      - Specifies the length of the synchronizer chain for metastability
//        retiming.
//    WIDTH
//      - Specifies the number of bits you want to synchronize. Controls the width of the
//        d and q ports.
//    SLOW_CLOCK - USE WITH CAUTION. 
//      - Leaving this setting at its default will create a standard resynch circuit that
//        merely passes the input data through a chain of flip-flops. This setting assumes
//        that the input data has a pulse width longer than one clock cycle sufficient to
//        satisfy setup and hold requirements on at least one clock edge.
//      - By setting this to 1 (USE CAUTION) you are creating an asynchronous
//        circuit that will capture the input data regardless of the pulse width and 
//        its relationship to the clock. However it is more difficult to apply static
//        timing constraints as it ties the data input to the clock input of the flop.
//        This implementation assumes the data rate is slow enough
//    INIT_VALUE
//      - Specifies the initial values of the synchronization registers.
//	  NO_CUT
//		- Specifies whether to apply embedded false path timing constraint. 
//		  0: Apply the constraint 1: Not applying the constraint
//

`timescale 1ps/1ps 

module green_bs_resync #(
    parameter SYNC_CHAIN_LENGTH = 2,  // Number of flip-flops for retiming. Must be >1
    parameter WIDTH             = 1,  // Number of bits to resync
    parameter SLOW_CLOCK        = 0,  // See description above
    parameter INIT_VALUE        = 0,
    parameter NO_CUT		= 1	  // See description above
  ) (
  input   wire              clk,
  input   wire              reset,
  input   wire  [WIDTH-1:0] d,
  output  wire  [WIDTH-1:0] q
  );

localparam  INT_LEN       = (SYNC_CHAIN_LENGTH > 1) ? SYNC_CHAIN_LENGTH : 2;
localparam  L_INIT_VALUE  = (INIT_VALUE == 1) ? 1'b1 : 1'b0;

genvar ig;

// Generate a synchronizer chain for each bit
generate begin
  for(ig=0;ig<WIDTH;ig=ig+1) begin : resync_chains
	wire                d_in;   // Input to sychronization chain.
	wire				sync_d_in;
	wire		        sync_q_out;
	
	// Adding inverter to the input of first sync register and output of the last sync register to implement power-up high for INIT_VALUE=1
	assign sync_d_in = (INIT_VALUE == 1) ? ~d_in : d_in;
	assign q[ig] = (INIT_VALUE == 1)  ? ~sync_q_out : sync_q_out;
	
	if (NO_CUT == 0) begin		
		altera_std_synchronizer #(
			.depth(INT_LEN)				
		) synchronizer (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
		
		//synthesis translate_off			
		initial begin
			synchronizer.dreg = {(INT_LEN-1){1'b0}};
			synchronizer.din_s1 = 1'b0;
		end
		//synthesis translate_on
				
	end else begin
		altera_std_synchronizer_nocut #(
			.depth(INT_LEN)				
		) synchronizer_nocut (
			.clk		(clk),
			.reset_n	(~reset),
			.din		(sync_d_in),
			.dout		(sync_q_out)
		);
				
		//synthesis translate_off
		initial begin
			synchronizer_nocut.dreg = {(INT_LEN-1){1'b0}};
			synchronizer_nocut.din_s1 = 1'b0;
		end
		//synthesis translate_on	
	end
	
    // Generate asynchronous capture circuit if specified.
    if(SLOW_CLOCK == 0) begin
      assign  d_in = d[ig];
    end else begin
      wire  d_clk;
      reg   d_r = L_INIT_VALUE;
      wire  clr_n;

      assign  d_clk = d[ig];
      assign  d_in  = d_r;
      assign  clr_n = ~q[ig] | d_clk; // Clear when output is logic 1 and input is logic 0

      // Asynchronously latch the input signal.
      always @(posedge d_clk or negedge clr_n)
        if(!clr_n)      d_r <= 1'b0;
        else if(d_clk)  d_r <= 1'b1;
    end // SLOW_CLOCK
  end // for loop
end // generate
endgenerate

endmodule
