; X = object type
; tmp+2 = object index
mdl_world_drw_obj_pos:
    ; get object data address
    LDA object_pos_lo, X
    STA tmp
    LDA object_pos_hi, X
    STA tmp+1
    LDX screen_draw_obj_buf+1
    JMP mdl_world_drw_obj_pos_base


; tmp = object adr
; X = obj position
mdl_world_drw_obj_pos_base:
    TXA
    ; get draw address offset
    JSR pos_to_int
    LDA tmp+6
    STA tmp+2
    LDA tmp+7
    STA tmp+3
    ; add screen_draw_flag offset
    LDA screen_draw_flag
    AND #$21
    JSR add_tmp2
    ; add screen address
    LDA scrbuf_index
    AND #$0C
    ASL
    ORA #$C0
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


mdl_world_drw_subobj_pos:
    JSR mdl_world_subobj_cat_idx
    ; get base addresse
    LDA pos_obj_sub_base_lo, X
    STA tmp
    LDA pos_obj_sub_base_hi, X
    STA tmp+1
    ; get index for the category
    LDA screen_draw_obj_buf+1
    AND #$3F
    TAX

    LDY #$00
    @loop:
        CPX #$00
        BEQ @loop_end
        DEX
        LDA (tmp), Y
        JSR size_to_int
        LDA MMC5_MUL_A
        JSR add_tmp
        JSR add_tmp
        INY
        JMP @loop
    @loop_end:
    TYA
    JSR add_tmp

    LDX screen_draw_obj_buf+2
    JMP mdl_world_drw_obj_pos_base


; tmp: load adr
; tmp+2: save adr
; tmp+4: size
; tmp+5: width
mdl_world_drw_obj_pos_half:
    LDX #$00
    LDY #$00
    @draw:
        ; get tile
        LDA (tmp), Y
        BEQ @draw_next
        ; draw low tile
        STA (tmp+2), Y
        @draw_next:
        ; check for next line
        INX
        CPX tmp+5
        BNE @draw_loop
            ; reset X
            LDX #$00
            ; next line
            LDA #$20
            SEC
            SBC tmp+5
            JSR add_tmp2
        @draw_loop:
        ; loop
        INY
        CPY tmp+4
        BNE @draw

    TYA
    JSR add_tmp

    RTS

