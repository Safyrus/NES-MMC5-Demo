module_world_draw_screen:
    ; set scrbuf_index
    JSR scroll2scrBufIdx

    ; get screen buffer bank
    LDA scrbuf_index
    AND #$03
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    ; do we need to draw expansion tiles ?
    LDA game_substate
    CMP #$F0
    BCS @draw_hi

    ; get screen buffer address high
    LDA scrbuf_index
    AND #$0C
    ASL
    CLC
    ADC #$60
    STA tmp+1
    ; get screen buffer address low
    LDA #$00
    STA tmp

    LDX background_index
    ;
    LDA #$40
    STA background, X
    INX
    ;
    LDA game_substate
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    TAY
    ;
    CLC
    ADC #$20
    STA background, X
    INX
    ;
    TYA
    CLC
    ADC tmp+1
    STA tmp+1
    ;
    LDA game_substate
    ASL
    ASL
    STA background, X
    STA tmp
    INX

    LDY #$00
    @loop_lo:
        ;
        LDA (tmp), Y
        ;
        STA background, X
        INX
        ;
        INY
        CPY #$40
        BNE @loop_lo

    LDA #$00
    STA background, X
    STX background_index

    ; increment game_substate
    LDA game_substate
    CLC
    ADC #$10
    STA game_substate

    JMP @draw_end

    @draw_hi:

    LDY #$00

    ; wait to be in the frame to write to expansion RAM
    @wait:
        BIT scanline
        BVC @wait

    LDA scrbuf_index
    AND #$0C
    CMP #$04
    BEQ @exp_ram_1
    CMP #$08
    BEQ @exp_ram_2

    @exp_ram_0:
        LDA #$64
        JMP @draw
    @exp_ram_1:
        LDA #$6C
        JMP @draw
    @exp_ram_2:
        LDA #$74

    @draw:
    JSR mdl_world_drw_scrn_exp
    ; increment game_substate
    LDA game_substate
    CLC
    ADC #$04
    STA game_substate
    @draw_end:
    ; enable background, scroll, sprites and palette updates
    LDA nmi_flags
    ORA #(NMI_BKG+NMI_SCRL+NMI_PLT+NMI_SPR)
    STA nmi_flags

    @end:
    RTS

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


;
module_world_draw_right:
    pushreg
    push_scroll

    ; move scroll one screen to the right
    JSR inc_scroll_x_hi
    ; draw
    JSR mdl_world_drw_x

    pull_scroll
    pullreg
    RTS


;
module_world_draw_left:
    pushreg
    push_scroll

    ; move scroll one column to the right
    JSR inc_scroll_x_tile
    ; draw
    JSR mdl_world_drw_x

    pull_scroll
    pullreg
    RTS


;
module_world_draw_down:
    pushreg
    push_scroll

    ; move scroll one screen to the bottom minus one row
    JSR inc_scroll_y_hi
    ; JSR dec_scroll_y_tile
    ; draw
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
    RTS


;
module_world_draw_up:
    pushreg
    push_scroll

    JSR inc_scroll_y_tile
    ; JSR inc_scroll_y_hi
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
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
