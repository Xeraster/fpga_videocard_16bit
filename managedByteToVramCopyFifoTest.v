`include "fifo_bram.v"
`include "managedByteToVramCopyFifo.v"

`default_nettype none

module tb();
reg clk;
reg rst_n;
reg test_signal;

reg[15:0] dataIn;
reg write_en, read_en;
wire[15:0] dataOut;  //wire on hardware, reg for testbench because thats just how
wire full, empty, valid;
wire[15:0] vramDataBus;
wire WE, CE, done;
reg bus_free;
wire fifo_read;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

//bram_256x16 testram(dataIn, write_en, waddr, clk, raddr, clk, dataOut);
psuedofiforam testfifo(dataIn, write_en, fifo_read, clk, clk, dataOut, rst_n, full, empty, valid);
managedByteToVramCopyFifo testramthingy(dataOut, vramDataBus, WE, CE, clk, done, bus_free, empty, valid, fifo_read);

initial begin
    $dumpfile("tb_.vcd");
    $dumpvars(0, tb);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(2) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(10) @(posedge clk);
    $finish(2);
end

initial begin
    #5
    test_signal = 0;
    bus_free=0;
    read_en = 0;
    #5
    test_signal = 1;
    #10
    test_signal = 0;
    #10
    test_signal = 1;
    dataIn = 42069;
    write_en = 1;
    #5
    #5
    write_en = 0;
    read_en = 1;
    #5
    #5
    test_signal = 0;
    read_en = 0;
    #5
    #5
    #5
    read_en = 1;
    test_signal = 1;
    write_en = 1;
    #5
    #5
    read_en = 1;
    #5
    #5
    #5
    write_en = 0;
    #5
    dataIn = 65535;
    write_en = 1;
    #5
    #5
    write_en = 1;
    dataIn = 4444;
    #5
    #5
    write_en = 0;
    #10
    bus_free=0;
    #10
    write_en = 0;
    #10
    #10
    test_signal = 0;
end

endmodule
