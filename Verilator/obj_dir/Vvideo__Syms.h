// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VVIDEO__SYMS_H_
#define VERILATED_VVIDEO__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vvideo.h"

// INCLUDE MODULE CLASSES
#include "Vvideo___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vvideo__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vvideo* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vvideo___024root               TOP;

    // CONSTRUCTORS
    Vvideo__Syms(VerilatedContext* contextp, const char* namep, Vvideo* modelp);
    ~Vvideo__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
