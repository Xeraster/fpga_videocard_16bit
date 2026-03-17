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
    output reg HSYNC,
    output reg VSYNC,
    output reg [19:0] vramAddress,
    input RESET,                 //gotta tell those counters when to reset to zero
    output reg VALID_PIXELS,             //its a 1 if there is allowed to be data on R,G,B
    output reg[10:0] horizontalCount,
    output reg[9:0] verticalCount 
);
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
    input a,b, 
    output HSYNC, 
    output VSYNC, 
    input pllclk, 
    output c, 
    output d, 
    output[4:0] Rt, 
    output[5:0] Gt, 
    output[4:0] Bt, 
    input RESET, 
    output[10:0] horizontalCount, 
    output[9:0] verticalCount, 
    output VALID_PIXELS,
    output pixelClock,
    input BALE
    );

clockDividerX3 cdd(pllclk, pixelClock);
//assign c = a & b;
//assign Ri = 4'hF;
//assign Gi = 5'h1F;
//assign Bi = 4'hF;
wire[19:0] vramAddress;
//wire VALID_PIXELS;
//wire[10:0] horizontalCount;
//wire[9:0] verticalCount;

generateSync gs(pixelClock, HSYNC, VSYNC, vramAddress, RESET, VALID_PIXELS, horizontalCount, verticalCount);
advancedTestPattern atp(vramAddress, Rt, Gt, Bt, HSYNC, VSYNC, pixelClock, VALID_PIXELS, horizontalCount, verticalCount);

reg syncBale;
reg b1_Pulse, b2_Pulse, b3_Pulse;
always@(posedge pllclk) begin
    b1_Pulse <= BALE;
    b2_Pulse <= b1_Pulse;
    b3_Pulse <= b2_Pulse;

    if (~b3_Pulse & b2_Pulse) begin
        syncBale <= 1;
    end else if (b3_Pulse & ~b2_Pulse) begin
        syncBale <= 0;
    end

    //everything below this line needs to be fixed to work with this simulation
    if (!settingsRegister[4])   //if bit 5 of settings register 0x423 is 0, do the test pattern instead of displaying vram
        begin
        /*Red <= Rt;
        Green <= Gt;
        Blue <= Bt;*/
            
        iVRAM_low_en <= 1;
        iVRAM_high_en <= 1;
        iread_cmd <= 1;
        iwrite_cmd <= 1;

        iRed <= Rt;
        iGreen <= Gt;
        iBlue <= Bt;

        dataBusOut <= DStxresult;//fix a bug where data outputs dont work if the test pattern is enabled.
    end else begin
        //Red = 4'h15;
        //Green = 5'h0;
        //Blue = 4'h15;
        /*Red <= Ri;
        Green <= Gi;
        Blue <= Bi;*/

        iRed <= Ri;
        iGreen <= Gi;
        iBlue <= Bi;

        if (/*full & !FPGA_IO_EN*/WRITEBUF_IO_EN) begin
            //if there is no more pixel buffer copying to do (and there is no relevant isa bus cycle happening), start processing write buffer data and writing it to the screen
            iVRAM_low_en <= vbuf_CE;
            iVRAM_high_en <= vbuf_CE;
            iwrite_cmd <= vbuf_WE;
            iread_cmd <= 1;

            addressBusOut <= writeBufferVramAddress;
            dataBusOut <= writeBufferVramData;
                ebugDataOut <= 0;
        end else if (!FPGA_IO_EN & !undecidedIsaCycle) begin
            //if there is no relevant isa bus cycle happening, relay the signals to the vram chips for copying stuff into the buffer
            iVRAM_low_en <= CE;
            iVRAM_high_en <= CE;
            iread_cmd <= OE;
            iwrite_cmd <= 1;
            addressBusOut <= bufferRequestedAddress;
            dataBusOut <= DStxresult;
            debugDataOut <= 1;
        end else begin
            //explicitly set this stuff to 1, disabling it all in invalid states. it didn't solve any bugs or artifacts but this seems like a good thing to do
            iVRAM_low_en <= 1;
            iVRAM_high_en <= 1;
            iread_cmd <= 1;
            iwrite_cmd <= 1;
            addressBusOut <= bufferRequestedAddress;
            dataBusOut <= DStxresult;
            debugDataOut <= 1;
        end
    end

end

endmodule
