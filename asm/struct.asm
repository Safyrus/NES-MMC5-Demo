.struct Module
    ; bank to load.
    ; If bit 7 is clear, then it means the end of an module array
    bank    .byte
    ; Pointer to the start of the module.
    ; Each module is load at $8000-9FFF
    ; so the pointer must be in this range.
    pointer .word
    ; use for padding
    pad .byte
.endstruct