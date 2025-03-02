`include "isa_slave_controller.v"

`default_nettype none

module tb();
reg clk;
reg rst_n;

reg[15:0] dataIn;
reg[19:0] addressBus;
wire[15:0] dataOut;

wire FPGA_IO_EN, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, done, TE0, TE1, TE2, TE3, FPGA_WR, ibufferActivate;
reg SBHE, BALE, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, bus_free, bus_free_forreal;

reg ISA_CLK;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

//bram_256x16 testram(dataIn, write_en, waddr, clk, raddr, clk, dataOut);
//psuedofiforam testfifo(dataIn, write_en, read_en, clk, clk, dataOut, rst_n, full, empty, valid);
isaSlaveBusController blahblahblah(dataIn, dataOut, addressBus, FPGA_IO_EN, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISA_CLK, done, bus_free, bus_free_forreal, TE0, TE1, TE2, TE3, FPGA_WR, clk ,ibufferActivate);

initial begin
    $dumpfile("tb_.vcd");
    $dumpvars(0, tb);
end

//initial begin
    /*#1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(2) @(posedge clk);
    rst_n<=1;*/
    //@(posedge clk);
    //repeat(10) @(posedge clk);
    //$finish(2);
    //more trouble than its worth. shame. the manual way sucks but it refuses to let me use this in a way that's actually helpful or useful so it is what it is
//end

//fuck
initial begin
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
    #1
    clk=0;
    #1
    clk=1;
end

initial begin
    //manually define every clock cycle. I wish there was a BETTER way. whatever bs the above is is not a better way because it never works correctly
    #5
    dataIn = 0;
    MEMR=1;
    MEMW=1;
    SMEMR=1;
    SMEMW=1;
    IOR=1;
    IOW=1;
    addressBus = 'h420; //0x420 is an address that activates the device
    ISA_CLK = 1;
    BALE = 0;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    BALE = 1;
    #5
    ISA_CLK = 1;
    BALE = 0;
    MEMW = 0;
    SBHE = 0;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    MEMW=1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    #5
    ISA_CLK = 1;
    #5
    ISA_CLK = 0;
    $finish(2);//stop crashing my fucking terminal window. sheesh
end

endmodule
