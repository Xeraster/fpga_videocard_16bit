/*
"FPGA VIDEO CARD 16"
this is the version that gets put on the video card with the 16 bit vga, don't put it on the icestick
*/
// 10ns = the time represented by #1
// 1ns is the resolution of the times stored in the simulation VCD (Value Change Dump) file
`timescale 10ns/1ns

// Disable the default net type so that you can not be fooled into trouble.
`default_nettype none

//spi
`include "SPI_Slave.v"
//`include "fifo_bram_new.v"
//`include "managedByteToVramCopyFifo.v"
//`include "managedVramDataBuffer.v"
`include "managedVramDataBufferCompositeBankSwap.v"
//`include "isa_slave_controller.v"
`include "isa_slave_controller_new.v"
`include "writeBufferVram_different.v"

//tested working
module manageReset(input FPGA_RESET, output reg SYSTEM_RESET, input CPU_CLK);

	reg [3:0] count;
	always@(posedge CPU_CLK)
	begin
		if (!FPGA_RESET)
			count <= 0;
		else if (count < 4)
			count <= count + 1;

		if (count > 3)
			SYSTEM_RESET <= 1;
		else
			SYSTEM_RESET <= 0;
	end
endmodule

//tested working
module mux_2to1 (i0,i1,sel,out);
	input i0,i1,sel;
	output reg out;
	always@(i0,i1,sel)
	begin
		if(sel)
			out = i1;
		else
			out = i0;
	end
endmodule

//make a 4 to 1 mux out of 2 to 1 mux.
//tested working
module mux_4to1 (i0,i1,i2,i3,s1,s0,out);
	input i0,i1,i2,i3,s0,s1;
	output out;
	wire x1,x2;

	mux_2to1 m1 (i0,i1,s1,x1);
	mux_2to1 m2 (i2,i3,s1,x2);
	mux_2to1 m3 (x1,x2,s0,out);
endmodule

//enable is active high
//tested working
module decoder_2to4_w_enable (a0, a1, d0, d1, d2, d3, en);
    input a0, a1, en;
    output reg d0, d1, d2, d3;
    always@(a0, a1, en)
    begin
        //if(en)
		d0<=(~a0 & ~a1 & en);
		d1<=(a0 & ~a1 & en);
		d2<=(~a0 & a1 & en);
		d3<=(a0 & a1 & en);
    end
endmodule

//tested working
module decoder_3to8 (a, b, c, o0, o1, o2, o3, o4, o5, o6, o7);
	input a, b, c;
	output reg o0, o1, o2, o3, o4, o5, o6, o7;

	//tested working on both testbench and hardware
	always@(a, b, c)
	begin
		o0 = (~a & ~b & ~c); //000
		o1 = (~a & ~b & c);	//001
		o2 = (~a & b & ~c);	//010
		o3 = (~a & b & c);	//011
		o4 = (a & ~b & ~c);	//100
		o5 = (a & ~b & c);	//101
		o6 = (a & b & ~c);	//110
		o7 = (a & b & c);	//111
	end
endmodule

//testted working
//G=enable (active high). D=data in
module d_latch(Q, Qn, G, D);
   output Q;
   output Qn;
   input  G;   
   input  D;

   wire   Dn; 
   wire   D1;
   wire   Dn1;

   not(Dn, D);   
   and(D1, G, D);
   and(Dn1, G, Dn);   
   nor(Qn, D1, Q);
   nor(Q, Dn1, Qn);
endmodule

//tested working
module d3_latch(d0, d1, d2, q0, q1, q2, G);
    input d0, d1, d2, G;
    output q0, q1, q2;

    wire dummy0, dummy1, dummy2;

    //a d4 latch is can be made up of 4 d_latch modules
    d_latch dl0(q0, dummy0, G, d0);
    d_latch dl1(q1, dummy1, G, d1);
    d_latch dl2(q2, dummy2, G, d2);
endmodule

//tested working
module d4_latch(d0, d1, d2, d3, q0, q1, q2, q3, G);
    input d0, d1, d2, d3, G;
    output q0, q1, q2, q3;

    wire dummy0, dummy1, dummy2, dummy3;

    //a d4 latch is can be made up of 4 d_latch modules
    d_latch dl0(q0, dummy0, G, d0);
    d_latch dl1(q1, dummy1, G, d1);
    d_latch dl2(q2, dummy2, G, d2);
    d_latch dl3(q3, dummy3, G, d3);

endmodule

// https://www.fpga4student.com/2017/08/verilog-code-for-clock-divider-on-fpga.html
// fpga4student.com: FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA
module clockDivider(clock_in,clock_out);
input clock_in; // input clock on FPGA
output clock_out; // output clock after dividing the input clock by divisor
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

//this module doesn't get used anymore, it was only used for the icestick test
module basicTestPattern(
    input [19:0] vramAddress,
    output reg R,
    output reg G,
    output reg B,
    input HSYNC,        //don't display color data during any of the sync signals
    input VSYNC,
    input clock,
    input VALID_SCREEN      //whether or not there's supposed to be stuff on the screen
);

    //draw a thin red line at the top and make the rest green. if this actually works, I'll make a better test pattern
    always@(posedge clock)
    begin
        if (!VALID_SCREEN)
            begin
                //don't output color data when off the screen
                R <= 0;
                G <= 0;
                B <= 0;
            end
        else if (vramAddress > 128000)//was 256000
            begin
                R <= 1;
                G <= 0;
                B <= 1;
            end
        else if (vramAddress > 102400)//was 204800
            begin
                R <= 0;
                G <= 0;
                B <= 1;
            end
        else if (vramAddress > 76800)//was 153600
            begin
                R <= 0;
                G <= 1;
                B <= 1;
            end
        else if (vramAddress > 51200)//was 102400
            begin
                R <= 0;
                G <= 1;
                B <= 0;
            end
        else if (vramAddress > 25600)//was 51200
            begin
                R <= 1;
                G <= 1;
                B <= 0;
            end
        else
            begin
                R <= 1;
                G <= 0;
                B <= 0;
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

//display the contents of vram based on what is being inputted on vramAddress. this module doesn't get used anymore
module displayVRAM(
    input [19:0] vramAddress,
    output reg[4:0] R,  //0-31.
    output reg[5:0] G,  //0-63
    output reg[4:0] B,  //0-31
    input HSYNC,
    input VSYNC,
    input clock,
    output reg READ_VRAM,    //outputs 1 when enough of a delay has occured for the vram data bus to contain valid data. Not used anymore, can be ignored
    input [10:0] horizontalPos,
    input [9:0] verticalPos,
    input RESET,
    output reg vram_OE,     //address transition controlled read cycles, as described in CY7C1049G documentation
    output reg vram_CE,
    input[15:0] ds,
    input VALID_SCREEN
);
    reg[15:0] vdata;

    assign R[0] = vdata[11];
    assign R[1] = vdata[12];
    assign R[2] = vdata[13];
    assign R[3] = vdata[14];
    assign R[4] = vdata[15];

    assign G[0] = vdata[5];
    assign G[1] = vdata[6];
    assign G[2] = vdata[7];
    assign G[3] = vdata[8];
    assign G[4] = vdata[9];
    assign G[5] = vdata[10];

    assign B[0] = vdata[0];
    assign B[1] = vdata[1];
    assign B[2] = vdata[2];
    assign B[3] = vdata[3];
    assign B[4] = vdata[4];

    /*always@(*)
    begin
        R[0] <= vdata[11];
        R[1] <= vdata[12];
        R[2] <= vdata[13];
        R[3] <= vdata[14];
        R[4] <= vdata[15];

        G[0] <= vdata[5];
        G[1] <= vdata[6];
        G[2] <= vdata[7];
        G[3] <= vdata[8];
        G[4] <= vdata[9];
        G[5] <= vdata[10];

        B[0] <= vdata[0];
        B[1] <= vdata[1];
        B[2] <= vdata[2];
        B[3] <= vdata[3];
        B[4] <= vdata[4];
    end*/

    always@(posedge clock)
    begin
        vdata <= ds;
        vram_CE <= 0;
        vram_OE <= 0;
        READ_VRAM <= 1;
        /*R[0] <= vdata[11];
        R[1] <= vdata[12];
        R[2] <= vdata[13];
        R[3] <= vdata[14];
        R[4] <= vdata[15];

        G[0] <= vdata[5];
        G[1] <= vdata[6];
        G[2] <= vdata[7];
        G[3] <= vdata[8];
        G[4] <= vdata[9];
        G[5] <= vdata[10];

        B[0] <= vdata[0];
        B[1] <= vdata[1];
        B[2] <= vdata[2];
        B[3] <= vdata[3];
        B[4] <= vdata[4];*/

        /*R[0] <= ds[11];
        R[1] <= ds[12];
        R[2] <= ds[13];
        R[3] <= ds[14];
        R[4] <= ds[15];

        G[0] <= ds[5];
        G[1] <= ds[6];
        G[2] <= ds[7];
        G[3] <= ds[8];
        G[4] <= ds[9];
        G[5] <= ds[10];

        B[0] <= ds[0];
        B[1] <= ds[1];
        B[2] <= ds[2];
        B[3] <= ds[3];
        B[4] <= ds[4];*/
        
    end

endmodule

//copies abyte to vram. not used anymore 
module managedByteToVramCopy(
    input[15:0] dataToCopy,       //the 16 bit word to copy into vram
    output[15:0] dataBusOutput,     //the 16 bit data bus to output to
    output reg writeSignal,         //CY7C1049 series sram chip WE and CE. CURRENTLY DOING WE CONTROLLED WRITE CYCLES
    output reg chipEnable,
    input clock,                  //what clock to run this on.
    input doCopy,
    output done,                  //1 if finished. 0 if busy
    input bus_free                //0 if the bus is not being used by the framebuffer. 1 if the bus is being used
);
    //assign dataBusOutput = dataToCopy; //this doesn't work, it doesn't circumvent whatever messes with the tristate buffer and makes it not work correctly for some reason
    //assign dataBusOutput = 65535;//doing this doesn't make it not disable read cycles
    reg[4:0] waitctr;//try experimenting with waitstates. update: that didnt solve any problems but im leaving it in anyway just so I can deassert writeSignal a little before chipEnable
    reg donestatus;
    assign done = donestatus;//see if this fixes THE BUG. update: it made no difference
    always@(negedge clock)
    begin
        //send everything to the bus at the same time because why not
        if (doCopy & waitctr < 1 & ~bus_free) begin     //only probe for bus free on the first cycle since bus_free goes high early enough that it leaves time for exaclty 1 WE cycle + a small margin
            writeSignal <= 1;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= 10; //10 for testing purposes.
            dataBusOutput <= dataToCopy;
        end
        else if (waitctr > 4)
        begin
            writeSignal <= 0;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= waitctr - 1;
            dataBusOutput <= dataToCopy;
        end
        else if (waitctr > 0)
        begin
            writeSignal <= 1;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= waitctr - 1;
            dataBusOutput <= dataToCopy;
        end
        else/* if (doCopy)*/
        begin
            writeSignal <= 1;
            chipEnable <= 1;
            donestatus <= 1;    //done. set to 1 to tristate the data bus and also deassert the chip write and select signals
            dataBusOutput <= 0; //IMPORTANT: for some reason you have to set this to zero when not in use or else it causes problems
        end
    end

endmodule

module top(
    input pixelClock,
    input HOST_RESET,
    output[4:0] Red,
    output[5:0] Green,
    output[4:0] Blue,
    output HSYNC,
    output VSYNC,
    inout[19:0] AV,    //use inout. It works well with the yosys tristate primitive
    inout[15:0] DS,
    input VGASCK,       //U6 pin
    input VGAMOSI,      //U5 pin      
    output VGAMISO,      //U4 pin
    input VGACS0,       //U3 pin
    output DEBUG0,      //U2 pin
    output DEBUG1,       //U1 pin (U0 pin is being used for a bodge wire hack)
    output VRAM_low_en,
    output VRAM_high_en,
    output read_cmd,
    output write_cmd,
    output MCLK0,
    output MCLK1,
    //the start of the isa specific signals
    input SBHE,
    input BALE,
    output IOCS16,
    output MEMCS16,
    output IOERR,
    output IO_RDY,
    output NOWS,
    output ADS_OE,
    output ADS_LATCH,
    input MEMR,
    input MEMW,
    input SMEMR,
    input SMEMW,
    input IOR,
    input IOW,
    input ISACLK,
    input FASTCLK,  //i'm not using this for anything right now, but the idea is to use it for 1024x768
    output TE0,
    output TE1,
    output TE2,
    output TE3,
    output FPGA_WR,
    output isa_ctrl_out_en
);
    //wire HSYNC, VSYNC, R, G, B;
    reg [19:0] VramCounter;
    reg VALID_PIXELS;
    reg VRAM_VALID;
    reg CE, OE;    //vram signal outputs
    reg CER, OER;  //vram signals for reading
    reg CEW, WE;   //vram signals for writing

    //also keep track of horizontal and vertical x,y position. saving this to a register and passing this into modules is easier than deriving it through math, so i'd rather just do that
    reg [10:0] horizontalCount;
    reg [9:0] verticalCount;
    reg[4:0] Rt;
    reg[5:0] Gt;
    reg[4:0] Bt;

    reg[4:0] Ri;
    reg[5:0] Gi;
    reg[4:0] Bi;

    wire[15:0] vgaDataPixel;//convert this into Ri, Gi, Bi
    wire bus_free;
    reg bus_free_forreal;
    reg[19:0] av_relay; //if I do this i can assign AV with an assign statement, which is a thing i haven't tried yet. update: didn't make a difference.
    wire[15:0] DS_RX;
    wire[15:0] DS_TX;
    wire[19:0] AV_RX;
    wire empty, full, fifovalid;//fifo status bits
    wire fifo_read; //signals when to read from the fifo module
    wire[15:0] fifo_data_out;
    wire vblank;//0 if there is supposed to be a vblank (no new pixels being copied to screen). 1 if there is supposed to be pixel data sent to the screen. needs to be asserted exactly 2 pixelClock cycles before color data is supposed to be on the bus
    reg ivblank;
    assign vblank = ivblank;

    generateSync gs(spixelClock, HSYNC, VSYNC, VramCounter, RESET, VALID_PIXELS, horizontalCount, verticalCount);    //generate the sync signals for use in other stuff
    advancedTestPattern atp(VramCounter, Rt, Gt, Bt, HSYNC, VSYNC, spixelClock, VALID_PIXELS, horizontalCount, verticalCount);   //generate the values for test pattern (when bit 4 of settings register 0x423 is 0)
    //displayVRAM vrambullshit(VramCounter, Ri, Gi, Bi, HSYNC, VSYNC, pixelClock, VRAM_VALID, horizontalCount, verticalCount, RESET, OE, CE, DS_RX, VALID_PIXELS);
    //managedByteToVramCopy mbtc(inputPixel, DS_TX, WE, CEW, pixelClock, byteToCopy, byteCopied, bus_free);
    //wire init;
    //psuedofiforam pfr(inputPixel, fifo_wr_en, fifo_read, pixelClock, pixelClock, fifo_data_out, RESET, full, empty, fifovalid);
    //managedByteToVramCopyFifo mbtc(fifo_data_out, DS_TX, WE, CEW, pixelClock, byteCopied, bus_free, empty, fifovalid, fifo_read);

    wire write_en, read_en;
    wire[19:0] maxVramAddress;
    wire [19:0] bufferRequestedAddress;
    reg [19:0] lastAdsRequest;
    assign maxVramAddress = 20'h96000;
    wire frameEnd;
    wire almostFull;
    wire evenOrOdd;
    wire alreadyDidHsyncReset;
    
    //this stuff was for testing, block swapping is superior in performance to fifo (since it can fill an entire horizontal line) and doesn't cause any new bugs.
    //doing it the block swapping way will greatly reduce the vram bandwidth required for 320x240 and 320x200
    //psuedofiforam_new testfifo(DS_RX, write_en, read_en, ~FASTCLK, pixelClock, fifo_data_out, (RESET & ~frameEnd), full, empty, fifovalid, almostFull);
    //managedVramDataBuffer testramthingy(DS_RX, Ri, Gi, Bi, OE, CE, FASTCLK, done, FPGA_IO_EN/*probably best this way, since cross clock domain*/, VALID_PIXELS/*vblank*/, empty, full, fifovalid, write_en, read_en, bufferRequestedAddress, maxVramAddress, RESET, pixelClock, fifo_data_out, frameEnd, almostFull);
    
                                                                                //use ADS_OE for bus free? it's either doing an isa transfer for a fpga <=> vram transfer basically

    managedVramDataBufferCompositeBankSwap testramthingy(DS_RX, Ri, Gi, Bi, OE, CE, pllClk/*FASTCLK*/, actualBusCycle | undecidedIsaCycle, 
    /*VALID_PIXELS*/ivblank, empty, full, fifovalid, write_en, read_en, bufferRequestedAddress, maxVramAddress, RESET, spixelClock, 
    frameEnd, HSYNC, VSYNC, vsyncctr/*verticalCount[0]*/, alreadyDidHsyncReset, VALID_PIXELS);

    //wire xpixelClock;
    //clockDivider cdd(pllClk, xpixelClock);
    //since not using assign is frowned upon, i tried this to see if it would make the "tristate not working bug" go away. it didn't. update to this comment: using SB_IO instead of tristate ternary is way better and avoids wierd bugs
    reg busstatus;
    assign bus_free = busstatus;
    
    wire DATA_OUTPUT_ENABLE;
    //assign DATA_OUTPUT_ENABLE = (FPGA_IO_EN & FPGA_WR & isadebugport0/* & ~write_en*/);//isa_slave_controller_new needs this instead\
    assign DATA_OUTPUT_ENABLE = (FPGA_IO_EN & FPGA_WR) | WRITEBUF_IO_EN;//the version that's compatible with write buffering
    //assign AV = av_relay;
    //assign isa_ctrl_out_en = ~(~ADS_OE & AV_RX >= 20'h420 & AV_RX <= 20'h430 & (~IOR | ~IOW));
    //assign isa_ctrl_out_en = ~(~ADS_OE & AV_RX >= 20'h420 & AV_RX <= 20'h430 & (~IOR | ~IOW));

    //control the ISA output 74lvc245 tranciever
    assign isa_ctrl_out_en = ~(/*(FPGA_IO_EN | undecidedIsaCycle)*/lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430 & (~IOR | ~IOW | FPGA_IO_EN) & ~BALE);//isa_slave_controller_new needs this instead
    //assign isa_ctrl_out_en = ~(/*FPGA_IO_EN & */AV_RX >= 20'h420 & AV_RX <= 20'h430 & (~IOR | ~IOW) & ~BALE);
    //assign isa_ctrl_out_en = 1;//disable
    //assign AV = ~FPGA_IO_EN ? 20'bZ : av_relay;
    
    //assign AV = ADS_OE ? 20'bZ : bufferRequestedAddress;
    //assign AV_RX = AV;
    //this works better than the above.
    SB_IO #(
    .PIN_TYPE(20'b 1010_01),
    ) raspi_io [19:0] (
    .PACKAGE_PIN(AV),
    .OUTPUT_ENABLE(ADS_OE),
    .D_OUT_0(/*bufferRequestedAddress*/addressBusOut),
    .D_IN_0(AV_RX)
    );

    wire pllClk;
    //pll experiment. results: solves *almost* every clock domain related bug
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),   // Don't use fine delay adjust
        .PLLOUT_SELECT("GENCLK"),   // No phase shift on output
        .DIVR(4'b0000),             // Reference clock divider . 0 + 1 = 1
        .DIVF(7'b0000010),          // Feedback clock divider. 22 + 1 = 23
        .DIVQ(3'b000),              // VCO clock divider. 3
        .FILTER_RANGE(3'b001)       // Filter range
    ) pll (
        .REFERENCECLK(pixelClock),     // Input clock
        .PLLOUTCORE(pllClk),           // Output clock
        //.PLLOUTGLOBAL(globalPixelClock),     //global pixelClock to avoid skew
        .LOCK(),                    // Locked signal
        .RESETB(1'b1),              // Active low reset
        .BYPASS(1'b0)               // No bypass, use PLL signal as output
    );

    assign spixelClock = ispixelClock;
    reg ispixelClock;
    always@(pllClk) begin
        ispixelClock <= pixelClock;
    end

    wire spixelClock;
    //clockDivider cd(pllClk, spixelClock);

    /*SB_PLL40_2F_CORE #(
                //.FEEDBACK_PATH("DELAY"),
                 .FEEDBACK_PATH("SIMPLE"),
                // .FEEDBACK_PATH("PHASE_AND_DELAY"),
                // .FEEDBACK_PATH("EXTERNAL"),

                .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
                // .DELAY_ADJUSTMENT_MODE_FEEDBACK("DYNAMIC"),

                .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
                // .DELAY_ADJUSTMENT_MODE_RELATIVE("DYNAMIC"),

                .PLLOUT_SELECT_PORTA("GENCLK"),
                // .PLLOUT_SELECT_PORTA("GENCLK_HALF"),
                // .PLLOUT_SELECT_PORTA("SHIFTREG_90deg"),
                // .PLLOUT_SELECT_PORTA("SHIFTREG_0deg"),

                .PLLOUT_SELECT_PORTB("GENCLK"),
                // .PLLOUT_SELECT_PORTB("GENCLK_HALF"),
                // .PLLOUT_SELECT_PORTB("SHIFTREG_90deg"),
                // .PLLOUT_SELECT_PORTB("SHIFTREG_0deg"),

                //.SHIFTREG_DIV_MODE(1'b0),//used when FEEDBACK_PATH is PHASE_AND_DELAY
                .FDA_FEEDBACK(4'b1111),//probably doesn't matter as long as these are the same
                .FDA_RELATIVE(4'b1111),//probably doesn't matter as long as these are the same
                .DIVR(4'b0000),
                .DIVF(7'b0000000),
                .DIVQ(3'b001),
                .FILTER_RANGE(3'b000),
                .ENABLE_ICEGATE_PORTA(1'b0),
                .ENABLE_ICEGATE_PORTB(1'b0),
                .TEST_MODE(1'b0)
        ) uut (
                .REFERENCECLK   (REFERENCECLK   ),
                .PLLOUTCOREA    (PLLOUTCORE  [0]),
                .PLLOUTGLOBALA  (PLLOUTGLOBAL[0]),
                .PLLOUTCOREB    (PLLOUTCORE  [1]),
                .PLLOUTGLOBALB  (PLLOUTGLOBAL[1]),
                .EXTFEEDBACK    (EXTFEEDBACK    ),
                .DYNAMICDELAY   (DYNAMICDELAY   ),
                .LOCK           (LOCK           ),
                .BYPASS         (BYPASS         ),
                .RESETB         (RESETB         ),
                .LATCHINPUTVALUE(LATCHINPUTVALUE),
                .SDO            (SDO            ),
                .SDI            (SDI            ),
                .SCLK           (SCLK           )
        );*/

    /*av_relay HAS to be assigned 0 when not in use EVEN if the enable signal (~ADS_OE) is 0
    idk if its a yosys bug, an ice40 chip bug or a feature but that's just how it is. 
    Troubleshooting and finding this limitation was really hard. The testbench simulator does NOT reflect this behavior.
    see DS_tX and DS_RX for another example of how this problem was delt with
    */

    wire shutUp;
    wire sTE0, sTE1, sTE2, sTE3, dummyFPGAIO, dummyactualbuscycle, dummyADSlatch;
    wire ISADONE, actualBusCycle, undecidedIsaCycle;
    reg FPGA_IO_EN;//goes high anytime an isa bus cycle is happening that is addressing this card
    isaSlaveBusController isathing(AV_RX, FPGA_IO_EN, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, ADS_OE, ADS_LATCH, 
    MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISACLK, ISADONE, 
    TE0, TE1, TE2, TE3, FPGA_WR, pllClk/*FASTCLK*/, actualBusCycle, RESET, 1'h0, undecidedIsaCycle);

    //this only controls FPGA_WR with all other controls being linked to dummy signals. THE SNOW BUG GOES AWAY COMPLETELY WHEN ISA IS DISABLED. so I just comment these lines in or out depending on what im testing
    //isaSlaveBusController isathing(AV_RX, dummyFPGAIO, SBHE, BALE, IOCS16, MEMCS16, IOERR, IO_RDY, NOWS, shutUp, dummyADSlatch, 
    //MEMR, MEMW, SMEMR, SMEMW, IOR, IOW, ISACLK, ISADONE, 
    //TE0, TE1, TE2, TE3, FPGA_WR, pllClk/*FASTCLK*/, actualBusCycle, RESET, 1'h0);

    //temporarily disable and watch the magic bug go away
    //assign FPGA_IO_EN = 0;
    //assign actualBusCycle = 0;
    //assign TE0 = 1;
    //assign TE1 = 1;
    //assign TE2 = 1;
    //assign TE3 = 1;
    //assign ADS_OE = 1;
    //assign ADS_LATCH = 0;
    //assign vblank = ivblank;


    //temporary placeholder values since vram is disabled for the isa interface test
    //assign VRAM_low_en = 1;
    //assign VRAM_high_en = 1;
    //assign read_cmd = 1;
    //assign write_cmd = 1;
    reg[7:0] control_register;

    //assign Red = !settingsRegister[4] ? Rt : 4'h15;
    //assign Green = !settingsRegister[4] ? Gt : 5'h0;
    //assign Blue = !settingsRegister[4] ? Bt : 4'h15;
    //assign Red = Ri;
    //assign Green = Gi;
    //assign Blue = Bi;

    /*reg[4:0] iRed;
    reg[5:0] iGreen;
    reg[4:0] iBlue;
    assign Red = iRed;
    assign Green = iGreen;
    assign Blue = iBlue;

    reg RESET;*/
    /*always@(posedge pllClk)
    begin
        RESET <= ~HOST_RESET;       //isa reset is inverted from what I assumed it to be, so do this to fix it

        //weirdly enough, doing this stuff on the rising edge of pllClk and not pixelClock makes all the flickering and wobbling go away.
        if (!settingsRegister[4])   //if bit 5 of settings register 0x423 is 0, do the test pattern instead of displaying vram
        begin
            iRed <= Rt;
            iGreen <= Gt;
            iBlue <= Bt;
        end else begin
            iRed <= Ri;
            iGreen <= Gi;
            iBlue <= Bi;
        end
    end*/

    reg[4:0] iRed;
    reg[5:0] iGreen;
    reg[4:0] iBlue;
    assign Red = iRed;
    assign Green = iGreen;
    assign Blue = iBlue;

    reg RESET;

    reg iVRAM_low_en, iVRAM_high_en, iwrite_cmd, iread_cmd;
    assign VRAM_low_en = iVRAM_low_en;
    assign VRAM_high_en = iVRAM_high_en;
    assign write_cmd = iwrite_cmd;
    assign read_cmd = iread_cmd;

    reg [10:0] shorizontalCount;
    reg [9:0] sverticalCount;

    //only process write buffer data if the block swapping buffer
    reg [19:0] addressBusOut;
    reg [15:0] dataBusOut;

    //try to modify BALE to behave better when used for things in the pllClk domain
    reg b1_Pulse, b2_Pulse, b3_Pulse;
    reg syncBale;

    always@(posedge pllClk)
    begin

        sverticalCount <= verticalCount;
        shorizontalCount <= horizontalCount;

        RESET <= ~HOST_RESET;       //isa reset is inverted from what I assumed it to be, so do this to fix it
        //DEBUG0 <= ivalid;
        //DEBUG1 <= VGASCK;

        //test points on the pcb
        MCLK1 <= lastAdsRequest == 20'h426;//(~ADS_OE & FPGA_WR & ~write_en);      //1 pin
        MCLK0 <= writeBufferEmpty/*lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430*/;    //0 pin
        DEBUG0 <= writeBufferAlmostFull;//u2
        //DEBUG1 = TE0 & TE1 & TE2 & TE3;//if any of the TEn signals go low, make DEBUG1 go high
        DEBUG1 <= full & !FPGA_IO_EN & !undecidedIsaCycle;//u1
    
        //Red = Rt;
        //Green = Gt;
        //Blue = Bt;

        b1_Pulse <= BALE;
        b2_Pulse <= b1_Pulse;
        b3_Pulse <= b2_Pulse;

        if (~b3_Pulse & b2_Pulse) begin
            syncBale <= 1;
        end else if (b3_Pulse & ~b2_Pulse) begin
            syncBale <= 0;
        end

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
            end else if (!FPGA_IO_EN & !undecidedIsaCycle) begin
                //if there is no relevant isa bus cycle happening, relay the signals to the vram chips for copying stuff into the buffer
                iVRAM_low_en <= CE;
                iVRAM_high_en <= CE;
                iread_cmd <= OE;
                iwrite_cmd <= 1;
                addressBusOut <= bufferRequestedAddress;
                dataBusOut <= DStxresult;
            end else begin
                //explicitly set this stuff to 1, disabling it all in invalid states. it didn't solve any bugs or artifacts but this seems like a good thing to do
                iVRAM_low_en <= 1;
                iVRAM_high_en <= 1;
                iread_cmd <= 1;
                iwrite_cmd <= 1;
                addressBusOut <= bufferRequestedAddress;
                dataBusOut <= DStxresult;
            end
        end

        if (shorizontalCount > 641/* & horizontalCount <= 800 */| sverticalCount > 481/* & verticalCount <= 525*/)
        begin
            ivblank <= 0;
        end else begin
            ivblank <= 1;
        end

    end

    /*always@(posedge pllClk) begin
        if (full & !FPGA_IO_EN) begin
            addressBusOut <= writeBufferVramAddress;
            dataBusOut <= writeBufferVramData;
        end else begin
            addressBusOut <= bufferRequestedAddress;
            dataBusOut <= DStxresult;
        end
    end*/

    //i tried all. kinds. of. stuff.
    wire internal_write_enable;
    assign internal_write_enable = ~bus_free;
    //assign internal_write_enable = ~byteCopied & ~bus_free_forreal & ~CEW;
    //assign internal_write_enable = ~byteCopied & ~bus_free_forreal;//this is unpredictable and doesn't work.

    //(~ADS_OE & FPGA_WR) works well, hopefully adding that ~write_en makes it work for vram buffering cycles too without breaking everything
    //assign DS = (~ADS_OE & FPGA_WR & ~write_en) ? 16'bZ : DStxresult;
    //assign DS_RX = DS;
    //this works better than the above.
    SB_IO #(
    .PIN_TYPE(16'b 1010_01),
    ) databus_io [15:0] (
    .PACKAGE_PIN(DS),
    .OUTPUT_ENABLE(DATA_OUTPUT_ENABLE/*(~ADS_OE & FPGA_WR & ~write_en)*/),
    .D_OUT_0(dataBusOut),
    .D_IN_0(DS_RX)
    );
    //assign DS = DStxresult;

    //placeholder registers for the port
    reg[15:0] vramBankRegister; //register 0x420
    reg[7:0] videoDisplayRegister;
    reg[7:0] settingsRegister;  //register 0x423 settings register
    reg[7:0] statusRegister;    //register 0x426 status register
    //reg[7:0] addressLowReg;
    //reg[7:0] addressMiddleReg;
    //reg[7:0] addressHighReg;
    reg[23:0] addressComReg;//combined address register maybe that will work
    reg[15:0] nextThingToWrite;
    reg alreadyIncrementedAdsPtr;

    reg[16:0] testreg;

    //do stuff on the edge of the fast clock
    reg[15:0] DStxresult;
    reg deviceBeingSelected;
    reg syncedISACLK;
    //assign DS_TX = DStxresult;
    reg vsyncctr;
    always@(negedge HSYNC) begin
        vsyncctr <= ~vsyncctr;
    end

    //an attempt at syncing isa clock to get around clock domain bugs. it doesn't seem to have changed anything.
    reg syncIOR, syncIOW;//maybe this will make there be less issues
    reg r1_Pulse, r2_Pulse, r3_Pulse;
    reg[15:0] synchronizedDataInput;//for isa

    reg [2:0] isahighctr;

    always@(posedge /*FASTCLK*/pllClk)
    begin
        if (!RESET) begin
            isahighctr <= 3;
        end

        if (~ADS_OE) begin
            lastAdsRequest <= AV_RX;
        end

        //r1_Pulse <= ISACLK;    //the ONLY TIME ISA_CLK EVER GETS REFERENCED
        //r2_Pulse <= r1_Pulse;
        //r3_Pulse <= r2_Pulse;

        /*if ((~r3_Pulse & r2_Pulse)) begin
            syncedISACLK <= 1;
            synchronizedDataInput <= DS_RX;
            syncIOR <= IOR | BALE;
            syncIOW <= IOW | BALE;
        end else if (r3_Pulse & ~r2_Pulse) begin
            syncedISACLK <= 0;
            synchronizedDataInput <= DS_RX;
        end*/

        if (isahighctr < 1 & ISACLK)
        begin
            synchronizedDataInput <= DS_RX;
            syncIOR <= IOR | BALE;
            syncIOW <= IOW | BALE;
        end else if (ISACLK) begin
            isahighctr <= isahighctr - 1;
        end else begin
            isahighctr <= 3;
        end


    end

    //wire[15:0] writeBufferOut;
    //wire writeBufferFull, writeBufferEmpty, writeBufferValid, writeBufferAlmostFull;
    //psuedofiforam_new pfr(nextThingToWrite, 1'b1, 1'b1, alreadyIncrementedAdsPtr, pllClk, writeBufferOut, RESET, writeBufferFull, writeBufferEmpty, writeBufferValid, writeBufferAlmostFull);

    //basically, whenever the composite bank swap buffer for the current frame is full, spend that time copying data to vram
    wire[15:0] writeBufferVramData;
    wire[19:0] writeBufferVramAddress;
    wire vbuf_WE, vbuf_CE, WRITEBUF_IO_EN;
    wire writeBufferFull, writeBufferAlmostFull, writeBufferEmpty;
    writeBufferVram wbv(nextThingToWrite, addressComReg[19:0], pllClk, doData, writeBufferVramData, writeBufferVramAddress, vbuf_WE, vbuf_CE, full & !FPGA_IO_EN & !undecidedIsaCycle, pllClk, RESET, WRITEBUF_IO_EN, writeBufferFull, writeBufferAlmostFull, writeBufferEmpty);
    
    reg numTimesWrittenTo;//workaround hack for a open collector vs totem pole issue. ugh
    reg gtfoonnextclock;
    reg doData;

    //it misses read and write cycles like 25%-50% of the time. It may be related to the address decode bug, still not sure if these 2 bugs are caused by the same thing or not
    always@(posedge /*ISACLK*/pllClk)
    begin
        //make it possible to find out if the write buffer is full or empty
        statusRegister[7] <= vblank;
        statusRegister[6] <= full;
        statusRegister[5] <= writeBufferFull;//bit 5: input buffer full. 0 if not full. 1 if full
        statusRegister[4] <= writeBufferAlmostFull;//welp, there isn't a way to find if it's *almost* full because of the impossibly intricate architecture of the async fifo buffer. fuck.


        //upon reset, load the registers with default values
        if (!RESET) begin
            videoDisplayRegister <= 8'h18;//b7-4 = 1 for 640x480. bit 3-2 = 2 for 16 bit color.
            settingsRegister <= 8'h70;//tldr 0x60 is for test pattern, 0x70 is for vram display mode.
            statusRegister <= 8'h0;
            alreadyIncrementedAdsPtr <= 0;
            addressComReg <= 0;
            numTimesWrittenTo<=0;
            gtfoonnextclock <= 0;
            doData <= 0;
        end else if (/*(~IOR | ~IOW)*/(~syncIOW | ~syncIOW) & actualBusCycle) begin//only io cycles for now
            //if (AV_RX == 20'h423) begin
            if (lastAdsRequest == 20'h422) begin
                if (FPGA_WR) begin
                    DStxresult[7:0] <= videoDisplayRegister;
                end else begin
                    videoDisplayRegister <= DS_RX[7:0];
                end
            end else if (lastAdsRequest == 20'h423) begin
                if (FPGA_WR) begin
                    DStxresult[15:8] <= settingsRegister[7:0];
                end else begin
                    settingsRegister[7:0] <= synchronizedDataInput[15:8];
                end

                //DStxresult <= 16'hA9A9;
                deviceBeingSelected <= 1;
                numTimesWrittenTo<=0;
            end else if (lastAdsRequest == 20'h426) begin
                if (FPGA_WR) begin
                    DStxresult[7:0] <= statusRegister;
                end else begin
                    statusRegister <= DS_RX[7:0];
                end
                deviceBeingSelected <= 1;
                numTimesWrittenTo<=0;
            end else if (lastAdsRequest == 20'h428) begin
                if (FPGA_WR) begin
                    DStxresult[7:0] <= addressComReg[7:0];
                end else begin
                    //addressComReg[7:0] <= DS_RX[7:0];
                    //addressComReg[7:0] <= DS_RX[7:0];
                    addressComReg[0] <= 0;
                    addressComReg[8:1] <= DS_RX[7:0];
                end
                deviceBeingSelected <= 1;
                numTimesWrittenTo <= 0;
            end else if (lastAdsRequest == 20'h429) begin
                if (FPGA_WR) begin
                    DStxresult[15:8] <= addressComReg[15:8];
                end else begin
                    //addressComReg[15:8] <= DS_RX[15:8];
                    //addressComReg[15:8] <= DS_RX[15:8];
                    addressComReg[16:9] <= DS_RX[15:8];
                    numTimesWrittenTo <= 0;
                end
                deviceBeingSelected <= 1;
            end else if (lastAdsRequest == 20'h42A) begin
                if (FPGA_WR) begin
                    DStxresult[7:0] <= addressComReg[23:16];
                end else begin
                    //addressComReg[23:16] <= DS_RX[7:0];
                    //addressComReg[23:16] <= DS_RX[7:0];
                    addressComReg[23:17] <= DS_RX[6:0];
                    numTimesWrittenTo <= 0;
                end
                deviceBeingSelected <= 1;
            end else if (lastAdsRequest == 20'h42C) begin
                if (FPGA_WR) begin
                    DStxresult[15:0] <= nextThingToWrite;
                end else begin
                    //nextThingToWrite <= DS_RX[15:0];
                    nextThingToWrite <= DS_RX;
                    //nextThingToWrite <= 16'hffff;
                    if (!alreadyIncrementedAdsPtr & !numTimesWrittenTo) begin
                        //hack so that repeated psuedo 16 bit writes don't get counted as 2 write cycles. just dont do 8 bit writes to this port and it'll be fine
                        addressComReg <= addressComReg + 2;//increment the address pointer for easiness
                        alreadyIncrementedAdsPtr <= 1;
                        numTimesWrittenTo <= 1;
                        doData <= 1;
                    end else if (!alreadyIncrementedAdsPtr & numTimesWrittenTo) begin
                        //fuck
                        gtfoonnextclock <= 1;
                    end
                end
                deviceBeingSelected <= 1;
            end else if (lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430) begin
                DStxresult <= 16'h5555;
                deviceBeingSelected <= 1;
                //numTimesWrittenTo <= 0;
            end else begin
                DStxresult <= 16'bZ;     //set DS_TX to 0 when not in use to circumvent the tristate bug (there probably isn't a tristate bug anymore)
                deviceBeingSelected <= 0;
                //numTimesWrittenTo <= 0;
            end
        end else begin
            DStxresult <= 16'bZ;         //set DS_TX to 0 when not in use to circumvent the tristate bug (there probably isn't a tristate bug anymore)
            deviceBeingSelected <= 0;
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
    end

endmodule