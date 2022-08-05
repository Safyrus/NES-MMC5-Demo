dialog_next:
    JSR update_btn_timer
    LDA buttons_1_timer
    BNE @end
        JSR readjoy
        LDA buttons_1
        BEQ @end
            LDX game_substate
            INX
            STX game_substate
    @end:
    RTS
