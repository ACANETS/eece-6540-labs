// The function of this module is to adapt burst read/writes such that
// they do not cross burst word boundary.
// The mem rerouter in memory bank divider routes reads/rites based on 
// address and max burstcount, and just forwards other request information.
// This is a problem when a read/write is requested that crosses burst
// word boundary for an interleaving memory access.
//
// Writes that cross burst word boundary will be broken into two smaller bursts
// This does not introduce any stalls, as Avalon only allows on word per clock cycle on writes.
//
// Reads that cross burst word boundary will be broken into 2 read requests, and this will cause
// a stall upstream, as an extra bus cycle is required to send the extra read command.
//
module burst_boundary_splitter #
(
    parameter WIDTH_D = 256,          // Width of data bus
    parameter WORD_WIDTH_A = 26,      // Width of word address bus
    parameter BURSTCOUNT_WIDTH = 6,   // Width of burstcount bus
    parameter BYTEENABLE_WIDTH = 32   // Width of byteenable bus
)
(
    input   logic                         clk,
    input   logic                         resetn,
    
    // Avalon Memory Mapped Slave Port
    input   logic [WORD_WIDTH_A-1:0]      s_addr_i,  // Word address
    input   logic [WIDTH_D-1:0]           s_writedata_i,
    input   logic                         s_read_i,
    input   logic                         s_write_i,
    input   logic [BURSTCOUNT_WIDTH-1:0]  s_burstcount_i,
    input   logic [BYTEENABLE_WIDTH-1:0]  s_byteenable_i,
    output  logic                         s_waitrequest_o,
    output  logic [WIDTH_D-1:0]           s_readdata_o,
    output  logic                         s_readdatavalid_o,
    
    // Avalon Memory Mapped Master Port
    input   logic                         m_waitrequest_i,
    input   logic [WIDTH_D-1:0]           m_readdata_i,
    input   logic                         m_readdatavalid_i,
    output  logic [WORD_WIDTH_A-1:0]      m_addr_o,  // Word address
    output  logic [WIDTH_D-1:0]           m_writedata_o,
    output  logic                         m_read_o,
    output  logic                         m_write_o,
    output  logic [BURSTCOUNT_WIDTH-1:0]  m_burstcount_o,
    output  logic [BYTEENABLE_WIDTH-1:0]  m_byteenable_o
);

logic [WORD_WIDTH_A-1:0]      split_address;      // Second read request's address when read burst split is required
logic [BURSTCOUNT_WIDTH-1:0]  max_burst;          // Maximum burst allowed before crossing burst word boundary.
                                                  // Also used as output burstcount during the first half of split read requests.
logic [BURSTCOUNT_WIDTH-1:0]  split_burstcount;   // Second read request's burstcount when read burst split is required
logic require_split;                              // Current request requires burst splitting
logic split_read_req;                             // Signal that second read request is occurring
logic waitrequest_prev;                           // previous state of waitrequest

// Since the address is word address, use the LSBs to calculate max burst
assign max_burst =  2**(BURSTCOUNT_WIDTH-1) - s_addr_i[BURSTCOUNT_WIDTH-2:0];
assign require_split =  s_burstcount_i > max_burst;

// When burst read that crosses burst word boundary is requested:
// stall slave for 1 cycle or until master is able to request read of first half
// next cycle, request read of the second half
assign s_waitrequest_o = m_waitrequest_i |
    (require_split & s_read_i & (!split_read_req | !waitrequest_prev));

assign m_addr_o = (split_read_req) ? split_address : s_addr_i;
assign m_burstcount_o = (split_read_req) ? split_burstcount :
      (require_split) ?  max_burst : s_burstcount_i;
      
assign m_read_o = split_read_req | s_read_i;

// Request path
assign m_write_o = s_write_i;
assign m_byteenable_o = s_byteenable_i;
assign m_writedata_o = s_writedata_i;

// Response path
assign s_readdata_o = m_readdata_i;
assign s_readdatavalid_o = m_readdatavalid_i;

always @(posedge clk) begin
  waitrequest_prev <= s_waitrequest_o;
end

always @(posedge clk or negedge resetn) begin
  if (!resetn)
    begin
      split_read_req <= 0;
      split_address <= 'x;
      split_burstcount <= 'x;
    end
  else
    if (s_read_i & require_split & !split_read_req & !m_waitrequest_i)
      begin
        split_read_req <= 1;
        split_address <= s_addr_i + max_burst;
        split_burstcount <= s_burstcount_i - max_burst;
      end
    else if (split_read_req & !m_waitrequest_i)
      begin
        split_read_req <= 0;
      end
    else
      begin
        split_read_req <= split_read_req;
        split_address <= split_address;
        split_burstcount <= split_burstcount;
      end
end

endmodule
