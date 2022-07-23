mdl_ctrl_load_scr_all:
    LDA #STATE::WAIT
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