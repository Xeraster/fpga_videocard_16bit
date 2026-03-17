// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvideo.h for the primary calling header

#include "Vvideo__pch.h"
#include "Vvideo__Syms.h"
#include "Vvideo___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvideo___024root___dump_triggers__stl(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvideo___024root___eval_triggers__stl(Vvideo___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvideo___024root___eval_triggers__stl\n"); );
    Vvideo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered.set(0U, (IData)(vlSelfRef.__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vvideo___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
