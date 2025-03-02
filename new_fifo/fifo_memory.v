//
// FIFO memory
//
module fifomem
#(
  parameter DATASIZE = 16, // Memory data word width
  parameter ADDRSIZE = 8  // Number of mem address bits
)
(
  input   winc, wfull, wclk,
  input   [ADDRSIZE-1:0] waddr, raddr,
  input   [DATASIZE-1:0] wdata,
  output  [DATASIZE-1:0] rdata
);

  //come on, wtf does this mean???
  // RTL Verilog memory model
  localparam DEPTH = 1<<ADDRSIZE;//2*addsize

  //i've never need this syntax before and its incompatible with my software setup, resorting to guessing what it means
  //logic [DATASIZE-1:0] mem [0:DEPTH-1];
  reg [DATASIZE-1:0] mem [(1<<ADDRSIZE)-1:0];//maaaybe this will work
  
  //well shit
  //reg[16:0] mem;

  assign rdata = mem[raddr];

  always@(posedge wclk)
    if (winc && !wfull)
      mem[waddr] <= wdata;

endmodule


