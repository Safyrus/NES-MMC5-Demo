module_world_draw_anim:

    LDA #PRGRAM_SCREEN_BANK
    STA MMC5_RAM_BNK
    STA last_frame_BNK+0
    LDA #PRGRAM_SCREEN_BANK+1
    STA MMC5_PRG_BNK1
    STA last_frame_BNK+2
    LDA #PRGRAM_SCREEN_BANK+2
    STA MMC5_PRG_BNK2
    STA last_frame_BNK+3

    LDX #$00
    LDY #$00
    @loop:
        @page_0:
        LDA $7800, X
        BEQ @page_1
            JSR module_world_draw_anim_loop1
            LDA $7C00, X
            JSR module_world_draw_anim_loop2
        @page_1:
        LDA $7900, X
        BEQ @page_2
            JSR module_world_draw_anim_loop1
            LDA $7D00, X
            JSR module_world_draw_anim_loop2
        @page_2:
        LDA $7A00, X
        BEQ @page_3
            JSR module_world_draw_anim_loop1
            LDA $7E00, X
            JSR module_world_draw_anim_loop2
        @page_3:
        LDA $7B00, X
        BEQ @next
            JSR module_world_draw_anim_loop1
            LDA $7F00, X
            JSR module_world_draw_anim_loop2
        @next:
        INX
        BEQ @end
        JMP @loop
    @end:
    LDA game_substate
    AND #$FE
    STA game_substate
    RTS


module_world_draw_anim_loop1:
    STA tmp+1
    AND #$03
    ORA #$5C
    STA tmp+3
    RTS

module_world_draw_anim_loop2:
    TXA
    PHA

    STA tmp+0
    STA tmp+2
    LDA (tmp), Y
    AND #$10
    BEQ @2frame
    @4frame:
        LDA (tmp), Y
        AND #$FC
        CLC
        ADC anim_counter
        JMP @frame_end
    @2frame:
        LDA (tmp), Y
        AND #$FE
        STA tmp+4
        LDA anim_counter
        LSR
        CLC
        ADC tmp+4
    @frame_end:
    STA (tmp), Y
    TAX
    ; wait to be in the frame to write to expansion RAM
    @wait_inframe_0:
        BIT scanline
        BVC @wait_inframe_0
    TXA
    STA (tmp+2), Y

    PLA
    TAX
    RTS
