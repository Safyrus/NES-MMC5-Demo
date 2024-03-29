.enum ENTITY_POS
    PLAYER = $50
.endenum

entity_pos_lo:
    .byte <entity_pos_0
    .byte <entity_pos_1
    .byte <entity_pos_2
    .byte <entity_pos_3
    .byte <entity_pos_4
    .byte <entity_pos_5
    .byte <entity_pos_6
    .byte <entity_pos_7
    .byte <entity_pos_8
    .byte <entity_pos_9
    .byte <entity_pos_A
    .byte <entity_pos_B
    .byte <entity_pos_C
    .byte <entity_pos_D
    .byte <entity_pos_E
    .byte <entity_pos_F
entity_pos_hi:
    .byte >entity_pos_0
    .byte >entity_pos_1
    .byte >entity_pos_2
    .byte >entity_pos_3
    .byte >entity_pos_4
    .byte >entity_pos_5
    .byte >entity_pos_6
    .byte >entity_pos_7
    .byte >entity_pos_8
    .byte >entity_pos_9
    .byte >entity_pos_A
    .byte >entity_pos_B
    .byte >entity_pos_C
    .byte >entity_pos_D
    .byte >entity_pos_E
    .byte >entity_pos_F

; player
entity_pos_0:
    ; behavior fct bank
    .byte MODULE_CTRL
    ; behavior fct adr
    .word ((player_input .MOD $2000) + $A000)
    ; size
    .byte $11
    ; sprite number
    .byte 3
    ; sprites
    .byte $10+ANIM_FLIP
    .byte $00
    .byte %00010001
    .byte $00+ANIM_INC
    .byte $90
    .byte %00010011
    .byte $04
    .byte $00
    .byte %00010011
entity_pos_1:
entity_pos_2:
entity_pos_3:
entity_pos_4:
entity_pos_5:
entity_pos_6:
entity_pos_7:
entity_pos_8:
entity_pos_9:
entity_pos_A:
entity_pos_B:
entity_pos_C:
entity_pos_D:
entity_pos_E:
entity_pos_F:
    .byte 0
