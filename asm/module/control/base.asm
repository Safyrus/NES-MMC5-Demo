.include "global_entity.asm"
.include "input.asm"
.include "player.asm"
.include "utils.asm"

.include "input_check/down.asm"
.include "input_check/left.asm"
.include "input_check/right.asm"
.include "input_check/up.asm"

.include "scroll/down.asm"
.include "scroll/left.asm"
.include "scroll/right.asm"
.include "scroll/up.asm"
.include "scroll/utils.asm"

.include "state/draw.asm"
.include "state/load_lv.asm"
.include "state/load_scr.asm"
.include "state/normal.asm"

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
