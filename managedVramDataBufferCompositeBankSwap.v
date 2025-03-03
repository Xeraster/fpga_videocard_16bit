/*
THis is better than the fifo buffering method

This swaps between 2 bram blocks where they switch between read only or write only on each horizontal line, (hopefully) bypassing clock domain bugs update: switching to this system didn't solve any issues but at least its more performant

It also doesn't need an external fifo block

the only disadvantage of this method is that is uses more memory.

an ice 40 hx4k has 80 "RAM4K RAM bits"

640 * 16 = 10240, 1024 * 8 = 8192 and 1024 * 16 = 16384.

640x480x16 with dual hsync buffers = 20480 bits
1024x768x8 with dual hsync buffers = 16384 bits
1024x768x16 with dual hsync buffers = 32786 bits

assuming these are the same bits that th ice 40 hx4k has 80000 of, and assuming that this memory is only used by block ram, it SHOULD work

The amount of block ram bits used up by this so far before implenting this hack is exactly: ¯\_(ツ)_/¯

*/
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

module bram_1024x16(din, write_en, waddr, wclk, raddr, rclk, dout, read_en);//256x16
parameter addr_width = 10;      //fun fact: 2 to the power of 10 is the same number you can count to on your fingers if you do it in base 2
parameter data_width = 16;
input [addr_width-1:0] waddr, raddr;
input [data_width-1:0] din;
input write_en, wclk, rclk, read_en;
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
    if (read_en) begin
        dout <= mem[raddr]; // Using read address bus.
    end
end
endmodule

module managedVramDataBufferCompositeBankSwap(
    input[15:0] dataInputBus,       //the input from vram during buffer fill cycles
    //output[15:0] dataBusOutput,     //the output for the vga signal. i think. output whatever is in the fifo buffer for being drawn to the screen
    output[4:0] Ri,
    output[5:0] Gi,
    output[4:0] Bi,
    output readSignal,              //CY7C1049 series sram chip RD and CE. Shoot for single-clock address transition controlled read cycles.
    output chipEnable,              //CY7C1049 chip enable
    input clock,                    //what clock to run this on. to avoid the most issues, it needs to be a pll output of the pixel clock.
    input bus_free,                 //0 if the bus isn't being used by something. 1 if the bus is currently being used by something
    input vblank,                   //0 if there is supposed to be a vblank (no new pixels being copied to screen). 1 if there is supposed to be pixel data sent to the screen. needs to be asserted exactly 2 pixelClock cycles before color data is supposed to be on the bus
    output empty,                    //1 if the fifo buffer is empty
    output full,                     //1 if the fifo buffer is full, 0 if not full
    output valid,                    //1 if the fifo buffer contains at least 1 word of valid data, 0 if the only data it can output is invalid
    output fifoWrite,               //1 when writing to fifo, 0 when not writing. not important anymore but preserved to make hardware debugging easier
    output fifoRead,                //1 when reading from fifo, 0 when not reading. not important anymore but preserved to make hardware debugging easier
    output[19:0] nextVramAddress,   //the address of whatever the next byte in vram this thing wants to load is
    input[19:0] maxVramAddress,     //the vram address at which to rollover to 0
    input RESET,
    input pixelClock,               //use the pixel clock to determine when to go to the next byte
    output frameEnd,                 //1 if this module thinks its on or beyond the last vram address for the current frame. 0 if this module thinks its in the correct vram address
    input HSYNC,                    //use hsync to swap between blocks. keep it simple stupid. only HSYNC is needed for now. hopefully
    input VSYNC,                     //try using vsync signal to correct timing issues
    input evenOrOdd,               //debugging port because this fucking bullshit is easier to test on hardware than it is on testbench
    output debugalreadyDidHsyncReset,
    input vblank_pixelDomian         //vblank but generated from the pixelclock clock domain
);

    //assign debugevenOrOdd = evenOrOdd;
    //assign debugalreadyDidHsyncReset = alreadyDidHsyncReset;
    //assign debugalreadyDidHsyncReset = delayBeforeWriteAgain > 0;
    assign debugalreadyDidHsyncReset = raddr[0];

    reg ireadSignal, ichipEnable, ififoWrite, ififoRead;
    reg[19:0] iNextVramAddress;
    reg[15:0] iDataFromVram;
    reg[15:0] ipixelOutput;
    reg[19:0] pixelClockAddress;//the pixel clock address this module thinks its on

    assign readSignal = ireadSignal;
    assign chipEnable = ichipEnable;
    assign fifoWrite = ififoWrite;
    assign fifoRead = ififoRead;
    //assign dataBusOutput = ipixelOutput;
    assign nextVramAddress = iNextVramAddress;
    //assign done = 0;

    assign Ri[0] = ipixelOutput[11];
    assign Ri[1] = ipixelOutput[12];
    assign Ri[2] = ipixelOutput[13];
    assign Ri[3] = ipixelOutput[14];
    assign Ri[4] = ipixelOutput[15];

    assign Gi[0] = ipixelOutput[5];
    assign Gi[1] = ipixelOutput[6];
    assign Gi[2] = ipixelOutput[7];
    assign Gi[3] = ipixelOutput[8];
    assign Gi[4] = ipixelOutput[9];
    assign Gi[5] = ipixelOutput[10];

    assign Bi[0] = ipixelOutput[0];
    assign Bi[1] = ipixelOutput[1];
    assign Bi[2] = ipixelOutput[2];
    assign Bi[3] = ipixelOutput[3];
    assign Bi[4] = ipixelOutput[4];
    reg iframeEnd;
    reg fastFrameEnd;
    assign frameEnd = iframeEnd;

    //reg evenOrOdd;//WHEN evenOrOdd IS 1, READ FROM B1 AND WRITE TO B2. WHEN evenOrOdd IS 0, READ FROM B2 AND WRITE TO B1. STAMP THIS COMMENT EVERYWHERE BECAUSE ITS IMPORTANT
    reg[9:0] waddr;//2^10 = 1024
    reg[9:0] raddr;//2^10 = 1024


    //on every rising edge of the pixel clock, get the next byte
    always@(posedge pixelClock)
    begin
        if (!RESET) begin
            //pixelClockAddress <= 0;
            ipixelOutput <= 16'h0;//data. not address. stop trying to reset it to 0xFFFFE. its not going to fix whatever problem you're having
            ififoRead <= 0;
            iframeEnd <= 0;
            raddr <= 0;
        end else if (vblank_pixelDomian) begin//if vblank == 1, there is supposed to be data copied to the screen
            //ipixelOutput <= fifoDataOut;

            //WHEN evenOrOdd IS 1, READ FROM B1 AND WRITE TO B2. WHEN evenOrOdd IS 0, READ FROM B2 AND WRITE TO B1. STAMP THIS COMMENT EVERYWHERE BECAUSE ITS IMPORTANT
            if (evenOrOdd) begin
                ipixelOutput <= b1dout;
                //ipixelOutput <= 16'h1F;
                //ipixelOutput <= 16'hFFFF;
            end else begin
                ipixelOutput <= b2dout;
                //ipixelOutput <= 16'hFFFF;
            end

            //ipixelOutput <= ipixelOutput + 1;

            //pixelClockAddress <= pixelClockAddress + 2;
            ififoRead <= 1;
            iframeEnd <= 0;
            raddr <= raddr + 1;
        end else begin
            ipixelOutput <= 16'h0;
            raddr <= 0;
            ififoRead <= 0;

            /*if (iframeEnd) begin
                pixelClockAddress <= 0;
            end*/

            if (!VSYNC/* & maxVramAddress <= pixelClockAddress*/) begin
                iframeEnd <= 1;
                //pixelClockAddress <= 20'h0;
            end
            
            /* else begin
                iframeEnd <= 0;
            end*/
            /* else if (vblank) begin
                iframeEnd <= 0;
            end*/
        end

        //has to happen on pixelClock to despite slower speeds because clock domains

    end

    /*always@(negedge pixelClock) begin
        if (!RESET) begin
            raddr <= 0;
        end else if (vblank) begin
            raddr <= raddr + 1;
        end else begin
            raddr <= 0;
        end
    end*/

    //WHEN evenOrOdd IS 1, READ FROM B1 AND WRITE TO B2. WHEN evenOrOdd IS 0, READ FROM B2 AND WRITE TO B1. STAMP THIS COMMENT EVERYWHERE BECAUSE ITS IMPORTANT
    /*always@(negedge HSYNC)
    //goddammit i have to emulate this
    begin
        if (!RESET) begin
            evenOrOdd <= 0;//START ON 0 - read from 
        end else if (iframeEnd) begin
            evenOrOdd <= 0;
        end else begin
            evenOrOdd <= ~evenOrOdd;
        end
    end*/

    //reg alreadyDidHsyncReset;
    reg[2:0] delayBeforeWriteAgain;//maybe if I insert a bit of a delay before writing after non-writeable cycles, it will eliminate the wobble
    assign full = waddr >= 639;//it copies 2 bytes per clock cycle but it displays 2 bytes per pixel so it cancels out
    reg fastEvenOrOdd, fastVblank;
    reg r1_Pulse, r2_Pulse, r3_Pulse;

    reg alreadySubtracted;
    reg bugFix;

    always@(posedge clock)
    begin
        //using this results in fewer undefined pixels in software testbench
        if (delayBeforeWriteAgain > 0) begin
            delayBeforeWriteAgain <= delayBeforeWriteAgain - 1;
        end

        r1_Pulse <= pixelClock;
        r2_Pulse <= r1_Pulse;
        r3_Pulse <= r2_Pulse;
        if (~r3_Pulse & r2_Pulse) begin
            fastEvenOrOdd <= evenOrOdd;
            fastVblank <= vblank;
            fastFrameEnd <= iframeEnd;
        end else if (r3_Pulse & ~r2_Pulse) begin
            //fastEvenOrOdd <= evenOrOdd;
        end
        
        //WHEN evenOrOdd IS 1, READ FROM B1 AND WRITE TO B2. WHEN evenOrOdd IS 0, READ FROM B2 AND WRITE TO B1. STAMP THIS COMMENT EVERYWHERE BECAUSE ITS IMPORTANT
        /*if (!RESET) begin
            alreadyDidHsyncReset <= 0;
            evenOrOdd <= 0;
        end else if (~HSYNC & ~alreadyDidHsyncReset) begin
            alreadyDidHsyncReset <= 1;
            if (iframeEnd) begin
                evenOrOdd <= 0;
            end else begin
                evenOrOdd <= ~evenOrOdd;
            end
        end else if (HSYNC) begin
            alreadyDidHsyncReset <= 0;
        end*/

        if (!RESET) begin
            bugFix <= 0;
            alreadySubtracted <= 1;
            delayBeforeWriteAgain <= 0;
            iNextVramAddress <= 20'h0;//this is how to ensure the first valid cycle is starts the vram address at 0 and not 1
            //actually for testing purposes start it at 0

            ireadSignal <= 1;           //DO NOT TOUCH THIS
            ichipEnable <= 1;           //DO NOT TOUCH THIS
            ififoWrite <= 1;
            waddr <= 0;
        end else if (fastFrameEnd) begin //if the buffer is not completely full, try to make it full
            bugFix <= 0;
            ireadSignal <= 1;           //DO NOT TOUCH THIS
            ichipEnable <= 1;           //DO NOT TOUCH THIS
            ififoWrite <= 1;
            iNextVramAddress <= 20'h0;
            waddr <= 0;
            delayBeforeWriteAgain <= 10;//fastclk cycles will probably do the trick
            alreadySubtracted <= 1;
        end else if (~vblank) begin //if vblank is zero and therefore not supposed to have stuff on the screen, reset the waddr pointer but not the vram address
            bugFix <= 0;
            ireadSignal <= 1;           //DO NOT TOUCH THIS
            ichipEnable <= 1;           //DO NOT TOUCH THIS
            ififoWrite <= 1;
            waddr <= 0;
            delayBeforeWriteAgain <= 10;
            //iNextVramAddress <= 20'h0;
            if (~alreadySubtracted) begin
                alreadySubtracted <= 1;
                iNextVramAddress <= iNextVramAddress + 2;
            end
        end else if (~full & ~bus_free)  //bus free is active low. 0 = bus not being used
        begin
            bugFix <= 0;
            //get the byte from vram
            //ireadSignal <= 0;           //DO NOT TOUCH THIS
            //ichipEnable <= 0;           //DO NOT TOUCH THIS
            //ififoWrite <= 1;

            if (delayBeforeWriteAgain > 1) begin
                ireadSignal <= 1;           //DO NOT TOUCH THIS
                ichipEnable <= 1;           //DO NOT TOUCH THIS
                ififoWrite <= 0;
            end else begin
                ireadSignal <= 0;           //DO NOT TOUCH THIS
                ichipEnable <= 0;           //DO NOT TOUCH THIS
                ififoWrite <= 1;
            end

            if (delayBeforeWriteAgain < 1) begin
                iNextVramAddress <= iNextVramAddress + 2;
                waddr <= waddr + 1;
                alreadySubtracted <= 0;
            end

            /*if (iNextVramAddress >= maxVramAddress) begin
                iNextVramAddress <= 0;
            end*/
        end else begin
            ireadSignal <= 1;
            ichipEnable <= 1;
            ififoWrite <= 0;
            delayBeforeWriteAgain <= 4;

            /*if (~bugFix) begin
                bugFix <= 1;
                if (waddr > 1) begin    //don't bother with the stupid bugfix if it will result in waddr rolling over
                    waddr <= waddr - 1;
                    iNextVramAddress <= iNextVramAddress - 2;
                end
            end*/

            //if this is happening, it's probably because of a ADS_OE cycle so backpedel on the counter and write address a little

            /*if (~full & ~alreadySubtracted) begin
                alreadySubtracted <= 1;
                iNextVramAddress <= iNextVramAddress - 2;
                waddr <= waddr - 1;
            end*/
        end
    end

    //WHEN evenOrOdd IS 1, READ FROM B1 AND WRITE TO B2. WHEN evenOrOdd IS 0, READ FROM B2 AND WRITE TO B1. STAMP THIS COMMENT EVERYWHERE BECAUSE ITS IMPORTANT
    wire[15:0] b1dout;
    wire[15:0] b2dout;

    //wire[15:0] testInputFuck1;
    //wire[15:0] testInputFuck2;
    //assign testInputFuck1 = 16'hFFFF;
    //assign testInputFuck2 = 16'h1F;
    //block 1. write on even horizontal line numbers. read on odd horizontal line numbers
    bram_1024x16 b1(dataInputBus, ififoWrite & ~fastEvenOrOdd, waddr, clock/*writes happen on falling edge of the fast clock*/, raddr, pixelClock, b1dout, ififoRead);

    //block 2. write on odd horizontal line numbers. read on even horizontal line numbers
    bram_1024x16 b2(dataInputBus, ififoWrite & fastEvenOrOdd, waddr, clock, raddr, pixelClock, b2dout, ififoRead);

endmodule