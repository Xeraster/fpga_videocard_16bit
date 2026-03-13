//writerBufferVram.v doesn't work and I can't figure out why. I'm trying different method that contains less stuff from the internet I can't understand. There is syntax in the "TOP" fifo that does not make sense
/*`include "new_fifo/TOP.V"
`include "new_fifo/sync_r2w.v"
`include "new_fifo/syncw2r.v"
`include "new_fifo/fifo_memory.v"
`include "new_fifo/r_pointer_epty.v"
`include "new_fifo/w_ptr_wfull.v"*/

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

//based on this: https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/
//also from the internet but doesn't contain as high a percentage of code I don't understand
module psuedofiforam(
    input[15:0] din,
    input write_en,
    input read_en,
    input wclk,
    input rclk,
    output[15:0] dout,
    input RESET,
    output full,
    output empty,           
    output valid,           //as long as this is high, reading from the fifo shouldn't cause any issues
    output almostFull
);


reg[7:0] r_ptr;
reg[7:0] w_ptr;
reg[7:0] diff;

reg init;
reg iwrite_en, iread_en;//internal read and write enables

//reg[15:0] flippyFlop;
//write data to memory
assign almostFull = ialmostFull;
reg ialmostFull;
reg ifull;
always@(posedge wclk) begin

    if (!RESET) begin
        w_ptr <= 0;
        //waddr <= 0;
        iwrite_en <= 0;
        init <= 0;
    end else if (write_en & !full) begin
        //waddr <= w_ptr;
        iwrite_en <= 1;
        w_ptr <= w_ptr + 1;
        init <= 1;
    end else begin
        iwrite_en <= 0;
    end

    ialmostFull <= (w_ptr - r_ptr) < 8'h8 & ~empty;//WHY THE FUCK DOES THIS WORK PERFECTLY ON TESTBENCH BUT NOT HARDWARE
    //ialmostFull <= 0;//broken, works on testbench, not on hardware, doesnt generate yosys errors. this is probably a very special case like yosys tristates that requires its own specific workaround depending on the situation
    //diff <= (r_ptr - w_ptr);

    //it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
    ifull <= ((w_ptr + 1'b1) == r_ptr);
end

//read data from memory
always@(posedge rclk) begin
    if (!RESET) begin
        r_ptr <= 0;
        //raddr <= 0;
        iread_en <= 0;
    end else if (read_en & !empty) begin
        //raddr <= r_ptr;
        iread_en <= 1;
        r_ptr <= r_ptr + 1;
    end else begin
        iread_en <= 0;
    end

    //ialmostFull <= (w_ptr - r_ptr) > 8'h8;
    //amtTillEmpty <= w_ptr - r_ptr;
end

assign full = ifull;//it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
assign empty = (w_ptr == r_ptr) & ~ifull;//possible combinational loop or timing problem
assign valid = init & ~empty;   //if there has already been an initializing write and also if it isnt empty. it seems avoiding undefined inputs avoids certain weird issues

//the exact module that hopefully infers a bram on ice40 hx4k
bram_256x16 theBlock(din, iwrite_en, w_ptr, wclk, r_ptr, rclk, dout);

endmodule

//based on this: https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/
//also from the internet but doesn't contain as high a percentage of code I don't understand
module psuedofiforam20(
    input[19:0] din,
    input write_en,
    input read_en,
    input wclk,
    input rclk,
    output[19:0] dout,
    input RESET,
    output full,
    output empty,           
    output valid,           //as long as this is high, reading from the fifo shouldn't cause any issues
    output almostFull
);


reg[7:0] r_ptr;
reg[7:0] w_ptr;

reg init;
reg iwrite_en, iread_en;//internal read and write enables

//reg[15:0] flippyFlop;
//write data to memory
assign almostFull = ialmostFull;
reg ialmostFull;
reg ifull;
always@(posedge wclk) begin

    if (!RESET) begin
        w_ptr <= 0;
        //waddr <= 0;
        iwrite_en <= 0;
        init <= 0;
    end else if (write_en & !full) begin
        //waddr <= w_ptr;
        iwrite_en <= 1;
        w_ptr <= w_ptr + 1;
        init <= 1;
    end else begin
        iwrite_en <= 0;
    end

    //it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
    ifull <= ((w_ptr + 1'b1) == r_ptr);
end

//read data from memory
always@(posedge rclk) begin
    if (!RESET) begin
        r_ptr <= 0;
        //raddr <= 0;
        iread_en <= 0;
    end else if (read_en & !empty) begin
        //raddr <= r_ptr;
        iread_en <= 1;
        r_ptr <= r_ptr + 1;
    end else begin
        iread_en <= 0;
    end

    ialmostFull <= (w_ptr - r_ptr) > 8'h8/* & (w_ptr - r_ptr) > 8'h0*/;
    //amtTillEmpty <= w_ptr - r_ptr;
end

assign full = ifull;//it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
assign empty = (w_ptr == r_ptr) & ~ifull;//possible combinational loop or timing problem
assign valid = init & ~empty;   //if there has already been an initializing write and also if it isnt empty. it seems avoiding undefined inputs avoids certain weird issues

//the exact module that hopefully infers a bram on ice40 hx4k
bram_256x20 theBlock(din, iwrite_en, w_ptr, wclk, r_ptr, rclk, dout);

endmodule

module writeBufferVram(
    input[15:0] dataFromIsa,
    input[19:0] addressFromIsa,
    input writeClk,  //on the rising edge of this signal, there is new isa bus data that needs to be copied to the write buffer
    input write_en,
    output[15:0] dataOut,           //what tocopy to vram when its vram writing time
    output[19:0] addressToWrite,     //what memory address to use when its vram copying time
    output write_cmd,               //WE for vram, active low
    output chip_select,             //CE for vram, active low
    input free,                     //1 if the bus is available for this module to do its thing, 0 if back off
    input clock,                     //what clock to use, should *probably* be the fast clock
    input RESET,
    output WRITEBUF_IO_EN,           //1 if this module is using the bus, 0 if 
    output full,
    output almostFull,
    output empty
);

assign write_cmd = iwrite_cmd;
assign chip_select = ichip_select;
assign WRITEBUF_IO_EN = iWRITEBUF_IO_EN;

reg ififoWrite;
reg ififoRead;
reg iWRITEBUF_IO_EN;
reg iwrite_cmd, ichip_select;
reg ialmostFull, ialmostEmpty;
//assign almostFull = ialmostFull;
//assign empty = ialmostEmpty;
//assign full = dFull;

//it ISNT possible to implement an "almost full" output into this/any fifo. This REALLY fucks things up but maybe there's a way to make an external one here
//reg [7:0] readCtr;
//reg [7:0] writeCtr;
//reg [7:0] diff;
//reg [7:0] fullAmt, emptyAmt;

always@(posedge writeClk or negedge RESET) begin
    if (!RESET) begin
        //writeCtr <= 0;
    end else begin
        //writeCtr <= writeCtr + 1;
    end
end


always@(posedge clock) begin
    if (!RESET) begin
        //initialize all the reset values
        //ialmostFull <= 0;
        //readCtr <= 0;
    end

    if (free & ~empty) begin
        ififoRead <= 1;
        iWRITEBUF_IO_EN <= 1;
        iwrite_cmd <= 0;
        ichip_select <= 0;
        //readCtr <= readCtr + 1;

    end else begin
        ififoRead <= 0;
        iWRITEBUF_IO_EN <= 0;
        iwrite_cmd <= 1;
        ichip_select <= 1;
        //internal_read_r1 <=0;
    end


    //fullAmt <= (writeCtr - readCtr);
    //emptyAmt <= (readCtr - writeCtr);
    //ialmostFull <= fullAmt < 7;
    //ialmostEmpty <= emptyAmt > 250;

end

wire dFull, dEmpty, dValid;
wire aFull, aEmpty, aValid, aAlmostFull;

psuedofiforam dataFifo(dataFromIsa, write_en, ififoRead, writeClk, clock, dataOut, RESET, full, empty, dValid, almostFull);
psuedofiforam20 addressFifo(addressFromIsa, write_en, ififoRead, writeClk, clock, addressToWrite, RESET, aFull, aEmpty, aValid, aAlmostFull);

//async_fifo1 dataFifo(/*ififoWrite*/1'b1, newData, RESET, ififoRead, clock, RESET, dataFromIsa, dataOut, full, dEmpty);
//async_fifo20 addressFifo(/*ififoWrite*/1'b1, newData, RESET, ififoRead, clock, RESET, addressFromIsa, addressToWrite, aFull, aEmpty);

endmodule