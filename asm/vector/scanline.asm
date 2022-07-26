scanline_irq_handler:
    ; push x
    TXA
    PHA

    ; disable flag
    LDA scanline
    AND #$7F
    STA scanline

    ; jump to function
    AND #$3F
    TAX
    LDA @table_hi, X
    PHA
    LDA @table_lo, X
    PHA
    RTS

    @scanline_irq_mid:
        ; next scanline state
        LDA #SCANLINE_UI
        STA scanline
        ; set next interrupt to ui scanline
        LDA dialog_scanline
        STA MMC5_SCNL_VAL
        ;
        LDX #$03
        @wait_mid:
            DEX
            BNE @wait_mid

        ; set nametable
        LDA #NAMETABLE_SCROLL
        STA MMC5_NAMETABLE

        ; enable sprite
        LDA #(PPU_MASK_BKG + PPU_MASK_SPR)
        STA PPU_MASK
        JMP @end

    @scanline_irq_bot:
        LDA game_state
        CMP #STATE::DRAW_SCREEN
        BEQ @bot_screen
        CMP #STATE::DRAW_SCREEN_WAIT
        BEQ @bot_screen
        CMP #STATE::DIALOG
        BEQ @bot_end
        @bot_normal:
            LDA #NAMETABLE_SCROLL
            STA nmi_mmc5_nametable
            JMP @bot_end
        @bot_screen:
            LDA #NAMETABLE_ALL
            STA nmi_mmc5_nametable
        @bot_end:
        ; next scanline state
        LDA #SCANLINE_TOP
        STA scanline
        ; set next interrupt to scanline 1
        LDA #1
        STA MMC5_SCNL_VAL
        JMP @end

    @scanline_irq_top:
        ; next scanline state
        LDA #SCANLINE_MID
        STA scanline
        ; set next interrupt to scanline 7
        LDA #7
        STA MMC5_SCNL_VAL
        JMP @end

    @scanline_irq_ui:
        ; next scanline state
        LDA #SCANLINE_UI_END
        STA scanline
        ; set next interrupt scanline
        LDA dialog_scanline
        CLC
        ADC #(DIALOG_BOX_HEIGHT+1)
        STA MMC5_SCNL_VAL

        LDA game_state
        CMP #STATE::DIALOG
        BNE @end
            ; set nametable
            LDA #NAMETABLE_UI
            STA MMC5_NAMETABLE
            STA nmi_mmc5_nametable
            ; set chr banks to UI and disable extended attributes
            LDA #$02
            STA MMC5_CHR_UPPER
            STA MMC5_EXT_RAM
            ; set font bank
            LDA #$00
            STA MMC5_CHR_BNK8
            ; set scroll to top left
            STA PPU_ADDR
            STA PPU_ADDR
            ; set background tile fully visible and disable sprite
            LDA #(PPU_MASK_BKG + PPU_MASK_BKG8)
            STA PPU_MASK
            JMP @end

    @scanline_irq_ui_end:
        ; next scanline state
        LDA #SCANLINE_BOT
        STA scanline
        ;
        LDA game_state
        CMP #STATE::DIALOG
        BNE @ui_bot_end
            ; set scroll back to normal
            LDA var+0
            STA PPU_ADDR
            LDA var+1
            STA PPU_ADDR
            ; enable background and sprites
            LDA #(PPU_MASK_BKG + PPU_MASK_SPR)
            STA PPU_MASK
            ; resotre chr upper bits
            LDX #$00
            STX MMC5_CHR_UPPER
            ; renable extended attributes
            INX
            STX MMC5_EXT_RAM
            ; set nametables
            LDA #NAMETABLE_SCROLL
            STA MMC5_NAMETABLE
        @ui_bot_end:
        ; set next interrupt to scanline 234
        LDA #234
        STA MMC5_SCNL_VAL

    @end:
    PLA
    TAX
    PLA
    RTI

    @table_lo:
        .byte <(@scanline_irq_mid-1)
        .byte <(@scanline_irq_bot-1)
        .byte <(@scanline_irq_top-1)
        .byte <(@scanline_irq_ui-1)
        .byte <(@scanline_irq_ui_end-1)
    @table_hi:
        .byte >(@scanline_irq_mid-1)
        .byte >(@scanline_irq_bot-1)
        .byte >(@scanline_irq_top-1)
        .byte >(@scanline_irq_ui-1)
        .byte >(@scanline_irq_ui_end-1)
