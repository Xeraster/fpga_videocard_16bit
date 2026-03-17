// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvideo.h for the primary calling header

#include "Vvideo__pch.h"
#include "Vvideo__Syms.h"
#include "Vvideo___024root.h"

void Vvideo___024root___ctor_var_reset(Vvideo___024root* vlSelf);

Vvideo___024root::Vvideo___024root(Vvideo__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vvideo___024root___ctor_var_reset(this);
}

void Vvideo___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vvideo___024root::~Vvideo___024root() {
}
