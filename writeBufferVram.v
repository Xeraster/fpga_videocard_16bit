`include "new_fifo/TOP.V"
`include "new_fifo/sync_r2w.v"
`include "new_fifo/syncw2r.v"
`include "new_fifo/fifo_memory.v"
`include "new_fifo/r_pointer_epty.v"
`include "new_fifo/w_ptr_wfull.v"

module writeBufferVram(
    input[15:0] dataFromIsa,
    input[19:0] addressFromIsa,
    input newData,  //on the rising edge of this signal, there is new isa bus data that needs to be copied to the write buffer
    output[15:0] dataOut,           //what tocopy to vram when its vram writing time
    output[19:0] addressToWrite,     //what memory address to use when its vram copying time
    output write_cmd,               //WE for vram, active low
    output chip_select,             //CE for vram, active low
    input free,                     //1 if the bus is available for this module to do its thing, 0 if back off
    input clock,                     //what clock to use, should *probably* be the fast clock
    input RESET,
    output WRITEBUF_IO_EN,           //1 if this module is using the bus, 0 if 
    output full,
    output almostFull,
    output empty
);

assign write_cmd = iwrite_cmd;
assign chip_select = ichip_select;
assign WRITEBUF_IO_EN = iWRITEBUF_IO_EN;

reg ififoWrite;
reg ififoRead;
reg iWRITEBUF_IO_EN;
reg iwrite_cmd, ichip_select;
reg ialmostFull, ialmostEmpty;
assign almostFull = ialmostFull;
assign empty = ialmostEmpty;
//assign full = dFull;

//it ISNT possible to implement an "almost full" output into this/any fifo. This REALLY fucks things up but maybe there's a way to make an external one here
reg [7:0] readCtr;
reg [7:0] writeCtr;
reg [7:0] diff;
reg [7:0] fullAmt, emptyAmt;

always@(posedge newData or negedge RESET) begin
    if (!RESET) begin
        writeCtr <= 0;
    end else begin
        writeCtr <= writeCtr + 1;
    end
end


always@(posedge clock) begin
    if (!RESET) begin
        //initialize all the reset values
        ialmostFull <= 0;
        readCtr <= 0;
    end

    if (free & ~dEmpty) begin
        ififoRead <= 1;
        iWRITEBUF_IO_EN <= 1;
        iwrite_cmd <= 0;
        ichip_select <= 0;
        readCtr <= readCtr + 1;

    end else begin
        ififoRead <= 0;
        iWRITEBUF_IO_EN <= 0;
        iwrite_cmd <= 1;
        ichip_select <= 1;
        //internal_read_r1 <=0;
    end


    fullAmt <= (writeCtr - readCtr);
    emptyAmt <= (readCtr - writeCtr);
    ialmostFull <= fullAmt < 7;
    ialmostEmpty <= emptyAmt > 250;

end

wire dFull, dEmpty;
wire aFull, aEmpty;

//psuedofiforam_new dataFifo(dataFromIsa, 1'b1, ififoRead, newData, dataOut, RESET, dFull, dEmpty, dValid, dAlmostFull);
//psuedofiforam_new_20bit addressFifo(addressFromIsa, 1'b1, ififoRead, newData, addressToWrite, RESET, aFull, aEmpty, aValid, aAlmostFull);

async_fifo1 dataFifo(/*ififoWrite*/1'b1, newData, RESET, ififoRead, clock, RESET, dataFromIsa, dataOut, full, dEmpty);
async_fifo20 addressFifo(/*ififoWrite*/1'b1, newData, RESET, ififoRead, clock, RESET, addressFromIsa, addressToWrite, aFull, aEmpty);

endmodule