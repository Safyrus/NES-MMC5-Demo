mdl_world_scr_buf_bnk2:
    ; get screen buffer bank at $C000 - $DFFF
    LDA scrbuf_index
    AND #$03
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA last_frame_BNK+3
    STA MMC5_PRG_BNK2
    RTS

