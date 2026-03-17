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
    VL_IN8(pllclk,0,0);
    VL_IN8(RESET,0,0);
    VL_OUT8(pixelClock,0,0);
    VL_IN8(a,0,0);
    VL_IN8(b,0,0);
    VL_OUT8(HSYNC,0,0);
    VL_OUT8(VSYNC,0,0);
    VL_OUT8(c,0,0);
    VL_OUT8(d,0,0);
    VL_OUT8(Rt,4,0);
    VL_OUT8(Gt,5,0);
    VL_OUT8(Bt,4,0);
    VL_OUT8(VALID_PIXELS,0,0);
    CData/*0:0*/ video__DOT__gs__DOT__VALID_H;
    CData/*0:0*/ video__DOT__gs__DOT__VALID_V;
    CData/*0:0*/ __Vtrigprevexpr___TOP__pllclk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__RESET__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__pixelClock__0;
    CData/*0:0*/ __VactContinue;
    VL_OUT16(horizontalCount,10,0);
    VL_OUT16(verticalCount,9,0);
    SData/*10:0*/ __Vdly__horizontalCount;
    SData/*9:0*/ __Vdly__verticalCount;
    IData/*19:0*/ video__DOT__vramAddress;
    IData/*27:0*/ video__DOT__cdd__DOT__counter;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

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
