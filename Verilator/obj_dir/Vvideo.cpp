// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vvideo__pch.h"

//============================================================
// Constructors

Vvideo::Vvideo(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vvideo__Syms(contextp(), _vcname__, this)}
    , pllclk{vlSymsp->TOP.pllclk}
    , RESET{vlSymsp->TOP.RESET}
    , pixelClock{vlSymsp->TOP.pixelClock}
    , a{vlSymsp->TOP.a}
    , b{vlSymsp->TOP.b}
    , HSYNC{vlSymsp->TOP.HSYNC}
    , VSYNC{vlSymsp->TOP.VSYNC}
    , c{vlSymsp->TOP.c}
    , d{vlSymsp->TOP.d}
    , Rt{vlSymsp->TOP.Rt}
    , Gt{vlSymsp->TOP.Gt}
    , Bt{vlSymsp->TOP.Bt}
    , VALID_PIXELS{vlSymsp->TOP.VALID_PIXELS}
    , horizontalCount{vlSymsp->TOP.horizontalCount}
    , verticalCount{vlSymsp->TOP.verticalCount}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vvideo::Vvideo(const char* _vcname__)
    : Vvideo(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vvideo::~Vvideo() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vvideo___024root___eval_debug_assertions(Vvideo___024root* vlSelf);
#endif  // VL_DEBUG
void Vvideo___024root___eval_static(Vvideo___024root* vlSelf);
void Vvideo___024root___eval_initial(Vvideo___024root* vlSelf);
void Vvideo___024root___eval_settle(Vvideo___024root* vlSelf);
void Vvideo___024root___eval(Vvideo___024root* vlSelf);

void Vvideo::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vvideo::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vvideo___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vvideo___024root___eval_static(&(vlSymsp->TOP));
        Vvideo___024root___eval_initial(&(vlSymsp->TOP));
        Vvideo___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vvideo___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vvideo::eventsPending() { return false; }

uint64_t Vvideo::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vvideo::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vvideo___024root___eval_final(Vvideo___024root* vlSelf);

VL_ATTR_COLD void Vvideo::final() {
    Vvideo___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vvideo::hierName() const { return vlSymsp->name(); }
const char* Vvideo::modelName() const { return "Vvideo"; }
unsigned Vvideo::threads() const { return 1; }
void Vvideo::prepareClone() const { contextp()->prepareClone(); }
void Vvideo::atClone() const {
    contextp()->threadPoolpOnClone();
}
