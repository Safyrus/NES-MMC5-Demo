; div/mod A by tmp+7
; return to:
; - A: mod
; - X: div
div:
    LDX #$00
    SEC
    @loop:
        SBC tmp+7
        INX
        BCS @loop
    ADC tmp+7
    DEX
    RTS


; mod A (signed) by tmp+7 (unsigned)
; return to A
mod_sign:
    BPL @next
        CLC
        ADC tmp+7
        JMP mod_sign
    @next:
    CMP tmp+7
    BCC @end
        SBC tmp+7
        JMP mod_sign
    @end:
    RTS

; A = val
; X = power of 2
; return in A (X is lost)
pwr_2:
    @loop:
        ASL
        DEX
        BNE @loop
    @end:
    RTS


; find the last max value in an array
; tmp = array adress
; Y = array size -1
; return in Y the index and in tmp+2 the max value
max_arr:
    push_ax

    LDX #$00
    STX tmp+2
    @loop:
        ; is it greather ?
        LDA (tmp), Y
        CMP tmp+2
        BCC @next
            ; yes
            STA tmp+2
            TYA
            TAX
        @next:
        ; loop
        DEY
        BPL @loop

    TXA
    TAY
    pull_ax
    RTS
