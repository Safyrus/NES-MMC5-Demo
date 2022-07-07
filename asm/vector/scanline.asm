scanline_irq_handler:
    ; disable flag
    LDA scanline
    AND #$7F
    STA scanline

    AND #$3F
    BEQ @scanline_irq_bot
    CMP #$01
    BEQ @scanline_irq_top
    @scanline_irq_mid:
        ; next scanline state
        LDA #$40
        STA scanline
        ; set next interrupt to scanline 239
        LDA #239
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
        JMP @end
    @scanline_irq_bot:
        ; next scanline state
        LDA #$01
        STA scanline
        ; set next interrupt to scanline 1
        LDA #1
        STA MMC5_SCNL_VAL
        JMP @end
    @scanline_irq_top:
        ; next scanline state
        LDA #$42
        STA scanline
        ; set next interrupt to scanline 7
        LDA #7
        STA MMC5_SCNL_VAL
        

    @end:
    RTS