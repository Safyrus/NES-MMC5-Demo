; X = index in global entity
player_input:
    JSR update_btn_timer
    LDA buttons_1_timer
    ; if button was just pressed
    BNE @scroll
        JSR readjoy
        LDA buttons_1
        LDY #$07
        @loop_check:
            LSR
            BCC @loop_check_next
                LDA @jump_table_check_hi, Y
                PHA
                LDA @jump_table_check_lo, Y
                PHA
                RTS
            @loop_check_next:
            DEY
            BPL @loop_check
        JMP @end
    ; else
    @scroll:
        LDA buttons_1
        LDY #$07
        @loop_move:
            LSR
            BCC @loop_move_next
                LDA @jump_table_move_hi, Y
                PHA
                LDA @jump_table_move_lo, Y
                PHA
                RTS
            @loop_move_next:
            DEY
            BPL @loop_move
    @end:
    RTS

    @jump_table_check_lo:
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(check_scroll_up-1)
        .byte <(check_scroll_down-1)
        .byte <(check_scroll_left-1)
        .byte <(check_scroll_right-1)
    @jump_table_check_hi:
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(check_scroll_up-1)
        .byte >(check_scroll_down-1)
        .byte >(check_scroll_left-1)
        .byte >(check_scroll_right-1)

    @jump_table_move_lo:
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(scroll_up-1)
        .byte <(scroll_down-1)
        .byte <(scroll_left-1)
        .byte <(scroll_right-1)
    @jump_table_move_hi:
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(scroll_up-1)
        .byte >(scroll_down-1)
        .byte >(scroll_left-1)
        .byte >(scroll_right-1)
