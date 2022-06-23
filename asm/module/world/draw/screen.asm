module_world_draw_screen:
    ; set scrbuf_index
    JSR scroll2scrBufIdx

    ; get screen buffer bank
    LDA scrbuf_index
    AND #$03
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0

    ; do we need to draw expansion tiles ?
    LDA game_substate
    CMP #$F0
    BEQ @draw_hi

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

    JMP @draw_end

    @draw_hi:

    LDY #$00

    ; wait to be in the frame to write to expansion RAM
    @wait:
        BIT MMC5_SCNL_STAT
        BVC @wait

    LDA scrbuf_index
    AND #$0C
    CMP #$04
    BEQ @exp_ram_1
    CMP #$08
    BEQ @exp_ram_2

    @exp_ram_0:
        LDA $6400, Y
        STA MMC5_EXP_RAM, Y
        LDA $6400+$100, Y
        STA MMC5_EXP_RAM+$100, Y
        LDA $6400+$200, Y
        STA MMC5_EXP_RAM+$200, Y
        LDA $6400+$300, Y
        STA MMC5_EXP_RAM+$300, Y
        ; loop
        INY
        BNE @exp_ram_0
        JMP @draw_end

    @exp_ram_1:
        LDA $6C00, Y
        STA MMC5_EXP_RAM, Y
        LDA $6C00+$100, Y
        STA MMC5_EXP_RAM+$100, Y
        LDA $6C00+$200, Y
        STA MMC5_EXP_RAM+$200, Y
        LDA $6C00+$300, Y
        STA MMC5_EXP_RAM+$300, Y
        ; loop
        INY
        BNE @exp_ram_1
        JMP @draw_end

    @exp_ram_2:
        LDA $7400, Y
        STA MMC5_EXP_RAM, Y
        LDA $7400+$100, Y
        STA MMC5_EXP_RAM+$100, Y
        LDA $7400+$200, Y
        STA MMC5_EXP_RAM+$200, Y
        LDA $7400+$300, Y
        STA MMC5_EXP_RAM+$300, Y
        ; loop
        INY
        BNE @exp_ram_2

    @draw_end:
    ; increment game_substate
    LDA game_substate
    CLC
    ADC #$10
    STA game_substate
    ; enable background, scroll and palette updadtes
    LDA nmi_flags
    ORA #(NMI_BKG+NMI_SCRL+NMI_PLT)
    STA nmi_flags

    @end:
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
    JSR dec_scroll_y_tile
    ; draw
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
    RTS


;
module_world_draw_up:
    pushreg
    push_scroll

    ; ; move scroll one row to the top
    ; JSR dec_scroll_y_tile
    ; draw
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
    RTS


mdl_world_drw_x:
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

    ; wait to be in frame to render expansion time correctly
    @wait_inframe:
        LDA MMC5_SCNL_STAT
        AND #$40
        BEQ @wait_inframe

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
        LDA MMC5_SCNL_STAT
        AND #$40
        BEQ @wait_inframe

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
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0

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
    CLC
    ADC #$04
    STA tmp+1
    LDA (tmp), Y
    ; set high tile
    STA (tmp+2), Y
    LDA tmp+1
    SEC
    SBC #$04
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
    CLC
    ADC #$04
    STA tmp+1
    LDA (tmp), Y
    ; set high tile
    STA (tmp+2), Y
    LDA tmp+1
    SEC
    SBC #$04
    STA tmp+1
    ;
    JSR inc_scroll_x_tile
    JSR inc_tmp
    JSR inc_tmp2

    RTS
