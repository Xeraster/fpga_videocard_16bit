/*the fpga tries to maintain a buffer of a certain number of bytes ahead of when each byte should be copied to the screen
address decoding requires that the fpga stops copying from ram, so its good to have a buffer
*/
module managedVramDataBuffer(
    input[15:0] dataInputBus,       //the input from vram during buffer fill cycles
    //output[15:0] dataBusOutput,     //the output for the vga signal. i think. output whatever is in the fifo buffer for being drawn to the screen
    output[4:0] Ri,
    output[5:0] Gi,
    output[4:0] Bi,
    output readSignal,              //CY7C1049 series sram chip RD and CE. Shoot for single-clock address transition controlled read cycles.
    output chipEnable,              //CY7C1049 chip enable
    input clock,                    //what clock to run this on. typically faster than pixel clock. 1024x768 is expected to work with a 65mhz pixel clock and 65mhz fpga clock because 1024x768 will only be 1 byte per pixel (on this version of the video card at least)
    output done,                    //1 if finished. 0 if busy
    input bus_free,                 //0 if the bus isn't being used by something. 1 if the bus is currently being used by something\
    input vblank,                   //0 if there is supposed to be a vblank (no new pixels being copied to screen). 1 if there is supposed to be pixel data sent to the screen. needs to be asserted exactly 2 pixelClock cycles before color data is supposed to be on the bus
    input empty,                    //1 if the fifo buffer is empty
    input full,                     //1 if the fifo buffer is full, 0 if not full
    input valid,                    //1 if the fifo buffer contains at least 1 word of valid data, 0 if the only data it can output is invalid
    output fifoWrite,               //1 when writing to fifo, 0 when not writing
    output fifoRead,                //1 when reading from fifo, 0 when not reading
    output[19:0] nextVramAddress,   //the address of whatever the next byte in vram this thing wants to load is
    input[19:0] maxVramAddress,     //the vram address at which to rollover to 0
    input RESET,
    input pixelClock,               //use the pixel clock to determine when to go to the next byte
    input[15:0] fifoDataOut,               //whatever the output side of the fifo is, put it in this
    output frameEnd,                 //1 if this module thinks its on or beyond the last vram address for the current frame. 0 if this module thinks its in the correct vram address
    input almostFull                //1 if almost full, 0 if not almost full
);

    reg ireadSignal, ichipEnable, ififoWrite, ififoRead;
    reg[19:0] iNextVramAddress;
    reg[15:0] iDataFromVram;
    reg[15:0] ipixelOutput;
    reg[19:0] pixelClockAddress;//the pixel clock address this module *thinks* its on
    reg idone;
    reg doCycle;

    assign readSignal = ireadSignal;
    assign chipEnable = ichipEnable;
    assign fifoWrite = ififoWrite;
    assign fifoRead = ififoRead;
    //assign dataBusOutput = ipixelOutput;
    assign nextVramAddress = iNextVramAddress;
    assign done = idone;

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
    assign frameEnd = iframeEnd;

    //on every rising edge of the pixel clock, get the next byte
    always@(posedge pixelClock)
    begin
        if (!RESET) begin
            pixelClockAddress <= 0;
            ipixelOutput <= 16'hFFFE;
            ififoRead <= 0;
            iframeEnd <= 1;
        end else if (vblank) begin//if vblank == 1, there is supposed to be data copied to the screen
            ipixelOutput <= fifoDataOut;
            pixelClockAddress <= pixelClockAddress + 2;
            ififoRead <= 1;
            iframeEnd <= 0;
        end else begin
            ipixelOutput <= 16'h0;
            //ififoRead <= 0;

            /*if (iframeEnd) begin
                pixelClockAddress <= 0;
            end*/
            if (maxVramAddress <= pixelClockAddress) begin
                iframeEnd <= 1;
                pixelClockAddress <= 20'hFFFFE;
            end/* else begin
                iframeEnd <= 0;
            end*/
            /* else if (vblank) begin
                iframeEnd <= 0;
            end*/
        end

    end

    always@(posedge clock)
    begin

        if (!RESET) begin
            iNextVramAddress <= 20'hFFFFE;//this is how to ensure the first valid cycle is starts the vram address at 0 and not 1
            //actually for testing purposes start it at 0

            ireadSignal <= 1;
            ichipEnable <= 1;
            ififoWrite <= 0;
            doCycle <= 0;
        end else if (frameEnd) begin //if the buffer is not completely full, try to make it full
            ireadSignal <= 1;
            ichipEnable <= 1;
            ififoWrite <= 0;
            doCycle <= 0;
            iNextVramAddress <= 20'hFFFFE;
        end else if (~full & ~bus_free & ~almostFull)  //bus free is active low. 0 = bus not being used
        begin
            //get the byte from vram
            ireadSignal <= 0;
            ichipEnable <= 0;
            iNextVramAddress <= iNextVramAddress + 2;
            doCycle <= 1;
            ififoWrite <= 1;

            /*if (iNextVramAddress >= maxVramAddress) begin
                iNextVramAddress <= 0;
            end*/
        end else begin
            ireadSignal <= 1;
            ichipEnable <= 1;
            ififoWrite <= 0;
            doCycle <= 0;
        end

        if (~full) begin
            idone <= 0;
        end else begin
            idone <= 1;
        end

    end

    //i can't afford to let this take more than 1 clock cycle under any circumstances pretty much
    always@(negedge clock)
    begin
        if (doCycle)
        begin
            iDataFromVram <= dataInputBus;
        end
    end

endmodule