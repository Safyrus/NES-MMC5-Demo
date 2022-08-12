.enum LOCAL_ENTITY_POS_0
    DIALOG_0 = $D000
    DIALOG_1
.endenum

local_entity_pos_0:
@dialog_0:
; dialog 0
    ; size
    .byte @dialog_1 - @dialog_0
    ; behavior fct bank
    .byte MODULE_CTRL
    ; behavior fct adr
    .word ((ai_dialog .MOD $2000) + $A000)
    ; sprite number
    .byte 0
    ;
    .byte 0
@dialog_1:
; dialog 1
    ; size
    .byte @end - @dialog_1
    ; behavior fct bank
    .byte MODULE_CTRL
    ; behavior fct adr
    .word ((ai_dialog .MOD $2000) + $A000)
    ; sprite number
    .byte 0
    ;
    .byte 1
@end:
