module_global_entity_act:
    LDA #PRGRAM_SPR_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK
    LDX #$3F
    @entity_act:
        LDA global_entity_buffer_adr_bnk, X
        BEQ @next
            LDA global_entity_buffer_adr_bnk, X
            STA last_frame_BNK+2
            STA MMC5_PRG_BNK1
            LDA global_entity_buffer_adr_lo, X
            STA tmp+0
            LDA global_entity_buffer_adr_hi, X
            STA tmp+1

            LDA #>(@entity_act_ret-1)
            PHA
            LDA #<(@entity_act_ret-1)
            PHA
            JMP (tmp)
            @entity_act_ret:
            LDA #PRGRAM_SPR_BANK
            STA MMC5_RAM_BNK
        @next:
        DEX
        BPL @entity_act
    RTS
