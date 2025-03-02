module bram_256x16(din, write_en, waddr, wclk, raddr, rclk, dout);//256x16
parameter addr_width = 8;
parameter data_width = 16;
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

//reg[7:0] waddr;
//reg[7:0] raddr;

reg[7:0] r_ptr;
reg[7:0] w_ptr;
reg[7:0] workaround;//w_ptr + 1'b1 works on test bench but not hardware, this is used as a workaround hack

reg init;
reg iwrite_en, iread_en;//internal read and write enables

//set stuff up on reset
/*always@(posedge wclk)
begin
    if (!RESET)
    begin
        //waddr <= 0;//works on testbench but not on hardware. this is due to multiple drivers
        //raddr <= 0;
        //w_ptr <= 0;
        //r_ptr <= 0;
        //iread_en <= 0;
        //iwrite_en <= 0;
        //init <= 0;
    end

    //not connected to anything
    //workaround <= w_ptr + 1'b1;
end*/

//reg[7:0] amtTillEmpty;  //a way to figure out if its about to run out of buffer or not
reg holdOffForASec;

//reg[15:0] flippyFlop;
//write data to memory
assign almostFull = ialmostFull;
reg ialmostFull;
reg ifull;
always@(posedge wclk) begin
    /*if (write_en & !full) begin
        waddr <= w_ptr;
        iwrite_en <= 1;
        w_ptr <= w_ptr + 1;
        init <= 1;
    end else if (!RESET)
    begin
        w_ptr <= 0;
        waddr <= 0;
        iwrite_en <= 0;
        init <= 0;
    end else begin
        iwrite_en <= 0;
    end*/

    //it's a few mhz faster to do this + it starts working a little bit earlier
    if (!RESET) begin
        w_ptr <= 0;
        //waddr <= 0;
        iwrite_en <= 0;
        init <= 0;
        holdOffForASec <= 0;
    end else if (write_en & !full & /*amtTillEmpty < 8'hF0*/~ialmostFull) begin
        //waddr <= w_ptr;
        iwrite_en <= 1;
        w_ptr <= w_ptr + 1;
        init <= 1;
        holdOffForASec <= 0;
    end else begin
        iwrite_en <= 0;
        holdOffForASec <= 1;
    end

    ialmostFull <= (w_ptr - r_ptr) > 8'hF0/* & (w_ptr - r_ptr) > 8'h0*/;
    //amtTillEmpty <= w_ptr - r_ptr;

    //it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
    ifull <= ((w_ptr + 1'b1) == r_ptr);
    //flippyFlop <= din;
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

    //amtTillEmpty <= w_ptr - r_ptr;
end

//assign full = (workaround == r_ptr);
//assign full = ((w_ptr + 1) == r_ptr);
//assign full = ((w_ptr + 1'b1) === r_ptr);
//assign full = ((w_ptr + 1'b1) == r_ptr);
assign full = ifull;//it has to be done this way to get 108ish mhz speeds instead ofg 55ish mhz speeds
assign empty = (w_ptr == r_ptr) & ~ifull;//possible combinational loop or timing problem
assign valid = init & ~empty;   //if there has already been an initializing write and also if it isnt empty. it seems avoiding undefined inputs avoids certain weird issues

//the exact module that hopefully infers a bram on ice40 hx4k
//bram_256x16 theBlock(din, write_en, waddr, wclk, raddr, rclk, dout);
//bram_256x16 theBlock(din, write_en, w_ptr, wclk, r_ptr, rclk, dout);
bram_256x16 theBlock(din, iwrite_en, w_ptr, wclk, r_ptr, rclk, dout);

endmodule