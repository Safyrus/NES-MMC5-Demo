inc_scroll_x_hi:
    PHA

    LDA level_wh
    AND #$0F
    STA tmp+7
    LDA game_scroll_x+0
    CLC
    ADC #$01
    JSR mod_sign
    STA game_scroll_x+0

    PLA
    RTS

inc_scroll_x_tile:
    PHA

    LDA game_scroll_x+1
    CLC
    ADC #$08
    BCC @end
        JSR inc_scroll_x_hi
        LDA #$00
    @end:
    STA game_scroll_x+1
    PLA
    RTS

inc_scroll_x:
    PHA

    LDA game_scroll_x+1
    CLC
    ADC #$01
    BCC @end
        JSR inc_scroll_x_hi
        LDA #$00
    @end:
    STA game_scroll_x+1
    PLA
    RTS

inc_scroll_y_hi:
    PHA

    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    STA tmp+7
    LDA game_scroll_y+0
    CLC
    ADC #$01
    JSR mod_sign
    STA game_scroll_y+0

    PLA
    RTS

inc_scroll_y_tile:
    PHA

    LDA game_scroll_y+1
    CLC
    ADC #$08
    CMP #$F0
    BCC @end
        JSR inc_scroll_y_hi
        LDA #$00
    @end:
    STA game_scroll_y+1
    PLA
    RTS


inc_scroll_y:
    PHA

    LDA game_scroll_y+1
    CLC
    ADC #$01
    CMP #$F0
    BCC @end
        JSR inc_scroll_y_hi
        LDA #$00
    @end:
    STA game_scroll_y+1
    PLA
    RTS


dec_scroll_x_hi:
    PHA

    LDA level_wh
    AND #$0F
    STA tmp+7
    LDA game_scroll_x+0
    SEC
    SBC #$01
    JSR mod_sign
    STA game_scroll_x+0

    PLA
    RTS

dec_scroll_x_tile:
    PHA

    LDA game_scroll_x+1
    SEC
    SBC #$08
    BCS @end
        JSR dec_scroll_x_hi
        LDA #$F8
    @end:
    STA game_scroll_x+1
    PLA
    RTS

dec_scroll_x:
    PHA

    LDA game_scroll_x+1
    SEC
    SBC #$01
    BCS @end
        JSR dec_scroll_x_hi
        LDA #$FF
    @end:
    STA game_scroll_x+1
    PLA
    RTS

dec_scroll_y_hi:
    PHA

    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    STA tmp+7
    LDA game_scroll_y+0
    SEC
    SBC #$01
    JSR mod_sign
    STA game_scroll_y+0

    PLA
    RTS

dec_scroll_y_tile:
    PHA

    LDA game_scroll_y+1
    SEC
    SBC #$08
    BCS @end
        JSR dec_scroll_y_hi
        LDA #$E8
    @end:
    STA game_scroll_y+1
    PLA
    RTS


dec_scroll_y:
    PHA

    LDA game_scroll_y+1
    SEC
    SBC #$01
    BCS @end
        JSR dec_scroll_y_hi
        LDA #$EF
    @end:
    STA game_scroll_y+1
    PLA
    RTS
