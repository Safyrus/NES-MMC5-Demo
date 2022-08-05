dialog_end:
    LDA #STATE::NORMAL
    STA game_state
    LDA #$00
    STA game_substate
    LDA #NAMETABLE_SCROLL
    STA nmi_mmc5_nametable
    RTS
