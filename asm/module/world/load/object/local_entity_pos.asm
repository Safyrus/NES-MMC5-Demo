mdl_world_drw_subentity_pos:
    ; get base adress
    JSR mdl_world_subobj_cat_idx
    LDA local_entity_pos_lo, X
    STA tmp
    LDA local_entity_pos_hi, X
    STA tmp+1

    ; get index for the category
    LDY #$00
    LDA screen_draw_obj_buf+1
    AND #$3F
    TAX

    ; find object addresse
    BEQ @loop_end
    @loop:
        ;
        LDA (tmp), Y
        JSR add_tmp
        ;
        DEX
        BNE @loop
    @loop_end:
    JSR inc_tmp

    ;
    LDA tmp+0
    STA tmp+2
    STA tmp+4
    LDA tmp+1
    STA tmp+3
    STA tmp+5

    ; tmp = entity_buf_adr
    JSR scrBufIdx2entityBufAdr

    JSR scrBufIdx2int
    TAY
    LDA local_entity_counter, Y
    JSR add_tmp
    CLC
    ADC #$01
    STA local_entity_counter, Y

    ;
    LDY #$00
    ; load act function bank
    LDA (tmp+2), Y
    STA (tmp), Y
    ; load act function low adr
    JSR inc_tmp2
    LDA #$40
    JSR add_tmp
    LDA (tmp+2), Y
    STA (tmp), Y
    ; load act function high adr
    JSR inc_tmp2
    LDA #$40
    JSR add_tmp
    LDA (tmp+2), Y
    STA (tmp), Y

    ; load entity x position
    LDA #$C0
    JSR add_tmp
    LDA screen_draw_obj_buf+2
    ASL
    ASL
    ASL
    ASL
    STA (tmp), Y
    ; load entity y position
    LDA #$40
    JSR add_tmp
    LDA screen_draw_obj_buf+2
    AND #$F0
    STA (tmp), Y

    ; load data address bank
    LDA #$40
    JSR add_tmp
    LDA #OBJ_BANK
    STA (tmp), Y
    ; load data address low
    LDA #$40
    JSR add_tmp
    LDA tmp+4
    STA (tmp), Y
    ; load data address high
    LDA #$40
    JSR add_tmp
    LDA tmp+5
    STA (tmp), Y

    RTS
