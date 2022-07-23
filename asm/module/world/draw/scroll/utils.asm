; A = base high adr
mdl_world_drw_scrn_exp:
    ;
    STA tmp+1
    LDA #>MMC5_EXP_RAM
    STA tmp+3
    ;
    LDA #PRGRAM_SCREEN_BANK
    STA last_frame_BNK+2
    STA MMC5_PRG_BNK1
    ;
    LDA #$78
    STA tmp+5
    ;
    LDY #$00
    STY tmp+0
    STY tmp+2
    STY tmp+4
    STY tmp+6
    ;
    LDA game_substate
    AND #$0F
    @loop_inc:
        BEQ @loop_inc_end
        ;
        LDX tmp+1
        INX
        STX tmp+1
        LDX tmp+3
        INX
        STX tmp+3
        LDX tmp+5
        INX
        STX tmp+5
        ;
        SEC
        SBC #$04
        JMP @loop_inc
    @loop_inc_end:

    @loop_y:
        LDA (tmp), Y
        STA (tmp+2), Y
        AND #$20
        BEQ @no_anim
            LDA tmp+1
            STA (tmp+4), Y
            LDA tmp+0
            STA tmp+7
            TYA
            CLC
            ADC tmp+7
            PHA
            LDA tmp+5
            CLC
            ADC #$04
            STA tmp+7
            PLA
            STA (tmp+6), Y
            JMP @next
        @no_anim:
            STA (tmp+4), Y
        @next:
        ; loop
        INY
        BNE @loop_y
    RTS


mdl_world_drw_x:
    ; load animation buffer bank
    LDA #PRGRAM_SCREEN_BANK
    STA last_frame_BNK+2
    STA MMC5_PRG_BNK1

    ; find number of tile for the first background packet
    @find_nb_tile_first:
    LDA game_scroll_y+1
    LSR
    LSR
    LSR
    STA tmp+5
    LDA #30
    SEC
    SBC tmp+5
    STA tmp+4

    LDA tmp+4
    ORA #$80
    JSR mdl_world_drw_adr

    ; wait to be in frame to render expansion tile correctly
    @wait_inframe:
        BIT scanline
        BVC @wait_inframe

    LDA #$00
    STA counter
    @loop_1:
        JSR mdl_world_drw_x_loop
        ; loop
        LDY counter
        INY
        STY counter
        CPY tmp+4
        BNE @loop_1
    LDA #$00
    STA background, X
    STX background_index

    LDA tmp+5
    BEQ @end
    ORA #$80
    JSR mdl_world_drw_adr

    LDA #$00
    STA counter
    @loop_2:
        JSR mdl_world_drw_x_loop
        ; loop
        LDY counter
        INY
        STY counter
        CPY tmp+5
        BNE @loop_2
    LDA #$00
    STA background, X
    STX background_index

    @end:
    RTS


mdl_world_drw_y:
    ; load animation buffer bank
    LDA #PRGRAM_SCREEN_BANK
    STA last_frame_BNK+2
    STA MMC5_PRG_BNK1

    ; find number of tile for the first background packet
    @find_nb_tile_first:
    LDA game_scroll_x+1
    LSR
    LSR
    LSR
    STA tmp+5
    LDA #32
    SEC
    SBC tmp+5
    STA tmp+4

    LDA tmp+4
    JSR mdl_world_drw_adr

    ; wait to be in frame to render expansion time correctly
    @wait_inframe:
        BIT scanline
        BVC @wait_inframe

    LDA #$00
    STA counter
    @loop_1:
        JSR mdl_world_drw_y_loop
        ; loop
        LDY counter
        INY
        STY counter
        CPY tmp+4
        BNE @loop_1
    LDA #$00
    STA background, X
    STX background_index

    LDA tmp+5
    BEQ @end
    JSR mdl_world_drw_adr

    LDA #$00
    STA counter
    @loop_2:
        JSR mdl_world_drw_y_loop
        ; loop
        LDY counter
        INY
        STY counter
        CPY tmp+5
        BNE @loop_2
    LDA #$00
    STA background, X
    STX background_index

    @end:
    RTS


; A = packet first byte
mdl_world_drw_adr:
    ; start a background packet
    JSR scroll2ppuAdr
    LDX background_index
    STA background, X
    INX
    LDA tmp+1
    STA background, X
    INX
    LDA tmp+0
    STA background, X
    INX

    ; get screen buffer adr
    JSR scroll2scrBufAdr
    LDA tmp+2
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    JSR scroll2expRam

    RTS


mdl_world_drw_x_loop:
    ; get low tile
    LDY #$00
    LDA (tmp), Y
    ; set low tile
    STA background, X
    INX
    ; get high tile
    LDA tmp+1
    PHA
    CLC
    ADC #$04
    STA tmp+1
    LDA (tmp), Y
    ; set high tile
    STA (tmp+2), Y
    JSR mdl_world_drw_loop_anim
    ;
    PLA
    STA tmp+1
    ;
    JSR inc_scroll_y_tile
    LDA #$20
    JSR add_tmp
    JSR add_tmp2

    RTS


mdl_world_drw_y_loop:
    ; get low tile
    LDY #$00
    LDA (tmp), Y
    ; set low tile
    STA background, X
    INX
    ; get high tile
    LDA tmp+1
    PHA
    CLC
    ADC #$04
    STA tmp+1
    LDA (tmp), Y
    ; set high tile
    STA (tmp+2), Y
    JSR mdl_world_drw_loop_anim
    ;
    PLA
    STA tmp+1
    ;
    JSR inc_scroll_x_tile
    JSR inc_tmp
    JSR inc_tmp2

    RTS


mdl_world_drw_loop_anim:
    ;
    AND #$20
    BEQ @no_anim
    @anim:
        ;
        LDA tmp+3
        EOR #$E0
        STA tmp+3
        LDA tmp+0
        STA (tmp+2), Y
        ;
        LDA tmp+3
        EOR #$04
        STA tmp+3
        ;
        LDA last_frame_BNK+0
        CMP #PRGRAM_SCREEN_BANK
        BEQ @anim_bnk_0
        CMP #PRGRAM_SCREEN_BANK+1
        BEQ @anim_bnk_1
        @anim_bnk_2:
            LDA #$60
            CLC
            ADC tmp+1
            STA tmp+1
            JMP @anim_bnk_0
        @anim_bnk_1:
            LDA #$40
            CLC
            ADC tmp+1
            STA tmp+1
        @anim_bnk_0:
        LDA tmp+1
        STA (tmp+2), Y
        ;
        JMP @end
    @no_anim:
        LDA tmp+3
        EOR #$E4
        STA tmp+3
        LDA #$00
        STA (tmp+2), Y
    @end:
    ;
    LDA tmp+3
    EOR #$E4
    STA tmp+3

    RTS
