// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvideo.h for the primary calling header

#include "Vvideo__pch.h"
#include "Vvideo___024root.h"

void Vvideo___024root___ico_sequent__TOP__0(Vvideo___024root* vlSelf);

void Vvideo___024root___eval_ico(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_ico\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        Vvideo___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vvideo___024root___ico_sequent__TOP__0(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___ico_sequent__TOP__0\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ video__DOT__iread_cmd;
    video__DOT__iread_cmd = 0;
    CData/*0:0*/ video__DOT__iVRAM_en;
    video__DOT__iVRAM_en = 0;
    CData/*0:0*/ video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1;
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 = 0;
    // Body
    vlSelfRef.ADS_LATCH = vlSelfRef.BALE;
    vlSelfRef.IOCS16 = vlSelfRef.SBHE;
    vlSelfRef.video__DOT____Vcellinp__testramthingy____pinNumber8 
        = (1U & ((IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle) 
                 | ((IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle) 
                    | ((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__iADS_OE)) 
                       | (IData)(vlSelfRef.BALE)))));
    video__DOT__iread_cmd = (((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
                              & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                 >> 4U)) || ((1U & 
                                              (~ ((
                                                   (((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)) 
                                                     & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
                                                    & (~ (IData)(vlSelfRef.BALE))) 
                                                   & (IData)(vlSelfRef.ADS_OE)) 
                                                  & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                                     >> 4U)))) 
                                             || (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal)));
    video__DOT__iVRAM_en = (((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
                             & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                >> 4U)) ? (IData)(vlSelfRef.video__DOT__wbv__DOT__ichip_select)
                             : ((1U & (~ (((((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)) 
                                             & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
                                            & (~ (IData)(vlSelfRef.BALE))) 
                                           & (IData)(vlSelfRef.ADS_OE)) 
                                          & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                             >> 4U)))) 
                                || (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable)));
    vlSelfRef.FPGA_WR = (1U & (~ (IData)(vlSelfRef.IOR)));
    vlSelfRef.read_cmd = video__DOT__iread_cmd;
    vlSelfRef.VRAM_en = video__DOT__iVRAM_en;
    vlSelfRef.isa_ctrl_out_en = (1U & (~ ((0x420U <= vlSelfRef.video__DOT__lastAdsRequest) 
                                          & ((0x430U 
                                              >= vlSelfRef.video__DOT__lastAdsRequest) 
                                             & ((~ (IData)(vlSelfRef.BALE)) 
                                                & ((IData)(vlSelfRef.FPGA_WR) 
                                                   | ((~ (IData)(vlSelfRef.IOW)) 
                                                      | (IData)(vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN))))))));
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 
        = (1U & (~ ((((IData)(vlSelfRef.FPGA_WR) | 
                      (~ (IData)(vlSelfRef.IOW))) & 
                     (~ (IData)(vlSelfRef.BALE))) & (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle))));
    vlSelfRef.TE0 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE0i));
    vlSelfRef.TE1 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE1i));
    vlSelfRef.TE2 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE2i));
    vlSelfRef.TE3 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE3i));
}

void Vvideo___024root___eval_triggers__ico(Vvideo___024root* vlSelf);

bool Vvideo___024root___eval_phase__ico(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_phase__ico\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vvideo___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelfRef.__VicoTriggered.any();
    if (__VicoExecute) {
        Vvideo___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vvideo___024root___eval_act(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_act\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vvideo___024root___nba_sequent__TOP__0(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__1(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__2(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__3(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__4(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__5(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__6(Vvideo___024root* vlSelf);

void Vvideo___024root___eval_nba(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_nba\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((0xcULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__3(vlSelf);
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__4(vlSelf);
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__5(vlSelf);
    }
    if ((0xcULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__6(vlSelf);
    }
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__0(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__0\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vdly__video__DOT__vsyncctr = vlSelfRef.video__DOT__vsyncctr;
    vlSelfRef.__Vdly__video__DOT__vsyncctr = (1U & 
                                              (~ (IData)(vlSelfRef.video__DOT__vsyncctr)));
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__1(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__1\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*19:0*/ video__DOT__AVi;
    video__DOT__AVi = 0;
    SData/*15:0*/ video__DOT__data_outi;
    video__DOT__data_outi = 0;
    CData/*0:0*/ video__DOT__iread_cmd;
    video__DOT__iread_cmd = 0;
    CData/*0:0*/ video__DOT__iwrite_cmd;
    video__DOT__iwrite_cmd = 0;
    CData/*0:0*/ video__DOT__iVRAM_en;
    video__DOT__iVRAM_en = 0;
    CData/*0:0*/ video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1;
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 = 0;
    CData/*7:0*/ __Vdly__video__DOT__statusRegister;
    __Vdly__video__DOT__statusRegister = 0;
    CData/*7:0*/ __Vdly__video__DOT__alreadyWrote;
    __Vdly__video__DOT__alreadyWrote = 0;
    CData/*7:0*/ __Vdly__video__DOT__settingsRegister;
    __Vdly__video__DOT__settingsRegister = 0;
    IData/*23:0*/ __Vdly__video__DOT__addressComReg;
    __Vdly__video__DOT__addressComReg = 0;
    CData/*0:0*/ __Vdly__video__DOT__doData;
    __Vdly__video__DOT__doData = 0;
    IData/*27:0*/ __Vdly__video__DOT__cdd__DOT__counter;
    __Vdly__video__DOT__cdd__DOT__counter = 0;
    CData/*7:0*/ __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr;
    __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr = 0;
    CData/*7:0*/ __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr;
    __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr = 0;
    CData/*7:0*/ __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr;
    __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr = 0;
    CData/*7:0*/ __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr;
    __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr = 0;
    CData/*2:0*/ __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay;
    __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay = 0;
    CData/*0:0*/ __Vdly__video__DOT__isathing__DOT__actualBusCycle;
    __Vdly__video__DOT__isathing__DOT__actualBusCycle = 0;
    IData/*19:0*/ __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress;
    __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress = 0;
    SData/*9:0*/ __Vdly__video__DOT__testramthingy__DOT__waddr;
    __Vdly__video__DOT__testramthingy__DOT__waddr = 0;
    CData/*0:0*/ __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted;
    __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted = 0;
    CData/*2:0*/ __Vdly__video__DOT__testramthingy__DOT__newDelay;
    __Vdly__video__DOT__testramthingy__DOT__newDelay = 0;
    SData/*15:0*/ __VdlyVal__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0;
    __VdlyVal__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 = 0;
    CData/*7:0*/ __VdlyDim0__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0;
    __VdlyDim0__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 = 0;
    CData/*0:0*/ __VdlySet__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0;
    __VdlySet__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 = 0;
    IData/*19:0*/ __VdlyVal__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0;
    __VdlyVal__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 = 0;
    CData/*7:0*/ __VdlyDim0__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0;
    __VdlyDim0__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 = 0;
    CData/*0:0*/ __VdlySet__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0;
    __VdlySet__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 = 0;
    // Body
    __Vdly__video__DOT__cdd__DOT__counter = vlSelfRef.video__DOT__cdd__DOT__counter;
    __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay 
        = vlSelfRef.video__DOT__isathing__DOT__ADS_OE_Delay;
    __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr 
        = vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr;
    __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr 
        = vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr;
    __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr 
        = vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr;
    __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr 
        = vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr;
    __VdlySet__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 = 0U;
    __VdlySet__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 = 0U;
    __Vdly__video__DOT__isathing__DOT__actualBusCycle 
        = vlSelfRef.video__DOT__isathing__DOT__actualBusCycle;
    __Vdly__video__DOT__statusRegister = vlSelfRef.video__DOT__statusRegister;
    __Vdly__video__DOT__alreadyWrote = vlSelfRef.video__DOT__alreadyWrote;
    __Vdly__video__DOT__addressComReg = vlSelfRef.video__DOT__addressComReg;
    __Vdly__video__DOT__doData = vlSelfRef.video__DOT__doData;
    __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted 
        = vlSelfRef.video__DOT__testramthingy__DOT__alreadySubtracted;
    __Vdly__video__DOT__testramthingy__DOT__newDelay 
        = vlSelfRef.video__DOT__testramthingy__DOT__newDelay;
    __Vdly__video__DOT__testramthingy__DOT__waddr = vlSelfRef.video__DOT__testramthingy__DOT__waddr;
    __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress 
        = vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress;
    __Vdly__video__DOT__settingsRegister = vlSelfRef.video__DOT__settingsRegister;
    vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 = 0U;
    vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 = 0U;
    if (vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en) {
        __VdlyVal__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 
            = (0xfffffU & vlSelfRef.video__DOT__addressComReg);
        __VdlyDim0__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 
            = vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr;
        __VdlySet__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0 = 1U;
    }
    if (vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en) {
        __VdlyVal__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 
            = vlSelfRef.video__DOT__nextThingToWrite;
        __VdlyDim0__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 
            = vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr;
        __VdlySet__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0 = 1U;
    }
    if (((~ (IData)(vlSelfRef.video__DOT__testramthingy__DOT__fastEvenOrOdd)) 
         & (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite))) {
        vlSelfRef.__VdlyVal__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 
            = vlSelfRef.data_in;
        vlSelfRef.__VdlyDim0__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 
            = vlSelfRef.video__DOT__testramthingy__DOT__waddr;
        vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 = 1U;
    }
    if (((IData)(vlSelfRef.video__DOT__testramthingy__DOT__fastEvenOrOdd) 
         & (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite))) {
        vlSelfRef.__VdlyVal__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 
            = vlSelfRef.data_in;
        vlSelfRef.__VdlyDim0__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 
            = vlSelfRef.video__DOT__testramthingy__DOT__waddr;
        vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 = 1U;
    }
    vlSelfRef.video__DOT__writeBufferVramData = vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem
        [vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr];
    vlSelfRef.video__DOT__writeBufferVramAddress = 
        vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem
        [vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr];
    vlSelfRef.video__DOT__wbv__DOT__iwrite_cmd = (1U 
                                                  & (~ 
                                                     ((IData)(vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9) 
                                                      & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)))));
    vlSelfRef.video__DOT__wbv__DOT__ichip_select = 
        (1U & (~ ((IData)(vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9) 
                  & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)))));
    vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN 
        = ((IData)(vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9) 
           & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)));
    if ((1U & (((~ (IData)(vlSelfRef.BALE)) & (~ (IData)(vlSelfRef.IOR))) 
               | ((~ (IData)(vlSelfRef.BALE)) & (~ (IData)(vlSelfRef.IOW)))))) {
        if (vlSelfRef.video__DOT__isathing__DOT__actualBusCycle) {
            if (vlSelfRef.SBHE) {
                if ((1U & vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest)) {
                    vlSelfRef.video__DOT__isathing__DOT__TE0i = 0U;
                } else {
                    vlSelfRef.video__DOT__isathing__DOT__TE0i = 0U;
                    vlSelfRef.video__DOT__isathing__DOT__TE1i = 0U;
                }
            } else if ((1U & vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest)) {
                vlSelfRef.video__DOT__isathing__DOT__TE0i = 0U;
            } else {
                vlSelfRef.video__DOT__isathing__DOT__TE0i = 0U;
                vlSelfRef.video__DOT__isathing__DOT__TE1i = 0U;
            }
        } else {
            vlSelfRef.video__DOT__isathing__DOT__TE0i = 1U;
            vlSelfRef.video__DOT__isathing__DOT__TE1i = 1U;
            vlSelfRef.video__DOT__isathing__DOT__TE2i = 1U;
            vlSelfRef.video__DOT__isathing__DOT__TE3i = 1U;
        }
    } else {
        vlSelfRef.video__DOT__isathing__DOT__TE0i = 1U;
        vlSelfRef.video__DOT__isathing__DOT__TE1i = 1U;
        vlSelfRef.video__DOT__isathing__DOT__TE2i = 1U;
        vlSelfRef.video__DOT__isathing__DOT__TE3i = 1U;
    }
    if ((1U & (~ (IData)(vlSelfRef.RESET)))) {
        __Vdly__video__DOT__isathing__DOT__actualBusCycle = 0U;
        vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN = 0U;
    }
    if (vlSelfRef.BALE) {
        vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle = 1U;
    }
    if (((((0x420U <= vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest) 
           & (0x430U >= vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest)) 
          & ((~ (IData)(vlSelfRef.IOR)) | (~ (IData)(vlSelfRef.IOW)))) 
         & (~ (IData)(vlSelfRef.BALE)))) {
        __Vdly__video__DOT__isathing__DOT__actualBusCycle = 1U;
        vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN = 1U;
        vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle = 0U;
    } else {
        vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN = 0U;
        __Vdly__video__DOT__isathing__DOT__actualBusCycle = 0U;
        vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle = 0U;
    }
    if ((1U & (~ (IData)(vlSelfRef.RESET)))) {
        vlSelfRef.video__DOT__isathing__DOT__iADS_OE = 1U;
        vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest = 0U;
        __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay = 0U;
    }
    if (vlSelfRef.BALE) {
        vlSelfRef.video__DOT__isathing__DOT__iADS_OE = 0U;
        vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest 
            = vlSelfRef.AV_in;
        __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay = 5U;
    }
    __Vdly__video__DOT__statusRegister = ((0xfU & (IData)(__Vdly__video__DOT__statusRegister)) 
                                          | ((((IData)(vlSelfRef.video__DOT__ivblank) 
                                               << 7U) 
                                              | ((0x27fU 
                                                  <= (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr)) 
                                                 << 6U)) 
                                             | (((IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ifull) 
                                                 << 5U) 
                                                | ((IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ialmostFull) 
                                                   << 4U))));
    if (vlSelfRef.RESET) {
        if (((IData)(vlSelfRef.video__DOT__wbv__DOT__ififoRead) 
             & (~ (IData)(vlSelfRef.video__DOT__wbv__DOT__aEmpty)))) {
            __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr 
                = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr)));
        }
        if (((IData)(vlSelfRef.video__DOT__wbv__DOT__ififoRead) 
             & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)))) {
            __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr 
                = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr)));
        }
        if ((((((~ (IData)(vlSelfRef.IOR)) | (~ (IData)(vlSelfRef.IOW))) 
               & (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)) 
              & (0x14U > (IData)(vlSelfRef.video__DOT__alreadyWrote))) 
             & (~ (IData)(vlSelfRef.BALE)))) {
            if ((0x422U == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (IData)(vlSelfRef.video__DOT__videoDisplayRegister));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    vlSelfRef.video__DOT__videoDisplayRegister 
                        = (0xffU & (IData)(vlSelfRef.data_in));
                }
            } else if ((0x423U == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (IData)(vlSelfRef.video__DOT__settingsRegister));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    __Vdly__video__DOT__settingsRegister 
                        = (0xffU & (IData)(vlSelfRef.data_in));
                }
            } else if ((0x426U == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (IData)(vlSelfRef.video__DOT__statusRegister));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    __Vdly__video__DOT__statusRegister 
                        = (0xffU & (IData)(vlSelfRef.data_in));
                }
            } else if ((0x428U == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (0xffU & vlSelfRef.video__DOT__addressComReg));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    __Vdly__video__DOT__addressComReg 
                        = ((0xfe0000U & __Vdly__video__DOT__addressComReg) 
                           | ((0x1fe00U & ((IData)(vlSelfRef.data_in) 
                                           << 1U)) 
                              | (0x1feU & ((IData)(vlSelfRef.data_in) 
                                           << 1U))));
                }
            } else if ((0x429U == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (0xffU & (vlSelfRef.video__DOT__addressComReg 
                                       >> 8U)));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    __Vdly__video__DOT__addressComReg 
                        = ((0xfe01ffU & __Vdly__video__DOT__addressComReg) 
                           | (0x1fe00U & ((IData)(vlSelfRef.data_in) 
                                          << 1U)));
                }
            } else if ((0x42aU == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (0xffU & (vlSelfRef.video__DOT__addressComReg 
                                       >> 0x10U)));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    __Vdly__video__DOT__addressComReg 
                        = ((0x1ffffU & __Vdly__video__DOT__addressComReg) 
                           | (0xfe0000U & ((IData)(vlSelfRef.data_in) 
                                           << 0x11U)));
                }
            } else if ((0x42cU == vlSelfRef.video__DOT__lastAdsRequest)) {
                if (vlSelfRef.FPGA_WR) {
                    vlSelfRef.video__DOT__DStxresult 
                        = ((0xff00U & (IData)(vlSelfRef.video__DOT__DStxresult)) 
                           | (0xffU & (IData)(vlSelfRef.video__DOT__nextThingToWrite)));
                } else {
                    __Vdly__video__DOT__alreadyWrote 
                        = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__alreadyWrote)));
                    vlSelfRef.video__DOT__nextThingToWrite 
                        = vlSelfRef.data_in;
                    if ((1U & (~ (IData)(vlSelfRef.video__DOT__alreadyIncrementedAdsPtr)))) {
                        __Vdly__video__DOT__addressComReg 
                            = (0xffffffU & ((IData)(2U) 
                                            + vlSelfRef.video__DOT__addressComReg));
                        vlSelfRef.video__DOT__alreadyIncrementedAdsPtr = 1U;
                        __Vdly__video__DOT__doData = 1U;
                    }
                }
            } else {
                vlSelfRef.video__DOT__DStxresult = 
                    (((0x420U <= vlSelfRef.video__DOT__lastAdsRequest) 
                      & (0x430U >= vlSelfRef.video__DOT__lastAdsRequest))
                      ? 0x5555U : 0U);
            }
        } else {
            if (vlSelfRef.video__DOT__gtfoonnextclock) {
                vlSelfRef.video__DOT__gtfoonnextclock = 0U;
            }
            vlSelfRef.video__DOT__DStxresult = 0U;
            vlSelfRef.video__DOT__alreadyIncrementedAdsPtr = 0U;
        }
    } else {
        __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr = 0U;
        __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr = 0U;
        vlSelfRef.video__DOT__gtfoonnextclock = 0U;
        __Vdly__video__DOT__alreadyWrote = 0U;
        vlSelfRef.video__DOT__videoDisplayRegister = 0x18U;
        __Vdly__video__DOT__settingsRegister = 0x70U;
        __Vdly__video__DOT__statusRegister = 0U;
        vlSelfRef.video__DOT__alreadyIncrementedAdsPtr = 0U;
        __Vdly__video__DOT__addressComReg = 0U;
        __Vdly__video__DOT__doData = 0U;
    }
    if (vlSelfRef.video__DOT__doData) {
        __Vdly__video__DOT__doData = 0U;
    }
    if ((1U & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)))) {
        __Vdly__video__DOT__alreadyWrote = 0U;
    }
    if ((0x10U & (IData)(vlSelfRef.video__DOT__settingsRegister))) {
        vlSelfRef.video__DOT__iRed = (0x1fU & ((IData)(vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput) 
                                               >> 0xbU));
        vlSelfRef.video__DOT__iGreen = (0x3fU & ((IData)(vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput) 
                                                 >> 5U));
        vlSelfRef.video__DOT__iBlue = (0x1fU & (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput));
    } else {
        vlSelfRef.video__DOT__iRed = (0x1fU & (IData)(vlSelfRef.video__DOT__Rt));
        vlSelfRef.video__DOT__iGreen = (0x3fU & (IData)(vlSelfRef.video__DOT__Gt));
        vlSelfRef.video__DOT__iBlue = (0x1fU & (IData)(vlSelfRef.video__DOT__Bt));
    }
    if (__VdlySet__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0) {
        vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem[__VdlyDim0__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0] 
            = __VdlyVal__video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem__v0;
    }
    if (__VdlySet__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0) {
        vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem[__VdlyDim0__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0] 
            = __VdlyVal__video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem__v0;
    }
    vlSelfRef.video__DOT__statusRegister = __Vdly__video__DOT__statusRegister;
    vlSelfRef.video__DOT__alreadyWrote = __Vdly__video__DOT__alreadyWrote;
    vlSelfRef.video__DOT__addressComReg = __Vdly__video__DOT__addressComReg;
    vlSelfRef.video__DOT__isathing__DOT__actualBusCycle 
        = __Vdly__video__DOT__isathing__DOT__actualBusCycle;
    vlSelfRef.video__DOT__settingsRegister = __Vdly__video__DOT__settingsRegister;
    vlSelfRef.video__DOT__wbv__DOT__ififoRead = ((IData)(vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9) 
                                                 & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)));
    if (vlSelfRef.RESET) {
        if (((IData)(vlSelfRef.video__DOT__doData) 
             & (~ (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__ifull)))) {
            __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr 
                = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr)));
            vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en = 1U;
        } else {
            vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en = 0U;
        }
    } else {
        __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr = 0U;
        vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en = 0U;
    }
    vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__ifull 
        = ((0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr))) 
           == (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr));
    if (((0U < (IData)(vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain)) 
         & (~ (IData)(vlSelfRef.video__DOT____Vcellinp__testramthingy____pinNumber8)))) {
        vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain 
            = (0x1fU & ((IData)(vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain) 
                        - (IData)(1U)));
    }
    if (vlSelfRef.RESET) {
        if (vlSelfRef.video__DOT__testramthingy__DOT__fastFrameEnd) {
            vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal = 1U;
            vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable = 1U;
            vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite = 1U;
            __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress = 0U;
            __Vdly__video__DOT__testramthingy__DOT__waddr = 0U;
            vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain = 0xaU;
            __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted = 1U;
        } else if (vlSelfRef.video__DOT__ivblank) {
            if ((1U & ((~ (IData)(vlSelfRef.video__DOT__full)) 
                       & (~ (IData)(vlSelfRef.video__DOT____Vcellinp__testramthingy____pinNumber8))))) {
                __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress 
                    = (0xfffffU & ((IData)(2U) + vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress));
                __Vdly__video__DOT__testramthingy__DOT__waddr 
                    = (0x3ffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr)));
                __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted = 0U;
                __Vdly__video__DOT__testramthingy__DOT__newDelay = 3U;
                vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal = 0U;
                vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable = 0U;
                vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite = 1U;
            } else {
                if ((0U < (IData)(vlSelfRef.video__DOT__testramthingy__DOT__newDelay))) {
                    __Vdly__video__DOT__testramthingy__DOT__newDelay 
                        = (7U & ((IData)(vlSelfRef.video__DOT__testramthingy__DOT__newDelay) 
                                 - (IData)(1U)));
                }
                if ((((1U == (IData)(vlSelfRef.video__DOT__testramthingy__DOT__newDelay)) 
                      & (0U < (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr))) 
                     & (~ (IData)(vlSelfRef.video__DOT__full)))) {
                    __Vdly__video__DOT__testramthingy__DOT__waddr 
                        = (0x3ffU & ((IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr) 
                                     - (IData)(1U)));
                    __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress 
                        = (0xfffffU & (vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress 
                                       - (IData)(2U)));
                }
                vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal = 1U;
                vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable = 1U;
                vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite = 0U;
                vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain = 1U;
            }
        } else {
            if ((1U & (~ (IData)(vlSelfRef.video__DOT__testramthingy__DOT__alreadySubtracted)))) {
                __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress 
                    = (0xfffffU & ((IData)(2U) + vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress));
                __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted = 1U;
            }
            vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal = 1U;
            vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable = 1U;
            vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite = 1U;
            __Vdly__video__DOT__testramthingy__DOT__waddr = 0U;
            vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain = 0xaU;
        }
        if (((IData)(vlSelfRef.video__DOT__doData) 
             & (~ (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ifull)))) {
            __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr 
                = (0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr)));
            vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en = 1U;
        } else {
            vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en = 0U;
        }
    } else {
        __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted = 1U;
        vlSelfRef.video__DOT__testramthingy__DOT__delayBeforeWriteAgain = 0U;
        __Vdly__video__DOT__testramthingy__DOT__newDelay = 0U;
        __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress = 0U;
        vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal = 1U;
        vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable = 1U;
        vlSelfRef.video__DOT__testramthingy__DOT__ififoWrite = 1U;
        __Vdly__video__DOT__testramthingy__DOT__waddr = 0U;
        __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr = 0U;
        vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en = 0U;
    }
    vlSelfRef.FPGA_IO_EN = vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN;
    if ((0U == (IData)(vlSelfRef.video__DOT__isathing__DOT__ADS_OE_Delay))) {
        vlSelfRef.video__DOT__isathing__DOT__iADS_OE = 1U;
    } else if ((0U < (IData)(vlSelfRef.video__DOT__isathing__DOT__ADS_OE_Delay))) {
        __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay 
            = (7U & ((IData)(vlSelfRef.video__DOT__isathing__DOT__ADS_OE_Delay) 
                     - (IData)(1U)));
        vlSelfRef.video__DOT__isathing__DOT__lastAdsRequest 
            = vlSelfRef.AV_in;
    }
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 
        = (1U & (~ ((((IData)(vlSelfRef.FPGA_WR) | 
                      (~ (IData)(vlSelfRef.IOW))) & 
                     (~ (IData)(vlSelfRef.BALE))) & (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle))));
    if ((1U & (~ (IData)(vlSelfRef.ADS_OE)))) {
        vlSelfRef.video__DOT__lastAdsRequest = vlSelfRef.AV_in;
    }
    vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ialmostFull 
        = ((8U > (0xffU & ((IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr) 
                           - (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr)))) 
           & (~ (IData)(vlSelfRef.video__DOT__writeBufferEmpty)));
    vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ifull 
        = ((0xffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr))) 
           == (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr));
    vlSelfRef.Red = vlSelfRef.video__DOT__iRed;
    vlSelfRef.Green = vlSelfRef.video__DOT__iGreen;
    vlSelfRef.Blue = vlSelfRef.video__DOT__iBlue;
    video__DOT__iwrite_cmd = ((1U & (~ ((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
                                        & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                           >> 4U)))) 
                              || (IData)(vlSelfRef.video__DOT__wbv__DOT__iwrite_cmd));
    vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr 
        = __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__w_ptr;
    vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr 
        = __Vdly__video__DOT__wbv__DOT__addressFifo__DOT__r_ptr;
    vlSelfRef.video__DOT__testramthingy__DOT__alreadySubtracted 
        = __Vdly__video__DOT__testramthingy__DOT__alreadySubtracted;
    vlSelfRef.video__DOT__testramthingy__DOT__newDelay 
        = __Vdly__video__DOT__testramthingy__DOT__newDelay;
    vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress 
        = __Vdly__video__DOT__testramthingy__DOT__iNextVramAddress;
    vlSelfRef.video__DOT__testramthingy__DOT__waddr 
        = __Vdly__video__DOT__testramthingy__DOT__waddr;
    vlSelfRef.video__DOT__isathing__DOT__ADS_OE_Delay 
        = __Vdly__video__DOT__isathing__DOT__ADS_OE_Delay;
    vlSelfRef.TE0 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE0i));
    vlSelfRef.TE1 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE1i));
    vlSelfRef.TE2 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE2i));
    vlSelfRef.TE3 = ((IData)(video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1) 
                     | (IData)(vlSelfRef.video__DOT__isathing__DOT__TE3i));
    vlSelfRef.video__DOT__doData = __Vdly__video__DOT__doData;
    vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr 
        = __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__w_ptr;
    vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr 
        = __Vdly__video__DOT__wbv__DOT__dataFifo__DOT__r_ptr;
    vlSelfRef.write_cmd = video__DOT__iwrite_cmd;
    video__DOT__data_outi = (((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
                              & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                 >> 4U)) ? (IData)(vlSelfRef.video__DOT__writeBufferVramData)
                              : (IData)(vlSelfRef.video__DOT__DStxresult));
    vlSelfRef.data_out = video__DOT__data_outi;
    vlSelfRef.video__DOT__wbv__DOT__aEmpty = ((~ (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__ifull)) 
                                              & ((IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr) 
                                                 == (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr)));
    vlSelfRef.video__DOT__full = (0x27fU <= (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr));
    vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9 
        = ((~ ((IData)(vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN) 
               | (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
           & (0x27fU <= (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr)));
    vlSelfRef.video__DOT__ivblank = vlSelfRef.VALID_PIXELS;
    if (((~ (IData)(vlSelfRef.video__DOT__testramthingy__DOT__r3_Pulse)) 
         & (IData)(vlSelfRef.video__DOT__testramthingy__DOT__r2_Pulse))) {
        vlSelfRef.video__DOT__testramthingy__DOT__fastEvenOrOdd 
            = vlSelfRef.video__DOT__vsyncctr;
        vlSelfRef.video__DOT__testramthingy__DOT__fastFrameEnd 
            = vlSelfRef.video__DOT__testramthingy__DOT__iframeEnd;
    }
    vlSelfRef.video__DOT__testramthingy__DOT__r3_Pulse 
        = vlSelfRef.video__DOT__testramthingy__DOT__r2_Pulse;
    vlSelfRef.video__DOT____Vcellinp__testramthingy____pinNumber8 
        = (1U & ((IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle) 
                 | ((IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle) 
                    | ((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__iADS_OE)) 
                       | (IData)(vlSelfRef.BALE)))));
    vlSelfRef.ADS_OE = vlSelfRef.video__DOT__isathing__DOT__iADS_OE;
    if (((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
         & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
            >> 4U))) {
        video__DOT__AVi = vlSelfRef.video__DOT__writeBufferVramAddress;
        video__DOT__iVRAM_en = vlSelfRef.video__DOT__wbv__DOT__ichip_select;
    } else {
        video__DOT__AVi = vlSelfRef.video__DOT__testramthingy__DOT__iNextVramAddress;
        video__DOT__iVRAM_en = ((1U & (~ (((((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)) 
                                             & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
                                            & (~ (IData)(vlSelfRef.BALE))) 
                                           & (IData)(vlSelfRef.ADS_OE)) 
                                          & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                             >> 4U)))) 
                                || (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ichipEnable));
    }
    vlSelfRef.isa_ctrl_out_en = (1U & (~ ((0x420U <= vlSelfRef.video__DOT__lastAdsRequest) 
                                          & ((0x430U 
                                              >= vlSelfRef.video__DOT__lastAdsRequest) 
                                             & ((~ (IData)(vlSelfRef.BALE)) 
                                                & ((IData)(vlSelfRef.FPGA_WR) 
                                                   | ((~ (IData)(vlSelfRef.IOW)) 
                                                      | (IData)(vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN))))))));
    vlSelfRef.video__DOT__writeBufferEmpty = ((~ (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ifull)) 
                                              & ((IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr) 
                                                 == (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr)));
    vlSelfRef.AV = video__DOT__AVi;
    video__DOT__iread_cmd = (((IData)(vlSelfRef.video__DOT__wbv__DOT__iWRITEBUF_IO_EN) 
                              & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                 >> 4U)) || ((1U & 
                                              (~ ((
                                                   (((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle)) 
                                                     & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
                                                    & (~ (IData)(vlSelfRef.BALE))) 
                                                   & (IData)(vlSelfRef.ADS_OE)) 
                                                  & ((IData)(vlSelfRef.video__DOT__settingsRegister) 
                                                     >> 4U)))) 
                                             || (IData)(vlSelfRef.video__DOT__testramthingy__DOT__ireadSignal)));
    vlSelfRef.video__DOT__testramthingy__DOT__r2_Pulse 
        = vlSelfRef.video__DOT__testramthingy__DOT__r1_Pulse;
    vlSelfRef.read_cmd = video__DOT__iread_cmd;
    vlSelfRef.VRAM_en = video__DOT__iVRAM_en;
    vlSelfRef.video__DOT__testramthingy__DOT__r1_Pulse 
        = vlSelfRef.pixelClock;
    __Vdly__video__DOT__cdd__DOT__counter = (0xfffffffU 
                                             & ((IData)(1U) 
                                                + vlSelfRef.video__DOT__cdd__DOT__counter));
    if ((2U <= vlSelfRef.video__DOT__cdd__DOT__counter)) {
        __Vdly__video__DOT__cdd__DOT__counter = 0U;
    }
    vlSelfRef.pixelClock = (1U > vlSelfRef.video__DOT__cdd__DOT__counter);
    vlSelfRef.video__DOT__cdd__DOT__counter = __Vdly__video__DOT__cdd__DOT__counter;
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__2(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__2\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vdly__horizontalCount = vlSelfRef.horizontalCount;
    vlSelfRef.__Vdly__verticalCount = vlSelfRef.verticalCount;
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__3(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__3\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    SData/*9:0*/ __Vdly__video__DOT__testramthingy__DOT__raddr;
    __Vdly__video__DOT__testramthingy__DOT__raddr = 0;
    // Body
    __Vdly__video__DOT__testramthingy__DOT__raddr = vlSelfRef.video__DOT__testramthingy__DOT__raddr;
    if (vlSelfRef.RESET) {
        if (vlSelfRef.VALID_PIXELS) {
            __Vdly__video__DOT__testramthingy__DOT__raddr 
                = (0x3ffU & ((IData)(1U) + (IData)(vlSelfRef.video__DOT__testramthingy__DOT__raddr)));
            vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput 
                = ((IData)(vlSelfRef.video__DOT__vsyncctr)
                    ? (IData)(vlSelfRef.video__DOT__testramthingy__DOT__b1dout)
                    : (IData)(vlSelfRef.video__DOT__testramthingy__DOT__b2dout));
            vlSelfRef.video__DOT__testramthingy__DOT__iframeEnd = 0U;
        } else {
            __Vdly__video__DOT__testramthingy__DOT__raddr = 0U;
            vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput = 0U;
            if ((1U & (~ (IData)(vlSelfRef.VSYNC)))) {
                vlSelfRef.video__DOT__testramthingy__DOT__iframeEnd = 1U;
            }
        }
    } else {
        __Vdly__video__DOT__testramthingy__DOT__raddr = 0U;
        vlSelfRef.video__DOT__testramthingy__DOT__ipixelOutput = 0U;
        vlSelfRef.video__DOT__testramthingy__DOT__iframeEnd = 0U;
    }
    if (vlSelfRef.VALID_PIXELS) {
        if ((0x7d000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x240U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.video__DOT__Rt = (0x1fU & 0x1fU);
                vlSelfRef.video__DOT__Gt = 0x3fU;
                vlSelfRef.video__DOT__Bt = (0x1fU & 0x1fU);
            } else {
                vlSelfRef.video__DOT__Rt = (0x1fU & 0U);
                vlSelfRef.video__DOT__Gt = 0U;
                vlSelfRef.video__DOT__Bt = (0x1fU & 
                                            ((0x23fU 
                                              < (IData)(vlSelfRef.horizontalCount))
                                              ? 0U : 
                                             ((IData)(vlSelfRef.horizontalCount) 
                                              >> 4U)));
            }
        } else if ((0x64000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x280U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.video__DOT__Rt = (0x1fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 2U));
                vlSelfRef.video__DOT__Gt = ((0x38U 
                                             & (IData)(vlSelfRef.video__DOT__Gt)) 
                                            | ((4U 
                                                & ((IData)(vlSelfRef.horizontalCount) 
                                                   >> 1U)) 
                                               | (2U 
                                                  & ((IData)(vlSelfRef.horizontalCount) 
                                                     >> 1U))));
                vlSelfRef.video__DOT__Gt = ((7U & (IData)(vlSelfRef.video__DOT__Gt)) 
                                            | (0x38U 
                                               & ((IData)(vlSelfRef.horizontalCount) 
                                                  >> 1U)));
                vlSelfRef.video__DOT__Bt = (0x1fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 2U));
            } else {
                vlSelfRef.video__DOT__Rt = (0x1fU & 0U);
                vlSelfRef.video__DOT__Gt = (0x3fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 3U));
                vlSelfRef.video__DOT__Bt = (0x1fU & 0U);
            }
        } else if ((0x4b000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x280U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.video__DOT__Rt = (0x1fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 2U));
                vlSelfRef.video__DOT__Gt = ((0x38U 
                                             & (IData)(vlSelfRef.video__DOT__Gt)) 
                                            | ((4U 
                                                & ((IData)(vlSelfRef.horizontalCount) 
                                                   >> 1U)) 
                                               | (2U 
                                                  & ((IData)(vlSelfRef.horizontalCount) 
                                                     >> 1U))));
                vlSelfRef.video__DOT__Gt = ((7U & (IData)(vlSelfRef.video__DOT__Gt)) 
                                            | (0x38U 
                                               & ((IData)(vlSelfRef.horizontalCount) 
                                                  >> 1U)));
                vlSelfRef.video__DOT__Bt = (0x1fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 2U));
            } else {
                vlSelfRef.video__DOT__Rt = (0x1fU & 
                                            ((IData)(vlSelfRef.horizontalCount) 
                                             >> 4U));
                vlSelfRef.video__DOT__Gt = 0U;
                vlSelfRef.video__DOT__Bt = (0x1fU & 0U);
            }
        } else {
            vlSelfRef.video__DOT__Rt = (0x1fU & (vlSelfRef.video__DOT__vramAddress 
                                                 >> 1U));
            vlSelfRef.video__DOT__Gt = (0x3fU & (vlSelfRef.video__DOT__vramAddress 
                                                 >> 6U));
            vlSelfRef.video__DOT__Bt = (0x1fU & (vlSelfRef.video__DOT__vramAddress 
                                                 >> 0xcU));
        }
    } else {
        vlSelfRef.video__DOT__Rt = 0U;
        vlSelfRef.video__DOT__Gt = 0U;
        vlSelfRef.video__DOT__Bt = 0U;
    }
    if (vlSelfRef.video__DOT__testramthingy__DOT__ififoRead) {
        vlSelfRef.video__DOT__testramthingy__DOT__b1dout 
            = vlSelfRef.video__DOT__testramthingy__DOT__b1__DOT__mem
            [vlSelfRef.video__DOT__testramthingy__DOT__raddr];
        vlSelfRef.video__DOT__testramthingy__DOT__b2dout 
            = vlSelfRef.video__DOT__testramthingy__DOT__b2__DOT__mem
            [vlSelfRef.video__DOT__testramthingy__DOT__raddr];
    }
    vlSelfRef.video__DOT__testramthingy__DOT__raddr 
        = __Vdly__video__DOT__testramthingy__DOT__raddr;
    vlSelfRef.video__DOT__testramthingy__DOT__ififoRead 
        = ((IData)(vlSelfRef.RESET) && (IData)(vlSelfRef.VALID_PIXELS));
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__4(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__4\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.video__DOT__vsyncctr = vlSelfRef.__Vdly__video__DOT__vsyncctr;
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__5(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__5\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b1__DOT__mem__v0) {
        vlSelfRef.video__DOT__testramthingy__DOT__b1__DOT__mem[vlSelfRef.__VdlyDim0__video__DOT__testramthingy__DOT__b1__DOT__mem__v0] 
            = vlSelfRef.__VdlyVal__video__DOT__testramthingy__DOT__b1__DOT__mem__v0;
    }
    if (vlSelfRef.__VdlySet__video__DOT__testramthingy__DOT__b2__DOT__mem__v0) {
        vlSelfRef.video__DOT__testramthingy__DOT__b2__DOT__mem[vlSelfRef.__VdlyDim0__video__DOT__testramthingy__DOT__b2__DOT__mem__v0] 
            = vlSelfRef.__VdlyVal__video__DOT__testramthingy__DOT__b2__DOT__mem__v0;
    }
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__6(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__6\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.RESET) {
        vlSelfRef.VALID_PIXELS = ((IData)(vlSelfRef.video__DOT__gs__DOT__VALID_H) 
                                  & (IData)(vlSelfRef.video__DOT__gs__DOT__VALID_V));
        vlSelfRef.__Vdly__horizontalCount = (0x7ffU 
                                             & ((IData)(1U) 
                                                + (IData)(vlSelfRef.horizontalCount)));
        if (((0x280U <= (IData)(vlSelfRef.horizontalCount)) 
             & (0x290U > (IData)(vlSelfRef.horizontalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
            vlSelfRef.video__DOT__gs__DOT__HSYNC = 1U;
        } else if (((0x290U <= (IData)(vlSelfRef.horizontalCount)) 
                    & (0x2f0U > (IData)(vlSelfRef.horizontalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
            vlSelfRef.video__DOT__gs__DOT__HSYNC = 0U;
        } else if (((0x2f0U <= (IData)(vlSelfRef.horizontalCount)) 
                    & (0x31fU > (IData)(vlSelfRef.horizontalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
        } else if ((0x31fU <= (IData)(vlSelfRef.horizontalCount))) {
            vlSelfRef.__Vdly__verticalCount = (0x3ffU 
                                               & ((IData)(1U) 
                                                  + (IData)(vlSelfRef.verticalCount)));
            vlSelfRef.__Vdly__horizontalCount = 0U;
            vlSelfRef.video__DOT__gs__DOT__HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
        } else {
            vlSelfRef.video__DOT__vramAddress = (0xfffffU 
                                                 & ((IData)(2U) 
                                                    + vlSelfRef.video__DOT__vramAddress));
            vlSelfRef.video__DOT__gs__DOT__HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 1U;
        }
        if (((0x1e0U <= (IData)(vlSelfRef.verticalCount)) 
             & (0x1eaU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.video__DOT__gs__DOT__VSYNC = 1U;
        } else if (((0x1eaU <= (IData)(vlSelfRef.verticalCount)) 
                    & (0x1ecU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.video__DOT__gs__DOT__VSYNC = 0U;
        } else if (((0x1ecU <= (IData)(vlSelfRef.verticalCount)) 
                    & (0x20dU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.video__DOT__gs__DOT__VSYNC = 1U;
        } else if ((0x20dU <= (IData)(vlSelfRef.verticalCount))) {
            vlSelfRef.__Vdly__verticalCount = 0U;
            vlSelfRef.video__DOT__vramAddress = 0U;
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.video__DOT__gs__DOT__VSYNC = 1U;
        } else {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 1U;
            vlSelfRef.video__DOT__gs__DOT__VSYNC = 1U;
        }
    } else {
        vlSelfRef.__Vdly__verticalCount = 0U;
        vlSelfRef.video__DOT__vramAddress = 0U;
        vlSelfRef.__Vdly__horizontalCount = 0U;
    }
    vlSelfRef.verticalCount = vlSelfRef.__Vdly__verticalCount;
    vlSelfRef.horizontalCount = vlSelfRef.__Vdly__horizontalCount;
    vlSelfRef.HSYNC = vlSelfRef.video__DOT__gs__DOT__HSYNC;
    vlSelfRef.VSYNC = vlSelfRef.video__DOT__gs__DOT__VSYNC;
}

void Vvideo___024root___eval_triggers__act(Vvideo___024root* vlSelf);

bool Vvideo___024root___eval_phase__act(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_phase__act\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<4> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vvideo___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vvideo___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vvideo___024root___eval_phase__nba(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_phase__nba\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vvideo___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__ico(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__nba(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__act(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG

void Vvideo___024root___eval(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY(((0x64U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vvideo___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("video.v", 305, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vvideo___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelfRef.__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vvideo___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("video.v", 305, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vvideo___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("video.v", 305, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vvideo___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vvideo___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vvideo___024root___eval_debug_assertions(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_debug_assertions\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.pllclk & 0xfeU)))) {
        Verilated::overWidthError("pllclk");}
    if (VL_UNLIKELY(((vlSelfRef.RESET & 0xfeU)))) {
        Verilated::overWidthError("RESET");}
    if (VL_UNLIKELY(((vlSelfRef.BALE & 0xfeU)))) {
        Verilated::overWidthError("BALE");}
    if (VL_UNLIKELY(((vlSelfRef.MEMW & 0xfeU)))) {
        Verilated::overWidthError("MEMW");}
    if (VL_UNLIKELY(((vlSelfRef.MEMR & 0xfeU)))) {
        Verilated::overWidthError("MEMR");}
    if (VL_UNLIKELY(((vlSelfRef.SMEMR & 0xfeU)))) {
        Verilated::overWidthError("SMEMR");}
    if (VL_UNLIKELY(((vlSelfRef.SMEMW & 0xfeU)))) {
        Verilated::overWidthError("SMEMW");}
    if (VL_UNLIKELY(((vlSelfRef.IOW & 0xfeU)))) {
        Verilated::overWidthError("IOW");}
    if (VL_UNLIKELY(((vlSelfRef.IOR & 0xfeU)))) {
        Verilated::overWidthError("IOR");}
    if (VL_UNLIKELY(((vlSelfRef.SBHE & 0xfeU)))) {
        Verilated::overWidthError("SBHE");}
    if (VL_UNLIKELY(((vlSelfRef.ISACLK & 0xfeU)))) {
        Verilated::overWidthError("ISACLK");}
    if (VL_UNLIKELY(((vlSelfRef.AV_in & 0xfff00000U)))) {
        Verilated::overWidthError("AV_in");}
}
#endif  // VL_DEBUG
