dialog_main:
    LDA dialog_last_char
    CMP #CHAR::END
    BEQ @end
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
            ; return to @last
            LDA #>(@last-1)
            PHA
            LDA #<(@last-1)
            PHA
            ; jump to special char function
            LDA @spe_table_hi, X
            STA tmp+1
            LDA @spe_table_lo, X
            STA tmp+0
            JMP (tmp)

        @normal:

        @last:
        ; if we need to read more raw data next frame
        LDA dialog_buf_data_idx
        CMP #(PPU_RD_BUF_SIZE >> 1) ; buf_ptr > buf_ptr / 2
        BCS @read_end
            ; buf_ptr = 0
            LDA #(PPU_RD_BUF_SIZE-1)
            STA dialog_buf_data_idx
            ; read next batch
            JSR dialog_load_raw_data
        @read_end:
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


dialog_spe_char_nl:
    RTS
dialog_spe_char_spd:
    RTS
dialog_spe_char_dict:
    RTS
dialog_spe_char_ldict:
    RTS
dialog_spe_char_ext:
    RTS
dialog_spe_char_end:
    RTS
