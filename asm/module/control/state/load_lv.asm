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