module_world_draw_global_sprites:
    ; load entity bank
    LDA #PRGRAM_SPR_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    ; update CHR banks
    LDX #$07
    @bnk:
        LDA sprite_banks, X
        STA MMC5_CHR_BNK0, X
        DEX
        BPL @bnk

    ; for each global entity
    LDY #$00
    STY tmp+6
    LDX #$00
    @loop:
        LDA global_entity_buffer_spr_nb, X
        STA tmp+4
        ; for each sprite of the entity
        @loop_spr:
            ; if sprite number == 0 then next entity
            BNE @ok
            JMP @loop_spr_end
            @ok:
            ; entity_x
            LDA global_entity_buffer_pos_x, X
            STA tmp+0
            LDA global_entity_buffer_pos_hi, X
            AND #$0F
            STA tmp+1
            ; + sprite_x_offset
            STY tmp+2
            LDY tmp+6
            LDA global_entity_buffer_spr_offset, Y
            AND #$0F
            JSR mdl_world_drw_spr_offset
            ; - scroll_x
            LDA game_scroll_x+0
            STA tmp+3
            LDA game_scroll_x+1
            STA tmp+2
            JSR sub_16
            ; is the sprite x coordinate inside the screen
            LDA tmp+1
            BNE @next
                ; save x position
                LDA tmp+0
                STA tmp+5

                ; entity_y_hi * $F0 + entity_y_lo
                LDA #$F0
                STA MMC5_MUL_A
                LDA global_entity_buffer_pos_hi, X
                LSR
                LSR
                LSR
                LSR
                STA MMC5_MUL_B
                LDA MMC5_MUL_A
                STA tmp+0
                LDA MMC5_MUL_B
                STA tmp+1
                LDA global_entity_buffer_pos_y, X
                JSR add_tmp
                ; + sprite_y_offset
                STY tmp+2
                LDY tmp+6
                LDA global_entity_buffer_spr_offset, Y
                LSR
                LSR
                LSR
                LSR
                JSR mdl_world_drw_spr_offset
                ; scroll_y_hi * $F0 + scroll_y_lo
                LDA game_scroll_y+0
                STA MMC5_MUL_A
                LDA #$F0
                STA MMC5_MUL_B
                LDA MMC5_MUL_A
                STA tmp+2
                LDA MMC5_MUL_B
                STA tmp+3
                LDA game_scroll_y+1
                JSR add_tmp2
                ; entity_y - scroll_y
                JSR sub_16
                ; is the entity y position inside the screen
                LDA tmp+1
                BNE @next
                CMP #$F0
                BCS @next
                    ; save sprite array index
                    STY tmp+1
                    ; get sprite and attribute
                    LDY tmp+6
                    LDA global_entity_buffer_spr, Y
                    STA tmp+2
                    LDA global_entity_buffer_atr, Y
                    STA tmp+3
                    ; load sprite array index
                    LDY tmp+1

                    ; write sprite to OAM
                    LDA tmp+0
                    STA OAM, Y
                    INY
                    LDA tmp+2
                    STA OAM, Y
                    INY
                    LDA tmp+3
                    STA OAM, Y
                    INY
                    LDA tmp+5
                    STA OAM, Y
                    INY

            ; next sprite
            @next:
            ; sprite_idx++
            LDA tmp+6
            CLC
            ADC #$01
            STA tmp+6
            ; nb_sprite--
            LDA tmp+4
            SEC
            SBC #$01
            STA tmp+4
            ; next
            JMP @loop_spr
        @loop_spr_end:

        ; next entity
        INX
        CPX #$40
        BEQ @loop_end
        JMP @loop
    @loop_end:

    ; fill the rest of the OAM with null sprites
    @end:
    LDA #$FF
    @rst_oam:
        STA OAM, Y
        INY
        BNE @rst_oam

    ; turn on flag to indicate that sprite has been drawned
    LDA game_substate
    AND #$FD
    STA game_substate

    RTS


mdl_world_drw_spr_offset:
    CMP #$08
    BCC @spr_offset_x_add
    @spr_offset_x_sub:
        AND #$07
        EOR #$07
        CLC
        ADC #$01
        JSR sub_tmp
        JMP @spr_offset_x_end
    @spr_offset_x_add:
        AND #$07
        JSR add_tmp
    @spr_offset_x_end:
    LDY tmp+2
    RTS

