scroll_left:
    ; decrease player position
    JSR get_player_pos_x
    JSR dec_tmp
    JSR set_player_pos_x
    ; update sprites
    LDA #DIR::LEFT
    JSR draw_player_move
    ; is it the left side of the level ?
    LDA game_scroll_x+0
    BNE @check_update
    LDA game_scroll_x+1
    BEQ @end
    @check_update:
    ; is scroll_x_lo == $7F ?
    LDA game_scroll_x+1
    CMP #$7F
    BNE @no
        ; have we already update screens ?
        LDA game_scroll_flag
        AND #$02
        BNE @scroll
            ; if we are in the bottom of the current screen
            LDA game_scroll_y+1
            BPL @update
                ; save scroll_y_hi
                LDA game_scroll_y+0
                PHA
                ; and increase it
                TAX
                INX
                STX game_scroll_y+0
            @update:
            ; command necessary screen to update
            LDX #DIR::LEFT
            JSR scroll_update_screen
            ; restore scroll_y_hi if needed
            LDA game_scroll_y+1
            BPL @update_end
                PLA
                STA game_scroll_y+0
            @update_end:
            ; tell we updated the screens
            LDA game_scroll_flag
            ORA #$02
            STA game_scroll_flag
            ; continue
            JMP @scroll
    @no:
        LDA game_scroll_flag
        AND #$FD
        STA game_scroll_flag
    
    @scroll:
    LDA game_scroll_x+1
    AND #$07
    BNE @dec_x
        LDY #DIR::LEFT
        JSR scroll_draw_plan
    @dec_x:
    ; scroll_x - player_x
    LDX #$10 + (ENTITY_POS::PLAYER & $0F)
    JSR get_player_pos_x
    LDA game_scroll_x+1
    STA tmp+2
    LDA game_scroll_x+0
    STA tmp+3
    JSR sub_16
    ; if rel_player_x < $80
    LDA tmp
    CMP #$80
    BCS @end
        ; then decrease scroll
        JSR dec_scroll_x
    @end:
    RTS

