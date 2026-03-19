// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vvideo.h for the primary calling header

#ifndef VERILATED_VVIDEO___024ROOT_H_
#define VERILATED_VVIDEO___024ROOT_H_  // guard

#include "verilated.h"


class Vvideo__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vvideo___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_OUT8(HSYNC,0,0);
        VL_IN8(pllclk,0,0);
        VL_IN8(RESET,0,0);
        VL_OUT8(pixelClock,0,0);
        VL_OUT8(VSYNC,0,0);
        VL_OUT8(Red,4,0);
        VL_OUT8(Green,5,0);
        VL_OUT8(Blue,4,0);
        VL_OUT8(VALID_PIXELS,0,0);
        VL_IN8(BALE,0,0);
        VL_IN8(MEMW,0,0);
        VL_IN8(MEMR,0,0);
        VL_IN8(SMEMR,0,0);
        VL_IN8(SMEMW,0,0);
        VL_IN8(IOW,0,0);
        VL_IN8(IOR,0,0);
        VL_IN8(SBHE,0,0);
        VL_OUT8(NOWS,0,0);
        VL_OUT8(IOCS16,0,0);
        VL_OUT8(MEMCS16,0,0);
        VL_OUT8(IO_RDY,0,0);
        VL_OUT8(IOERR,0,0);
        VL_IN8(ISACLK,0,0);
        VL_OUT8(TE0,0,0);
        VL_OUT8(TE1,0,0);
        VL_OUT8(TE2,0,0);
        VL_OUT8(TE3,0,0);
        VL_OUT8(FPGA_WR,0,0);
        VL_OUT8(ADS_OE,0,0);
        VL_OUT8(ADS_LATCH,0,0);
        VL_OUT8(VRAM_en,0,0);
        VL_OUT8(write_cmd,0,0);
        VL_OUT8(read_cmd,0,0);
        CData/*4:0*/ video__DOT__Rt;
        CData/*5:0*/ video__DOT__Gt;
        CData/*4:0*/ video__DOT__Bt;
        CData/*4:0*/ video__DOT__iRed;
        CData/*5:0*/ video__DOT__iGreen;
        CData/*4:0*/ video__DOT__iBlue;
        CData/*0:0*/ video__DOT__ivblank;
        CData/*7:0*/ video__DOT__videoDisplayRegister;
        CData/*7:0*/ video__DOT__settingsRegister;
        CData/*7:0*/ video__DOT__statusRegister;
        CData/*0:0*/ video__DOT__alreadyIncrementedAdsPtr;
        CData/*0:0*/ video__DOT__writeBufferEmpty;
        CData/*0:0*/ video__DOT____Vcellinp__wbv____pinNumber9;
        CData/*0:0*/ video__DOT__gtfoonnextclock;
        CData/*0:0*/ video__DOT__doData;
        CData/*0:0*/ video__DOT__full;
        CData/*7:0*/ video__DOT__alreadyWrote;
        CData/*0:0*/ video__DOT__iread_cmd;
        CData/*0:0*/ video__DOT__iwrite_cmd;
        CData/*0:0*/ video__DOT__iVRAM_en;
        CData/*0:0*/ video__DOT__vsyncctr;
        CData/*0:0*/ video__DOT____Vcellinp__testramthingy____pinNumber8;
        CData/*0:0*/ video__DOT__gs__DOT__HSYNC;
        CData/*0:0*/ video__DOT__gs__DOT__VSYNC;
        CData/*0:0*/ video__DOT__gs__DOT__VALID_H;
        CData/*0:0*/ video__DOT__gs__DOT__VALID_V;
        CData/*0:0*/ video__DOT__wbv__DOT__ififoRead;
        CData/*0:0*/ video__DOT__wbv__DOT__iWRITEBUF_IO_EN;
        CData/*0:0*/ video__DOT__wbv__DOT__iwrite_cmd;
        CData/*0:0*/ video__DOT__wbv__DOT__ichip_select;
        CData/*0:0*/ video__DOT__wbv__DOT__aEmpty;
    };
    struct {
        CData/*7:0*/ video__DOT__wbv__DOT__dataFifo__DOT__r_ptr;
        CData/*7:0*/ video__DOT__wbv__DOT__dataFifo__DOT__w_ptr;
        CData/*0:0*/ video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en;
        CData/*0:0*/ video__DOT__wbv__DOT__dataFifo__DOT__ialmostFull;
        CData/*0:0*/ video__DOT__wbv__DOT__dataFifo__DOT__ifull;
        CData/*7:0*/ video__DOT__wbv__DOT__addressFifo__DOT__r_ptr;
        CData/*7:0*/ video__DOT__wbv__DOT__addressFifo__DOT__w_ptr;
        CData/*0:0*/ video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en;
        CData/*0:0*/ video__DOT__wbv__DOT__addressFifo__DOT__ifull;
        CData/*0:0*/ video__DOT__isathing__DOT__i_undedicedIsaCycle;
        CData/*0:0*/ video__DOT__isathing__DOT__r1_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__r2_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__r3_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__absIOR;
        CData/*0:0*/ video__DOT__isathing__DOT__absIOW;
        CData/*0:0*/ video__DOT__isathing__DOT__fastBALE;
        CData/*0:0*/ video__DOT__isathing__DOT__iADS_OE;
        CData/*0:0*/ video__DOT__isathing__DOT__iFPGA_IO_EN;
        CData/*0:0*/ video__DOT__isathing__DOT__actualBusCycle;
        CData/*0:0*/ video__DOT__isathing__DOT__TE0i;
        CData/*0:0*/ video__DOT__isathing__DOT__TE1i;
        CData/*0:0*/ video__DOT__isathing__DOT__TE2i;
        CData/*0:0*/ video__DOT__isathing__DOT__TE3i;
        CData/*2:0*/ video__DOT__isathing__DOT__isahighctr;
        CData/*2:0*/ video__DOT__isathing__DOT__isacyclessincebale;
        CData/*0:0*/ video__DOT__isathing__DOT__ISACLKSTATE;
        CData/*0:0*/ video__DOT__isathing__DOT__IOW1_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__IOW2_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__IOW3_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__IOR1_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__IOR2_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__IOR3_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__BALE1_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__BALE2_Pulse;
        CData/*0:0*/ video__DOT__isathing__DOT__BALE3_Pulse;
        CData/*0:0*/ video__DOT__testramthingy__DOT__ireadSignal;
        CData/*0:0*/ video__DOT__testramthingy__DOT__ichipEnable;
        CData/*0:0*/ video__DOT__testramthingy__DOT__ififoWrite;
        CData/*0:0*/ video__DOT__testramthingy__DOT__ififoRead;
        CData/*0:0*/ video__DOT__testramthingy__DOT__iframeEnd;
        CData/*0:0*/ video__DOT__testramthingy__DOT__fastFrameEnd;
        CData/*4:0*/ video__DOT__testramthingy__DOT__delayBeforeWriteAgain;
        CData/*0:0*/ video__DOT__testramthingy__DOT__fastEvenOrOdd;
        CData/*0:0*/ video__DOT__testramthingy__DOT__r1_Pulse;
        CData/*0:0*/ video__DOT__testramthingy__DOT__r2_Pulse;
        CData/*0:0*/ video__DOT__testramthingy__DOT__r3_Pulse;
        CData/*0:0*/ video__DOT__testramthingy__DOT__alreadySubtracted;
        CData/*0:0*/ __Vdly__video__DOT__vsyncctr;
        CData/*0:0*/ __VdlySet__video__DOT__testramthingy__DOT__b1__DOT__mem__v0;
        CData/*0:0*/ __VdlySet__video__DOT__testramthingy__DOT__b2__DOT__mem__v0;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VicoFirstIteration;
        CData/*0:0*/ __Vtrigprevexpr___TOP__HSYNC__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__pllclk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__RESET__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__pixelClock__0;
        CData/*0:0*/ __VactContinue;
        VL_OUT16(horizontalCount,10,0);
        VL_OUT16(verticalCount,9,0);
        VL_OUT16(data_out,15,0);
        VL_IN16(data_in,15,0);
        SData/*15:0*/ video__DOT__data_outi;
        SData/*15:0*/ video__DOT__nextThingToWrite;
        SData/*15:0*/ video__DOT__writeBufferVramData;
    };
    struct {
        SData/*15:0*/ video__DOT__DStxresult;
        SData/*15:0*/ video__DOT__testramthingy__DOT__ipixelOutput;
        SData/*9:0*/ video__DOT__testramthingy__DOT__waddr;
        SData/*9:0*/ video__DOT__testramthingy__DOT__raddr;
        SData/*15:0*/ video__DOT__testramthingy__DOT__b1dout;
        SData/*15:0*/ video__DOT__testramthingy__DOT__b2dout;
        SData/*10:0*/ __Vdly__horizontalCount;
        SData/*9:0*/ __Vdly__verticalCount;
        SData/*15:0*/ __VdlyVal__video__DOT__testramthingy__DOT__b1__DOT__mem__v0;
        SData/*9:0*/ __VdlyDim0__video__DOT__testramthingy__DOT__b1__DOT__mem__v0;
        SData/*15:0*/ __VdlyVal__video__DOT__testramthingy__DOT__b2__DOT__mem__v0;
        SData/*9:0*/ __VdlyDim0__video__DOT__testramthingy__DOT__b2__DOT__mem__v0;
        VL_OUT(AV,19,0);
        VL_IN(AV_in,19,0);
        IData/*19:0*/ video__DOT__vramAddress;
        IData/*19:0*/ video__DOT__AVi;
        IData/*23:0*/ video__DOT__addressComReg;
        IData/*19:0*/ video__DOT__writeBufferVramAddress;
        IData/*19:0*/ video__DOT__lastAdsRequest;
        IData/*27:0*/ video__DOT__cdd__DOT__counter;
        IData/*19:0*/ video__DOT__isathing__DOT__lastAdsRequest;
        IData/*19:0*/ video__DOT__testramthingy__DOT__iNextVramAddress;
        IData/*31:0*/ __VactIterCount;
        VlUnpacked<SData/*15:0*/, 256> video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem;
        VlUnpacked<IData/*19:0*/, 256> video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem;
        VlUnpacked<SData/*15:0*/, 1024> video__DOT__testramthingy__DOT__b1__DOT__mem;
        VlUnpacked<SData/*15:0*/, 1024> video__DOT__testramthingy__DOT__b2__DOT__mem;
    };
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<4> __VactTriggered;
    VlTriggerVec<4> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vvideo__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vvideo___024root(Vvideo__Syms* symsp, const char* v__name);
    ~Vvideo___024root();
    VL_UNCOPYABLE(Vvideo___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
