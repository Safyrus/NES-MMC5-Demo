; A = (height, width)
; do height*width
; result in MMC5_MUL_A
size_to_int:
    STA tmp+7
    PHA

    JSR wait_at_frame_end

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

    JSR wait_at_frame_end

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


; return in tmp the screen buffer address from $6000 (lo,hi)
; and in tmp+2 the bank index
scroll2scrBufAdr:
    PHA

    ; ----------------
    ; high address
    ; ----------------
    ; init
    LDA #$60
    STA tmp+1
    ; mod x by 3
    LDA #$03
    STA tmp+7
    LDA game_scroll_x+0
    JSR mod_sign
    ; mul by 8
    ASL
    ASL
    ASL
    ; add
    ORA tmp+1
    STA tmp+1
    ; 
    LDA game_scroll_y+1
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    ORA tmp+1
    STA tmp+1

    ; ----------------
    ; low address
    ; ----------------
    LDA game_scroll_y+1
    AND #$38
    ASL
    ASL
    STA tmp+0
    LDA game_scroll_x+1
    LSR
    LSR
    LSR
    ORA tmp+0
    STA tmp+0

    ; ----------------
    ; bank index
    ; ----------------
    ; mod y by 3
    LDA #$03
    STA tmp+7
    LDA game_scroll_y+0
    JSR mod_sign
    ;
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA tmp+2

    PLA
    RTS


; wait if we are at the end of the frame
; can fix bug because multiplcation registers may be used by other modules next frame
wait_at_frame_end:
    LDA scanline
    CMP #SCANLINE_TOP
    BEQ wait_at_frame_end
    RTS
