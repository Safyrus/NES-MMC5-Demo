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
        JSR wait_at_frame_end
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
