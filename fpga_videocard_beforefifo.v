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
`include "managedByteToVramCopyFifo.v"

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

	//uuh, the 2 working examples i have of modules contain @always, so throw that in there
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
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd4;
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

//generate a 640x480 vga sync signal
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
                VALID_H <= 1;
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

//this module doesn't get used anymore
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

//display the contents of vram based on what is being inputted on vramAddress
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

//copies abyte to vram. 
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
    input RESET,
    output reg[4:0] Red,
    output reg[5:0] Green,
    output reg[4:0] Blue,
    output HSYNC,
    output VSYNC,
    output[19:0] AV,
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
    output MCLK1
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
    wire bus_free;
    reg bus_free_forreal;
    reg[19:0] av_relay; //if I do this i can assign AV with an assign statement, which is a thing i haven't tried yet. update: didn't make a difference.
    wire[15:0] DS_RX;
    wire[15:0] DS_TX;

    generateSync gs(pixelClock, HSYNC, VSYNC, VramCounter, RESET, VALID_PIXELS, horizontalCount, verticalCount);//this module is bit depth independent
    advancedTestPattern atp(VramCounter, Rt, Gt, Bt, HSYNC, VSYNC, pixelClock, VALID_PIXELS, horizontalCount, verticalCount);
    displayVRAM vrambullshit(VramCounter, Ri, Gi, Bi, HSYNC, VSYNC, pixelClock, VRAM_VALID, horizontalCount, verticalCount, RESET, OE, CE, DS_RX, VALID_PIXELS);
    managedByteToVramCopy mbtc(inputPixel, DS_TX, WE, CEW, pixelClock, byteToCopy, byteCopied, bus_free);

    //since not using assign is frowned upon, i tried this to see if it would make the "tristate not working bug" go away. it didn't
    reg busstatus;
    assign bus_free = busstatus;

    assign AV = av_relay;

    always@(*)
    begin
        //DEBUG0 <= ivalid;
        //DEBUG1 <= VGASCK;

        //test points on the pcb
        MCLK1 = bus_free;      //1 pin
        MCLK0 = internal_write_enable;    //0 pin
        DEBUG0 = CEW;
        DEBUG1 = WE;

        if (!control_register[0])
        begin
            Red = Rt;
            Green = Gt;
            Blue = Bt;
        end else begin
            Red = Ri;
            Green = Gi;
            Blue = Bi;
        end

        //since bus_free is used for vram copy, deassert it just a litttle bit before the end of the blanking period. "bus_free_forreal" contains the absolute vblanking status if needed
        if (horizontalCount > 641 & horizontalCount < 785 | verticalCount > 481 & verticalCount < 510)
        begin
            busstatus = 0;
        end else begin
            busstatus = 1;
        end

        if (horizontalCount > 641 & horizontalCount < 799 | verticalCount > 481 & verticalCount < 524)
        begin
            //if this is happening, vram write cycles can happen if desired
            //bus_free <= 0;
            //DS_input <= bus_free ? DS : 16'bz;
            //DS_output <= ~bus_free ? inputPixel : 16'bz;
            //DS <= byteCopied ? DS_output : 16'bz;
            //AV <= writeAddress;
            bus_free_forreal = 0;
            VRAM_low_en = CEW;
            VRAM_high_en = CEW;
            read_cmd = 1;
            write_cmd = WE;
            av_relay <= writeAddress;
            //AV = writeAddress;
            //DS <= byteCopied ? DS_output : 16'bz;
        end else begin
            //if this i
            //bus_free <= 1;
            //DS_input <= DS;
            //AV <= VramCounter;
            bus_free_forreal = 1;
            VRAM_low_en = CE;
            VRAM_high_en = CE;
            read_cmd = OE;
            write_cmd = 1;
            av_relay <= VramCounter;
            //AV = VramCounter;
            //DS_input <= bus_free ? DS : 16'bz;
            //DS_output <= ~bus_free ? inputPixel : 16'bz;
        end

    end

    //i tried all. kinds. of. stuff.
    wire internal_write_enable;
    assign internal_write_enable = ~bus_free;
    //assign internal_write_enable = ~byteCopied & ~bus_free_forreal & ~CEW;
    //assign internal_write_enable = ~byteCopied & ~bus_free_forreal;//this is unpredictable and doesn't work.

    //somehow this doesn't work. it can only read data until the first write cycle happens, then it can never write again until power cycle. the RESET pin doesn't even do it, only a power cycle restores the ability for DS reads to work
    assign DS = bus_free ? 16'bZ : DS_TX;
    assign DS_RX = DS;


    //recieve spi commands and do stuff with them
    reg [7:0] ibuffer;  //data recieve buffer
    reg [7:0] obuffer;  //data out buffer 
    reg ivalid;  
    wire ovalid;  //if in data or out data is valid respectively
    reg ivalid_fake;//im sure the spi module works for many people but it doesnt work for me. this is part of the workaround hack


    reg [7:0] rindex;//active register index
    reg [7:0] rdata;//data to put into the register or whatever
    reg dataorindex;    //0 if operaing on register index. 1 if operating data
    SPI_Slave ss(RESET, pixelClock, ovalid, obuffer, ivalid_fake, ibuffer, VGASCK, VGAMISO_FAKE, VGAMOSI, VGACS0);
    reg debugDid;
    wire VGAMISO_FAKE;//part of the workaround hack for non-workng features of the spi module

    //part of the spi workaround. It works well enough for ready vs not ready status but the bits aren't in the correct order. It's more likely that particular bug is caused by my spi program and not this
    reg [3:0] octr;
    always @(posedge VGASCK)
    begin
      if (ivalid & ~VGACS0)
      begin
        VGAMISO <= ibuffer[octr];
        octr <= octr + 1;
      end
      else if (VGACS0)
      begin
        octr <= 0;
        VGAMISO <= 0;
      end
    end

    //variables for the registers
    reg [7:0] inputNum;         //register 0xB0
    reg [7:0] outputNum;        //register 0xB1
    reg [7:0] testResult;        //register 0xB2
    reg [7:0] control_register;     //register 0xB3
    reg [15:0] inputPixel;          //register 0xB4. the one that requires a 16 bit write.
    reg [7:0] status_register;      //register 0x80. the status register. if 0, ready. if anything besides 0, its not ready
    reg [19:0] writeAddress;        //the user-assignable writeAddress
    reg step;                       //part of the register 0xB4 state machine to allow it to recieve a 16 bit value over spi
    reg byteToCopy;                 //when high there is a 16 bit work waiting to be copied to vram
    reg debugByteCopy;
    wire byteCopied;                //0 when fpga-to-vram write cycle is in progress. 1 if otherwise

    assign ivalid = 1;
    //set input buffer to set the output buffer
    always@(posedge pixelClock)
    begin
        //status_register[1] <= bus_free;

        /*if (horizontalCount > 640 & horizontalCount < 800 | verticalCount > 480 & verticalCount < 525)
        begin
            AV <= writeAddress;
        end else begin
            AV <= VramCounter;
        end*/

        if (!RESET)
        begin
            ibuffer <= 69;
            //obuffer <= 0;
            //ivalid <= 1;
            ivalid_fake <= 0;
            byteToCopy <= 0;
            dataorindex <= 0;
            rindex <= 0;
            rdata <= 0;
            control_register <= 0;
            status_register <= 0;
            //ovalid <= 0;
            debugDid <= 0;
            debugByteCopy <= 0;
            step <= 0;
        end else if (~dataorindex & ovalid & ~byteToCopy)
        begin
            rindex <= obuffer;
            dataorindex <= 1;
            step <= 0;
            //ivalid <= 0;  //
            //debugDid <= 1;
        end
        else if (ovalid & dataorindex & ~byteToCopy)
        begin
            dataorindex <= 0;
            //ivalid <= 0;
            //ibuffer <= obuffer;
                //save the data to a data register if this is a non-register index setting operation
                rdata <= obuffer;

                //function 0xB0
                if (rindex == 176)//176 in decimal is the5 same as B0 hex. vram pointer address bits 0-7
                begin 
                    inputNum <= obuffer;
                    writeAddress[0] <= obuffer[0];
                    writeAddress[1] <= obuffer[1];
                    writeAddress[2] <= obuffer[2];
                    writeAddress[3] <= obuffer[3];
                    writeAddress[4] <= obuffer[4];
                    writeAddress[5] <= obuffer[5];
                    writeAddress[6] <= obuffer[6];
                    writeAddress[7] <= obuffer[7];
                    //ivalid <= 0;    //this is not an input command
                end

                if (rindex == 177)  //probably 0xB1 when converted to hex. vram pointer address bits 8-15
                begin
                    outputNum <= obuffer;
                    writeAddress[8] <= obuffer[0];
                    writeAddress[9] <= obuffer[1];
                    writeAddress[10] <= obuffer[2];
                    writeAddress[11] <= obuffer[3];
                    writeAddress[12] <= obuffer[4];
                    writeAddress[13] <= obuffer[5];
                    writeAddress[14] <= obuffer[6];
                    writeAddress[15] <= obuffer[7];
                    //ivalid <= 0;    //this is not an input command
                end

                if (rindex == 178)  //register 0xB2. vram pointer address bits 16-24 (on this system only bits 16-19 are used)
                begin
                    testResult <= obuffer;
                    writeAddress[16] <= obuffer[0];
                    writeAddress[17] <= obuffer[1];
                    writeAddress[18] <= obuffer[2];
                    writeAddress[19] <= obuffer[3];
                    //ivalid <= 0;    //this is not an input command
                    //writeAddress[20] = obuffer[4];
                    //writeAddress[21] = obuffer[5];
                    //writeAddress[22] = obuffer[6];
                    //1writeAddress[23] = obuffer[7];
                end

                if (rindex == 179)  //register 0xB3. control register. bit 0 low means test mode. bit 0 high means display contents of vram
                begin
                    control_register <= obuffer;
                    //ivalid <= 0;    //this is not an input command
                end

                if (rindex == 180)
                begin
                    if (!step)
                    begin
                    inputPixel[0] <= obuffer[0];
                    inputPixel[1] <= obuffer[1];
                    inputPixel[2] <= obuffer[2];
                    inputPixel[3] <= obuffer[3];
                    inputPixel[4] <= obuffer[4];
                    inputPixel[5] <= obuffer[5];
                    inputPixel[6] <= obuffer[6];
                    inputPixel[7] <= obuffer[7];
                    //ivalid <= 0;    //this is not an input command
                    step <= 1;
                    dataorindex <= 1;
                    end else if (step)
                    begin
                        inputPixel[8] <= obuffer[0];
                        inputPixel[9] <= obuffer[1];
                        inputPixel[10] <= obuffer[2];
                        inputPixel[11] <= obuffer[3];
                        inputPixel[12] <= obuffer[4];
                        inputPixel[13] <= obuffer[5];
                        inputPixel[14] <= obuffer[6];
                        inputPixel[15] <= obuffer[7];
                        //ivalid <= 0;    //this is not an input command
                        step <= 0;
                        byteToCopy <= 1;
                        dataorindex <= 0;
                        writeAddress <= writeAddress + 2;
                        status_register[5] <= 1;    //the single-pixel output buffer is full. set input buffer bit to 1
                    end

                end
        //you have to do things a little differently for recieve commands
        end else if (rindex == 128 & ~byteToCopy)
        begin
            debugDid <= 1;
            ibuffer <= status_register;
        end

        else if (byteToCopy/* & byteCopied*/ & ~bus_free)
        begin
            //if the word copy operation completed sucessfully, deassert the byte copy signal
            byteToCopy <= 0;
            status_register[5] <= 0;//the single-pixel output buffer is no longer full. set input buffer bit to 0
        end
    end


endmodule