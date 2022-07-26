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

    AND #$08
    BEQ @draw_tile
    JMP @draw_ui

    @draw_tile:
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

        JSR mdl_world_drw_scrn_init_packet

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

        @draw_tile_end:
        LDA #$00
        STA background, X
        STX background_index

        ; increment game_substate
        LDA game_substate
        CLC
        ADC #$08
        STA game_substate

        JMP @draw_end


    @draw_ui:
        JSR mdl_world_drw_scrn_init_packet
        LDY #$40
        LDA #$24
        @loop_ui:
            STA background, X
            INX
            DEY
            BNE @loop_ui
        JMP @draw_tile_end


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
            JMP @draw_exp
        @exp_ram_1:
            LDA #$6C
            JMP @draw_exp
        @exp_ram_2:
            LDA #$74
        @draw_exp:
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


mdl_world_drw_scrn_init_packet:
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
    STA tmp
    LDA game_substate
    LSR
    AND #$04
    CLC
    ADC tmp
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
    AND #$C0
    STA background, X
    STA tmp
    INX

    RTS
