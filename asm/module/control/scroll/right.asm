scroll_right:
    ; increase player position
    JSR get_player_pos_x
    JSR inc_tmp
    JSR set_player_pos_x
    ; update sprites
    LDA #DIR::RIGHT
    JSR draw_player_move
    ; is it the right side of the level ?
    LDA level_wh
    AND #$0F
    SEC
    SBC #$01
    CMP game_scroll_x+0
    BEQ @end
    ; is scroll_x_lo == $80 ?
    LDA game_scroll_x+1
    CMP #$80
    BNE @no
        ; have we already update screens ?
        LDA game_scroll_flag
        AND #$01
        BNE @scroll
            ; save scroll_x_hi
            LDA game_scroll_x+0
            PHA
            ; and increase it
            TAX
            INX
            STX game_scroll_x+0
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
            LDX #DIR::RIGHT
            JSR scroll_update_screen
            ; restore scroll_y_hi if needed
            LDA game_scroll_y+1
            BPL @update_end
                PLA
                STA game_scroll_y+0
            @update_end:
            ; restore scroll_x_hi
            PLA
            STA game_scroll_x+0
            ; tell we updated the screens
            LDA game_scroll_flag
            ORA #$01
            STA game_scroll_flag
            ; continue
            JMP @scroll
    @no:
        LDA game_scroll_flag
        AND #$FE
        STA game_scroll_flag
    
    @scroll:
    LDA game_scroll_x+1
    AND #$07
    BNE @inc_x
        LDY #DIR::RIGHT
        JSR scroll_draw_plan
    @inc_x:
    ; scroll_x - player_x
    LDX #$10 + (ENTITY_POS::PLAYER & $0F)
    JSR get_player_pos_x
    LDA game_scroll_x+1
    STA tmp+2
    LDA game_scroll_x+0
    STA tmp+3
    JSR sub_16
    ; if rel_player_x > $80
    LDA tmp
    CMP #$81
    BCC @end
        ; then increase scroll
        JSR inc_scroll_x
    @end:
    RTS

