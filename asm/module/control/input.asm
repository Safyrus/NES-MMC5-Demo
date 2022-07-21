; X = index in global entity
player_input:
    JSR update_btn_timer
    LDA buttons_1_timer
    ; if button was just pressed
    BNE @scroll
        JSR readjoy
        LDA buttons_1
        LDY #$07
        @loop_check:
            LSR
            BCC @loop_check_next
                LDA @jump_table_check_hi, Y
                PHA
                LDA @jump_table_check_lo, Y
                PHA
                RTS
            @loop_check_next:
            DEY
            BPL @loop_check
        JMP @end
    ; else
    @scroll:
        LDA buttons_1
        LDY #$07
        @loop_move:
            LSR
            BCC @loop_move_next
                LDA @jump_table_move_hi, Y
                PHA
                LDA @jump_table_move_lo, Y
                PHA
                RTS
            @loop_move_next:
            DEY
            BPL @loop_move
    @end:
    RTS

    @jump_table_check_lo:
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(check_scroll_up-1)
        .byte <(check_scroll_down-1)
        .byte <(check_scroll_left-1)
        .byte <(check_scroll_right-1)
    @jump_table_check_hi:
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(check_scroll_up-1)
        .byte >(check_scroll_down-1)
        .byte >(check_scroll_left-1)
        .byte >(check_scroll_right-1)

    @jump_table_move_lo:
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(scroll_up-1)
        .byte <(scroll_down-1)
        .byte <(scroll_left-1)
        .byte <(scroll_right-1)
    @jump_table_move_hi:
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(scroll_up-1)
        .byte >(scroll_down-1)
        .byte >(scroll_left-1)
        .byte >(scroll_right-1)


check_scroll_up:
    push_scroll

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
    STA buttons_1_timer
    STA buttons_1

    @end:
    pull_scroll
    RTS

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

check_scroll_left:
    push_scroll

    JSR setScroll2PlayerPos
    JSR dec_scroll_x_tile
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
        ; if 0 == player_x_hi
        BNE @end
            ; if (player_x_lo >> 3) == 1
            LDA global_entity_buffer_pos_x, X
            AND #$F8
            CMP #$08
            BNE @end
    @cancel:
    ; cancel input
    LDA #$00
    STA buttons_1_timer
    STA buttons_1

    @end:
    pull_scroll
    RTS

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



setScroll2PlayerPos:
    ; get player_y_hi
    LDA global_entity_buffer_pos_hi, X
    LSR
    LSR
    LSR
    LSR
    ; set game_scroll_y to player_y
    STA game_scroll_y+0
    LDA global_entity_buffer_pos_y, X
    STA game_scroll_y+1
    ; get player_x_hi
    LDA global_entity_buffer_pos_hi, X
    AND #$0F
    ; set game_scroll_x to player_x
    STA game_scroll_x+0
    LDA global_entity_buffer_pos_x, X
    STA game_scroll_x+1

    RTS
