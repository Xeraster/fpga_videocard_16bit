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
    output actual_bus_cycle,             //does nothing for now
    input RESET,
    input memoryCyclesEnabled,       //1 for true, 0 for false. there needs to be a way to disable this so that it can be possible to run a vga card at the same time for debugging
    output undecidedIsaCycle        //1 if there is a pending ISA cycle. 0 if there is not a pending ISA cycle
);
    reg i_undedicedIsaCycle;
    assign undecidedIsaCycle = i_undedicedIsaCycle;

    assign MEMCS16 = 1;
    //assign IOCS16 = iIOCS16;
    assign IOCS16 = SBHE;

    assign IOERR = 1;//1 means no error
    assign NOWS = 0;//GTFO asap by asserting NOWS the entire time
    assign IO_RDY = 1;  //high means "no additional wait states"

    //BALE just happens to be the exact signal that latches the address just the right way
    assign ADS_LATCH = BALE;
    assign FPGA_WR = (~absIOR/* | ~absMEMR | ~absSMEMR*/);

    //synchronize the stupid fucking isa clock and don't even bother to use it directly BECAUSE CLOCK DOMAIN CROSSINGS FUCKING SUCK
    reg r1_Pulse, r2_Pulse, r3_Pulse;

    reg fastIOR, fastIOW, fastSMEMR, fastSMEMW, fastMEMR, fastMEMW;
    reg absIOR, absIOW, absSMEMR, absSMEMW, absMEMR, absMEMW;       //absX are masked as long as BALE is high - this avoids the device having to decode those pesky DRAM refresh cycles, saving precious bandwidth
    reg fastBALE;
    reg fastSBHE;
    reg mio;//same as 486 M/IO pin. memory cycle = 1. I/O cycle = 0
    reg wr;//same as 486 W/R pin. read = 0. write = 1.
    reg anyCycle;   //1 if SMEMR, SMEMW, MEMR, MEMW, IOR, IOW indicate there is a bus cycle, 0 if there is not one
    reg iIOCS16;
    reg iADS_OE;
    assign ADS_OE = iADS_OE;
    reg iFPGA_IO_EN;//I'm taking a different approach to handling this this time around
    assign FPGA_IO_EN = iFPGA_IO_EN/* | FPGA_IO_WAITCTR > 0*/;

    reg [19:0] lastAdsRequest;
    reg needToDecode;       //1 if there is a pending decode. 0 if no decode onteh next clock cycle
    reg actualBusCycle;

    assign actual_bus_cycle = actualBusCycle;

    //tranciever enable signals
    reg TE0i, TE1i, TE2i, TE3i;
    assign TE0 = TE0i;
    assign TE1 = TE1i;
    assign TE2 = TE2i;
    assign TE3 = TE3i;

    reg[2:0] FPGA_IO_WAITCTR;//waitstating FPGA_IO_EN for a clock cycle or two after its supposed to go low is a thing i have not tried yet
    reg waitAlreadySet;//this didn't improve or mess up anything. fuck. no difference.

    reg[3:0] stupidCtr;//sequential logic doesn't work the way i thought it did so i'll do my own sequential logic with blackjack and hookers and use this counter to run it
    reg[2:0] isahighctr;
    reg[2:0] isalowwaitctr;

    reg[1:0] baleassertctr;
    reg[2:0] isacyclessincebale;

    reg ISACLKSTATE;//yet another experiment with the isa clock that probably wont make a difference but im running out of ideas
    //maybe each important signal should have this done individually
    reg IOW1_Pulse, IOW2_Pulse, IOW3_Pulse;
    reg IOR1_Pulse, IOR2_Pulse, IOR3_Pulse;
    reg BALE1_Pulse, BALE2_Pulse, BALE3_Pulse;

    //worth a fuckin' try
    reg MEMW1_Pulse, MEMW2_Pulse, MEMW3_Pulse;
    reg MEMR1_Pulse, MEMR2_Pulse, MEMR3_Pulse;
    reg SMEMW1_Pulse, SMEMW2_Pulse, SMEMW3_Pulse;
    reg SMEMR1_Pulse, SMEMR2_Pulse, SMEMR3_Pulse;

    //im starting all the way the fuck over. fuck this shit
    always@(posedge FPGACLK) begin
        /*if (FPGA_IO_WAITCTR > 0) begin
            FPGA_IO_WAITCTR <= FPGA_IO_WAITCTR - 1;
        end*/

        if (!RESET) begin
            needToDecode <= 0;
            actualBusCycle <= 0;
            iFPGA_IO_EN <= 0;
            iADS_OE <= 1;
            stupidCtr <= 0;
            iIOCS16 <= 1;//pretty sure this is active low
            waitAlreadySet <= 1;
            FPGA_IO_WAITCTR <= 0;

            isahighctr <= 3;
            isalowwaitctr <= 3;

            lastAdsRequest <= 20'h0;

            baleassertctr <= 3;

            isacyclessincebale <= 0;

            absIOR <= 1;
            absIOW <= 1;
            fastBALE <= 0;
        end

        r1_Pulse <= ISA_CLK;
        r2_Pulse <= r1_Pulse;
        r3_Pulse <= r2_Pulse;

        IOW1_Pulse <= IOW;
        IOW2_Pulse <= IOW1_Pulse;
        IOW3_Pulse <= IOW2_Pulse;

        IOR1_Pulse <= IOR;
        IOR2_Pulse <= IOR1_Pulse;
        IOR3_Pulse <= IOR2_Pulse;

        BALE1_Pulse <= BALE;
        BALE2_Pulse <= BALE1_Pulse;
        BALE3_Pulse <= BALE2_Pulse;

        SMEMW1_Pulse <= SMEMW;
        SMEMW2_Pulse <= SMEMW1_Pulse;
        SMEMW3_Pulse <= SMEMW2_Pulse;

        SMEMR1_Pulse <= SMEMR;
        SMEMR2_Pulse <= SMEMR1_Pulse;
        SMEMR3_Pulse <= SMEMR2_Pulse;

        MEMW1_Pulse <= MEMW;
        MEMW2_Pulse <= MEMW1_Pulse;
        MEMW3_Pulse <= MEMW2_Pulse;

        MEMR1_Pulse <= MEMR;
        MEMR2_Pulse <= MEMR1_Pulse;
        MEMR3_Pulse <= MEMR2_Pulse;

        //fastBALE <= BALE;
        //absIOR <= IOR;
        //absIOW <= IOW;
        if (~r3_Pulse & r2_Pulse) begin 
            ISACLKSTATE <= 1;
        end else if (r3_Pulse & ~r2_Pulse) begin
            ISACLKSTATE <= 0;
        end

        if (~IOW3_Pulse & IOW2_Pulse) begin 
            absIOW <= 1;
        end else if (IOW3_Pulse & ~IOW2_Pulse) begin
            absIOW <= 0;
        end

        //io cycle sync. still not 100% sure if this is the way to go
        if (~IOR3_Pulse & IOR2_Pulse) begin 
            absIOR <= 1;
        end else if (IOR3_Pulse & ~IOR2_Pulse) begin
            absIOR <= 0;
        end

        if (~BALE3_Pulse & BALE2_Pulse) begin 
            fastBALE <= 1;
        end else if (BALE3_Pulse & ~BALE2_Pulse) begin
            fastBALE <= 0;
        end

        //memory cycle signal sync. i dont know if this will help anything
        if (~MEMW3_Pulse & MEMW2_Pulse) begin 
            absMEMW <= 1;
        end else if (MEMW3_Pulse & ~MEMW2_Pulse) begin
            absMEMW <= 0;
        end

        if (~MEMR3_Pulse & MEMR2_Pulse) begin 
            absMEMR <= 1;
        end else if (MEMR3_Pulse & ~MEMR2_Pulse) begin
            absMEMR <= 0;
        end

        if (~SMEMW3_Pulse & SMEMW2_Pulse) begin 
            absSMEMW <= 1;
        end else if (SMEMW3_Pulse & ~SMEMW2_Pulse) begin
            absSMEMW <= 0;
        end

        if (~SMEMR3_Pulse & SMEMR2_Pulse) begin 
            absSMEMR <= 1;
        end else if (SMEMR3_Pulse & ~SMEMR2_Pulse) begin
            absSMEMR <= 0;
        end

        //stuff that is normally supposed to happen on the rising edge of the isa clock shouldbe inside this
        //doesnt seem to avoid any problems. time for a different approach i guess
        //if ((~r3_Pulse & r2_Pulse) | (r3_Pulse & ~r2_Pulse)) begin//its too slow to not do on the rising and falling edge
            //memory or io cycles only count is BALE is low. This device is to give zero fucks about any ISA cycles generated while the host is not the bus master
            //absIOR <= IOR | BALE;
            //absIOW <= IOW | BALE;
            //absSMEMR <= SMEMR | BALE;
            //absSMEMW <= SMEMW | BALE;
            //absMEMR <= MEMR | BALE;
            //absMEMW <= MEMW | BALE;

            //fastSBHE <= SBHE; //sample SBHE on rising edge of isa clock should be enough
            //fastBALE <= BALE;

            //wr <= IOW & MEMW & SMEMW;
            //mio <= ~MEMW | ~MEMR | ~SMEMW | ~SMEMW;

            /*if (~fastSBHE) begin
                iIOCS16 <= 0;
            end else begin
                iIOCS16 <= 1;
            end*/

        //end

        /*if (~SBHE) begin
            iIOCS16 <= 0;
        end else begin
            iIOCS16 <= 1;
        end*/

        if (isahighctr < 1 & ISACLKSTATE)
        begin
            //absIOR <= IOR | BALE;
            //absIOW <= IOW | BALE;
            //absSMEMR <= SMEMR | BALE;
            //absSMEMW <= SMEMW | BALE;
            //absMEMR <= MEMR | BALE;
            //absMEMW <= MEMW | BALE;
            fastSBHE <= SBHE; //sample SBHE on rising edge of isa clock should be enough

            wr <= IOW & MEMW & SMEMW;
            mio <= ~MEMW | ~MEMR | ~SMEMW | ~SMEMW;

            /*if (~fastSBHE) begin
                iIOCS16 <= 0;
            end else begin
                iIOCS16 <= 1;
            end*/

        end else if (ISACLKSTATE) begin
            isahighctr <= isahighctr - 1;
        end else begin
            isahighctr <= 3;
        end

        //treat BALE like a standalone asynchronous signal that has to be clock domain cross de-fucked seperately
        /*if (~b3_Pulse & b2_Pulse) begin
            fastBALE <= 1;//FPGACLK compatible BALE signal
        end else if (b3_Pulse & ~b2_Pulse) begin
            fastBALE <= 0;//FPGACLK compatible BALE signal

            //the falling edge of BALE means there's an address cycle I guess
        end*/

        //when BALE is low and the respective select line is low, output low.
        /*absIOR <= fastIOR | fastBALE;
        absIOW <= fastIOW | fastBALE;
        absSMEMR <= fastSMEMR | fastBALE;
        absSMEMW <= fastSMEMW | fastBALE;
        absMEMR <= fastMEMR | fastBALE;
        absMEMW <= fastMEMW | fastBALE;*/

        //the address has to be fetched while BALE is high because the host system needs the IOC16 signal sooner than after ADS_OE. some isa devices assert IOCS16 rising edge of BALE for some stupid reason
        if (fastBALE & baleassertctr > 0) 
        begin
            i_undedicedIsaCycle <= 1;
            baleassertctr <= baleassertctr - 1;
            iADS_OE <= 1;
        end else if (fastBALE & baleassertctr < 1)
        begin
            i_undedicedIsaCycle <= 1;
            //ADS_OE and hurry up about it
            iADS_OE <= 0;   //get the address. while BALE Is still high
            lastAdsRequest <= addressBus;
        end else if (~fastBALE)
        begin
            baleassertctr <= 3;
            iADS_OE <= 1;
        end

        /*if ((~IOW & ~BALE) | (~IOR & ~BALE)) begin
            if (stupidCtr == 0) begin
                stupidCtr <= 4;
                iFPGA_IO_EN <= 1;
                waitAlreadySet <= 0;
            end else if (stupidCtr == 3) begin
                iADS_OE <= 0;//give things time to back off te bus
            end else if (stupidCtr == 2) begin
                lastAdsRequest <= addressBus;
            end else if (stupidCtr == 1) begin
               iADS_OE <= 1;
               needToDecode <= 1; 
            end

            if (stupidCtr > 1) begin
                stupidCtr <= stupidCtr - 1;
            end
        end else begin
            needToDecode <= 0;
            actualBusCycle <= 0;

            iFPGA_IO_EN <= 0;
            waitAlreadySet <= 1;
            if (~waitAlreadySet) begin
                FPGA_IO_WAITCTR <= 3;
            end

            //huh, i wasnt doing this. oh well.
            lastAdsRequest <= 20'h0;

            stupidCtr <= 0;
        end*/

        /*if (needToDecode) begin
            needToDecode <= 0;
            if (lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430 & ~mio & (~IOR | ~IOW) & ~BALE) begin//its fucking bullshit i have to add those extra condition. why the fuck is it not respecting my logic
                actualBusCycle <= 1;
            end else begin
                iFPGA_IO_EN <= 0;//the end of the isa cycle. the isa controller no longer owns the bus
                waitAlreadySet <= 1;

                if (~waitAlreadySet) begin
                    FPGA_IO_WAITCTR <= 3;
                end
            end
        end*/
        //if (lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430 /*& ~mio*/ & ((~IOR | ~IOW) | (MEMR & MEMW & SMEMR & SMEMW & isacyclessincebale < 2)) & ~BALE) begin
        if (lastAdsRequest >= 20'h420 & lastAdsRequest <= 20'h430 /*& ~mio*/ & ((~absIOR | ~absIOW) | (absMEMR & absMEMW & absSMEMR & absSMEMW & isacyclessincebale < 2)) & ~fastBALE) begin
            actualBusCycle <= 1;
            //if (FPGA_IO_WAITCTR < 1) begin
                iFPGA_IO_EN <= 1;
                i_undedicedIsaCycle <= 0;//this isa cycle is no longer undecided but is has to be delayed before going low again because reasons
            //end else begin
            //    FPGA_IO_WAITCTR <= FPGA_IO_WAITCTR - 1;
            //end
        end else begin
            iFPGA_IO_EN <= 0;
            actualBusCycle <= 0;
            FPGA_IO_WAITCTR <= 3;

            //has the potential to be fucky due to clock domain
            //if (~BALE & r3_Pulse & ~r2_Pulse) begin//if bale is low and isa clock is doing a high-to-low transition
            //    i_undedicedIsaCycle <= 0;
            //end
            //if (~ISA_CLK & isacyclessincebale > 1) begin
            if (~ISACLKSTATE & isacyclessincebale > 1) begin
                i_undedicedIsaCycle <= 0;
            end
        end

        if (fastBALE) begin
            isacyclessincebale <= 0;
        end
        else if (!fastBALE & ((~r3_Pulse & r2_Pulse) | (r3_Pulse & ~r2_Pulse)) & isacyclessincebale < 6) begin
            isacyclessincebale <= isacyclessincebale + 1;
        end


        if (/*(~absIOR & ~fastBALE) | (~absIOW & ~fastBALE)*/ (~absIOR & ~fastBALE) | (~absIOW & ~fastBALE))//not sure which is better, it generally behaves the same way with both methods
        begin

            //figure out wtf to do about TE0-TE3 signals
            if (actualBusCycle) begin
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

            //clocksSinceBale <= 0;//this doesn't seem to cause a multiple driver warning. If this is truly valid, then it is better
            
            //if actualBysCycle is 0, these should always be trned off
            TE0i <= 1;
            TE1i <= 1;
            TE2i <= 1;
            TE3i <= 1;
        end

    end

endmodule