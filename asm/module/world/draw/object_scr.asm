; X = object type
mdl_world_drw_obj_scr:
    ; get object data address
    LDA object_screen_lo, X
    STA tmp
    LDA object_screen_hi, X
    STA tmp+1

    ; find draw mode
    LDY #$00
    LDA (tmp), Y
    ; mode 1 (normal mode)
    CMP #$01
    BNE @normal_mode_end
    @normal_mode:
        LDX #$00
        JMP mdl_world_fill_scr_buf
    @normal_mode_end:
    CMP #$02
    BNE @random_mode_end
    @random_mode:
        ; get random power
        JSR inc_tmp
        LDA (tmp), Y
        ; create random mask
        TAX
        LDA #$01
        JSR pwr_2
        TAX
        DEX
        ; fill screen
        JMP mdl_world_fill_scr_buf
    @random_mode_end:
    CMP #$03
    BNE @x_offset_end
    @x_offset:
        LDA #$01
        EOR screen_draw_flag
        STA screen_draw_flag
        RTS
    @x_offset_end:
    CMP #$04
    BNE @y_offset_end
    @y_offset:
        LDA #$20
        EOR screen_draw_flag
        STA screen_draw_flag
        RTS
    @y_offset_end:

    @end:
    RTS


;
mdl_world_fill_scr_buf:
    ; store random
    STX tmp+5
    ; get tile low
    JSR inc_tmp
    LDA (tmp), Y
    STA tmp+2
    ; get tile high
    JSR inc_tmp
    LDA (tmp), Y
    STA tmp+3

    ; get screen buffer address high
    LDA scrbuf_index
    AND #$0C
    ASL
    CLC
    ADC #$C0
    STA tmp+1
    ; get screen buffer address low
    LDA #$00
    STA tmp

    ; draw low tile
    LDA tmp+2
    STA tmp+4
    JSR mdl_world_fill_scr_buf_half

    ; draw high tile
    LDA tmp+3
    STA tmp+4
    LDA #$00
    STA tmp+5
    JSR mdl_world_fill_scr_buf_half

    RTS


; tmp = write adr
; tmp+4 = tile
; tmp+5 = max random
; Note: overflow of 64 bytes
mdl_world_fill_scr_buf_half:
    LDX #$00
    @loop_x:
        ;
        LDY #$00
        @loop_y:
            STY tmp+6
            JSR rand
            LDY tmp+6
            AND tmp+5
            CLC
            ADC tmp+4
            ; store tile
            STA (tmp), Y
            ; loop
            INY
            BNE @loop_y
        ; add 256 to the address
        LDY tmp+1
        INY
        STY tmp+1
        ; loop
        INX
        CPX #$04
        BNE @loop_x
    RTS
