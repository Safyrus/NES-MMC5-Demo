mdl_ctrl_normal:
    ; tile animation
    LDA game_framecount+1
    AND #ANIM_BASE_SPD_MASK
    BNE @anim_end
    LDA game_substate
    AND #$01
    BNE @anim_end
        LDA game_substate
        ORA #$01
        STA game_substate
        ; add the module_world_draw_anim module
        LDA #LOWER_MODULE_MAX_PRIO-2
        JSR mdl_ctrl_lw_adr
        LDA #MODULE_WORLD
        STA lower_module_array, X
        INX
        LDA #<module_world_draw_anim
        STA lower_module_array, X
        INX
        LDA #>module_world_draw_anim
        STA lower_module_array, X
        ;
        LDX anim_counter
        INX
        TXA
        AND #ANIM_MAX_FRAME_MASK
        STA anim_counter
    @anim_end:

    LDA #PRGRAM_SPR_BANK
    STA MMC5_RAM_BNK
    LDX #$3F
    @entity_act:
        LDA global_entity_buffer_adr_bnk, X
        BEQ @next
            LDA global_entity_buffer_adr_bnk, X
            STA MMC5_PRG_BNK1
            LDA global_entity_buffer_adr_lo, X
            STA tmp+0
            LDA global_entity_buffer_adr_hi, X
            STA tmp+1

            LDA #>(@entity_act_ret-1)
            PHA
            LDA #<(@entity_act_ret-1)
            PHA
            JMP (tmp)
            @entity_act_ret:
            LDA #PRGRAM_SPR_BANK
            STA MMC5_RAM_BNK
        @next:
        DEX
        BPL @entity_act

    LDA game_substate
    AND #$02
    BNE @entity_draw_end
        LDA game_substate
        ORA #$02
        STA game_substate
        ; add the module_world_draw_global_sprites module
        LDA #LOWER_MODULE_MAX_PRIO
        JSR mdl_ctrl_lw_adr
        LDA #MODULE_WORLD
        STA lower_module_array, X
        INX
        LDA #<module_world_draw_global_sprites
        STA lower_module_array, X
        INX
        LDA #>module_world_draw_global_sprites
        STA lower_module_array, X
    @entity_draw_end:

    @end:
    RTS
