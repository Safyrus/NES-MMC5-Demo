mdl_world_drw_entity_pos:
    ;
    LDA entity_pos_lo, X
    STA tmp
    LDA entity_pos_hi, X
    STA tmp+1

    ;
    TXA
    ORA #$10
    TAX
    ;
    LDA global_entity_buffer_adr_bnk+$6000, X
    BEQ @load
    JMP @end
    @load:

    ;
    LDA screen_draw_obj_buf+2
    AND #$F0
    STA global_entity_buffer_pos_y+$6000, X
    ;
    LDA screen_draw_obj_buf+2
    ASL
    ASL
    ASL
    ASL
    STA global_entity_buffer_pos_x+$6000, X
    ;
    LDA game_scroll_x
    AND #$0F
    STA tmp+2
    LDA game_scroll_y
    ASL
    ASL
    ASL
    ASL
    CLC
    ADC tmp+2
    STA global_entity_buffer_pos_hi+$6000, X

    ;
    LDY #$00
    LDA (tmp), Y
    STA global_entity_buffer_adr_bnk+$6000, X
    ;
    INY
    LDA (tmp), Y
    STA global_entity_buffer_adr_lo+$6000, X
    ;
    INY
    LDA (tmp), Y
    STA global_entity_buffer_adr_hi+$6000, X
    ;
    INY
    LDA (tmp), Y
    STA global_entity_buffer_size+$6000, X
    ;
    INY
    LDA (tmp), Y
    STA global_entity_buffer_spr_nb+$6000, X
    ;
    BEQ @end
    STA tmp+2

    LDX global_entity_spr_counter

    ;
    INY
    LDA (tmp), Y
    STA tmp+3
    @spr:
        ;
        LDA tmp+3
        STA global_entity_buffer_spr+$6000, X
        CLC
        ADC #$02
        STA tmp+3
        ;
        INY
        LDA (tmp), Y
        STA global_entity_buffer_spr_offset+$6000, X
        ;
        INY
        LDA (tmp), Y
        STA global_entity_buffer_atr+$6000, X
        ;
        INX
        ;
        LDA tmp+2
        SEC
        SBC #$01
        STA tmp+2
        BNE @spr

    STX global_entity_spr_counter

    @end:
    ; return
    RTS
