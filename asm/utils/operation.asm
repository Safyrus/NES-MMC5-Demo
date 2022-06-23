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

