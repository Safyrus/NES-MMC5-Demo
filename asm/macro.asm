;**********
; Macros
;**********

.macro pushreg
    PHA
    TXA
    PHA
    TYA
    PHA
.endmacro


.macro pullreg
    PLA
    TAY
    PLA
    TAX
    PLA
.endmacro

.macro push_ax
    PHA
    TXA
    PHA
.endmacro

.macro pull_ax
    PLA
    TAX
    PLA
.endmacro

.macro push_ay
    PHA
    TYA
    PHA
.endmacro

.macro pull_ay
    PLA
    TAY
    PLA
.endmacro


.macro push_xy
    TXA
    PHA
    TYA
    PHA
.endmacro

.macro pull_xy
    PLA
    TAY
    PLA
    TAX
.endmacro


.macro push_x
    TXA
    PHA
.endmacro

.macro pull_x
    PLA
    TAX
.endmacro

.macro push_scroll
    LDA game_scroll_x+0
    PHA
    LDA game_scroll_x+1
    PHA
    LDA game_scroll_y+0
    PHA
    LDA game_scroll_y+1
    PHA
.endmacro

.macro pull_scroll
    PLA
    STA game_scroll_y+1
    PLA
    STA game_scroll_y+0
    PLA
    STA game_scroll_x+1
    PLA
    STA game_scroll_x+0
.endmacro
