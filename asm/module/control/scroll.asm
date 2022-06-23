scroll_right:
    LDA level_wh
    AND #$0F
    SEC
    SBC #$01
    CMP game_scroll_x+0
    BEQ @end
        @check_scr:
        LDA game_scroll_flag
        AND #$02
        BNE @scr_do_update
        LDA game_scroll_x+1
        CMP #SCR_UPD_SCR_X_R
        BCC @check_scr_no
            LDA game_scroll_flag
            AND #$01
            BNE @check_tile
            @scr_do_update:
                LDA game_scroll_flag
                AND #$FD
                ORA #$01
                STA game_scroll_flag
                LDA game_scroll_x+0
                PHA
                CLC
                ADC #$01
                STA game_scroll_x+0
                LDX #DIR::RIGHT
                JSR scroll_update_screen
                PLA
                STA game_scroll_x+0
                JMP @check_tile
        @check_scr_no:
            LDA game_scroll_flag
            AND #$FC
            STA game_scroll_flag
        @check_tile:
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
    LDA game_scroll_x+0
    BNE @scroll
    LDA game_scroll_x+1
    BEQ @end
    @scroll:
        @check_scr:
        LDA game_scroll_x+0
        BEQ @check_tile
        LDA game_scroll_x+1
        CMP #SCR_UPD_SCR_X_L
        BCS @check_scr_no
            LDA game_scroll_flag
            AND #$02
            BNE @check_tile
                ;
                LDA game_scroll_flag
                AND #$FE
                ORA #$02
                STA game_scroll_flag
                ;
                LDX #DIR::LEFT
                JSR scroll_update_screen
                ;
                JMP @check_tile
        @check_scr_no:
            LDA game_scroll_flag
            AND #$FC
            STA game_scroll_flag
        @check_tile:
        LDA game_scroll_x+1
        AND #$07
        BNE @inc_x
            LDY #DIR::LEFT
            JSR scroll_draw_plan
        @inc_x:
        JSR dec_scroll_x
        @end:
        RTS

scroll_down:
    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    SEC
    SBC #$01
    CMP game_scroll_y+0
    BEQ @end
        @check_scr:
        LDA game_scroll_flag
        AND #$08
        BNE @scr_do_update
        LDA game_scroll_y+1
        CMP #SCR_UPD_SCR_Y_D
        BCC @check_scr_no
            LDA game_scroll_flag
            AND #$04
            BNE @check_tile
            @scr_do_update:
                LDA game_scroll_flag
                AND #$F7
                ORA #$04
                STA game_scroll_flag
                LDA game_scroll_y+0
                PHA
                CLC
                ADC #$01
                STA game_scroll_y+0
                LDX #DIR::DOWN
                JSR scroll_update_screen
                PLA
                STA game_scroll_y+0
                JMP @check_tile
        @check_scr_no:
            LDA game_scroll_flag
            AND #$F3
            STA game_scroll_flag
        @check_tile:
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
    LDA game_scroll_y+0
    BNE @scroll
    LDA game_scroll_y+1
    BEQ @end
    @scroll:
        @check_scr:
        LDA game_scroll_y+0
        BEQ @check_tile
        LDA game_scroll_y+1
        CMP #SCR_UPD_SCR_Y_U
        BCS @check_scr_no
            LDA game_scroll_flag
            AND #$08
            BNE @check_tile
                ;
                LDA game_scroll_flag
                AND #$FB
                ORA #$08
                STA game_scroll_flag
                ;
                LDX #DIR::UP
                JSR scroll_update_screen
                ;
                JMP @check_tile
        @check_scr_no:
            LDA game_scroll_flag
            AND #$F3
            STA game_scroll_flag
        @check_tile:
        LDA game_scroll_y+1
        AND #$07
        BNE @inc_y
            LDY #DIR::UP
            JSR scroll_draw_plan
        @inc_y:
        JSR dec_scroll_y
        @end:
        RTS


scroll_update_screen:
    ; get level buffer bank in RAM
    LDA #$00
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0

    JSR mdl_ctrl_update_scrbuf
    ; JSR mdl_ctrl_draw_scr

scroll_end:
    RTS


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
