//copies a byte to vram but does it in a way that is compatible with the fifo I made
module managedByteToVramCopyFifo(
    input[15:0] dataToCopy,         //the 16 bit word to copy into vram
    output[15:0] dataBusOutput,     //the 16 bit data bus to output to
    output reg writeSignal,         //CY7C1049 series sram chip WE and CE. CURRENTLY DOING WE CONTROLLED WRITE CYCLES
    output reg chipEnable,
    input clock,                  //what clock to run this on.
    //input doCopy,               //instead of a copy command bit, this version queries the status of the fifo buffer
    output done,                  //1 if finished. 0 if busy
    input bus_free,                //0 if the bus is not being used by the framebuffer. 1 if the bus is being used
    input empty,                   //1 if the fifo buffer is empty. 0 if the fifo buffer is full
    input valid,                  //1 if the fifo buffer contains at least 1 word of valid data, 0 if the only data it can output is invalid
    output fifo_read               //this outputs a 1 when reading from the fifo, a 0 if no read command is to take place
);
    //assign dataBusOutput = dataToCopy; //this doesn't work, it doesn't circumvent whatever messes with the tristate buffer and makes it not work correctly for some reason
    //assign dataBusOutput = 65535;//doing this doesn't make it not disable read cycles
    reg[4:0] waitctr;//try experimenting with waitstates. update: that didnt solve any problems but im leaving it in anyway just so I can deassert writeSignal a little before chipEnable
    reg donestatus;
    assign done = donestatus;//see if this fixes THE BUG. update: it made no difference
    reg[15:0] idataBusOutput;
    reg ififo_read;
    assign fifo_read = ififo_read;
    assign dataBusOutput = idataBusOutput;
    always@(posedge clock)
    begin
        //send everything to the bus at the same time because why not
        if (~empty & valid & waitctr < 3 & ~bus_free) begin     //only probe for bus free on the first cycle since bus_free goes high early enough that it leaves time for exaclty 1 WE cycle + a small margin
            writeSignal <= 0;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= 3; //10 for testing purposes.
            idataBusOutput <= dataToCopy;
            ififo_read <= 1;     //only leave this high for 1 clock cycle, hopefully doing it on neg edge desnt cause any issues but who knows
        end
        else if (waitctr > 1)
        begin
            writeSignal <= 0;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= waitctr - 1;
            idataBusOutput <= dataToCopy;
            ififo_read <= 0;
        end
        else if (waitctr > 0)
        begin
            writeSignal <= 1;
            chipEnable <= 0;
            donestatus <= 0;//dont terminate the write cycle until the counter has had a chance to count down
            waitctr <= waitctr - 1;
            idataBusOutput <= dataToCopy;
            ififo_read <= 0;
        end
        else/* if (doCopy)*/
        begin
            writeSignal <= 1;
            chipEnable <= 1;
            donestatus <= 1;    //done. set to 1 to tristate the data bus and also deassert the chip write and select signals
            idataBusOutput <= 0; //IMPORTANT: for some reason you have to set this to zero when not in use or else it causes problems
            ififo_read <= 0;
            waitctr <= 0;
        end
    end

endmodule