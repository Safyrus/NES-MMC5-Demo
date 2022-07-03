scroll_right:
    ; is it the right side of the level ?
    LDA level_wh
    AND #$0F
    SEC
    SBC #$01
    CMP game_scroll_x+0
    BEQ @end
    ; is scroll_x_lo >= $80 ?
    LDA game_scroll_x+1
    BPL @no
        ; is scroll_x_lo < $A0 ?
        CMP #$A0
        BCS @no
            ; have we already update screens ?
            LDA game_scroll_flag
            AND #$01
            BNE @scroll
                ; save scroll_x_hi
                LDA game_scroll_x+0
                PHA
                TAX
                INX
                STX game_scroll_x+0
                ; command necessary screen to update
                LDX #DIR::RIGHT
                JSR scroll_update_screen
                ; restore scsroll_x_hi
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
    JSR inc_scroll_x
    @end:
    RTS

scroll_left:
    ; is it the left side of the level ?
    LDA game_scroll_x+0
    BNE @update
    LDA game_scroll_x+1
    BEQ @end
    @update:
    ; is scroll_x_lo < $80 ?
    LDA game_scroll_x+1
    BMI @no
        ; is scroll_x_lo >= $60 ?
        CMP #$60
        BCC @no
            ; have we already update screens ?
            LDA game_scroll_flag
            AND #$02
            BNE @scroll
                ; command necessary screen to update
                LDX #DIR::LEFT
                JSR scroll_update_screen
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
    JSR dec_scroll_x
    @end:
    RTS

scroll_down:
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
    ; is scroll_y_lo >= $80 ?
    LDA game_scroll_y+1
    BPL @no
        ; is scroll_y_lo < $A0 ?
        CMP #$A0
        BCS @no
            ; have we already update screens ?
            LDA game_scroll_flag
            AND #$04
            BNE @scroll
                ; save scroll_y_hi
                LDA game_scroll_y+0
                PHA
                TAX
                INX
                STX game_scroll_y+0
                ; command necessary screen to update
                LDX #DIR::DOWN
                JSR scroll_update_screen
                ; restore scsroll_y_hi
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
    JSR inc_scroll_y
    @end:
    RTS

scroll_up:
    ; is it the up side of the level ?
    LDA game_scroll_y+0
    BNE @update
    LDA game_scroll_y+1
    BEQ @end
    @update:
    ; is scroll_y_lo < $80 ?
    LDA game_scroll_y+1
    BMI @no
        ; is scroll_y_lo >= $60 ?
        CMP #$60
        BCC @no
            ; have we already update screens ?
            LDA game_scroll_flag
            AND #$08
            BNE @scroll
                ; command necessary screen to update
                LDX #DIR::UP
                JSR scroll_update_screen
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
