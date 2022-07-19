scroll_right:
    ; increase player position
    JSR get_player_pos_x
    JSR inc_tmp
    JSR set_player_pos_x
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
    ; if rel_player_x >= $80
    LDA tmp
    CMP #$80
    BCC @end
        ; then increase scroll
        JSR inc_scroll_x
    @end:
    RTS

scroll_left:
    ; decrease player position
    JSR get_player_pos_x
    JSR dec_tmp
    JSR set_player_pos_x
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
    ; if rel_player_y >= $80
    LDA tmp
    CMP #$80
    BCC @end
        ; then increase scroll
        JSR inc_scroll_y
    @end:
    RTS

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

scroll_update_screen:
    ; get level buffer bank in RAM
    LDA #$00
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0

    JMP mdl_ctrl_update_scrbuf

scroll_draw_plan:
    push_ax

    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_WORLD
    STA lower_module_array, X
    INX
    LDA scroll_draw_arr_lo, Y
    STA lower_module_array, X
    INX
    LDA scroll_draw_arr_hi, Y
    STA lower_module_array, X

    pull_ax
    RTS


scroll_draw_arr_lo:
    .byte <module_world_draw_up
    .byte <module_world_draw_down
    .byte <module_world_draw_left
    .byte <module_world_draw_right
scroll_draw_arr_hi:
    .byte >module_world_draw_up
    .byte >module_world_draw_down
    .byte >module_world_draw_left
    .byte >module_world_draw_right
