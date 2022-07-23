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


