.macro entity_act idx
    .local loop, next, end, ret
    LDX local_entity_counter+idx
    loop:
        LDA scrbuf_update_array_act+idx
        BNE end
        DEX
        CPX #$FF
        BEQ end
        ;
        LDA #PRGRAM_ENTITY_BANK
        STA last_frame_BNK+0
        STA MMC5_RAM_BNK
        ;
        LDA entity_buffer_0_adr_bnk+($280*idx), X
        BEQ next
            ;
            STA last_frame_BNK+2
            STA MMC5_PRG_BNK1
            LDA entity_buffer_0_adr_lo+($280*idx), X
            STA tmp+0
            LDA entity_buffer_0_adr_hi+($280*idx), X
            STA tmp+1
            ;
            LDA #<(entity_buffers+($280*idx))
            STA tmp+2
            LDA #>(entity_buffers+($280*idx))
            STA tmp+3
            TXA
            JSR add_tmp2
            LDY #idx
            ;
            TXA
            PHA
            LDA #>(ret-1)
            PHA
            LDA #<(ret-1)
            PHA
            ;
            JMP (tmp)
        ret:
        PLA
        TAX
        next:
        JMP loop
    end:
.endmacro

module_local_entity_act:
    entity_act 0
    entity_act 1
    entity_act 2
    entity_act 3
    entity_act 4
    entity_act 5
    entity_act 6
    entity_act 7
    entity_act 8

    RTS
