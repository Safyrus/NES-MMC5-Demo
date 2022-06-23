.include "utils.asm"
.include "scroll.asm"

module_control:
    ; reset background index
    LDA #$00
    STA background_index
    STA background

    ; choose a action based on the game state
    LDX game_state
    LDA @mdl_ctrl_act_hi,X
    PHA
    LDA @mdl_ctrl_act_lo,X
    PHA
    @wait:
    RTS ; RTS trick

    @mdl_ctrl_act_hi:
        .byte >(mdl_ctrl_load_lv-1)
        .byte >(@wait-1)
        .byte >(mdl_ctrl_draw_scr-1)
        .byte >(mdl_ctrl_draw_scr-1)
        .byte >(mdl_ctrl_load_scr_all-1)
        .byte >(mdl_ctrl_normal-1)
    @mdl_ctrl_act_lo:
        .byte <(mdl_ctrl_load_lv-1)
        .byte <(@wait-1)
        .byte <(mdl_ctrl_draw_scr-1)
        .byte <(mdl_ctrl_draw_scr-1)
        .byte <(mdl_ctrl_load_scr_all-1)
        .byte <(mdl_ctrl_normal-1)


mdl_ctrl_load_lv:
    LDA #STATE::NORMAL
    STA game_state

    ; set the world and level to 0
    LDA #$00
    STA world
    LDA #$00
    STA level

    ; add the world_load_level module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_WORLD
    STA lower_module_array, X
    INX
    LDA #<module_world_load_level
    STA lower_module_array, X
    INX
    LDA #>module_world_load_level
    STA lower_module_array, X

    RTS


mdl_ctrl_load_scr_all:
    LDA #STATE::NORMAL
    STA game_state

    ; add the world_load_screen_all module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_WORLD
    STA lower_module_array, X
    INX
    LDA #<module_world_load_screen_all
    STA lower_module_array, X
    INX
    LDA #>module_world_load_screen_all
    STA lower_module_array, X

    RTS


mdl_ctrl_draw_scr:
    LDA game_state
    CMP #STATE::DRAW_SCREEN_WAIT
    BEQ @wait

    @start:
        LDA #STATE::DRAW_SCREEN_WAIT
        STA game_state
        LDA #$00
        STA game_substate
        JMP @load

    @wait:
        LDA game_substate
        BEQ @wait_end
        JMP @load
    
    @load:
        ; add the module_world_draw_screen module
        LDA #LOWER_MODULE_MAX_PRIO
        JSR mdl_ctrl_lw_adr
        LDA #MODULE_WORLD
        STA lower_module_array, X
        INX
        LDA #<module_world_draw_screen
        STA lower_module_array, X
        INX
        LDA #>module_world_draw_screen
        STA lower_module_array, X

        JMP @end

    @wait_end:
        LDA #STATE::NORMAL
        STA game_state
        LDY #DIR::RIGHT
        JSR scroll_draw_plan
        LDY #DIR::DOWN
        JSR scroll_draw_plan

    @end:
    RTS


mdl_ctrl_normal:
    ; input
    JSR update_btn_timer
    LDA buttons_1_timer
    BNE @end
        JSR readjoy
        LDA buttons_1
        BEQ @end
            LDX #$07
            @loop:
                LSR
                BCC @loop_next
                    LDA @jump_table_hi, X
                    PHA
                    LDA @jump_table_lo, X
                    PHA
                    RTS
                @loop_next:
                DEX
                BPL @loop
    @end:
    RTS

    @jump_table_lo:
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(scroll_up-1)
        .byte <(scroll_down-1)
        .byte <(scroll_left-1)
        .byte <(scroll_right-1)
    @jump_table_hi:
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(scroll_up-1)
        .byte >(scroll_down-1)
        .byte >(scroll_left-1)
        .byte >(scroll_right-1)

