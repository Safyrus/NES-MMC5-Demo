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
