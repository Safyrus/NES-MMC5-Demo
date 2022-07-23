check_scroll_right:
    push_scroll

    JSR setScroll2PlayerPos
    JSR inc_scroll_x_tile
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
        ; get player_x_hi
        LDA global_entity_buffer_pos_hi, X
        AND #$0F
        STA tmp
        ; get level width - 1
        LDA level_wh
        AND #$0F
        SEC
        SBC #$01
        ; if level width - 1 == player_x_hi
        CMP tmp
        BNE @end
            ; if (player_x_lo >> 3) == 31
            LDA global_entity_buffer_pos_x, X
            AND #$F8
            CMP #$F8
            BNE @end
    @cancel:
    ; cancel input
    LDA #$00
    STA buttons_1_timer
    STA buttons_1

    @end:
    pull_scroll
    RTS
