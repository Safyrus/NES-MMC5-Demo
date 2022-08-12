; X = index in global entity
player_input:
    LDA global_entity_buffer_state, X
    BNE @normal
        JSR draw_player_move
        LDA #$80
        STA global_entity_buffer_state, X
    @normal:
    ; if button was just pressed
    LDA buttons_1_timer
    BNE @scroll

    @check:
        LDA #BTN_TIMER
        STA player_move_counter
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

    @scroll:
        LDA player_move_counter
        BEQ @end
        SEC
        SBC #$01
        STA player_move_counter
        LDA global_entity_buffer_state, X
        AND #$03
        TAY
        LDA @jump_table_move_hi, Y
        PHA
        LDA @jump_table_move_lo, Y
        PHA
        RTS
    @end:
    ; cancel input
    LDA #$00
    STA player_move_counter
    ; align player (temporary solution to fix player misalignement)
    LDA global_entity_buffer_pos_x, X
    AND #$F8
    STA global_entity_buffer_pos_x, X
    LDA global_entity_buffer_pos_y, X
    AND #$F8
    STA global_entity_buffer_pos_y, X
    ; return
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
        .byte <(scroll_up-1)
        .byte <(scroll_down-1)
        .byte <(scroll_left-1)
        .byte <(scroll_right-1)
    @jump_table_move_hi:
        .byte >(scroll_up-1)
        .byte >(scroll_down-1)
        .byte >(scroll_left-1)
        .byte >(scroll_right-1)
