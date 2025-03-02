//copies a byte to vram
module isaSlaveBusController(
    //inout[15:0] dataBus,         //the 16 bit data bus
    //inpouts and outputs are incompatible with test bench. i swear to fuck
    //input[15:0] dataBus,            //the input part of the data bus
    //output[15:0] dataOutByte,       //the output part of the data bus
    //isa slave bus controller doesn't deal with data directly

    input[19:0] addressBus,      //20 bit address bus because 1mb of ram

    output FPGA_IO_EN,          //turn the isa output bits on or off. whether or not to tell other modules to gtfo the bus, you should do (BALE | FPGA_IO_EN) if crossing clock domains probably or something
    input SBHE,                 //SBHE input from host system's ISA chipset
    input BALE,                  //bus address latch enable. this should basically just be relayed to ADS_LATCH

    output IOCS16,
    output MEMCS16,             //signals to the host system that this device can do 16 bit data cycles
    output IOERR,               //just set to 1 or something to disable
    output IO_RDY,              //set low if to insert wait states, high for no wait states
    output NOWS,                //setting this to 0 signals to the host system that this device needs no additional wait states

    output ADS_OE,              //address latch output enable
    output ADS_LATCH,           //LE pin on the address latch chips
    input MEMR,                 
    input MEMW,
    input SMEMR,
    input SMEMW,
    input IOR,
    input IOW,
    input ISA_CLK,              //The isa bus clock, technically on a different clock domain. usually 8mhz.
    
    output done,                  //1 if finished. 0 if busy

    output TE0, TE1, TE2, TE3,  //tranciever enable signals for the 74ALVC16245 chips
    output FPGA_WR,
    input FPGACLK,               //a 25mhz or 65mhz clock asynchronous from the 8mhz isa clock
    output ibufferActivate,          //iirc this does nothing. for now
    input RESET,
    input memoryCyclesEnabled       //1 for true, 0 for false. there needs to be a way to disable this so that it can be possible to run a vga card at the same time for debugging
);
    reg isyncIsaClock;
    reg syncIsaClock;//an isa clock that only goes high or low on rising edges of FPGACLK

    reg [19:0] lastAdsRequest;
    reg [15:0] lastAdsData;
    wire actualBusCycle;
    assign actualBusCycle = iactualBusCycle;    //when an isa bus cycle of either memory or io is taking place. BALE is not counted as part of the memory cycle since address latching is handled by external chips
    assign FPGA_IO_EN = BALE | ~ADS_OE | checkThisCycle;

    assign ADS_LATCH = BALE;        //ADS_LATCH is exactly BALE. I'm pretty sure this is the actual way ISA chipsets were intended to be used in the beginning anyway
    assign ADS_OE = iADS_OE;
    //assign FPGA_WR = (~SMEMW | ~MEMR | ~IOW);

    //figure out if this device is being selected?
    reg selected;

    wire BALELOCK;
    reg BALELOCK_buf;

    reg checkAddressOnNextCycleBuf;
    reg inputAddress;
    assign BALELOCK = BALELOCK_buf;
    reg checkAddressOnNextCycle;
    reg iADS_OE;
    reg completeCycle;//1 if this device is supposed to do the next isa cycle, 0 if it can sit this one out
    reg endIsaCycle;//this signal pulses for 1 fpga clock cycle after a valid device-concerning isa cycle has been completed
    reg checkThisCycle;

    assign IOERR = 1;//1 means no error
    assign NOWS = 0;//GTFO asap by asserting NOWS the entire time
    assign IO_RDY = 1;  //high means "no additional wait states"
    reg[3:0] clocksSinceBale;

    //wire timeout;
    //assign timeout = clocksSinceBale > 1;

    reg r1_Pulse, r2_Pulse, r2_Pulse;
    
    always@(posedge FPGACLK)
    begin
        /*if (ISA_CLK) begin
            isyncIsaClock <= 1;
        end else begin
            isyncIsaClock <= 0;
        end

        if (isyncIsaClock) begin
            syncIsaClock <= 1;
        end else begin
            syncIsaClock <= 0;
        end*/

        //didn't work. try this video: https://www.youtube.com/watch?v=eyNU6mn_-7g at 6:33
        //isyncIsaClock <= ISA_CLK;
        //syncIsaClock <= isyncIsaClock;
        //here is the code that was tried from video
        r1_Pulse <= ISA_CLK;
        r2_Pulse <= r1_Pulse;
        r3_Pulse <= r2_Pulse;
        if (~r3_Pulse & r2_Pulse) begin
            syncIsaClock <= 1;
        end else if (r3_Pulse & ~r2_Pulse) begin
            syncIsaClock <= 0;
        end

        if (!RESET) begin
            checkThisCycle <= 0;
            //clocksSinceBale <= 0;
            iADS_OE <= 1;
        end

        //it crosses clock domains so do a flip-flop step
        //checkAddressOnNextCycleBuf <= checkAddressOnNextCycle;
        if ((~MEMR | ~MEMW | ~SMEMR | ~SMEMW) & actualBusCycle & checkThisCycle) begin
            iADS_OE <= 0;//temporarily disable memory cycles because the test system is a socket 7 motherboard with a normal vga card that needs to work alongside this one
            //(normally this should be iADS_OE <= 0)
            checkAddressOnNextCycle <= 1;
        end else if ((~IOR | ~IOW) & actualBusCycle & checkThisCycle) begin
            iADS_OE <= 0;
            checkAddressOnNextCycle <= 1;
        end else if (clocksSinceBale > 1 & ~(~MEMR | ~MEMW | ~SMEMR | ~SMEMW | ~IOR | ~IOW)) begin
            iADS_OE <= 1;
        end

        //get the address bus contents asap and be fast about it
        if (checkAddressOnNextCycle & /*ISA_CLK*/syncIsaClock) begin
            checkAddressOnNextCycle <= 0;
            lastAdsRequest <= addressBus;
            checkThisCycle <= 0;
            //iADS_OE <= 1;//might be too soon, idk
        end

        //if this device is being selected, it has to do a bus cycle. otherwise, it can just revert back to fpga <=> vram buffering operation
        //simply consider memory cycles when memoryCyclesEnabled is set to 0 as not the right decoded address. the performance gains by doing it the other way aren't worth it
        if (lastAdsRequest >= 'hA0000 & lastAdsRequest <= 'hBFFFF & iADS_OE == 0 & (~MEMR | ~MEMW | ~SMEMR | ~SMEMW) & memoryCyclesEnabled)
        begin
            completeCycle <= 1;
        end else if ((~(lastAdsRequest >= 'hA0000 & lastAdsRequest <= 'hBFFFF) | ~memoryCyclesEnabled) & iADS_OE == 0 & (~MEMR | ~MEMW | ~SMEMR | ~SMEMW)) begin
            iADS_OE <= 1;
        end else if (lastAdsRequest >= 'h420 & lastAdsRequest <= 'h430 & iADS_OE == 0 & (~IOR | ~IOW)) begin
            completeCycle <= 1;
            /*if (~actualBusCycle) begin
                endIsaCycle <= 1;
            end else begin
                endIsaCycle <= 0;
            end*/
        end else begin
            //iADS_OE <= 1;
            if (iADS_OE == 0 & /*~(lastAdsRequest >= 'h420 & lastAdsRequest <= 'h430)*/ (IOR & IOW & MEMW & MEMR & SMEMR & SMEMW)) begin
                iADS_OE <= 1;
            end

            if (completeCycle == 1) begin
                completeCycle <= 0;
                endIsaCycle <= 1;
            end else begin
                completeCycle <= 0;
                endIsaCycle <= 0;
            end
        end

        //if this is actually an isa bus cycle that this device is involved in, do different stuff than if it isn't
        if (completeCycle) begin
            //if (SBHE) begin
                //assert IOCS16 or MEMCS16 if the host asserts SBHE
            //end
        end

        /*if (~actualBusCycle) begin
            checkThisCycle <= 1;
        end*/
        if (BALE) begin
            checkThisCycle <= 1;
            //clocksSinceBale <= 0;
        end else if (clocksSinceBale > 1 & ~(~MEMR | ~MEMW | ~SMEMR | ~SMEMW | ~IOR | ~IOW)) begin
            checkThisCycle <= 0;
        end

        //if ads is high, get the address but do it at fpga speeds and npt isa speeds because 8mhz is slow af
        /*if (checkAddressOnNextCycleBuf) begin
            inputAddress <= 1;
        end

        if (inputAddress) begin
            inputAddress <= 0;
            lastAdsRequest <= addressBus;
            BALELOCK_buf <= 0;
        end*/
    end

    reg iibufferActivate;
    reg iibufferCheck;

    //set FPGA_WR to the right value. it's ok if the state of FPGA_WR changes when there's not a isa bus cycle. FPGA_WR only ever runs if therte is a ISA memory cycle
    //for VRAM to HOST (read), set to 1. for HOST to VRAM (write), set to 0
    assign FPGA_WR = (~IOR | ~MEMR | ~SMEMR);
    //assign ibufferActivate = checkThisCycle;
    assign ibufferActivate = clocksSinceBale < 3;
    assign actualBusCycle = iactualBusCycle;
    //assign ADS_OE = inputAddress;//put the host requested address on the bus any time that it's supposed to be on the bus
    assign IOCS16 = (~IOR | ~IOW) & ~SBHE & completeCycle;   //any time the host system requests a high bus IO cycle, assert IOCS16
    assign MEMCS16 = (~MEMR | ~MEMW | ~SMEMR | ~SMEMW) & ~SBHE & completeCycle;//might be a combinational loop. could do the always block then assign relay thingy if so

    reg TE0i, TE1i, TE2i, TE3i;
    assign TE0 = TE0i;
    assign TE1 = TE1i;
    assign TE2 = TE2i;
    assign TE3 = TE3i;


    reg iactualBusCycle;
    always@(posedge /*ISA_CLK*/syncIsaClock)
    begin
        if (!RESET) begin
            clocksSinceBale <= 0;
        end else if (~FPGA_IO_EN) begin
            clocksSinceBale <= 0;
        end else if (clocksSinceBale < 6 & ADS_OE) begin
            clocksSinceBale <= clocksSinceBale + 1;
        end


        if (((~SMEMR) | (~SMEMW) | ~IOR | ~IOW | (~MEMR) | (~MEMW)) & clocksSinceBale < 3)
        begin
            iactualBusCycle <= 1;

            //figure out wtf to do about TE0-TE3 signals
            if (completeCycle) begin
                //only if completeCycle is asserted is this device supposed to do anything with the isa bus
                if (~SBHE) begin    //SBHE is active low - a 16 bit cycle
                    if (lastAdsRequest[0] == 0) begin   //if even byte aligned 16 bit cycle
                        TE0i <= 0;
                        TE1i <= 0;
                    end else begin  //if odd byte aligned 16 bit cycle
                        TE2i <= 0;
                        TE3i <= 0;
                    end
                end else begin  //if SBHE is high - an 8 bit cycle
                    if (lastAdsRequest[0] == 0) begin   //if even byte aligned 8 bit cycle
                        TE0i <= 0;   //every even byte of vram can only go on bits 0-7. That's why there are 2 74ALVC16245s
                    end else begin  //if odd byte aligned 8 bit cycle
                        TE3i <= 0;   //every odd byte of vram can only go on bits 8-15. That's why there are 2 74ALVC16245s
                    end
                end
            end else begin
                TE0i <= 1;
                TE1i <= 1;
                TE2i <= 1;
                TE3i <= 1;
            end
        end else begin
            iactualBusCycle <= 0;

            //clocksSinceBale <= 0;//this doesn't seem to cause a multiple driver warning. If this is truly valid, then it is better
            
            //if actualBysCycle is 0, these should always be trned off
            TE0i <= 1;
            TE1i <= 1;
            TE2i <= 1;
            TE3i <= 1;
        end

    end


endmodule