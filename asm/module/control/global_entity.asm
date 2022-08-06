module_global_entity_act:
    LDX global_entity_counter
    DEX
    @entity_act:
        ;
        LDA #PRGRAM_SPR_BANK
        STA last_frame_BNK+0
        STA MMC5_RAM_BNK
        ;
        LDA global_entity_buffer_adr_bnk, X
        BEQ @next
            ;
            STA last_frame_BNK+2
            STA MMC5_PRG_BNK1
            LDA global_entity_buffer_adr_lo, X
            STA tmp+0
            LDA global_entity_buffer_adr_hi, X
            STA tmp+1
            TXA
            PHA
            ;
            LDA #>(@next-1)
            PHA
            LDA #<(@next-1)
            PHA
            ;
            JMP (tmp)
        @next:
        PLA
        TAX
        DEX
        BPL @entity_act
    RTS
