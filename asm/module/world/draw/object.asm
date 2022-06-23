; Y = index in screen_objects_buffer
module_world_draw_object:
    pushreg

    STY tmp+2

    ; get object type
    LDA screen_objects_buffer, Y
    AND #$0F
    TAX
    ; get object flags
    LDA screen_objects_buffer, Y
    LSR
    LSR
    LSR
    LSR
    LSR
    TAY

    ; get function to call
    LDA @draw_fct_lo, Y
    STA tmp
    LDA @draw_fct_hi, Y
    STA tmp+1

    ; for rts call
    LDA #>(@end-1)
    PHA
    LDA #<(@end-1)
    PHA

    ; call draw function
    JMP (tmp)

    @draw_fct_lo:
    .byte <mdl_world_drw_obj_scr
    .byte <mdl_world_drw_obj_size
    .byte <mdl_world_drw_obj_pos
    .byte <mdl_world_drw_obj_error
    .byte <mdl_world_drw_subobj_scr
    .byte <mdl_world_drw_subobj_size
    .byte <mdl_world_drw_subobj_pos
    .byte <mdl_world_drw_obj_error

    @draw_fct_hi:
    .byte >mdl_world_drw_obj_scr
    .byte >mdl_world_drw_obj_size
    .byte >mdl_world_drw_obj_pos
    .byte >mdl_world_drw_obj_error
    .byte >mdl_world_drw_subobj_scr
    .byte >mdl_world_drw_subobj_size
    .byte >mdl_world_drw_subobj_pos
    .byte >mdl_world_drw_obj_error

    @end:
    pullreg
    RTS


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

    @end:
    RTS


; X = object type
; tmp+2 = object index
mdl_world_drw_obj_pos:
    ; get object data address
    LDA object_pos_lo, X
    STA tmp
    LDA object_pos_hi, X
    STA tmp+1

    ; get position
    LDA tmp+2
    TAX
    INX
    LDA screen_objects_buffer, X
    ; get draw address offset
    JSR pos_to_int
    LDA tmp+6
    STA tmp+2
    LDA tmp+7
    STA tmp+3
    ; add screen address
    LDA scrbuf_index
    AND #$0C
    ASL
    CLC
    ADC #$C0
    CLC
    ADC tmp+3
    STA tmp+3

    ; push draw address
    PHA
    LDA tmp+2
    PHA

    ; load size
    LDY #$00
    LDA (tmp), Y
    JSR inc_tmp
    ; size to int
    JSR size_to_int
    ; save width
    AND #$0F
    STA tmp+5
    ; save size to int
    LDA MMC5_MUL_A
    STA tmp+4

    ; draw low tile
    LDA #$20
    STA tmp+6
    LDA #$00
    STA tmp+7
    JSR mdl_world_drw_obj_pos_half
    ; pull draw address
    PLA
    STA tmp+2
    PLA
    CLC
    ADC #$04
    STA tmp+3
    ; draw high tile
    JSR mdl_world_drw_obj_pos_half

    @end:
    RTS


; TODO
mdl_world_drw_obj_size:
mdl_world_drw_obj_error:
mdl_world_drw_subobj_scr:
mdl_world_drw_subobj_size:
mdl_world_drw_subobj_pos:
    RTS


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


mdl_world_drw_obj_pos_half:
    LDX #$00
    LDY #$00
    @draw:
        ; get tile
        LDA (tmp), Y
        ; draw tile
        STA (tmp+2), Y
        ; check for next line
        INX
        CPX tmp+5
        BNE @draw_loop
            ; reset X
            LDA #$00
            TAX
            ; next line
            LDA tmp+6
            SEC
            SBC tmp+5
            JSR add_tmp2
            LDA tmp+7
            JSR add_tmp
        @draw_loop:
        ; loop
        INY
        CPY tmp+4
        BNE @draw

    TYA
    JSR add_tmp

    RTS