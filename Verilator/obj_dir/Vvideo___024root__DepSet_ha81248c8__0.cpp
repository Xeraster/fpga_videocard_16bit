// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvideo.h for the primary calling header

#include "Vvideo__pch.h"
#include "Vvideo___024root.h"

void Vvideo___024root___eval_act(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_act\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vvideo___024root___nba_sequent__TOP__0(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__1(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__2(Vvideo___024root* vlSelf);
void Vvideo___024root___nba_sequent__TOP__3(Vvideo___024root* vlSelf);

void Vvideo___024root___eval_nba(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_nba\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((6ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((6ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vvideo___024root___nba_sequent__TOP__3(vlSelf);
    }
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__0(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__0\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*27:0*/ __Vdly__video__DOT__cdd__DOT__counter;
    __Vdly__video__DOT__cdd__DOT__counter = 0;
    // Body
    __Vdly__video__DOT__cdd__DOT__counter = vlSelfRef.video__DOT__cdd__DOT__counter;
    __Vdly__video__DOT__cdd__DOT__counter = (0xfffffffU 
                                             & ((IData)(1U) 
                                                + vlSelfRef.video__DOT__cdd__DOT__counter));
    if ((2U <= vlSelfRef.video__DOT__cdd__DOT__counter)) {
        __Vdly__video__DOT__cdd__DOT__counter = 0U;
    }
    vlSelfRef.pixelClock = (1U > vlSelfRef.video__DOT__cdd__DOT__counter);
    vlSelfRef.video__DOT__cdd__DOT__counter = __Vdly__video__DOT__cdd__DOT__counter;
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__1(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__1\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vdly__horizontalCount = vlSelfRef.horizontalCount;
    vlSelfRef.__Vdly__verticalCount = vlSelfRef.verticalCount;
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__2(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__2\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.VALID_PIXELS) {
        if ((0x7d000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x240U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.Rt = (0x1fU & 0x1fU);
                vlSelfRef.Gt = 0x3fU;
                vlSelfRef.Bt = (0x1fU & 0x1fU);
            } else {
                vlSelfRef.Rt = (0x1fU & 0U);
                vlSelfRef.Gt = 0U;
                vlSelfRef.Bt = (0x1fU & ((0x23fU < (IData)(vlSelfRef.horizontalCount))
                                          ? 0U : ((IData)(vlSelfRef.horizontalCount) 
                                                  >> 4U)));
            }
        } else if ((0x64000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x280U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.Rt = (0x1fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 2U));
                vlSelfRef.Gt = ((0x38U & (IData)(vlSelfRef.Gt)) 
                                | ((4U & ((IData)(vlSelfRef.horizontalCount) 
                                          >> 1U)) | 
                                   (2U & ((IData)(vlSelfRef.horizontalCount) 
                                          >> 1U))));
                vlSelfRef.Gt = ((7U & (IData)(vlSelfRef.Gt)) 
                                | (0x38U & ((IData)(vlSelfRef.horizontalCount) 
                                            >> 1U)));
                vlSelfRef.Bt = (0x1fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 2U));
            } else {
                vlSelfRef.Rt = (0x1fU & 0U);
                vlSelfRef.Gt = (0x3fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 3U));
                vlSelfRef.Bt = (0x1fU & 0U);
            }
        } else if ((0x4b000U < vlSelfRef.video__DOT__vramAddress)) {
            if (((0x200U < (IData)(vlSelfRef.horizontalCount)) 
                 & (0x280U > (IData)(vlSelfRef.horizontalCount)))) {
                vlSelfRef.Rt = (0x1fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 2U));
                vlSelfRef.Gt = ((0x38U & (IData)(vlSelfRef.Gt)) 
                                | ((4U & ((IData)(vlSelfRef.horizontalCount) 
                                          >> 1U)) | 
                                   (2U & ((IData)(vlSelfRef.horizontalCount) 
                                          >> 1U))));
                vlSelfRef.Gt = ((7U & (IData)(vlSelfRef.Gt)) 
                                | (0x38U & ((IData)(vlSelfRef.horizontalCount) 
                                            >> 1U)));
                vlSelfRef.Bt = (0x1fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 2U));
            } else {
                vlSelfRef.Rt = (0x1fU & ((IData)(vlSelfRef.horizontalCount) 
                                         >> 4U));
                vlSelfRef.Gt = 0U;
                vlSelfRef.Bt = (0x1fU & 0U);
            }
        } else {
            vlSelfRef.Rt = (0x1fU & (vlSelfRef.video__DOT__vramAddress 
                                     >> 1U));
            vlSelfRef.Gt = (0x3fU & (vlSelfRef.video__DOT__vramAddress 
                                     >> 6U));
            vlSelfRef.Bt = (0x1fU & (vlSelfRef.video__DOT__vramAddress 
                                     >> 0xcU));
        }
    } else {
        vlSelfRef.Rt = 0U;
        vlSelfRef.Gt = 0U;
        vlSelfRef.Bt = 0U;
    }
}

VL_INLINE_OPT void Vvideo___024root___nba_sequent__TOP__3(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___nba_sequent__TOP__3\n"); );
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
            vlSelfRef.HSYNC = 1U;
        } else if (((0x290U <= (IData)(vlSelfRef.horizontalCount)) 
                    & (0x2f0U > (IData)(vlSelfRef.horizontalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
            vlSelfRef.HSYNC = 0U;
        } else if (((0x2f0U <= (IData)(vlSelfRef.horizontalCount)) 
                    & (0x31fU > (IData)(vlSelfRef.horizontalCount)))) {
            vlSelfRef.HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
        } else if ((0x31fU <= (IData)(vlSelfRef.horizontalCount))) {
            vlSelfRef.__Vdly__verticalCount = (0x3ffU 
                                               & ((IData)(1U) 
                                                  + (IData)(vlSelfRef.verticalCount)));
            vlSelfRef.__Vdly__horizontalCount = 0U;
            vlSelfRef.HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 0U;
        } else {
            vlSelfRef.video__DOT__vramAddress = (0xfffffU 
                                                 & ((IData)(2U) 
                                                    + vlSelfRef.video__DOT__vramAddress));
            vlSelfRef.HSYNC = 1U;
            vlSelfRef.video__DOT__gs__DOT__VALID_H = 1U;
        }
        if (((0x1e0U <= (IData)(vlSelfRef.verticalCount)) 
             & (0x1eaU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.VSYNC = 1U;
        } else if (((0x1eaU <= (IData)(vlSelfRef.verticalCount)) 
                    & (0x1ecU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.VSYNC = 0U;
        } else if (((0x1ecU <= (IData)(vlSelfRef.verticalCount)) 
                    & (0x20dU > (IData)(vlSelfRef.verticalCount)))) {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.VSYNC = 1U;
        } else if ((0x20dU <= (IData)(vlSelfRef.verticalCount))) {
            vlSelfRef.__Vdly__verticalCount = 0U;
            vlSelfRef.video__DOT__vramAddress = 0U;
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 0U;
            vlSelfRef.VSYNC = 1U;
        } else {
            vlSelfRef.video__DOT__gs__DOT__VALID_V = 1U;
            vlSelfRef.VSYNC = 1U;
        }
    } else {
        vlSelfRef.__Vdly__verticalCount = 0U;
        vlSelfRef.video__DOT__vramAddress = 0U;
        vlSelfRef.__Vdly__horizontalCount = 0U;
    }
    vlSelfRef.verticalCount = vlSelfRef.__Vdly__verticalCount;
    vlSelfRef.horizontalCount = vlSelfRef.__Vdly__horizontalCount;
}

void Vvideo___024root___eval_triggers__act(Vvideo___024root* vlSelf);

bool Vvideo___024root___eval_phase__act(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_phase__act\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<3> __VpreTriggered;
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
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vvideo___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("video.v", 298, "", "NBA region did not converge.");
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
                VL_FATAL_MT("video.v", 298, "", "Active region did not converge.");
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
    if (VL_UNLIKELY(((vlSelfRef.a & 0xfeU)))) {
        Verilated::overWidthError("a");}
    if (VL_UNLIKELY(((vlSelfRef.b & 0xfeU)))) {
        Verilated::overWidthError("b");}
    if (VL_UNLIKELY(((vlSelfRef.pllclk & 0xfeU)))) {
        Verilated::overWidthError("pllclk");}
    if (VL_UNLIKELY(((vlSelfRef.RESET & 0xfeU)))) {
        Verilated::overWidthError("RESET");}
}
#endif  // VL_DEBUG
