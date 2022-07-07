input:
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

    @dbg_input:
    LDA game_scroll_x+1
    AND #$F8
    STA game_scroll_x+1
    LDA game_scroll_y+1
    AND #$F8
    STA game_scroll_y+1
    RTS

    @jump_table_lo:
        .byte <(@dbg_input-1)
        .byte <(@dbg_input-1)
        .byte <(@end-1)
        .byte <(@end-1)
        .byte <(scroll_up-1)
        .byte <(scroll_down-1)
        .byte <(scroll_left-1)
        .byte <(scroll_right-1)
    @jump_table_hi:
        .byte >(@dbg_input-1)
        .byte >(@dbg_input-1)
        .byte >(@end-1)
        .byte >(@end-1)
        .byte >(scroll_up-1)
        .byte >(scroll_down-1)
        .byte >(scroll_left-1)
        .byte >(scroll_right-1)

