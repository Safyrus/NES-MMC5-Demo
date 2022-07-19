inc_tmp:
    PHA

    LDA tmp
    CLC
    ADC #$01
    STA tmp
    BNE @end
        LDA tmp+1
        CLC
        ADC #$01
        STA tmp+1

    @end:
    PLA
    RTS


inc_tmp2:
    PHA

    LDA tmp+2
    CLC
    ADC #$01
    STA tmp+2
    BNE @end
        LDA tmp+3
        CLC
        ADC #$01
        STA tmp+3

    @end:
    PLA
    RTS


dec_tmp:
    PHA

    LDA tmp
    SEC
    SBC #$01
    STA tmp
    CMP #$FF
    BNE @end
        LDA tmp+1
        SEC
        SBC #$01
        STA tmp+1

    @end:
    PLA
    RTS


; A = 8 bits value to add
add_tmp:
    PHA

    CLC
    ADC tmp
    STA tmp
    BCC @end
        LDA tmp+1
        ADC #$00
        STA tmp+1

    @end:
    PLA
    RTS


; A = 8 bits value to add
add_tmp2:
    PHA

    CLC
    ADC tmp+2
    STA tmp+2
    BCC @end
        LDA tmp+3
        ADC #$00
        STA tmp+3

    @end:
    PLA
    RTS


; A = 8 bits value to sub
sub_tmp:
    PHA

    SEC
    SBC tmp+0
    PHP
    EOR #$FF
    CLC
    ADC #$01
    STA tmp+0
    PLP
    BCC @end
    BEQ @end
        LDA tmp+1
        SEC
        SBC #$01
        STA tmp+1

    @end:
    PLA
    RTS


; Substract tmp+2 from tmp
; return to tmp
sub_16:
    PHA

    LDA tmp+0
    SEC
    SBC tmp+2
    STA tmp+0
    BCS @end
    BEQ @end
        LDA tmp+1
        SEC
        SBC #$01
        STA tmp+1
    @end:
    LDA tmp+1
    SEC
    SBC tmp+3
    STA tmp+1

    PLA
    RTS
