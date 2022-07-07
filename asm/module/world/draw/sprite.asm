module_world_draw_global_sprites:
    LDA #PRGRAM_SPR_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    LDX #$00
    @bnk:
        LDA sprite_banks, X
        STA MMC5_CHR_BNK0, X
        INX
        CPX #$08
        BNE @bnk

    LDY #$00
    LDX #$00
    @loop:
        LDA global_entity_buffer_spr_nb, X
        STA tmp
        @loop_spr:
            BEQ @loop_spr_end

            STY tmp+1
            TYA
            LSR
            LSR
            TAY
            LDA global_entity_buffer_spr, Y
            STA tmp+2
            LDA global_entity_buffer_atr, Y
            STA tmp+3

            ;
            LDY tmp+1
            LDA global_entity_buffer_pos_y, X
            STA OAM, Y
            INY
            ;
            LDA tmp+2
            STA OAM, Y
            INY
            ;
            LDA tmp+3
            STA OAM, Y
            INY
            ;
            LDA global_entity_buffer_pos_x, X
            STA OAM, Y
            INY

            LDA tmp
            SEC
            SBC #$01
            STA tmp
            JMP @loop_spr
        @loop_spr_end:

        INX
        CPX #$40
        BNE @loop

    @rst_oam:
        STA OAM, Y
        INY
        BNE @rst_oam

    RTS
