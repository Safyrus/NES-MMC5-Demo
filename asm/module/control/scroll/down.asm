scroll_down:
    ; increase player position
    JSR get_player_pos_y
    JSR inc_tmp
    LDA tmp
    CMP #$F0
    BCC @set_player_pos
        LDA #$00
        STA tmp
        LDA tmp+1
        CLC
        ADC #$01
        STA tmp+1
    @set_player_pos:
    JSR set_player_pos_y
    ; update sprites
    LDA #DIR::DOWN
    JSR draw_player_move
    ; is it the down side of the level ?
    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    SEC
    SBC #$01
    CMP game_scroll_y+0
    BEQ @end
    ; is scroll_y_lo == $80 ?
    LDA game_scroll_y+1
    CMP #$80
    BNE @no
        ; have we already update screens ?
        LDA game_scroll_flag
        AND #$04
        BNE @scroll
            ; save scroll_y_hi
            LDA game_scroll_y+0
            PHA
            ; and increase it
            TAX
            INX
            STX game_scroll_y+0
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
            LDX #DIR::DOWN
            JSR scroll_update_screen
            ; restore scroll_x_hi if needed
            LDA game_scroll_x+1
            BPL @update_end
                PLA
                STA game_scroll_x+0
            @update_end:
            ; restore scroll_y_hi
            PLA
            STA game_scroll_y+0
            ; tell we updated the screens
            LDA game_scroll_flag
            ORA #$04
            STA game_scroll_flag
            ; continue
            JMP @scroll
    @no:
        LDA game_scroll_flag
        AND #$FB
        STA game_scroll_flag
    
    @scroll:
    LDA game_scroll_y+1
    AND #$07
    BNE @inc_y
        LDY #DIR::DOWN
        JSR scroll_draw_plan
    @inc_y:
    ; scroll_y - player_y
    LDX #$10 + (ENTITY_POS::PLAYER & $0F)
    JSR get_player_pos_y
    LDA game_scroll_y+1
    STA tmp+2
    LDA game_scroll_y+0
    STA tmp+3
    JSR sub_16
    ; if rel_player_y > $80
    LDA tmp
    CMP #$81
    BCC @end
        ; then increase scroll
        JSR inc_scroll_y
    @end:
    RTS

