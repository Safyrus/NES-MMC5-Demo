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

    LDA game_state
    CMP #STATE::DIALOG
    BEQ @end
        LDA #$00
        STA dialog_data_idx+0
        LDA #$02
        STA dialog_data_idx+1
        LDA #$00
        STA dialog_last_char
        LDA #$01
        STA dialog_data_bit_offset
        LDA #(PPU_RD_BUF_SIZE-1)
        STA dialog_buf_data_idx
        LDA #$08
        STA dialog_nl_offset
        LDA #$03
        STA dialog_speed
    @end:
    RTS
