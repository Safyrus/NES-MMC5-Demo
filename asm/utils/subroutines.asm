; A = (height, width)
; do height*width
; result in MMC5_MUL_A
size_to_int:
    STA tmp+7
    PHA

    ; wait to not by at the end of the frame because
    ; multiplcation registers may be used by other modules next frame
    @wait_for_mul:
        LDA scanline
        CMP #SCANLINE_BOT
        BEQ @wait_for_mul

    ; width
    LDA tmp+7
    AND #$0F
    STA MMC5_MUL_A
    ; height
    LDA tmp+7
    AND #$F0
    LSR
    LSR
    LSR
    LSR
    STA MMC5_MUL_B

    @end:
    PLA
    RTS


; A = (y, x)
; do (y*2*32)+(x*2)
; result in tmp+6, tmp+7
pos_to_int:
    STA tmp+7
    PHA

    ; y * 2 * 32
    LDA tmp+7
    AND #$F0
    LSR
    LSR
    LSR
    STA MMC5_MUL_A
    LDA #$20
    STA MMC5_MUL_B

    ; push tmp & tmp+1
    LDA tmp
    PHA
    LDA tmp+1
    PHA

    ; load previous result in tmp
    LDA MMC5_MUL_A
    STA tmp
    LDA MMC5_MUL_B
    STA tmp+1

    ; add x*2
    LDA tmp+7
    AND #$0F
    ASL
    JSR add_tmp

    ; load result in tmp+6
    LDA tmp
    STA tmp+6
    LDA tmp+1
    STA tmp+7

    ; pull tmp & tmp+1
    PLA
    STA tmp+1
    PLA
    STA tmp

    @end:
    PLA
    RTS



