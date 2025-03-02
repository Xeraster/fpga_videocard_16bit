//`include "fifo_bram.v"
`include "fifo_bram_new.v"
`include "managedVramDataBuffer.v"
`include "isa_slave_controller.v"

`default_nettype none

module tb();
reg clk;
reg rst_n;

//reg[15:0] dataIn;
wire read_en;
wire write_en;
wire[15:0] dataOut;  //wire on hardware, reg for testbench because thats just how
wire full, empty, valid;
reg[15:0] vramDataBus;
//wire[15:0] vgaDataPixel;
wire[4:0] Ri;
wire[5:0] Gi;
wire[4:0] Bi;
wire[19:0] genVramAddress;       //what vram address to request
wire[19:0] maxVramAddress;
wire WE, CE, RD, done;
reg bus_free;
reg bus_free_forreal;
reg vblank;
reg pixelClock;

//assign maxVramAddress = 20'h4b000; //640 * 480 = 307200d or 4b000h
assign maxVramAddress = 20'h34;

wire isa_ctrl_out_en;
wire almostFull;
wire frameEnd;
assign isa_ctrl_out_en = ~(~ADS_OE & isaAddressBus >= 20'h420 & isaAddressBus <= 20'h430 & (~IOR | ~IOW));

localparam CLK_PERIOD = 8;
always #(CLK_PERIOD/2) clk=~clk;

//bram_256x16 testram(dataIn, write_en, waddr, clk, raddr, clk, dataOut);
//psuedofiforam testfifo(vramDataBus, write_en, read_en, ~clk, pixelClock, dataOut, (rst_n & ~frameEnd), full, empty, valid, almostFull);

psuedofiforam_new testfifo(vramDataBus, write_en, read_en, ~clk, pixelClock, dataOut, (rst_n & ~frameEnd), full, empty, valid, almostFull);
managedVramDataBuffer testramthingy(vramDataBus, Ri, Gi, Bi, RD, CE, clk, done, FPGA_IO_EN/*probably best this way, since cross clock domain*/, vblank, empty, full, valid, write_en, read_en, genVramAddress, maxVramAddress, rst_n, pixelClock, dataOut, frameEnd, almostFull);
                                                                                //use ADS_OE for bus free? it's either doing an isa transfer for a fpga <=> vram transfer basically
wire[15:0] isaDataOut;
reg[19:0] isaAddressBus;
wire FPGA_IO_EN;
reg SBHE, BALE, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISA_CLK;
wire IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH;
wire ISADONE;
wire TE0, TE1, TE2, TE3, FPGA_WR, ibufferActivate;
isaSlaveBusController isathing(/*vramDataBus, isaDataOut,*/ isaAddressBus, FPGA_IO_EN, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISA_CLK, ISADONE, TE0, TE1, TE2, TE3, FPGA_WR, clk, ibufferActivate, rst_n, 1'h1);

reg isaCE, isaWE, isaRD;    //the vram/sram control signals to use when doing isa bus cycles that access or modify vram/sram


initial begin
    $dumpfile("tb_.vcd");
    $dumpvars(0, tb); 
end

//fpga clk
initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(3) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(400) @(posedge clk);
    $finish(2);
end

//isa bus and clock
initial begin
    #30
    ISA_CLK=1;
    IOR=1;
    IOW=1;
    MEMR=1;
    MEMW=1;
    SMEMR=1;
    SMEMW=1;
    BALE=0; //active high
    SBHE=1; //this is active low
    isaAddressBus=255;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    BALE=1;
    SBHE=0;
    isaAddressBus=20'h520;
    #30
    ISA_CLK=1;
    BALE=0;
    //IOW=0;
    //IOW=0;
    #30
    ISA_CLK=0;
    IOW=0;
    #30
    ISA_CLK=1;
    //IOW=0;
    #30
    ISA_CLK=0;
    //IOW=0;
    #30
    ISA_CLK=1;
    //MEMW=1;
    IOW=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    IOW=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    BALE=1;
    #30
    ISA_CLK=1;
    BALE=0;
    IOW=0;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    IOW=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    #30
    ISA_CLK=0;
end

//pixel clock
initial begin
    #10
    vblank = 0;
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    vblank = 1; //the logic will need to assert vblank 2 pixelClock cycles before there needs to be color data on the bus
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    //vblank = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    vblank=0;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    vblank=1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    vblank=0;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    vblank=1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
end

//the stuff that's supposed to be happening on the fpga clock
initial begin
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #CLK_PERIOD
    #CLK_PERIOD
    vramDataBus = 0;
    //write_en = 1;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    //write_en = 0;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    //write_en = 1;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 42069;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 65535;
    //write_en = 1;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    //write_en = 1;
    vramDataBus = 55555;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 5555;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 12345;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 4322;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 8888;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 4414;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 5555;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 6622;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 17232;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 900;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 420;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 69;
    #(CLK_PERIOD/2)
    #(CLK_PERIOD/2)
    vramDataBus = 65000;
end

endmodule
