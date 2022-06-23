.enum OBJ_POS
    TREE = $40
    TALL_BUSH
    BEHIND_TREE
    BUSH
    FOREST
    FOREST_TOP
.endenum

object_pos_lo:
    .byte <object_pos_0
    .byte <object_pos_1
    .byte <object_pos_2
    .byte <object_pos_3
    .byte <object_pos_4
    .byte <object_pos_5
    .byte <object_pos_6
    .byte <object_pos_7
    .byte <object_pos_8
    .byte <object_pos_9
    .byte <object_pos_A
    .byte <object_pos_B
    .byte <object_pos_C
    .byte <object_pos_D
    .byte <object_pos_E
    .byte <object_pos_F
object_pos_hi:
    .byte >object_pos_0
    .byte >object_pos_1
    .byte >object_pos_2
    .byte >object_pos_3
    .byte >object_pos_4
    .byte >object_pos_5
    .byte >object_pos_6
    .byte >object_pos_7
    .byte >object_pos_8
    .byte >object_pos_9
    .byte >object_pos_A
    .byte >object_pos_B
    .byte >object_pos_C
    .byte >object_pos_D
    .byte >object_pos_E
    .byte >object_pos_F


; Tree
object_pos_0:
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $08, $09, $0A, $0B
    .byte $18, $19, $1A, $1B
    .byte $28, $29, $2A, $2B
    .byte $00, $0C, $0D, $00
    ; high tile
    .byte $41, $81, $81, $41
    .byte $41, $81, $81, $41
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; tall bush
object_pos_1:
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $08, $0B
    .byte $18, $1B
    .byte $28, $2B
    ; high tile
    .byte $41, $41
    .byte $41, $41
    .byte $41, $41
; Behind tree
object_pos_2:
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $1C, $1D
    .byte $2C, $2D
    ; high tile
    .byte $41, $41
    .byte $41, $41
; bush
object_pos_3:
    ; size
    .byte (1 << 4)+3
    ; low tile
    .byte $08, $09, $0B
    ; high tile
    .byte $41, $81, $41
; forest
object_pos_4:
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $0A, $19, $1A, $09
    .byte $1A, $09, $0A, $19
    ; high tile
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
; forest top
object_pos_5:
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $00, $04, $00, $00
    .byte $08, $09, $0A, $0B
    ; high tile
    .byte $01, $01, $01, $01
    .byte $41, $81, $81, $41
object_pos_6:
object_pos_7:
object_pos_8:
object_pos_9:
object_pos_A:
object_pos_B:
object_pos_C:
object_pos_D:
object_pos_E:
object_pos_F:
    .byte 0
