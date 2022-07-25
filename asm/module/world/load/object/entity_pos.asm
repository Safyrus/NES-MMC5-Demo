mdl_world_drw_entity_pos:
    ;
    LDA entity_pos_lo, X
    STA tmp
    LDA entity_pos_hi, X
    STA tmp+1

    ; add offset for pos entity
    TXA
    ORA #$10
    TAX

    ;
    LDA tmp
    STA global_entity_buffer_data_lo+$6000, X
    LDA tmp+1
    STA global_entity_buffer_data_hi+$6000, X
    LDA #OBJ_BANK
    STA global_entity_buffer_data_bnk+$6000, X

    ; check if entity was already loaded
    LDA global_entity_buffer_adr_bnk+$6000, X
    BNE @end
    @load:
    ; load entity y position
    LDA screen_draw_obj_buf+2
    AND #$F0
    STA global_entity_buffer_pos_y+$6000, X
    ; load entity x position
    LDA screen_draw_obj_buf+2
    ASL
    ASL
    ASL
    ASL
    STA global_entity_buffer_pos_x+$6000, X
    ; load entity high position
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

    ; load entity action function bank
    LDY #$00
    LDA (tmp), Y
    STA global_entity_buffer_adr_bnk+$6000, X
    ; load entity action function adresse low
    INY
    LDA (tmp), Y
    STA global_entity_buffer_adr_lo+$6000, X
    ; load entity action function adresse high
    INY
    LDA (tmp), Y
    STA global_entity_buffer_adr_hi+$6000, X
    
    @end:
    ; return
    RTS
