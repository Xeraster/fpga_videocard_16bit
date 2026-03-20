`include "../writeBufferVram_different.v"
`include "../isa_f_slave_controller.v"
`include "../managedVramDataBufferCompositeBankSwap.v"
// https://www.fpga4student.com/2017/08/verilog-code-for-clock-divider-on-fpga.html
// fpga4student.com: FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA
module clockDividerX3(input clock_in, output reg clock_out);
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd3;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;

 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;

end
endmodule

//generate a 640x480 vga sync signal. don't use this anymore, this was only for the icestick experiment
module generateSync(
    input clock,
    output HSYNCo,
    output VSYNCo,
    output reg [19:0] vramAddress,
    input RESET,                 //gotta tell those counters when to reset to zero
    output reg VALID_PIXELS,             //its a 1 if there is allowed to be data on R,G,B
    output reg[10:0] horizontalCount,
    output reg[9:0] verticalCount 
);

reg HSYNC, VSYNC;
assign HSYNCo = HSYNC;
assign VSYNCo = VSYNC;
    //reg [10:0] horizontalCount;
    //reg [9:0] verticalCount;
    reg VALID_H;                    //1 if in valid horizontal viewing area. 0 if otherwise 
    reg VALID_V;                    //1 if in valid veritcal viewing area. 0 if otherwise
    always@(posedge clock or negedge RESET)
    begin
        if (!RESET)
        begin
            horizontalCount <= 0;
            verticalCount <= 0;
            vramAddress <= 0;
        end
        else begin
        //increment h counter
        horizontalCount <= horizontalCount + 1;

        //horizontal counter cases
        if (horizontalCount >= 640 & horizontalCount < 656)
            begin
                //front porch
                VALID_H <= 0;
                HSYNC <= 1;
            end
        else if (horizontalCount >= 656 & horizontalCount < 752)
            begin
                //when hsync happens
                VALID_H <= 0;
                HSYNC <= 0;
            end
        else if (horizontalCount >= 752 & horizontalCount < 799)
            begin
                //back porch
                HSYNC <= 1;
                VALID_H <= 0;
            end
        else if (horizontalCount >= 799)
            begin
                //the reset pixel
                verticalCount <= verticalCount + 1;
                horizontalCount <= 0;
                HSYNC <= 1;
                VALID_H <= 0;//was 1 for some reason
            end
        else
            begin
                //this should only be happening if within visible screen area
                HSYNC <= 1;
                VALID_H <= 1;
                vramAddress <= vramAddress + 2;
            end

        if (verticalCount >= 480 & verticalCount < 490)
            begin
                //front porch
                VALID_V <= 0;
                VSYNC <= 1;
            end
        else if (verticalCount >= 490 & verticalCount < 492)
            begin
                //vsync signal
                VALID_V <= 0;
                VSYNC <= 0;
            end
        else if (verticalCount >= 492 & verticalCount < 525)
            begin
                //back porch
                VALID_V <= 0;
                VSYNC <= 1;
            end
        else if (verticalCount >= 525)
            begin
                //the reset pixel
                VALID_V <= 0;
                VSYNC <= 1;
                verticalCount <= 0;
                vramAddress <= 0;
            end
        else
            begin
                //this should only be happening if within visible screen area
                VALID_V <= 1;
                VSYNC <= 1;
            end

        //set the value of the valid pixel signal. only draw pixels if h and v are within a valid range
        VALID_PIXELS <= VALID_H & VALID_V;
        end

    end

endmodule

//draws a 16 bit test pattern. works flawlessly on the current hardware
module advancedTestPattern(
    input [19:0] vramAddress,
    output reg[4:0] R,  //0-31.
    output reg[5:0] G,  //0-63
    output reg[4:0] B,  //0-31
    input HSYNC,
    input VSYNC,
    input clock,
    input VALID_SCREEN,
    input [10:0] horizontalPos,
    input [9:0] verticalPos
);

    always@(posedge clock)
    begin
        if (!VALID_SCREEN)
            begin
                //don't output color data when off the screen
                R <= 0;
                G <= 0;
                B <= 0;
            end
        else if (vramAddress > 512000)//was 256000
            begin
                //R <= 31;
                //G <= 0;
                //B <= 31;
                if (horizontalPos > 512 & horizontalPos < 576)
                begin
                    //do white
                    R <= 31;
                    G <= 63;
                    B <= 31;
                end else if (horizontalPos > 575)
                begin
                    //do black
                    R <= 0;
                    G <= 0;
                    B <= 0;
                end else begin
                    R <= 0;
                    G <= 0;
                    //B <= 31;
                    B[0] <= horizontalPos[4];
                    B[1] <= horizontalPos[5];
                    B[2] <= horizontalPos[6];
                    B[3] <= horizontalPos[7];
                    B[4] <= horizontalPos[8];
                end
            end
        else if (vramAddress > 409600)//was 204800
            begin
                if (horizontalPos > 512 & horizontalPos < 640)
                begin
                    R[0] <= horizontalPos[2];
                    R[1] <= horizontalPos[3];
                    R[2] <= horizontalPos[4];
                    R[3] <= horizontalPos[5];
                    R[4] <= horizontalPos[6];   

                    G[0] <= 0;
                    G[1] <= horizontalPos[2];
                    G[2] <= horizontalPos[3];
                    G[3] <= horizontalPos[4];
                    G[4] <= horizontalPos[5];
                    G[5] <= horizontalPos[6];

                    B[0] <= horizontalPos[2];
                    B[1] <= horizontalPos[3];
                    B[2] <= horizontalPos[4];
                    B[3] <= horizontalPos[5];
                    B[4] <= horizontalPos[6];
                end else begin
                    //R <= 0;
                    //G <= 0;
                    //B <= 31;
                    R <= 0;
                    //G <= 0;
                    B <= 0;
                    G[0] <= horizontalPos[3];
                    G[1] <= horizontalPos[4];
                    G[2] <= horizontalPos[5];
                    G[3] <= horizontalPos[6];
                    G[4] <= horizontalPos[7];
                    G[5] <= horizontalPos[8];
                    //G[3] <= 0;
                    //G[4] <= 0;
                    //G[5] <= 0;
                end
            end
        else if (vramAddress > 307200)//was 153600
            begin
                //R <= 0;
                //G <= 63;
                //B <= 31;
                //R <= 0;
                if (horizontalPos > 512 & horizontalPos < 640)
                begin
                    R[0] <= horizontalPos[2];
                    R[1] <= horizontalPos[3];
                    R[2] <= horizontalPos[4];
                    R[3] <= horizontalPos[5];
                    R[4] <= horizontalPos[6];

                    G[0] <= 0;
                    G[1] <= horizontalPos[2];
                    G[2] <= horizontalPos[3];
                    G[3] <= horizontalPos[4];
                    G[4] <= horizontalPos[5];
                    G[5] <= horizontalPos[6];

                    B[0] <= horizontalPos[2];
                    B[1] <= horizontalPos[3];
                    B[2] <= horizontalPos[4];
                    B[3] <= horizontalPos[5];
                    B[4] <= horizontalPos[6];
                end else begin
                    G <= 0;
                    B <= 0;
                    R[0] <= horizontalPos[4];
                    R[1] <= horizontalPos[5];
                    R[2] <= horizontalPos[6];
                    R[3] <= horizontalPos[7];
                    R[4] <= horizontalPos[8];
                end
            end
        /*else if (vramAddress > 102400)
            begin
                R <= 0;
                G <= 63;
                B <= 0;
                //R <= 0;
                //G <= 0;
                //B <= 12;
            end
        else if (vramAddress > 51200)
            begin
                R <= 31;
                G <= 63;
                B <= 0;
                //R <= 0;
                //G <= 0;
                //B <= 4;
            end*/
        else
            begin
                //iterate through all of the 65535 different colors in the upper half section of the screen
                R[0] <= vramAddress[1];
                R[1] <= vramAddress[2];
                R[2] <= vramAddress[3];
                R[3] <= vramAddress[4];
                R[4] <= vramAddress[5];

                G[0] <= vramAddress[6];
                G[1] <= vramAddress[7];
                G[2] <= vramAddress[8];
                G[3] <= vramAddress[9];
                G[4] <= vramAddress[10];
                G[5] <= vramAddress[11];

                B[0] <= vramAddress[12];
                B[1] <= vramAddress[13];
                B[2] <= vramAddress[14];
                B[3] <= vramAddress[15];
                B[4] <= vramAddress[16];
            end
    end

endmodule

module video(
    output HSYNC, 
    output VSYNC, 
    input pllclk, 
    output[4:0] Red, 
    output[5:0] Green, 
    output[4:0] Blue, 
    input RESET, 
    output[10:0] horizontalCount, 
    output[9:0] verticalCount, 
    output VALID_PIXELS,
    output pixelClock,

    //ISA bus-specific signals
    input BALE,
    input MEMW, MEMR, SMEMR, SMEMW, IOW, IOR, SBHE,
    output NOWS, IOCS16, MEMCS16, IO_RDY, IOERR,
    input ISACLK,

    //bus tranciever signals
    output TE0, TE1, TE2, TE3,      //bus tranciever enable signals, rtfm for more info
    output FPGA_WR,                 //write direction pin for the 74lvc16245 trancievers

    //address latch chip signals
    output ADS_OE, ADS_LATCH,

    //sram signals
    output VRAM_en,
    output write_cmd,
    output read_cmd,

    //sram bus signals. they have to be simulated because there isn't inout or tristate in Verilator (or at least chatgpt says so)
    output[19:0] AV,   //video card address bus
    input[19:0] AV_in,  //whenever the host accesses the video card, use this one for address bus input
    output[15:0] data_out,
    input[15:0] data_in,
    output FPGA_IO_EN,
    output isa_ctrl_out_en
    );

clockDividerX3 cdd(pllclk, pixelClock);
assign isa_ctrl_out_en = ~(lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430 & (~IOR | ~IOW | FPGA_IO_EN) & ~BALE);//isa_slave_controller_new needs this instead
//assign c = a & b;
//assign Ri = 4'hF;
//assign Gi = 5'h1F;
//assign Bi = 4'hF;
wire[19:0] vramAddress;
//wire VALID_PIXELS;
//wire[10:0] horizontalCount;
//wire[9:0] verticalCount;
reg[4:0] Rt;
reg[5:0] Gt;
reg[4:0] Bt;

reg[4:0] Ri;
reg[5:0] Gi;
reg[4:0] Bi;

reg[4:0] iRed;
reg[5:0] iGreen;
reg[4:0] iBlue;
assign Red = iRed;
assign Green = iGreen;
assign Blue = iBlue;

assign AV = AVi;
assign data_out = data_outi;
reg[19:0] AVi;
reg[15:0] data_outi;

wire vblank;//0 if there is supposed to be a vblank (no new pixels being copied to screen). 1 if there is supposed to be pixel data sent to the screen. needs to be asserted exactly 2 pixelClock cycles before color data is supposed to be on the bus
reg ivblank;
assign vblank = ivblank;

generateSync gs(pixelClock, HSYNC, VSYNC, vramAddress, RESET, VALID_PIXELS, horizontalCount, verticalCount);
advancedTestPattern atp(vramAddress, Rt, Gt, Bt, HSYNC, VSYNC, pixelClock, VALID_PIXELS, horizontalCount, verticalCount);


reg[15:0] vramBankRegister; //register 0x420
reg[7:0] videoDisplayRegister;
reg[7:0] settingsRegister;  //register 0x423 settings register
reg[7:0] statusRegister;    //register 0x426 status register
reg[23:0] addressComReg;//combined address register maybe that will work
reg[15:0] nextThingToWrite;
reg alreadyIncrementedAdsPtr;

//basically, whenever the composite bank swap buffer for the current frame is full, spend that time copying data to vram
wire[15:0] writeBufferVramData;
wire[19:0] writeBufferVramAddress;
wire vbuf_WE, vbuf_CE, WRITEBUF_IO_EN;
wire writeBufferFull, writeBufferAlmostFull, writeBufferEmpty;
writeBufferVram wbv(nextThingToWrite, addressComReg[19:0], pllclk, doData, writeBufferVramData, writeBufferVramAddress, vbuf_WE, vbuf_CE, full & !FPGA_IO_EN & !undecidedIsaCycle, pllclk, RESET, WRITEBUF_IO_EN, writeBufferFull, writeBufferAlmostFull, writeBufferEmpty);

reg numTimesWrittenTo;//workaround hack for a open collector vs totem pole issue. ugh
reg gtfoonnextclock;
reg doData;
wire empty, full, fifovalid;//fifo status bits
reg[7:0] alreadyWrote;//deal with write cycle unreliability by only respecting 1 single write per isa write cycle

reg syncBale;
reg b1_Pulse, b2_Pulse, b3_Pulse;
reg iread_cmd, iwrite_cmd, iVRAM_en;
assign VRAM_en = iVRAM_en;
assign read_cmd = iread_cmd;
assign write_cmd = iwrite_cmd;
reg CE, OE;    //vram signal outputs

//reg FPGA_IO_EN;//goes high anytime an isa bus cycle is happening that is addressing this card
wire ISADONE, actualBusCycle, undecidedIsaCycle;
isaSlaveBusController isathing(AV_in, FPGA_IO_EN, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, 
    MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISACLK, ISADONE, 
    TE0, TE1, TE2, TE3, FPGA_WR, pllclk/*FASTCLK*/, actualBusCycle, RESET, 1'h0, undecidedIsaCycle);

//do stuff on the edge of the fast clock
reg[15:0] DStxresult;

//shit for the managedVramDataBufferCompositeBankSwap
wire write_en, read_en;
wire[19:0] maxVramAddress;
wire [19:0] bufferRequestedAddress;
reg [19:0] lastAdsRequest;
assign maxVramAddress = 20'h96000;
wire frameEnd;
wire almostFull;
wire evenOrOdd;
wire alreadyDidHsyncReset;

reg vsyncctr;
always@(negedge HSYNC) begin
    vsyncctr <= ~vsyncctr;
end

//managedVramDataBufferCompositeBankSwap testramthingy(data_in, Ri, Gi, Bi, OE, CE, pllclk/*FASTCLK*/, actualBusCycle | undecidedIsaCycle | ~ADS_OE, 
//    /*VALID_PIXELS*/ivblank, empty, full, fifovalid, write_en, read_en, bufferRequestedAddress, maxVramAddress, RESET, pixelClock, 
//    frameEnd, HSYNC, VSYNC, vsyncctr/*verticalCount[0]*/, alreadyDidHsyncReset, VALID_PIXELS);

managedVramDataBufferCompositeBankSwap testramthingy(data_in, Ri, Gi, Bi, OE, CE, pllclk/*FASTCLK*/, actualBusCycle | undecidedIsaCycle | ~ADS_OE | BALE, 
    /*VALID_PIXELS*/ivblank, empty, full, fifovalid, write_en, read_en, bufferRequestedAddress, maxVramAddress, RESET, pixelClock, 
    frameEnd, HSYNC, VSYNC, vsyncctr/*verticalCount[0]*/, alreadyDidHsyncReset, VALID_PIXELS);

always@(posedge pllclk) begin
    b1_Pulse <= BALE;
    b2_Pulse <= b1_Pulse;
    b3_Pulse <= b2_Pulse;

    if (~b3_Pulse & b2_Pulse) begin
        syncBale <= 1;
    end else if (b3_Pulse & ~b2_Pulse) begin
        syncBale <= 0;
    end

    if (~ADS_OE) begin
        lastAdsRequest <= AV_in;
    end

    ivblank <= VALID_PIXELS;

    //everything below this line needs to be fixed to work with this simulation
    if (!settingsRegister[4])   //if bit 5 of settings register 0x423 is 0, do the test pattern instead of displaying vram
        begin
            
        //iVRAM_low_en <= 1;
        //iVRAM_high_en <= 1;

        //iVRAM_en <= 1;
        //iread_cmd <= 1;
        //iwrite_cmd <= 1;
        //data_outi <= DStxresult;//fix a bug where data outputs dont work if the test pattern is enabled.        
        

        iRed <= Rt;
        iGreen <= Gt;
        iBlue <= Bt;
    end else begin
        //Red = 4'h15;
        //Green = 5'h0;
        //Blue = 4'h15;

        iRed <= Ri;
        iGreen <= Gi;
        iBlue <= Bi;

        if (WRITEBUF_IO_EN) begin
            //if there is no more pixel buffer copying to do (and there is no relevant isa bus cycle happening), start processing write buffer data and writing it to the screen
            //iVRAM_low_en <= vbuf_CE;
            //iVRAM_high_en <= vbuf_CE;

            iVRAM_en <= vbuf_CE;
            iwrite_cmd <= vbuf_WE;
            iread_cmd <= 1;

            AVi <= writeBufferVramAddress;
            data_outi <= writeBufferVramData;

            //debugDataOut <= 0;
        //end else if (/*!FPGA_IO_EN & !undecidedIsaCycle*/~actualBusCycle & ~undecidedIsaCycle & ~BALE & ADS_OE) begin
        end else if (~actualBusCycle & ~undecidedIsaCycle & ~BALE & ADS_OE) begin
            //if there is no relevant isa bus cycle happening, relay the signals to the vram chips for copying stuff into the buffer
            //iVRAM_low_en <= CE;
            //iVRAM_high_en <= CE;

            iVRAM_en <= CE;
            iread_cmd <= OE;
            iwrite_cmd <= 1;
            AVi <= bufferRequestedAddress;
            data_outi <= DStxresult;

            //debugDataOut <= 1;
        end else begin
            //explicitly set this stuff to 1, disabling it all in invalid states. it didn't solve any bugs or artifacts but this seems like a good thing to do
            //iVRAM_low_en <= 1;
            //iVRAM_high_en <= 1;

            iVRAM_en <= 1;
            iread_cmd <= 1;
            iwrite_cmd <= 1;
            AVi <= bufferRequestedAddress;
            data_outi <= DStxresult;

            //debugDataOut <= 1;
        end
    end

end


/*reg [1:0] vram_owner;
always @(*) begin
    if (WRITEBUF_IO_EN & settingsRegister[4]) begin
        vram_owner = 2'd0;
        iVRAM_en = vbuf_CE;
        iwrite_cmd = vbuf_WE;
        iread_cmd = 1;

        AVi = writeBufferVramAddress;
        data_outi = writeBufferVramData;
    end else if (~actualBusCycle & ~undecidedIsaCycle & ~BALE & ADS_OE & settingsRegister[4]) begin
        vram_owner = 2'd1;
        iVRAM_en = CE;
        iread_cmd = OE;
        iwrite_cmd = 1;
        AVi = bufferRequestedAddress;
        data_outi = DStxresult;
    end else begin
        vram_owner = 2'd2;
        iVRAM_en = 1;
        iread_cmd = 1;
        iwrite_cmd = 1;
        AVi = bufferRequestedAddress;
        data_outi = DStxresult;
    end
end*/

//the other pllclk logic loop. this one is generally for things having to do with the isa bus and isa cycles
always@(posedge pllclk) begin
  //make it possible to find out if the write buffer is full or empty
    statusRegister[7] <= vblank;
    statusRegister[6] <= full;
    statusRegister[5] <= writeBufferFull;//bit 5: input buffer full. 0 if not full. 1 if full
    statusRegister[4] <= writeBufferAlmostFull;//welp, there isn't a way to find if it's *almost* full because of the impossibly intricate architecture of the async fifo buffer. fuck.
    if (!RESET) begin
        videoDisplayRegister <= 8'h18;//b7-4 = 1 for 640x480. bit 3-2 = 2 for 16 bit color.
        settingsRegister <= 8'h70;//tldr 0x60 is for test pattern, 0x70 is for vram display mode.
        statusRegister <= 8'h0;
        alreadyIncrementedAdsPtr <= 0;
        addressComReg <= 0;
        numTimesWrittenTo<=0;
        gtfoonnextclock <= 0;
        doData <= 0;
        alreadyWrote <= 4'h0;
    end else if ((~IOR | ~IOW) & actualBusCycle & alreadyWrote < 20 & ~BALE) begin//only io cycles for now. doesnt make a difference? THATS FUCKING IMPOSSIBLE
        //if (AV_RX == 20'h423) begin
        if (lastAdsRequest == 20'h422) begin
            if (FPGA_WR) begin
                DStxresult[7:0] <= videoDisplayRegister;
            end else begin
                videoDisplayRegister <= data_in[7:0];
                alreadyWrote <= alreadyWrote + 1;
            end
        end else if (lastAdsRequest == 20'h423) begin
            if (FPGA_WR) begin
                //DStxresult[15:8] <= settingsRegister[7:0];
                DStxresult[7:0] <= settingsRegister[7:0];//temporarily modified to work with isa chipsets that dont do 16 bit isa cycles at all
            end else begin
                //settingsRegister[7:0] <= synchronizedDataInput[15:8];
                settingsRegister[7:0] <= data_in[7:0];//temporarily modified to work with isa chipsets that dont do 16 bit isa cycles at all
                alreadyWrote <= alreadyWrote + 1;
            end

            //DStxresult <= 16'hA9A9;
            //deviceBeingSelected <= 1;
            //numTimesWrittenTo<=0;
        end else if (lastAdsRequest == 20'h426) begin
            if (FPGA_WR) begin
                DStxresult[7:0] <= statusRegister;
            end else begin
                statusRegister <= data_in[7:0];
                alreadyWrote <= alreadyWrote + 1;
            end
            //deviceBeingSelected <= 1;
            //numTimesWrittenTo<=0;
        end else if (lastAdsRequest == 20'h428) begin
            if (FPGA_WR) begin
                DStxresult[7:0] <= addressComReg[7:0];
            end else begin
                //addressComReg[7:0] <= DS_RX[7:0];
                //addressComReg[7:0] <= DS_RX[7:0];
                addressComReg[0] <= 0;
                addressComReg[8:1] <= data_in[7:0];
                addressComReg[16:9] <= data_in[15:8];
                alreadyWrote <= alreadyWrote + 1;
            end
            //deviceBeingSelected <= 1;
            //numTimesWrittenTo <= 0;
        end else if (lastAdsRequest == 20'h429) begin
            if (FPGA_WR) begin
                //DStxresult[15:8] <= addressComReg[15:8];
                DStxresult[7:0] <= addressComReg[15:8];
            end else begin
                //addressComReg[16:9] <= DS_RX[15:8];
                addressComReg[16:9] <= data_in[15:8];
                //numTimesWrittenTo <= 0;
                alreadyWrote <= alreadyWrote + 1;
            end
            //deviceBeingSelected <= 1;
        end else if (lastAdsRequest == 20'h42A) begin
            if (FPGA_WR) begin
                DStxresult[7:0] <= addressComReg[23:16];
            end else begin
                //addressComReg[23:16] <= DS_RX[7:0];
                //addressComReg[23:16] <= DS_RX[7:0];
                addressComReg[23:17] <= data_in[6:0];
                //numTimesWrittenTo <= 0;
                alreadyWrote <= alreadyWrote + 1;
            end
            //deviceBeingSelected <= 1;
        end else if (lastAdsRequest == 20'h42C) begin
            if (FPGA_WR) begin
                //DStxresult[15:0] <= nextThingToWrite;
                DStxresult[7:0] <= nextThingToWrite;
            end else begin
                //nextThingToWrite <= DS_RX[15:0];
                nextThingToWrite <= data_in;
                alreadyWrote <= alreadyWrote + 1;
                //nextThingToWrite <= 16'hffff;
                if (~alreadyIncrementedAdsPtr) begin
                    addressComReg <= addressComReg + 2;
                    alreadyIncrementedAdsPtr <= 1;
                    doData <= 1;
                end
                /*if (!alreadyIncrementedAdsPtr & !numTimesWrittenTo) begin
                    //hack so that repeated psuedo 16 bit writes don't get counted as 2 write cycles. just dont do 8 bit writes to this port and it'll be fine
                    addressComReg <= addressComReg + 2;//increment the address pointer for easiness
                    alreadyIncrementedAdsPtr <= 1;
                    numTimesWrittenTo <= 1;
                    doData <= 1;
                end else if (!alreadyIncrementedAdsPtr & numTimesWrittenTo) begin
                    //fuck
                    gtfoonnextclock <= 1;
                end*/
            end
            //deviceBeingSelected <= 1;
        end else if (lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430) begin
            DStxresult <= 16'h5555;
            //deviceBeingSelected <= 1;
            //numTimesWrittenTo <= 0;
        end else begin
            DStxresult <= 16'h0;    //no tristate in Verilator
            //DStxresult <= 16'bZ;     //set DS_TX to 0 when not in use to circumvent the tristate bug (there probably isn't a tristate bug anymore)
            //deviceBeingSelected <= 0;
            //numTimesWrittenTo <= 0;
        end
    end else begin
        DStxresult <= 16'h0;    //no tristate in Verilator
        //DStxresult <= 16'bZ;         //set DS_TX to 0 when not in use to circumvent the tristate bug (there probably isn't a tristate bug anymore)
        //deviceBeingSelected <= 0;
        alreadyIncrementedAdsPtr <= 0;
        //numTimesWrittenTo <= 0;

        if (gtfoonnextclock) begin
            gtfoonnextclock <= 0;
            numTimesWrittenTo <= 0;
         end
    end



    if (doData) begin
        doData <= 0;
    end

    //every time a bus cycle ends, disable the alreadyWrote blocker signal
    if (~actualBusCycle) begin
        alreadyWrote <= 7'h0;
    end
end

endmodule
