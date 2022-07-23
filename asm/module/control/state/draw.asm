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
