module_world_draw_sprites:
    ; load entity draw bank
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

    ; for each sprite
    LDX #$01
    LDY #$00
    @loop:
        ; is this sprite taken
        LDA entity_draw_atr, X
        AND #$10
        BNE @check
            JMP @next
        @check:
            ; sprite_x
            LDA entity_draw_pos_x, X
            STA tmp+0
            LDA entity_draw_pos_hi, X
            AND #$0F
            STA tmp+1
            ; minus scroll_x
            LDA game_scroll_x+0
            STA tmp+3
            LDA game_scroll_x+1
            STA tmp+2
            JSR sub_16
            ; is the sprite x position inside the screen
            LDA tmp+1
            BNE @next
                ; save x position
                LDA tmp+0
                STA tmp+4

                ; sprite_y_hi * $F0 + sprite_y_lo
                LDA #$F0
                STA MMC5_MUL_A
                LDA entity_draw_pos_hi, X
                LSR
                LSR
                LSR
                LSR
                STA MMC5_MUL_B
                LDA MMC5_MUL_A
                STA tmp+0
                LDA MMC5_MUL_B
                STA tmp+1
                LDA entity_draw_pos_y, X
                JSR add_tmp
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
                ; sprite_y - scroll_y
                JSR sub_16
                ; is the sprite y position inside the screen
                LDA tmp+1
                BNE @next
                CMP #$F0
                BCS @next
                    ; draw it
                    LDA tmp+0
                    STA OAM, Y
                    INY
                    LDA entity_draw_spr, X
                    STA OAM, Y
                    INY
                    LDA entity_draw_atr, X
                    STA OAM, Y
                    INY
                    LDA tmp+4
                    STA OAM, Y
                    INY
                    BCS @end

        @next:
        CPX sprite_number
        BCS @loop_end
        INX
        JMP @loop
    @loop_end:

    LDA #$FF
    @fill_empty_sprite_oam:
        STA OAM, Y
        INY
        INY
        INY
        INY
        BNE @fill_empty_sprite_oam

    @end:
    ; turn on flag to indicate that sprite has been drawned
    LDA game_substate
    AND #$FD
    STA game_substate

    RTS

