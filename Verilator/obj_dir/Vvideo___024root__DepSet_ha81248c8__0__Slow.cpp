// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvideo.h for the primary calling header

#include "Vvideo__pch.h"
#include "Vvideo___024root.h"

VL_ATTR_COLD void Vvideo___024root___eval_static__TOP(Vvideo___024root* vlSelf);

VL_ATTR_COLD void Vvideo___024root___eval_static(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_static\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vvideo___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void Vvideo___024root___eval_static__TOP(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_static__TOP\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.video__DOT__cdd__DOT__counter = 0U;
}

VL_ATTR_COLD void Vvideo___024root___eval_initial(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_initial\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__pllclk__0 = vlSelfRef.pllclk;
    vlSelfRef.__Vtrigprevexpr___TOP__RESET__0 = vlSelfRef.RESET;
    vlSelfRef.__Vtrigprevexpr___TOP__pixelClock__0 
        = vlSelfRef.pixelClock;
}

VL_ATTR_COLD void Vvideo___024root___eval_final(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_final\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vvideo___024root___eval_settle(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_settle\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__act(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___dump_triggers__act\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge pllclk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(negedge RESET)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @(posedge pixelClock)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__nba(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___dump_triggers__nba\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge pllclk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(negedge RESET)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @(posedge pixelClock)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvideo___024root___ctor_var_reset(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___ctor_var_reset\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->a = VL_RAND_RESET_I(1);
    vlSelf->b = VL_RAND_RESET_I(1);
    vlSelf->HSYNC = VL_RAND_RESET_I(1);
    vlSelf->VSYNC = VL_RAND_RESET_I(1);
    vlSelf->pllclk = VL_RAND_RESET_I(1);
    vlSelf->c = VL_RAND_RESET_I(1);
    vlSelf->d = VL_RAND_RESET_I(1);
    vlSelf->Rt = VL_RAND_RESET_I(5);
    vlSelf->Gt = VL_RAND_RESET_I(6);
    vlSelf->Bt = VL_RAND_RESET_I(5);
    vlSelf->RESET = VL_RAND_RESET_I(1);
    vlSelf->horizontalCount = VL_RAND_RESET_I(11);
    vlSelf->verticalCount = VL_RAND_RESET_I(10);
    vlSelf->VALID_PIXELS = VL_RAND_RESET_I(1);
    vlSelf->pixelClock = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__vramAddress = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__cdd__DOT__counter = VL_RAND_RESET_I(28);
    vlSelf->video__DOT__gs__DOT__VALID_H = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__gs__DOT__VALID_V = VL_RAND_RESET_I(1);
    vlSelf->__Vdly__horizontalCount = VL_RAND_RESET_I(11);
    vlSelf->__Vdly__verticalCount = VL_RAND_RESET_I(10);
    vlSelf->__Vtrigprevexpr___TOP__pllclk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__RESET__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__pixelClock__0 = VL_RAND_RESET_I(1);
}
