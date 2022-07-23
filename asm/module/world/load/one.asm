; X = screen index
mdl_world_load_screen_one:
    pushreg
    JSR mdl_world_ld_wrld_bnk

    ; save screen index
    TXA
    STA tmp+2

    ; setup start address
    LDA WORLD_DATA_START_ADDR
    STA tmp
    LDA WORLD_DATA_START_ADDR+1
    STA tmp+1

    ; set ram bank
    LDA #PRGRAM_LEVEL_BANK
    STA last_frame_BNK+0
    STA MMC5_RAM_BNK

    ; find the screen data
    LDX #$00
    LDY #$00
    @find_screen:
        ; get size
        LDA (tmp),Y
        STA screen_objbuf_size

        ; is it the correct screen ?
        CPX tmp+2
        BEQ @find_screen_end

        ; add the screen size
        JSR add_tmp
        JSR inc_tmp

        ; loop
        INX
        JMP @find_screen
    @find_screen_end:

    LDX #$00
    @load_objects:
        JSR inc_tmp
        LDA (tmp),Y
        STA screen_objects_buffer, X
        INX
        CPX screen_objbuf_size
        BNE @load_objects
    @load_objects_end:

    ; get entity buffer adr
    LDA scrbuf_index
    AND #$03
    STA MMC5_MUL_A
    LDA scrbuf_index
    AND #$0C
    LSR
    LSR
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA #$C0
    CLC
    ADC MMC5_MUL_A
    STA tmp+1
    LDA #$00
    STA tmp+0
    LDA #PRGRAM_SPR_BANK
    STA last_frame_BNK+3
    STA MMC5_PRG_BNK2
    ; reset entity buffer
    LDY #$3F
    LDA #$00
    STA entity_load_counter
    @reset_entity:
        STA (tmp), Y
        DEY
        BPL @reset_entity

    ; get screen buffer bank at $C000 - $DFFF
    JSR mdl_world_scr_buf_bnk2

    ; get object bank at $A000 - $BFFF
    LDA #OBJ_BANK
    STA last_frame_BNK+2
    STA MMC5_PRG_BNK1

    ; init seed
    LDX world
    INX
    STX seed+0
    LDX tmp+2
    STX seed+1

    ; reset screen_draw_flag
    LDA #$00
    STA screen_draw_flag

    LDY #$00
    @draw_objects:
        ; init number of loop
        LDX #$01
        ; load the object type
        LDA screen_objects_buffer, Y
        STA screen_draw_obj_buf+0
        INY

        ; if object type == RLE
        CMP #$20
        BNE @obj_rle_end
            ; load number of loop
            LDA screen_objects_buffer, Y
            INY
            TAX
            ; load real object type
            LDA screen_objects_buffer, Y
            STA screen_draw_obj_buf+0
            INY
        @obj_rle_end:

        ; if object has a subtype
        ASL
        BCC @obj_sub_end
            LDA screen_objects_buffer, Y
            STA screen_draw_obj_buf+1
            INY
        @obj_sub_end:

        ; if object is an entity
        ASL
        ASL
        ASL
        LDA screen_draw_flag
        AND #$02
        BCS @obj_entity
            ;
            BEQ @obj_entity_end
                ;
                LDA screen_draw_flag
                AND #$FD
                STA screen_draw_flag
                ; get screen buffer bank at $C000 - $DFFF
                JSR mdl_world_scr_buf_bnk2
                JMP @obj_entity_end
        @obj_entity:
            BNE @obj_entity_end
                ;
                LDA screen_draw_flag
                ORA #$02
                STA screen_draw_flag
                ;
                LDA #PRGRAM_SPR_BANK
                STA last_frame_BNK+3
                STA MMC5_PRG_BNK2
        @obj_entity_end:

        @rle_loop:
            ; if object has a pos
            LDA screen_draw_obj_buf+0
            AND #$40
            BEQ @obj_pos_end
                LDA screen_objects_buffer, Y
                STA screen_draw_obj_buf+2
                INY
            @obj_pos_end:

            ; if object has a size
            LDA screen_draw_obj_buf+0
            AND #$20
            BEQ @obj_size_end
                LDA screen_objects_buffer, Y
                STA screen_draw_obj_buf+3
                INY
            @obj_size_end:

            ; draw object
            JSR module_world_draw_object

            ; rle loop
            DEX
            BNE @rle_loop

        ; loop
        CPY screen_objbuf_size
        BNE @draw_objects

    pullreg
    RTS

