check_scroll_down:
    push_scroll

    JSR setScroll2PlayerPos
    JSR inc_scroll_y_tile
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
        STA tmp
        ; get level height - 1
        LDA level_wh
        LSR
        LSR
        LSR
        LSR
        SEC
        SBC #$01
        ; if level height - 1 == player_y_hi
        CMP tmp
        BNE @end
            ; if (player_y_lo >> 3) == 29
            LDA global_entity_buffer_pos_y, X
            AND #$F8
            CMP #$E8
            BNE @end
    @cancel:
    ; cancel input
    LDA #$00
    STA buttons_1_timer
    STA buttons_1

    @end:
    pull_scroll
    RTS

