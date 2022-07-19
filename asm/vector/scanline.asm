scanline_irq_handler:
    ; disable flag
    LDA scanline
    AND #$7F
    STA scanline

    AND #$3F
    BEQ @scanline_irq_bot
    CMP #SCANLINE_BOT
    BEQ @scanline_irq_top
    @scanline_irq_mid:
        ; next scanline state
        LDA #SCANLINE_MID
        STA scanline
        ; set next interrupt to scanline 232
        LDA #232
        STA MMC5_SCNL_VAL
        ;
        LDA #$00
        CLC
        @wait_mid:
            ADC #$01
            CMP #$04
            BNE @wait_mid
        ; set nametable to normal
        LDA #NAMETABLE_SCROLL
        STA MMC5_NAMETABLE
        ; enable sprite
        LDA #(PPU_MASK_BKG + PPU_MASK_SPR)
        STA PPU_MASK
        JMP @end
    @scanline_irq_bot:
        ; next scanline state
        LDA #SCANLINE_BOT
        STA scanline
        ; set next interrupt to scanline 1
        LDA #1
        STA MMC5_SCNL_VAL
        JMP @end
    @scanline_irq_top:
        ; next scanline state
        LDA #SCANLINE_TOP
        STA scanline
        ; set next interrupt to scanline 7
        LDA #7
        STA MMC5_SCNL_VAL
        

    @end:
    RTS