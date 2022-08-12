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
        LDA #LOWER_MODULE_MAX_PRIO-1
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

    ; add the module_global_entity_act module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_CTRL
    STA lower_module_array, X
    INX
    LDA #<module_global_entity_act
    STA lower_module_array, X
    INX
    LDA #>module_global_entity_act
    STA lower_module_array, X

    ; add the module_local_entity_act module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_CTRL
    STA lower_module_array, X
    INX
    LDA #<module_local_entity_act
    STA lower_module_array, X
    INX
    LDA #>module_local_entity_act
    STA lower_module_array, X

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
        LDA #<module_world_draw_sprites
        STA lower_module_array, X
        INX
        LDA #>module_world_draw_sprites
        STA lower_module_array, X
    @entity_draw_end:

    @end:
    RTS
