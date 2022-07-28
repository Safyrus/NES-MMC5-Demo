dialog_load_raw_data:
    ;
    LDA dialog_data_idx+1
    ROL
    ROL
    ROL
    AND #$03
    STA ppu_read_mmc5_bnk
    LDA dialog_data_idx+0
    ASL
    ASL
    ORA ppu_read_mmc5_bnk
    STA ppu_read_mmc5_bnk
    ;
    LDA #$1C
    STA ppu_read_adr+0
    LDA dialog_data_idx+1
    AND #$3F
    STA ppu_read_adr+1
    ;
    LDA #(PPU_RD_BUF_SIZE-1)
    STA ppu_read_n
    ;
    LDA nmi_flags
    ORA #NMI_READ
    STA nmi_flags

    RTS

dialog_next_bit:
    push_ax

    ; tmp = buf[buf_ptr]
    LDX dialog_buf_data_idx
    LDA ppu_data_buf, X
    ; (tmp >> offset) & 0x01
    LDX dialog_data_bit_offset
    @shift:
        BEQ @shift_end
        LSR
        DEX
        JMP @shift
    @shift_end:
    AND #$01
    ORA dialog_char_buf+1
    STA dialog_char_buf+1
    ; offset -= 1
    LDX dialog_data_bit_offset
    DEX
    STX dialog_data_bit_offset
    ; if offset < 0:
    CPX #$00
    BPL @end
        ; offset = 7
        LDX #$07
        STX dialog_data_bit_offset
        ; pointer += 1
        LDX dialog_data_idx+1
        INX
        STX dialog_data_idx+1
        BNE @inc_ptr_end
            LDX dialog_data_idx+0
            INX
            STX dialog_data_idx+0
        @inc_ptr_end:
        ; buf_ptr -= 1
        LDX dialog_buf_data_idx
        DEX
        STX dialog_buf_data_idx
    @end:
    pull_ax
    RTS


dialog_next_char:
    ; c = 1
    LDX #$00
    STX dialog_char_buf+0
    INX
    STX dialog_char_buf+1
    ; while True:
    @while:
        ; c = (c << 1)
        LDA dialog_char_buf+0
        ASL
        STA dialog_char_buf+0
        LDA dialog_char_buf+1
        ASL
        STA dialog_char_buf+1
        ; + read_bit_from_left(tmp, offset)
        JSR dialog_next_bit
        ; for i in range(len(char_cypher)):
        LDX #($3F << 1)+1
        @for:
            ; if char_cypher[i] == c:
            LDA cypher_char, X
            CMP dialog_char_buf+1
            BNE @for_next_1
            DEX
            LDA cypher_char, X
            CMP dialog_char_buf+0
            BNE @for_next_2
                ; return i
                TXA
                LSR
                RTS
            @for_next_1:
            DEX
            @for_next_2:
            DEX
            BPL @for
        JMP @while
