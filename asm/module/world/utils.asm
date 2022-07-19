mdl_world_ld_wrld_bnk:
    PHA

    ; load the world data in $A000-$DFFF
    LDA world
    ASL
    CLC
    ADC #WORLD_BANK_START+$80
    STA last_frame_BNK+2
    STA MMC5_PRG_BNK1
    CLC
    ADC #$01
    STA last_frame_BNK+3
    STA MMC5_PRG_BNK2

    PLA
    RTS


; A: number to scrbuf_index
mdl_world_A2scrBufIdx:
    ; div A by 3
    TAX
    LDA #$03
    STA tmp+7
    TXA
    JSR div

    ; mod result times 4
    ASL
    ASL
    ; add div result
    STX tmp+7
    CLC
    ADC tmp+7
    ; set scrbuf_index
    STA scrbuf_index

    RTS

; return adr to tmp+2
scroll2expRam:
    PHA

    ; high address
    LDA #>MMC5_EXP_RAM
    STA tmp+3
    LDA game_scroll_y+1
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    ORA tmp+3
    STA tmp+3

    ; low address
    LDA game_scroll_y+1
    AND #$38
    ASL
    ASL
    STA tmp+2
    LDA game_scroll_x+1
    LSR
    LSR
    LSR
    ORA tmp+2
    STA tmp+2

    PLA
    RTS


; return in tmp the screen buffer address from $6000 (lo,hi)
; and in tmp+2 the bank index
scroll2scrBufAdr:
    PHA

    ; ----------------
    ; high address
    ; ----------------
    ; init
    LDA #$60
    STA tmp+1
    ; mod x by 3
    LDA #$03
    STA tmp+7
    LDA game_scroll_x+0
    JSR mod_sign
    ; mul by 8
    ASL
    ASL
    ASL
    ; add
    ORA tmp+1
    STA tmp+1
    ; 
    LDA game_scroll_y+1
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    ORA tmp+1
    STA tmp+1

    ; ----------------
    ; low address
    ; ----------------
    LDA game_scroll_y+1
    AND #$38
    ASL
    ASL
    STA tmp+0
    LDA game_scroll_x+1
    LSR
    LSR
    LSR
    ORA tmp+0
    STA tmp+0

    ; ----------------
    ; bank index
    ; ----------------
    ; mod y by 3
    LDA #$03
    STA tmp+7
    LDA game_scroll_y+0
    JSR mod_sign
    ;
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA tmp+2

    PLA
    RTS


; return in tmp the ppu address (lo,hi)
scroll2ppuAdr:
    PHA

    ; high address
    LDA #$20
    STA tmp+1
    LDA game_scroll_x+0
    AND #$01
    ASL
    ASL
    ORA tmp+1
    STA tmp+1
    LDA game_scroll_y+1
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    ORA tmp+1
    STA tmp+1
    LDA game_scroll_y+0
    AND #$01
    ASL
    ASL
    ASL
    ORA tmp+1
    STA tmp+1

    ; low address
    LDA game_scroll_y+1
    AND #$38
    ASL
    ASL
    STA tmp+0
    LDA game_scroll_x+1
    LSR
    LSR
    LSR
    ORA tmp+0
    STA tmp+0

    PLA
    RTS


;
scroll_fit_lv:
    PHA

    LDA level_wh
    AND #$0F
    STA tmp+7
    LDA game_scroll_x
    JSR mod_sign
    STA game_scroll_x

    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    STA tmp+7
    LDA game_scroll_y
    JSR mod_sign
    STA game_scroll_y

    PLA
    RTS


;
scroll2scrBufIdx:
    pushreg

    ; div x by 3
    LDA #$03
    STA tmp+7
    LDA game_scroll_x
    JSR div
    ; mod result times 4
    ASL
    ASL
    TAY
    ; div y by 3
    LDA game_scroll_y
    JSR div
    ;
    STY tmp+7
    CLC
    ADC tmp+7

    ; set scrbuf_index
    STA scrbuf_index

    pullreg
    RTS

