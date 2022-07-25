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
        INY
        INY
        LDA (tmp), Y
        STA tmp+2
        DEY
        LDA (tmp), Y
        JSR get_scr_buf_adr
        JSR mdl_world_fill_scr_buf_half
        LDA tmp+2
        JMP mdl_world_fill_scr_buf_half
    @normal_mode_end:
    CMP #$02
    BNE @random_mode_end
    @random_mode:
        ; get random chance
        INY
        LDA (tmp), Y
        STA tmp+2
        ; get max random
        INY
        LDA (tmp), Y
        STA tmp+3
        ; get low tile
        INY
        LDA (tmp), Y
        STA tmp+4
        ; get high tile
        INY
        LDA (tmp), Y
        STA tmp+5
        ; fill screen
        JSR get_scr_buf_adr
        JMP mdl_world_fill_scr_buf_rnd
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


get_scr_buf_adr:
    PHA
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
    ; return
    PLA
    RTS


; tmp = screen buffer adr
; tmp+2 = random chance
; tmp+3 = max random mask
; tmp+4 = low tile
; tmp+5 = high tile
; tmp+6 = tmp variable
; Note: overflow of 64 bytes
mdl_world_fill_scr_buf_rnd:
    LDX #$04
    @loop_x:
        LDY #$00
        @loop_y:
            ;
            STY tmp+7
            JSR rand
            LDY tmp+7
            ;
            CMP tmp+2
            BCC @no_rnd
                AND tmp+3
                CLC
                ADC tmp+4
                JMP @set_lo_tile
            @no_rnd:
                LDA tmp+4
            @set_lo_tile:
            STA (tmp), Y
            ;
            BEQ @no_hi_tile
            @hi_tile:
                LDA tmp+5
                JMP @set_hi_tile
            @no_hi_tile:
                LDA #$00
            @set_hi_tile:
            STA tmp+6
            LDA tmp+1
            CLC
            ADC #$04
            STA tmp+1
            LDA tmp+6
            STA (tmp), Y
            LDA tmp+1
            SEC
            SBC #$04
            STA tmp+1
            @loop_y_next:
            ; loop
            INY
            BNE @loop_y
        ; add 256 to the address
        LDY tmp+1
        INY
        STY tmp+1
        ; loop
        DEX
        BNE @loop_x
    RTS


; A = tile
; tmp = screen buffer adr
mdl_world_fill_scr_buf_half:
    LDX #$04
    @loop_x:
        LDY #$00
        @loop_y:
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
        DEX
        BNE @loop_x
    RTS
