`include "TOP.V"
`include "sync_r2w.v"
`include "syncw2r.v"
`include "fifo_memory.v"
`include "r_pointer_epty.v"
`include "w_ptr_wfull.v"

`default_nettype none

module tb();
reg clk;
reg rst_n;
reg test_signal;

reg[15:0] dataIn;
reg[7:0] waddr, raddr;
reg write_en, read_en;
wire[15:0] dataOut;
wire full, empty, valid;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

//bram_256x16 testram(dataIn, write_en, waddr, clk, raddr, clk, dataOut);
//psuedofiforam testfifo(dataIn, write_en, read_en, clk, clk, dataOut, rst_n, full, empty, valid);
async_fifo1 testfiforam(write_en, clk, rst_n, read_en, clk, rst_n, dataIn, dataOut, full, empty);

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
    read_en = 0;
    #5
    test_signal = 1;
    #10
    test_signal = 0;
    #10
    test_signal = 1;
    dataIn = 42069;
    waddr = 0;
    raddr = 0;
    write_en = 1;
    #5
    #5
    write_en = 0;
    #5
    #5
    test_signal = 0;
    #5
    #5
    #5
    test_signal = 1;
    waddr = 0;
    raddr = 0;
    write_en = 1;
    #5
    #5
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
    read_en = 1;
    #10
    write_en = 0;
    #10
    #10
    test_signal = 0;
end

endmodule
