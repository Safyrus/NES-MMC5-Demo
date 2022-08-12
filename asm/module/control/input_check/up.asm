check_scroll_up:
    push_scroll

    LDA global_entity_buffer_state, X
    AND #$FC
    ORA #DIR::UP
    STA global_entity_buffer_state, X
    LDA #DIR::UP
    JSR draw_player_move

    JSR setScroll2PlayerPos
    JSR dec_scroll_y_tile
    ; get tile low value
    JSR scroll2scrBufAdr
    LDA tmp+2
    STA MMC5_RAM_BNK
    LDY #$00
    LDA (tmp), Y
    ; if tile is not a collision
    AND #$80
    BNE @cancel
        LDA #PRGRAM_SPR_BANK
        STA MMC5_RAM_BNK
        ; get player_y_hi
        LDA global_entity_buffer_pos_hi, X
        LSR
        LSR
        LSR
        LSR
        ; if 0 == player_y_hi
        BNE @end
            ; if (player_y_lo >> 3) == 1
            LDA global_entity_buffer_pos_y, X
            AND #$F8
            CMP #$08
            BNE @end
    @cancel:
    ; cancel input
    LDA #$00
    STA player_move_counter

    @end:
    pull_scroll
    RTS

