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

VL_ATTR_COLD void Vvideo___024root___eval_initial__TOP(Vvideo___024root* vlSelf);

VL_ATTR_COLD void Vvideo___024root___eval_initial(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_initial\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vvideo___024root___eval_initial__TOP(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__HSYNC__0 = vlSelfRef.HSYNC;
    vlSelfRef.__Vtrigprevexpr___TOP__pllclk__0 = vlSelfRef.pllclk;
    vlSelfRef.__Vtrigprevexpr___TOP__RESET__0 = vlSelfRef.RESET;
    vlSelfRef.__Vtrigprevexpr___TOP__pixelClock__0 
        = vlSelfRef.pixelClock;
}

VL_ATTR_COLD void Vvideo___024root___eval_initial__TOP(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_initial__TOP\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.MEMCS16 = 1U;
    vlSelfRef.IOERR = 1U;
    vlSelfRef.NOWS = 0U;
    vlSelfRef.IO_RDY = 1U;
}

VL_ATTR_COLD void Vvideo___024root___eval_final(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_final\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__stl(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vvideo___024root___eval_phase__stl(Vvideo___024root* vlSelf);

VL_ATTR_COLD void Vvideo___024root___eval_settle(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_settle\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vvideo___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("video.v", 305, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vvideo___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__stl(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___dump_triggers__stl\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvideo___024root___stl_sequent__TOP__0(Vvideo___024root* vlSelf);

VL_ATTR_COLD void Vvideo___024root___eval_stl(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_stl\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vvideo___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vvideo___024root___stl_sequent__TOP__0(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___stl_sequent__TOP__0\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1;
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 = 0;
    // Body
    vlSelfRef.HSYNC = vlSelfRef.video__DOT__gs__DOT__HSYNC;
    vlSelfRef.VSYNC = vlSelfRef.video__DOT__gs__DOT__VSYNC;
    vlSelfRef.Red = vlSelfRef.video__DOT__iRed;
    vlSelfRef.Green = vlSelfRef.video__DOT__iGreen;
    vlSelfRef.Blue = vlSelfRef.video__DOT__iBlue;
    vlSelfRef.ADS_OE = vlSelfRef.video__DOT__isathing__DOT__iADS_OE;
    vlSelfRef.ADS_LATCH = vlSelfRef.BALE;
    vlSelfRef.video__DOT__full = (0x27fU <= (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr));
    vlSelfRef.IOCS16 = vlSelfRef.SBHE;
    vlSelfRef.FPGA_WR = (1U & (~ (IData)(vlSelfRef.video__DOT__isathing__DOT__absIOR)));
    vlSelfRef.VRAM_en = vlSelfRef.video__DOT__iVRAM_en;
    vlSelfRef.write_cmd = vlSelfRef.video__DOT__iwrite_cmd;
    vlSelfRef.read_cmd = vlSelfRef.video__DOT__iread_cmd;
    vlSelfRef.AV = vlSelfRef.video__DOT__AVi;
    vlSelfRef.data_out = vlSelfRef.video__DOT__data_outi;
    vlSelfRef.video__DOT____Vcellinp__wbv____pinNumber9 
        = ((~ ((IData)(vlSelfRef.video__DOT__isathing__DOT__iFPGA_IO_EN) 
               | (IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle))) 
           & (0x27fU <= (IData)(vlSelfRef.video__DOT__testramthingy__DOT__waddr)));
    vlSelfRef.video__DOT__writeBufferEmpty = ((~ (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__ifull)) 
                                              & ((IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__r_ptr) 
                                                 == (IData)(vlSelfRef.video__DOT__wbv__DOT__dataFifo__DOT__w_ptr)));
    vlSelfRef.video__DOT__wbv__DOT__aEmpty = ((~ (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__ifull)) 
                                              & ((IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__r_ptr) 
                                                 == (IData)(vlSelfRef.video__DOT__wbv__DOT__addressFifo__DOT__w_ptr)));
    vlSelfRef.video__DOT____Vcellinp__testramthingy____pinNumber8 
        = (1U & ((IData)(vlSelfRef.video__DOT__isathing__DOT__actualBusCycle) 
                 | ((IData)(vlSelfRef.video__DOT__isathing__DOT__i_undedicedIsaCycle) 
                    | ((~ (IData)(vlSelfRef.video__DOT__isathing__DOT__iADS_OE)) 
                       | (IData)(vlSelfRef.BALE)))));
    video__DOT__isathing__DOT____VdfgRegularize_h12aca4bb_0_1 
        = (1U & (~ ((((~ (IData)(vlSelfRef.IOR)) | 
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

VL_ATTR_COLD void Vvideo___024root___eval_triggers__stl(Vvideo___024root* vlSelf);

VL_ATTR_COLD bool Vvideo___024root___eval_phase__stl(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_phase__stl\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vvideo___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vvideo___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__ico(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___dump_triggers__ico\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VicoTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

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
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(negedge HSYNC)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge pllclk)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @(negedge RESET)\n");
    }
    if ((8ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @(posedge pixelClock)\n");
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
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(negedge HSYNC)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge pllclk)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @(negedge RESET)\n");
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @(posedge pixelClock)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvideo___024root___ctor_var_reset(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___ctor_var_reset\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->HSYNC = VL_RAND_RESET_I(1);
    vlSelf->VSYNC = VL_RAND_RESET_I(1);
    vlSelf->pllclk = VL_RAND_RESET_I(1);
    vlSelf->Red = VL_RAND_RESET_I(5);
    vlSelf->Green = VL_RAND_RESET_I(6);
    vlSelf->Blue = VL_RAND_RESET_I(5);
    vlSelf->RESET = VL_RAND_RESET_I(1);
    vlSelf->horizontalCount = VL_RAND_RESET_I(11);
    vlSelf->verticalCount = VL_RAND_RESET_I(10);
    vlSelf->VALID_PIXELS = VL_RAND_RESET_I(1);
    vlSelf->pixelClock = VL_RAND_RESET_I(1);
    vlSelf->BALE = VL_RAND_RESET_I(1);
    vlSelf->MEMW = VL_RAND_RESET_I(1);
    vlSelf->MEMR = VL_RAND_RESET_I(1);
    vlSelf->SMEMR = VL_RAND_RESET_I(1);
    vlSelf->SMEMW = VL_RAND_RESET_I(1);
    vlSelf->IOW = VL_RAND_RESET_I(1);
    vlSelf->IOR = VL_RAND_RESET_I(1);
    vlSelf->SBHE = VL_RAND_RESET_I(1);
    vlSelf->NOWS = VL_RAND_RESET_I(1);
    vlSelf->IOCS16 = VL_RAND_RESET_I(1);
    vlSelf->MEMCS16 = VL_RAND_RESET_I(1);
    vlSelf->IO_RDY = VL_RAND_RESET_I(1);
    vlSelf->IOERR = VL_RAND_RESET_I(1);
    vlSelf->ISACLK = VL_RAND_RESET_I(1);
    vlSelf->TE0 = VL_RAND_RESET_I(1);
    vlSelf->TE1 = VL_RAND_RESET_I(1);
    vlSelf->TE2 = VL_RAND_RESET_I(1);
    vlSelf->TE3 = VL_RAND_RESET_I(1);
    vlSelf->FPGA_WR = VL_RAND_RESET_I(1);
    vlSelf->ADS_OE = VL_RAND_RESET_I(1);
    vlSelf->ADS_LATCH = VL_RAND_RESET_I(1);
    vlSelf->VRAM_en = VL_RAND_RESET_I(1);
    vlSelf->write_cmd = VL_RAND_RESET_I(1);
    vlSelf->read_cmd = VL_RAND_RESET_I(1);
    vlSelf->AV = VL_RAND_RESET_I(20);
    vlSelf->AV_in = VL_RAND_RESET_I(20);
    vlSelf->data_out = VL_RAND_RESET_I(16);
    vlSelf->data_in = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__vramAddress = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__Rt = VL_RAND_RESET_I(5);
    vlSelf->video__DOT__Gt = VL_RAND_RESET_I(6);
    vlSelf->video__DOT__Bt = VL_RAND_RESET_I(5);
    vlSelf->video__DOT__iRed = VL_RAND_RESET_I(5);
    vlSelf->video__DOT__iGreen = VL_RAND_RESET_I(6);
    vlSelf->video__DOT__iBlue = VL_RAND_RESET_I(5);
    vlSelf->video__DOT__AVi = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__data_outi = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__ivblank = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__videoDisplayRegister = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__settingsRegister = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__statusRegister = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__addressComReg = VL_RAND_RESET_I(24);
    vlSelf->video__DOT__nextThingToWrite = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__alreadyIncrementedAdsPtr = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__writeBufferVramData = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__writeBufferVramAddress = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__writeBufferEmpty = VL_RAND_RESET_I(1);
    vlSelf->video__DOT____Vcellinp__wbv____pinNumber9 = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__gtfoonnextclock = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__doData = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__full = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__alreadyWrote = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__iread_cmd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__iwrite_cmd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__iVRAM_en = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__DStxresult = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__lastAdsRequest = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__vsyncctr = VL_RAND_RESET_I(1);
    vlSelf->video__DOT____Vcellinp__testramthingy____pinNumber8 = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__cdd__DOT__counter = VL_RAND_RESET_I(28);
    vlSelf->video__DOT__gs__DOT__HSYNC = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__gs__DOT__VSYNC = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__gs__DOT__VALID_H = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__gs__DOT__VALID_V = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__ififoRead = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__iWRITEBUF_IO_EN = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__iwrite_cmd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__ichip_select = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__aEmpty = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__r_ptr = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__w_ptr = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__iwrite_en = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__ialmostFull = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__ifull = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->video__DOT__wbv__DOT__dataFifo__DOT__theBlock__DOT__mem[__Vi0] = VL_RAND_RESET_I(16);
    }
    vlSelf->video__DOT__wbv__DOT__addressFifo__DOT__r_ptr = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__wbv__DOT__addressFifo__DOT__w_ptr = VL_RAND_RESET_I(8);
    vlSelf->video__DOT__wbv__DOT__addressFifo__DOT__iwrite_en = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__wbv__DOT__addressFifo__DOT__ifull = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->video__DOT__wbv__DOT__addressFifo__DOT__theBlock__DOT__mem[__Vi0] = VL_RAND_RESET_I(20);
    }
    vlSelf->video__DOT__isathing__DOT__i_undedicedIsaCycle = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__r1_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__r2_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__r3_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__absIOR = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__absIOW = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__fastBALE = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__iADS_OE = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__iFPGA_IO_EN = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__lastAdsRequest = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__isathing__DOT__actualBusCycle = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__TE0i = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__TE1i = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__TE2i = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__TE3i = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__isahighctr = VL_RAND_RESET_I(3);
    vlSelf->video__DOT__isathing__DOT__isacyclessincebale = VL_RAND_RESET_I(3);
    vlSelf->video__DOT__isathing__DOT__ISACLKSTATE = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOW1_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOW2_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOW3_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOR1_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOR2_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__IOR3_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__BALE1_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__BALE2_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__isathing__DOT__BALE3_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__ireadSignal = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__ichipEnable = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__ififoWrite = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__ififoRead = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__iNextVramAddress = VL_RAND_RESET_I(20);
    vlSelf->video__DOT__testramthingy__DOT__ipixelOutput = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__testramthingy__DOT__iframeEnd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__fastFrameEnd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__waddr = VL_RAND_RESET_I(10);
    vlSelf->video__DOT__testramthingy__DOT__raddr = VL_RAND_RESET_I(10);
    vlSelf->video__DOT__testramthingy__DOT__delayBeforeWriteAgain = VL_RAND_RESET_I(5);
    vlSelf->video__DOT__testramthingy__DOT__fastEvenOrOdd = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__r1_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__r2_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__r3_Pulse = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__alreadySubtracted = VL_RAND_RESET_I(1);
    vlSelf->video__DOT__testramthingy__DOT__bsCounter = VL_RAND_RESET_I(3);
    vlSelf->video__DOT__testramthingy__DOT__b1dout = VL_RAND_RESET_I(16);
    vlSelf->video__DOT__testramthingy__DOT__b2dout = VL_RAND_RESET_I(16);
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->video__DOT__testramthingy__DOT__b1__DOT__mem[__Vi0] = VL_RAND_RESET_I(16);
    }
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->video__DOT__testramthingy__DOT__b2__DOT__mem[__Vi0] = VL_RAND_RESET_I(16);
    }
    vlSelf->__Vdly__video__DOT__vsyncctr = VL_RAND_RESET_I(1);
    vlSelf->__Vdly__horizontalCount = VL_RAND_RESET_I(11);
    vlSelf->__Vdly__verticalCount = VL_RAND_RESET_I(10);
    vlSelf->__VdlyVal__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 = VL_RAND_RESET_I(16);
    vlSelf->__VdlyDim0__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 = VL_RAND_RESET_I(10);
    vlSelf->__VdlySet__video__DOT__testramthingy__DOT__b1__DOT__mem__v0 = 0;
    vlSelf->__VdlyVal__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 = VL_RAND_RESET_I(16);
    vlSelf->__VdlyDim0__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 = VL_RAND_RESET_I(10);
    vlSelf->__VdlySet__video__DOT__testramthingy__DOT__b2__DOT__mem__v0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__HSYNC__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__pllclk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__RESET__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__pixelClock__0 = VL_RAND_RESET_I(1);
}
