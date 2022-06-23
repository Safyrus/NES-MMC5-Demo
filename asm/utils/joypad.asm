;
readjoy:
    LDA #$01
    STA IO_JOY1
    STA buttons_2  ; player 2's buttons double as a ring counter
    LSR A         ; now A is 0
    STA IO_JOY1
    @loop:
        LDA IO_JOY1
        AND #%00000011  ; ignore bits other than controller
        CMP #$01        ; Set carry if and only if nonzero
        ROL buttons_1    ; Carry -> bit 0; bit 7 -> Carry
        LDA IO_JOY2     ; Repeat
        AND #%00000011
        CMP #$01
        ROL buttons_2    ; Carry -> bit 0; bit 7 -> Carry
        BCC @loop
    RTS


update_btn_timer:
    @timer:
    LDA buttons_1_timer   ; decrease buttons_1_timer if it is not 0
    BEQ @timer_reset
    SEC
    SBC #$01
    STA buttons_1_timer
    JMP @end

    @timer_reset:
    LDA buttons_1        ; set buttons_1_timer if any button was pressed
    BEQ @end
    LDA #BTN_TIMER
    STA buttons_1_timer

    @end:
    RTS
