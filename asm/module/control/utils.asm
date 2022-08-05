; A = priority
mdl_ctrl_lw_adr:
    PHA

    LDX #LOWER_MODULE_SIZE-1
    @loop:
        LDA lower_module_array_prio, X
        BEQ @found
        DEX
        BPL @loop
    JMP @end

    @found:
        PLA
        STA lower_module_array_prio, X
        PHA
        TXA
        ASL
        ASL
        TAX

    @end:
    PLA
    RTS


; X = dir
mdl_ctrl_update_scrbuf:
    pushreg

    ; setup var S
    TXA
    AND #$01
    BEQ @s_m
    @s_p:
        STA var+0
        JMP @s_done
    @s_m:
        LDA #$FF
        STA var+0
    @s_done:

    ; setup x, y, w, h, rw
    LDA game_scroll_x
    STA var+1
    LDA game_scroll_y
    STA var+2
    LDA level_wh
    AND #$0F
    STA var+3
    STA var+13
    LDA level_wh
    LSR
    LSR
    LSR
    LSR
    STA var+4

    ; swap if necessary
    TXA
    AND #$02
    BEQ @swap_done
        ; swap x and y
        LDA var+1
        STA tmp
        LDA var+2
        STA var+1
        LDA tmp
        STA var+2
        ; swap w and h
        LDA var+3
        STA tmp
        LDA var+4
        STA var+3
        LDA tmp
        STA var+4
    @swap_done:

    ; compute YS
    LDA var+2
    CLC
    ADC var+0
    STA var+5

    ; compute Y3
    LDA #$03
    STA tmp+7
    LDA var+5
    JSR mod_sign
    STA var+6

    ; compute YH
    LDA var+4
    STA tmp+7
    LDA var+5
    JSR mod_sign
    STA var+7

    ; compute XM
    LDA var+3
    STA tmp+7
    LDA var+1
    SEC
    SBC #$01
    JSR mod_sign
    STA var+8

    ; compute XP
    LDA var+3
    STA tmp+7
    LDA var+1
    CLC
    ADC #$01
    JSR mod_sign
    STA var+9

    ; compute X3
    LDA #$03
    STA tmp+7
    LDA var+1
    JSR mod_sign
    STA var+10

    ; compute XM3
    LDA #$03
    STA tmp+7
    LDA var+1
    SEC
    SBC #$01
    JSR mod_sign
    STA var+11

    ; compute XP3
    LDA #$03
    STA tmp+7
    LDA var+1
    CLC
    ADC #$01
    JSR mod_sign
    STA var+12

    TXA
    AND #$02
    BEQ @by
    @bx:
        JSR mdl_ctrl_update_scrbuf_x
        JMP @update
    @by:
        JSR mdl_ctrl_update_scrbuf_y

    @update:
    ;
    LDA scrbuf_update_flag
    AND #$01
    BNE @end
        ; add the module_world_load_screens module
        LDA #LOWER_MODULE_MAX_PRIO-2
        JSR mdl_ctrl_lw_adr
        LDA #MODULE_WORLD
        STA lower_module_array, X
        INX
        LDA #<module_world_load_screens
        STA lower_module_array, X
        INX
        LDA #>module_world_load_screens
        STA lower_module_array, X

    @end:
    LDA #PRGRAM_SPR_BANK
    STA MMC5_RAM_BNK
    pullreg
    RTS


mdl_ctrl_update_scrbuf_y:
    ; ----------------
    ; middle buffer
    ; ----------------
    ; buffer index
    LDA var+6
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+10
    TAX
    ; screen index
    LDA var+7
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+1
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    ; ----------------
    ; left buffer
    ; ----------------
    ; buffer index
    LDA var+6
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+11
    TAX
    ; screen index
    LDA var+7
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+8
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    ; ----------------
    ; right buffer
    ; ----------------
    ; buffer index
    LDA var+6
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+12
    TAX
    ; screen index
    LDA var+7
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+9
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    RTS


mdl_ctrl_update_scrbuf_x:
    ; ----------------
    ; middle buffer
    ; ----------------
    ; buffer index
    LDA var+10
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+6
    TAX
    ; screen index
    LDA var+1
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+7
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    ; ----------------
    ; left buffer
    ; ----------------
    ; buffer index
    LDA var+11
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+6
    TAX
    ; screen index
    LDA var+8
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+7
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    ; ----------------
    ; right buffer
    ; ----------------
    ; buffer index
    LDA var+12
    STA MMC5_MUL_A
    LDA #$03
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+6
    TAX
    ; screen index
    LDA var+9
    STA MMC5_MUL_A
    LDA var+13
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    CLC
    ADC var+7
    TAY
    ; buf = scr
    LDA level_screens_buffer, Y
    STA scrbuf_update_array_scr, X
    LDA #$01
    STA scrbuf_update_array_act, X

    RTS
