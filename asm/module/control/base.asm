.include "input.asm"
.include "player.asm"
.include "scroll.asm"
.include "utils.asm"

module_control:
    ; reset background index
    LDA #$00
    STA background_index
    STA background

    ; choose a action based on the game state
    LDX game_state
    LDA @mdl_ctrl_act_hi,X
    PHA
    LDA @mdl_ctrl_act_lo,X
    PHA
    @wait:
    RTS ; RTS trick

    @mdl_ctrl_act_hi:
        .byte >(mdl_ctrl_load_lv-1)
        .byte >(@wait-1)
        .byte >(mdl_ctrl_draw_scr-1)
        .byte >(mdl_ctrl_draw_scr-1)
        .byte >(mdl_ctrl_load_scr_all-1)
        .byte >(mdl_ctrl_normal-1)
    @mdl_ctrl_act_lo:
        .byte <(mdl_ctrl_load_lv-1)
        .byte <(@wait-1)
        .byte <(mdl_ctrl_draw_scr-1)
        .byte <(mdl_ctrl_draw_scr-1)
        .byte <(mdl_ctrl_load_scr_all-1)
        .byte <(mdl_ctrl_normal-1)


mdl_ctrl_load_lv:
    LDA #STATE::NORMAL
    STA game_state

    ; set the world and level to 0
    LDA #$00
    STA world
    LDA #$00
    STA level

    ; add the world_load_level module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_WORLD
    STA lower_module_array, X
    INX
    LDA #<module_world_load_level
    STA lower_module_array, X
    INX
    LDA #>module_world_load_level
    STA lower_module_array, X

    RTS


mdl_ctrl_load_scr_all:
    LDA #STATE::WAIT
    STA game_state

    ; add the world_load_screen_all module
    LDA #LOWER_MODULE_MAX_PRIO
    JSR mdl_ctrl_lw_adr
    LDA #MODULE_WORLD
    STA lower_module_array, X
    INX
    LDA #<module_world_load_screen_all
    STA lower_module_array, X
    INX
    LDA #>module_world_load_screen_all
    STA lower_module_array, X

    RTS


mdl_ctrl_draw_scr:
    LDA game_state
    CMP #STATE::DRAW_SCREEN_WAIT
    BEQ @wait

    @start:
        LDA #STATE::DRAW_SCREEN_WAIT
        STA game_state
        LDA #$00
        STA game_substate
        JMP @load

    @wait:
        LDA game_substate
        BEQ @wait_end
        JMP @load
    
    @load:
        ; add the module_world_draw_screen module
        LDA #LOWER_MODULE_MAX_PRIO
        JSR mdl_ctrl_lw_adr
        LDA #MODULE_WORLD
        STA lower_module_array, X
        INX
        LDA #<module_world_draw_screen
        STA lower_module_array, X
        INX
        LDA #>module_world_draw_screen
        STA lower_module_array, X

        JMP @end

    @wait_end:
        LDA #STATE::NORMAL
        STA game_state
        LDY #DIR::RIGHT
        JSR scroll_draw_plan
        LDY #DIR::DOWN
        JSR scroll_draw_plan

    @end:
    RTS


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
