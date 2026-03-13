//`include "fifo_bram.v"
//`include "fifo_bram_new.v"
//`include "managedVramDataBuffer.v"
`include "managedVramDataBufferCompositeBankSwap.v"
//`include "isa_slave_controller.v"
`include "isa_slave_controller_new.v"

`default_nettype none

/*this is approaching the point of "too complicated to testbench in software". all "real" debugging already has to be done on hardware. Finding out evenOrOdd wasn't fully in sync isn't something that could have been done via testbench software for example. 
I can't just hand-program literal millions of testbench clock cycles. 
Even if I was willing to do that much work, it would be virtually impossible to get it correct enough to get useful debugging
for now, this is at least better than nothing but if this gets more complicated that won't still be the case
*/
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

reg [9:0] verticalCount;//the new buffer swap system relies on these
reg [10:0] horizontalCount;
reg HSYNC, VSYNC;

//assign maxVramAddress = 20'h4b000; //640 * 480 = 307200d or 4b000h
assign maxVramAddress = 20'h34;

wire isa_ctrl_out_en;
wire almostFull;
wire frameEnd;
//assign isa_ctrl_out_en = ~(~ADS_OE & isaAddressBus >= 20'h420 & isaAddressBus <= 20'h430 & (~IOR | ~IOW));
assign isa_ctrl_out_en = ~(/*FPGA_IO_EN & */isaAddressBus >= 20'h420 & isaAddressBus <= 20'h430 & (~IOR | ~IOW | FPGA_IO_EN) & ~BALE);//isa_slave_controller_new needs this instead
wire alreadyDidHsyncReset;
reg evenOrOdd;

wire DATA_OUTPUT_ENABLE, ADDRESS_OUTPUT_ENABLE; //the same tristate enable conditions as in fpga_videocard.v
//assign DATA_OUTPUT_ENABLE = (~ADS_OE & FPGA_WR & ~write_en);
assign DATA_OUTPUT_ENABLE = (FPGA_IO_EN & FPGA_WR & actualBusCycle/* & ~write_en*/);//isa_slave_controller_new needs this instead
assign ADDRESS_OUTPUT_ENABLE = ADS_OE;
localparam CLK_PERIOD = 8;
always #(CLK_PERIOD/2) clk=~clk;

//bram_256x16 testram(dataIn, write_en, waddr, clk, raddr, clk, dataOut);
//psuedofiforam testfifo(vramDataBus, write_en, read_en, ~clk, pixelClock, dataOut, (rst_n & ~frameEnd), full, empty, valid, almostFull);

//psuedofiforam_new testfifo(vramDataBus, write_en, read_en, ~clk, pixelClock, dataOut, (rst_n & ~frameEnd), full, empty, valid, almostFull);


managedVramDataBufferCompositeBankSwap testramthingy(vramDataBus, Ri, Gi, Bi, RD, CE, clk, actualBusCycle | undecidedIsaCycle, vblank, empty, full, 
valid, write_en, read_en, genVramAddress, maxVramAddress, rst_n, pixelClock, frameEnd, HSYNC,
VSYNC, evenOrOdd, alreadyDidHsyncReset, vblank
);
                                                                                //use ADS_OE for bus free? it's either doing an isa transfer for a fpga <=> vram transfer basically
wire[15:0] isaDataOut;
reg[19:0] isaAddressBus;
wire FPGA_IO_EN;
reg SBHE, BALE, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISA_CLK;
wire IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH;
wire ISADONE;
wire TE0, TE1, TE2, TE3, FPGA_WR, actualBusCycle, undecidedIsaCycle;
isaSlaveBusController isathing(/*vramDataBus, isaDataOut,*/ isaAddressBus, FPGA_IO_EN, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISA_CLK, ISADONE, TE0, TE1, TE2, TE3, FPGA_WR, clk, actualBusCycle, rst_n, 1'h1, undecidedIsaCycle);

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
    BALE=1;//uncomment this for normal test
    SBHE=0;
    isaAddressBus=20'h420;
    #30
    ISA_CLK=1;
    BALE=0;
    //IOW=0;
    //IOR=0;    //uncomment this for a sooner than usual IO cycle test
    #30
    ISA_CLK=0;
    IOR=0;//uncomment this for normal test
    #30
    ISA_CLK=1;
    //IOW=0;
    #30
    ISA_CLK=0;
    //IOW=0;
    #30
    ISA_CLK=1;
    //MEMW=1;
    IOR=1;
    //BALE=0;
    #30
    ISA_CLK=0;
    #30
    ISA_CLK=1;
    IOW=1;
    //BALE=0;
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
    HSYNC=1;
    VSYNC=1;
    evenOrOdd=0;
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
    vblank=1;     //uncomment to test ISA cycles during vblank transition periods, comment out for a normal isa cycle test
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    HSYNC=0;      //uncomment to test ISA cycles during vblank transition periods, comment out for a normal isa cycle test
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    #10
    pixelClock = 0;
    evenOrOdd=1;
    HSYNC=1;      //uncomment to test ISA cycles during vblank transition periods, comment out for a normal isa cycle test
    #10
    pixelClock = 1;
    vblank=1;     //uncomment to test ISA cycles during vblank transition periods, comment out for a normal isa cycle test
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
    HSYNC=0;
    #10
    pixelClock = 0;
    #10
    pixelClock = 1;
    HSYNC=1;
    #10
    pixelClock = 0;
    evenOrOdd=0;
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

//I saw this on the internet one time, maybe it'll work
/*module prob1(input wire a,b,c,d, output wire out);
    assign out = (a||d)&&(!d&&b&&c);
endmodule

module prob1_tb();
    reg a,b,c,d;
    wire out;

    prob1 prob1_test(a,b,c,d, out);

    initial begin
        $monitor(a,b,c,d,out);
        for (int i=0; i<16; i=i+1) begin
            {a,b,c,d} = i;
            #1;
        end
    end
endmodule*/