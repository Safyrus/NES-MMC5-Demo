module_world_load_level:
    
    JSR mdl_world_ld_wrld_bnk
    
    ; setup start address
    LDA #<WORLD_DATA_START_ADDR
    STA tmp
    LDA #>WORLD_DATA_START_ADDR
    STA tmp+1

    ; get level buffer bank in RAM
    LDA #PRGRAM_LEVEL_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    ; skip screen address
    LDA #$02
    JSR add_tmp

    LDX #$00
    LDY #$00
    @find_level:
        ; size to int
        LDA (tmp),Y
        JSR size_to_int

        ; is it the correct level ?
        CPX level
        BEQ @load_level

        ; add the level size
        LDA MMC5_MUL_A
        JSR add_tmp
        ; add header size
        LDA #$09
        JSR add_tmp

        ; loop
        INX
        JMP @find_level

    @load_level:
        ; load level size
        LDA MMC5_MUL_A
        STA level_size
        ; load level width & height
        LDA (tmp),Y
        STA level_wh
        JSR inc_tmp

        ; load palettes index
        LDA (tmp),Y
        ASL
        ASL
        ASL

        ; load palette
        TAX
        LDY #$00
        @load_game_palette:
            LDA game_palettes, X
            STA level_pal, Y
            INX
            INY
            CPY #$07
            BNE @load_game_palette

        ; load background color
        LDY #$00
        LDA (tmp),Y
        LSR
        LSR
        LSR
        LSR
        LSR
        TAX
        LDA level_pal, X
        STA palettes+0

        LDX #$00
        STX tmp+2 ; last sprite palette buffer
        STX tmp+4 ; counter
        INX
        STX tmp+3 ; nmi palette index
        @load_level_palettes:
            LDY #$00
            JSR inc_tmp
            LDA (tmp),Y
            ; load 1 palette
            LDX #$00
            @load_1_palette:
                ; check the color bit
                LSR
                BCC @load_1_palette_loop
                    ;
                    PHA
                    LDA level_pal, X
                    ;
                    LDY tmp+3
                    STA palettes, Y
                    INY
                    STY tmp+3
                    ;
                    PLA
                @load_1_palette_loop:
                INX
                CPX #$07
                BNE @load_1_palette

            ; last sprite palette bit
            LSR
            LDA tmp+2
            ADC #$00
            ASL
            STA tmp+2

            ; loop
            LDX tmp+4
            INX
            STX tmp+4
            CPX #$07
            BNE @load_level_palettes

        ; load the last palette
        LDA tmp+2
        LSR
        LDX #$00
        @load_last_palette:
            ; check the color bit
            LSR
            BCC @load_last_palette_loop
                ;
                PHA
                LDA level_pal, X
                ;
                LDY tmp+3
                STA palettes, Y
                INY
                STY tmp+3
                ;
                PLA
            @load_last_palette_loop:
            INX
            CPX #$07
            BNE @load_last_palette

        ; load sprite banks
        JSR inc_tmp
        LDY #$00
        @load_level_spr_bnk:
            LDA (tmp), Y
            STA sprite_banks, Y
            ;
            INY
            CPY #$08
            BNE @load_level_spr_bnk
        TYA
        JSR add_tmp

        ; load level screens
        LDY #$00
        @load_level_screen:
            LDA (tmp),Y
            STA level_screens_buffer, Y
            INY
            CPY level_size
            BNE @load_level_screen

        ; reset scroll
        LDA #$00
        STA game_scroll_x+1
        STA game_scroll_y+1
        STA game_scroll_x+0
        STA game_scroll_y+0

        ; reset global entity buffer
        LDX #$3F
        LDA #$00
        STA sprite_number
        @reset_entity:
            STA global_entity_buffer_adr_bnk, X
            DEX
            BPL @reset_entity
        LDA #$01
        STA free_sprite_idx

        ; reset entity draw buffer
        LDX #$00
        LDA #$00
        @reset_entity_draw_1:
            STA entity_draw_pos_x, X
            STA entity_draw_pos_hi, X
            STA entity_draw_atr, X
            STA entity_draw_spr, X
            INX
            BNE @reset_entity_draw_1
            LDA #$FF
        LDA #$FF
        @reset_entity_draw_2:
            STA entity_draw_pos_y, X
            INX
            BNE @reset_entity_draw_2

        ; set state to load screens all
        LDA #STATE::LOAD_SCR_ALL
        STA game_state

    RTS
