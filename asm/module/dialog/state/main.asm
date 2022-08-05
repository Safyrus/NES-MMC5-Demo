dialog_main:
    ;
    LDA dialog_last_char
    CMP #CHAR::END
    BEQ @end
    ;
    LDX dialog_speed_counter
    DEX
    STX dialog_speed_counter
    BEQ @spd_end
        RTS
    @spd_end:
    LDX dialog_speed
    STX dialog_speed_counter
    ;
    LDA dialog_remaining_char
    BEQ @read
        JMP dialog_draw

    @read:
    ; read the next character
    JSR dialog_next_char
    STA dialog_last_char
    TAY
    ; if char < $38
    CMP #$38
    BCC @normal
    @special:
        ; get special char index
        AND #$07
        TAX
        ; jump to special char function
        LDA @spe_table_hi, X
        STA tmp+1
        LDA @spe_table_lo, X
        STA tmp+0
        JMP (tmp)

    @normal:
        LDA #$00
        STA dialog_remaining_char
        JMP dialog_draw

    @end:
    LDX game_substate
    INX
    STX game_substate
    RTS

    @spe_table_lo:
        .byte <@end
        .byte <@end
        .byte <dialog_spe_char_nl
        .byte <dialog_spe_char_spd
        .byte <dialog_spe_char_dict
        .byte <dialog_spe_char_ldict
        .byte <dialog_spe_char_ext
        .byte <dialog_spe_char_end
    @spe_table_hi:
        .byte >@end
        .byte >@end
        .byte >dialog_spe_char_nl
        .byte >dialog_spe_char_spd
        .byte >dialog_spe_char_dict
        .byte >dialog_spe_char_ldict
        .byte >dialog_spe_char_ext
        .byte >dialog_spe_char_end

dialog_draw:
    LDX dialog_remaining_char
    BEQ @draw_normal
    @draw_dict:
        ;
        LDA dialog_word_size
        SEC
        SBC dialog_remaining_char
        TAY
        ;
        DEX
        STX dialog_remaining_char
        ;
        LDA dialog_word_buffer, Y
        TAY
    @draw_normal:
        ; ----
        ; draw char
        ; ----
        ; packet of 1 tile
        LDX background_index
        LDA #$01
        STA background, X
        INX
        ; at adr dialog_ppu_adr 
        LDA dialog_ppu_adr+0
        STA tmp+1
        STA background, X
        INX
        LDA dialog_ppu_adr+1
        STA tmp+0
        STA background, X
        INX
        ; with the char tile
        TYA
        STA background, X
        INX
        ; end packet
        LDA #$00
        STA background, X
        STX background_index
        ; inc dialog_ppu_adr
        JSR inc_tmp
        LDA tmp+0
        STA dialog_ppu_adr+1
        LDA tmp+1
        STA dialog_ppu_adr+0
    @end:
    JMP dialog_check_buffer


dialog_check_buffer:
    ; if we need to read more raw data next frame
    LDA dialog_buf_data_idx
    CMP #(PPU_RD_BUF_SIZE >> 1) ; buf_ptr > buf_ptr / 2
    BCS @end
        ; buf_ptr = 0
        LDA #(PPU_RD_BUF_SIZE-1)
        STA dialog_buf_data_idx
        ; read next batch
        JSR dialog_load_raw_data
    @end:
    RTS


dialog_spe_char_nl:
    LDA dialog_ppu_adr+1
    AND #$E0
    STA tmp+0
    LDA dialog_ppu_adr+0
    STA tmp+1
    LDA #$40
    CLC
    ADC dialog_nl_offset
    JSR add_tmp
    LDA tmp+0
    STA dialog_ppu_adr+1
    LDA tmp+1
    STA dialog_ppu_adr+0
    RTS

dialog_spe_char_dict:
    JSR dialog_next_char
    TAX
    LDA #<dict
    STA tmp+0
    LDA #>dict
    STA tmp+1
    LDY #$00
    @find_adr:
        LDA (tmp), Y
        JSR inc_tmp
        CPX #$00
        BEQ @find_adr_end
        DEX
        JSR add_tmp
        JMP @find_adr
    @find_adr_end:
    TAY
    INY
    STY dialog_word_size
    STY dialog_remaining_char
    ;
    DEY
    LDA #CHAR::SPACE
    STA dialog_word_buffer, Y
    DEY
    @copy:
        LDA (tmp), Y
        STA dialog_word_buffer, Y
        DEY
        BPL @copy
    @end:
    RTS

dialog_spe_char_ldict:
dialog_spe_char_spd:
dialog_spe_char_ext:
    JMP dialog_draw
dialog_spe_char_end:
    RTS
