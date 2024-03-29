;***********
; RST vector
;***********

.ifdef C_CODE
.import _main
.endif


RST:
    SEI         ; Disable interrupt
    CLD         ; Clear/disable decimal

    LDX #$FF    ; Initialized stack
    TXS

    INX         ; X=0
    STX PPU_CTRL ; Disable NMI
    STX PPU_MASK ; Disable Rendering
    STX APU_DMC_FREQ ; Disable DMC IRQ

    ; Wait for the PPU to initialized
    BIT PPU_STATUS       ; Clear the VBL flag if it was set at reset time
@vwait1:
    BIT PPU_STATUS
    BPL @vwait1      ; At this point, about 27384 cycles have passed

@clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0200, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    INX
    BNE @clrmem

@vwait2:
    BIT PPU_STATUS
    BPL @vwait2      ; At this point, about 57165 cycles have passed

    LDA #%10010000      ; Enable NMI + background at $1000
    STA PPU_CTRL
    STA ppu_ctrl_val

    ; set all attributes to last palette
    LDX #$3F
    LDA #$FF
    @atr:
        STA attributes, X
        DEX
        BPL @atr

    LDA #176-1
    STA dialog_scanline

    ; - - - - - - -
    ; setup MMC5
    ; - - - - - - -
    ; disable ram protection
    LDA #$02
    STA MMC5_RAM_PRO1
    LDA #$01
    STA MMC5_RAM_PRO2

    ; Set the Extented RAM as work RAM to clean it
    LDA #$02
    STA MMC5_EXT_RAM
    ; Reset Extended RAM content
    LDA #$00
    LDX #$00
    @rst_exp_ram:
        STA MMC5_EXP_RAM, X
        STA MMC5_EXP_RAM+$100, X
        STA MMC5_EXP_RAM+$200, X
        STA MMC5_EXP_RAM+$300, X
        ; loop
        INX
        BNE @rst_exp_ram

    ; Set the Extented RAM as extended attribute data
    LDA #$01
    STA MMC5_EXT_RAM

    ; set fill tile
    LDA #$00
    STA MMC5_FILL_TILE
    STA MMC5_FILL_COL

    ; enable scanline irq
    LDA #$80
    STA MMC5_SCNL_STAT
    LDA #239
    STA MMC5_SCNL_VAL

    ; Disable Vertical split
    LDA #$00
    STA MMC5_SPLT_MODE
    STA MMC5_SPLT_BNK
    STA MMC5_SPLT_SCRL

    ; Set CHR mode to 1KB pages
    LDA #$03
    STA MMC5_CHR_MODE

    ; clean prg ram
    LDA #$00
    STA tmp+2
    @clean_prgram:
        LDA tmp+2
        STA MMC5_RAM_BNK
        LDX #$00
        @clean_prgram_bank:
            ;
            TXA
            CLC
            ADC #$60
            STA tmp+1
            LDA #$00
            STA tmp
            ;
            LDY #$00
            @clean_prgram_page:
                STA (tmp), Y
                INY
                BNE @clean_prgram_page
            ;
            INX
            CPX #$20
            BNE @clean_prgram_bank
        LDX tmp+2
        INX
        STX tmp+2
        DEX
        CPX #RAM_MAX_BNK
        BNE @clean_prgram

    ; - - - - - - -
    ; setup Game
    ; - - - - - - -
    ; setup control module
    LDA #MODULE_CTRL
    STA higher_module_array+Module::bank
    LDA #<module_control
    STA higher_module_array+Module::pointer
    LDA #>module_control
    STA higher_module_array+Module::pointer+1

    CLI

.ifdef C_CODE
    JMP _main
.else
    JMP MAIN
.endif
