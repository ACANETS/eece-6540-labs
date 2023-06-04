// Module for Quartus synthesize only. Simulation model reside in
// global_routing_sim.v
module global_routing
(
   input s,
   input clk,
   output g
);

  GLOBAL cal_clk_gbuf (.in(s), .out(g));

endmodule
