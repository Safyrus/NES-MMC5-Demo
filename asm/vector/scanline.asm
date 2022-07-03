scanline_irq_handler:
    ; disable flag
    LDA scanline
    AND #$7F
    STA scanline

    BEQ @scanline_irq_top
    @scanline_irq_bot:
        ; next scanline state
        LDA #$00
        STA scanline
        ; set next interrupt to scanline 239
        LDA #239
        STA MMC5_SCNL_VAL
        ;
        LDA #$00
        CLC
        @wait_bot:
            ADC #$01
            CMP #$04
            BNE @wait_bot
        ; set all nametable to fill mode
        LDA #NAMETABLE_FILL
        STA MMC5_NAMETABLE
        JMP @end
    @scanline_irq_top:
        ; next scanline state
        CLC
        ADC #$01
        STA scanline
        ; set next interrupt to scanline 231
        LDA #231
        STA MMC5_SCNL_VAL
        ; wait for 1 scanline
        LDA #$00
        CLC
        @wait:
            ADC #$01
            CMP #$10
            BNE @wait
        ; set nametable to normal
        LDA #NAMETABLE_SCROLL
        STA MMC5_NAMETABLE

    @end:
    RTS