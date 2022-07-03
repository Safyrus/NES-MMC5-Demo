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
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0

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

    ; get screen buffer bank at $C000 - $DFFF
    LDA scrbuf_index
    AND #$03
    CLC
    ADC #PRGRAM_SCREEN_BANK
    STA MMC5_PRG_BNK2
    STA last_frame_BNK+3

    ; get object bank at $A000 - $BFFF
    LDA #OBJ_BANK
    STA MMC5_PRG_BNK1
    STA last_frame_BNK+2

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
        BNE @obj_sub
            ; load number of loop
            LDA screen_objects_buffer, Y
            INY
            TAX
            ; load real object type
            LDA screen_objects_buffer, Y
            STA screen_draw_obj_buf+0
            INY

        @obj_sub:
        ; if object has a subtype
        ASL
        BCC @rle_loop
            LDA screen_objects_buffer, Y
            STA screen_draw_obj_buf+1
            INY

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


module_world_load_screens:
    ;
    LDA scrbuf_update_flag
    ORA #$01
    STA scrbuf_update_flag
    ;
    @while:
        ;
        LDA scrbuf_update_flag
        AND #$FD
        STA scrbuf_update_flag
        ;
        LDY #$00
        @loop:
            ;
            LDA scrbuf_update_array_act, Y
            BEQ @loop_nxt
            ;
            LDA scrbuf_update_flag
            ORA #$02
            STA scrbuf_update_flag
            ;
            LDA #$00
            STA scrbuf_update_array_act, Y

            TYA
            JSR mdl_world_A2scrBufIdx

            ; update one screen buffer
            LDA scrbuf_update_array_scr, Y
            TAX
            JSR mdl_world_load_screen_one

            @loop_nxt:
            INY
            CPY #$09
            BNE @loop
        ;
        LDA scrbuf_update_flag
        AND #$02
        BNE @while

    ;
    LDA scrbuf_update_flag
    AND #$FE
    STA scrbuf_update_flag
    ; return
    RTS


module_world_load_screen_all:
    LDY #$00
    @loop:
        LDA #$01
        STA scrbuf_update_array_act, Y
        ;
        LDA #$03
        STA tmp+7
        TYA
        JSR div
        ; save mod
        STA tmp+7
        ; res*lv_w
        TXA
        STA MMC5_MUL_A
        LDA level_wh
        AND #$0F
        STA MMC5_MUL_B
        ;
        LDA MMC5_MUL_A
        CLC
        ADC tmp+7
        ;
        TAX
        LDA level_screens_buffer, X
        STA scrbuf_update_array_scr, Y
        ; loop
        INY
        CPY #$09
        BNE @loop

    JSR module_world_load_screens

    LDA #STATE::DRAW_SCREEN
    STA game_state

    RTS
