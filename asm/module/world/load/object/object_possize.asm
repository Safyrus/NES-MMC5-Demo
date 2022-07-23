;
mdl_world_drw_subobj_possize:
    ; get object category
    JSR mdl_world_subobj_cat_idx
    ; get base addresse
    LDA possize_obj_sub_base_lo, X
    STA tmp
    LDA possize_obj_sub_base_hi, X
    STA tmp+1
    ; get index for the category
    LDA screen_draw_obj_buf+1
    AND #$3F
    TAX

    ; find object addresse
    @loop:
        CPX #$00
        BEQ @loop_end
        DEX
        LDA #$13
        JSR add_tmp
        JMP @loop
    @loop_end:

    ; copy object into bufer
    LDY #$01
    @copy:
        LDA (tmp), Y
        STA screen_draw_subobj_possize_buf-1, Y
        ; loop
        INY
        CPY #19
        BNE @copy

    ; ----------------
    ; change tiles base on flags
    ; ----------------
    ; check if right side is open
    LDY #$00
    LDA (tmp), Y
    LSR
    BCC @right_end
        PHA
        LDX #$00
        @right_loop:
            LDA screen_draw_subobj_possize_buf+1, X
            STA screen_draw_subobj_possize_buf+2, X
            INX
            INX
            INX
            CPX #$12
            BNE @right_loop
        PLA
    @right_end:
    ; check if left side is open
    LSR
    BCC @left_end
        PHA
        LDX #$00
        @left_loop:
            LDA screen_draw_subobj_possize_buf+1, X
            STA screen_draw_subobj_possize_buf+0, X
            INX
            INX
            INX
            CPX #$12
            BNE @left_loop
        PLA
    @left_end:
    ; check if down side is open
    LSR
    BCC @down_end
        PHA
        LDX #$00
        @down_loop:
            LDA screen_draw_subobj_possize_buf_lo+3, X
            STA screen_draw_subobj_possize_buf_lo+6, X
            INX
            CPX #$03
            BNE @down_loop
        LDX #$00
        @down_loop2:
            LDA screen_draw_subobj_possize_buf_hi+3, X
            STA screen_draw_subobj_possize_buf_hi+6, X
            INX
            CPX #$03
            BNE @down_loop2
        PLA
    @down_end:
    ; check if up side is open
    LSR
    BCC @up_end
        PHA
        LDX #$00
        @up_loop:
            LDA screen_draw_subobj_possize_buf_lo+3, X
            STA screen_draw_subobj_possize_buf_lo+0, X
            INX
            CPX #$03
            BNE @up_loop
        LDX #$00
        @up_loop2:
            LDA screen_draw_subobj_possize_buf_hi+3, X
            STA screen_draw_subobj_possize_buf_hi+0, X
            INX
            CPX #$03
            BNE @up_loop2
        PLA
    @up_end:

    ; ----------------
    ; draw the box
    ; ----------------
    ; get position
    LDA screen_draw_obj_buf+2
    JSR pos_to_int
    LDA tmp+6
    STA tmp
    LDA tmp+7
    STA tmp+1
    ; x = w-1
    LDA screen_draw_obj_buf+3
    AND #$0F
    TAX
    DEX
    STX tmp+6
    ; y = h-1
    LDA screen_draw_obj_buf+3
    LSR
    LSR
    LSR
    LSR
    TAY
    DEY
    STY tmp+7
    ; while y >= 0
    @while_y:
        ; x = w-1
        LDA tmp+6
        TAX
        ; idx = 3
        LDA #$03
        ; if y == 0
        CPY #$00
        BNE @if_y_h1
            ; idx = 0
            LDA #$00
        @if_y_h1:
        ; if y == h-1
        CPY tmp+7
        BNE @while_x
            ; idx = 0
            LDA #$06
        ; while x >= 0
        @while_x:
            ; save idx
            PHA
            ; if x > 0
            CPX #$01
            BCC @if_x_w1
                ; idx++
                ADC #$00
            @if_x_w1:
            ; if x == w-1
            CPX tmp+6
            BNE @place_tile
                ; idx++
                ADC #$00
            @place_tile:
            ; place tile
            JSR mdl_world_drw_possize_tile
            ; restore idx
            PLA
            ; x--
            DEX
            BPL @while_x
        ; y--
        DEY
        BPL @while_y

    ; return
    RTS


mdl_world_drw_possize_tile:
    ; save idx
    STA tmp+3

    pushreg

    ; push pos
    LDA tmp
    PHA
    LDA tmp+1
    PHA

    JSR wait_at_frame_end

    ; y*32
    STY MMC5_MUL_A
    LDA #$20
    STA MMC5_MUL_B

    ; pos += y*32
    LDA MMC5_MUL_A
    LDY MMC5_MUL_B
    JSR add_tmp
    TYA
    ADC tmp+1
    STA tmp+1

    ; pos += x
    TXA
    JSR add_tmp

    ; add screen_draw_flag offset
    LDA screen_draw_flag
    AND #$21
    JSR add_tmp
    ; add screen address
    LDA scrbuf_index
    AND #$0C
    ASL
    CLC
    ADC #$C0
    ADC tmp+1
    STA tmp+1

    ; screen[pos] = tile[idx]
    LDY #$00
    LDX tmp+3
    LDA screen_draw_subobj_possize_buf_lo, X
    BEQ @high_tile
        STA (tmp), Y
    @high_tile:
    LDA tmp+1
    CLC
    ADC #$04
    STA tmp+1
    LDA screen_draw_subobj_possize_buf_hi, X
    BEQ @end
        STA (tmp), Y

    @end:
    ; pull pos
    PLA
    STA tmp+1
    PLA
    STA tmp

    pullreg
    RTS

