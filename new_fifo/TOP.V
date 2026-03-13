// Top level wrapper
//
//`include "sync_r2w.v"
//`include "syncw2r.v"
//`include "fifo_memory.v"
//`include "r_pointer_epty.v"
//`include "w_ptr_wfull.v"

module bram_256x20(din, write_en, waddr, wclk, raddr, rclk, dout);//256x20
parameter addr_width = 8;
parameter data_width = 20;
input [addr_width-1:0] waddr, raddr;
input [data_width-1:0] din;
input write_en, wclk, rclk;
output reg [data_width-1:0] dout;
reg [data_width-1:0] mem [(1<<addr_width)-1:0];

always @(posedge wclk) // Write memory.
begin
    if (write_en)
    begin
        mem[waddr] <= din; // Using write address bus.
    end
end

always @(posedge rclk) // Read memory.
begin
    dout <= mem[raddr]; // Using read address bus.
end
endmodule

module async_fifo1
#(
  parameter DSIZE = 16,   //16 bit data
  parameter ASIZE = 8     //8 bits of address
 )
(
  input   winc, wclk, wrst_n,//winc write enable signal
  input   rinc, rclk, rrst_n,//rinc read enable signal
  input   [DSIZE-1:0] wdata,

  output  [DSIZE-1:0] rdata,
  output  wfull,
  output  rempty
);

  wire [ASIZE-1:0] waddr, raddr, walmostaddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (wclk, wrst_n, rptr, wq2_rptr);
  sync_w2r sync_w2r (rclk, rrst_n, wptr, rq2_wptr);
  //fifomem #(DSIZE, ASIZE) fifomem (winc, wfull, wclk, waddr, raddr, wdata, rdata);//uses like a zillion logic cells, no good
  bram_256x16 goddammit(wdata, winc, waddr, wclk, raddr, rclk, rdata);
  rptr_empty #(ASIZE) rptr_empty (rinc, rclk, rrst_n, rq2_wptr, rempty, raddr, rptr);
  wptr_full #(ASIZE) wptr_full (winc, wclk, wrst_n, wq2_rptr, wfull, waddr, wptr);

endmodule

module async_fifo20
#(
  parameter DSIZE = 20,   //20 bit data since this is used for keeping track of wrie addresses in the write buffer
  parameter ASIZE = 8     //8 bits of address
 )
(
  input   winc, wclk, wrst_n,//winc write enable signal
  input   rinc, rclk, rrst_n,//rinc read enable signal
  input   [DSIZE-1:0] wdata,

  output  [DSIZE-1:0] rdata,
  output  wfull,
  output  rempty
);
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w (wclk, wrst_n, rptr, wq2_rptr);
  sync_w2r sync_w2r (rclk, rrst_n, wptr, rq2_wptr);
  //fifomem #(DSIZE, ASIZE) fifomem (winc, wfull, wclk, waddr, raddr, wdata, rdata);//uses like a zillion logic cells, no good
  bram_256x20 goddammit(wdata, winc, waddr, wclk, raddr, rclk, rdata);
  rptr_empty #(ASIZE) rptr_empty (rinc, rclk, rrst_n, rq2_wptr, rempty, raddr, rptr);
  wptr_full #(ASIZE) wptr_full (winc, wclk, wrst_n, wq2_rptr, wfull, waddr, wptr);

endmodule
