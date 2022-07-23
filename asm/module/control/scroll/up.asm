scroll_up:
    ; decrease player position
    JSR get_player_pos_y
    JSR dec_tmp
    LDA tmp
    CMP #$F0
    BCC @set_player_pos
        LDA #$EF
        STA tmp
    @set_player_pos:
    JSR set_player_pos_y
    ; update sprites
    LDA #DIR::UP
    JSR draw_player_move
    ; is it the up side of the level ?
    LDA game_scroll_y+0
    BNE @check_update
    LDA game_scroll_y+1
    BEQ @end
    @check_update:
    ; is scroll_y_lo == $7F ?
    LDA game_scroll_y+1
    CMP #$7F
    BNE @no
        ; have we already update screens ?
        LDA game_scroll_flag
        AND #$08
        BNE @scroll
            ; if we are in the right of the current screen
            LDA game_scroll_x+1
            BPL @update
                ; save scroll_x_hi
                LDA game_scroll_x+0
                PHA
                ; and increase it
                TAX
                INX
                STX game_scroll_x+0
            @update:
            ; command necessary screen to update
            LDX #DIR::UP
            JSR scroll_update_screen
            ; restore scroll_x_hi if needed
            LDA game_scroll_x+1
            BPL @update_end
                PLA
                STA game_scroll_x+0
            @update_end:
            ; tell we updated the screens
            LDA game_scroll_flag
            ORA #$08
            STA game_scroll_flag
            ; continue
            JMP @scroll
    @no:
        LDA game_scroll_flag
        AND #$F7
        STA game_scroll_flag
    
    @scroll:
    LDA game_scroll_y+1
    AND #$07
    BNE @dec_y
        LDY #DIR::UP
        JSR scroll_draw_plan
    @dec_y:
    ; scroll_y - player_y
    LDX #$10 + (ENTITY_POS::PLAYER & $0F)
    JSR get_player_pos_y
    LDA game_scroll_y+1
    STA tmp+2
    LDA game_scroll_y+0
    STA tmp+3
    JSR sub_16
    ; if rel_player_y < $80
    LDA tmp
    CMP #$80
    BCS @end
        ; then decrease scroll
        JSR dec_scroll_y
    @end:
    RTS

