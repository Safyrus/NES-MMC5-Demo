.include "read.asm"

.include "state/border.asm"
.include "state/clear.asm"
.include "state/end.asm"
.include "state/init.asm"
.include "state/main.asm"
.include "state/next.asm"

module_dialog:
    LDA game_state
    CMP #STATE::DIALOG
    BEQ @state
    @start:
        ;
        LDA #STATE::DIALOG
        STA game_state
        LDA #$00
        STA game_substate

    @state:
    LDA game_substate
    TAX
    LDA @table_next, X
    STA game_substate
    ;
    LDA @table_hi, X
    PHA
    LDA @table_lo, X
    PHA
    RTS

@table_lo:
    .byte <(dialog_init-1)
    .byte <(dialog_draw_border-1)
    .byte <(dialog_clear_1-1)
    .byte <(dialog_clear_2-1)
    .byte <(dialog_clear_3-1)
    .byte <(dialog_draw_border-1)
    .byte <(dialog_main-1)
    .byte <(dialog_next-1)
    .byte <(dialog_clear_1-1)
    .byte <(dialog_clear_2-1)
    .byte <(dialog_clear_3-1)
    .byte <(dialog_end-1)
@table_hi:
    .byte >(dialog_init-1)
    .byte >(dialog_draw_border-1)
    .byte >(dialog_clear_1-1)
    .byte >(dialog_clear_2-1)
    .byte >(dialog_clear_3-1)
    .byte >(dialog_draw_border-1)
    .byte >(dialog_main-1)
    .byte >(dialog_next-1)
    .byte >(dialog_clear_1-1)
    .byte >(dialog_clear_2-1)
    .byte >(dialog_clear_3-1)
    .byte >(dialog_end-1)
@table_next:
    .byte 1
    .byte 2
    .byte 3
    .byte 4
    .byte 5
    .byte 6
    .byte 6
    .byte 7
    .byte 9
    .byte 10
    .byte 11
    .byte 0
