.include "read.asm"

.include "state/border.asm"
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
    .byte <(dialog_main-1)
    .byte <(dialog_next-1)
    .byte <(dialog_end-1)
@table_hi:
    .byte >(dialog_init-1)
    .byte >(dialog_draw_border-1)
    .byte >(dialog_main-1)
    .byte >(dialog_next-1)
    .byte >(dialog_end-1)
@table_next:
    .byte 1
    .byte 2
    .byte 2
    .byte 0
    .byte 0
