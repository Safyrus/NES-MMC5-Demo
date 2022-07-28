dialog_draw_border:
    ; disable attribute update
    LDA nmi_flags
    AND #($FF-NMI_ATR-NMI_READ)
    STA nmi_flags

    LDA #$00
    STA tmp+0
    LDA #$80
    STA tmp+1
    JSR dialog_draw_border_packet

    LDA #$C0
    STA tmp+0
    LDA #$81
    STA tmp+1
    JMP dialog_draw_border_packet


; tmp+0 = low adr
; tmp+1 = tile
dialog_draw_border_packet:
    ; start background packet of size 32
    LDX background_index
    LDA #$20
    STA background, X
    INX
    ; at adress $20XX
    STA background, X
    INX
    LDA tmp+0
    STA background, X
    INX
    ; with this tile 32 time
    LDA tmp+1
    LDY #$20
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
