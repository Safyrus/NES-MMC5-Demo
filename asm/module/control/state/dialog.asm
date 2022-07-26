mdl_ctrl_dialog:
    ; add the module_dialog module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_CTRL
    STA lower_module_array, X
    INX
    LDA #<module_dialog
    STA lower_module_array, X
    INX
    LDA #>module_dialog
    STA lower_module_array, X

    RTS
