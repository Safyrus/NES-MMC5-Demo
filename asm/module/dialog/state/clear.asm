dialog_clear_1:
    LDY #$20
    JMP dialog_clear
dialog_clear_2:
    LDY #$60
    JMP dialog_clear
dialog_clear_3:
    LDY #$A0
    JMP dialog_clear

dialog_clear:
    ; start background packet of size 64
    LDX background_index
    LDA #$40
    STA background, X
    INX
    ; at adress $20YY
    LDA #$20
    STA background, X
    INX
    TYA
    STA background, X
    INX
    ; with the space char tile
    LDA #CHAR::SPACE
    LDY #$40
    @border_bot:
        STA background, X
        INX
        DEY
        BNE @border_bot
    ; update background index
    LDA #$00
    STA background, X
    STX background_index
    ; return
    RTS
