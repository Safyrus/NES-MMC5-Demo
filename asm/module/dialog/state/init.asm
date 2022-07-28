dialog_init:
    ; update attriute for second VRAM screen
    LDA #$27
    STA atr_nametable
    LDA nmi_flags
    ORA #NMI_ATR
    STA nmi_flags
    ; set dialog box position
    LDA #176-1
    STA dialog_scanline

    ;
    JSR dialog_load_raw_data
    ;
    LDA #$20
    STA dialog_ppu_adr+0
    STA dialog_ppu_adr+1

    ; math for scanline IRQ scroll
    CLC
    ADC #(DIALOG_BOX_HEIGHT+1)
    STA var+0
    LDA scroll_y
    TAX
    CLC
    ADC var+0
    BCS @y_offscreen_1
    CMP #$F0
    BCC @y_ok
    @y_offscreen_1:
        SBC #$F0
        STA scroll_y
        LDA ppu_ctrl_val
        EOR #$02
        JMP @y_end
    @y_ok:
        STA scroll_y
        LDA ppu_ctrl_val
    @y_end:
    ; first byte
    AND #$03
    ASL
    ASL
    STA var+0
    LDA scroll_y
    ASL
    ASL
    ASL
    ASL
    AND #$30
    ORA var+0
    STA var+0
    LDA scroll_y
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    ORA var+0
    STA var+0
    ; second byte
    LDA scroll_y
    ASL
    ASL
    AND #$E0
    STA var+1
    LDA scroll_x
    LSR
    LSR
    LSR
    ORA var+1
    STA var+1
    STX scroll_y

    RTS
