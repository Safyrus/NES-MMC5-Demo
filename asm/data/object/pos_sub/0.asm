.enum OBJ_SUBPOS_0
    TREE = $C000
    TALL_BUSH
    BEHIND_TREE
    BUSH
    FOREST_MID
    FOREST_BOT
    FOREST_BOTLEFT
    FOREST_BOTRIGHT
    FOREST_LEFT
    FOREST_RIGHT
    FOREST_TOPLEFT
    FOREST_TOPRIGHT
    FOREST_TOP
    FOREST_TOPRIGHT2
    FOREST_TOPLEFT2
    FOREST_BOTLEFT2
    FOREST_BOTRIGHT2
    FOREST_BOTLEFT3
    FOREST_BOTRIGHT3
    CLIFF_BOT
    CLIFF_BOTLEFT
    CLIFF_BOTRIGHT
    CLIFF_BOTLR
    TRUNK
    LOG
    SHAFT
    GATE
    WATERFALL
.endenum

object_subpos_0_base:
; tree
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $88, $89, $8A, $8B
    .byte $98, $99, $9A, $9B
    .byte $A8, $A9, $AA, $AB
    .byte $00, $8C, $8D, $0E
    ; high tile
    .byte $41, $81, $81, $41
    .byte $41, $81, $81, $41
    .byte $41, $41, $41, $41
    .byte $00, $41, $41, $41
; tall bush
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $88, $8B
    .byte $98, $9B
    .byte $A8, $AB
    ; high tile
    .byte $41, $41
    .byte $41, $41
    .byte $41, $41
; Behind tree
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $9C, $9D
    .byte $AC, $AD
    ; high tile
    .byte $41, $41
    .byte $41, $41
; bush
    ; size
    .byte (1 << 4)+3
    ; low tile
    .byte $88, $89, $8B
    ; high tile
    .byte $41, $81, $41
; forest - middle
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $9A, $89, $8A, $99
    .byte $8A, $99, $9A, $89
    .byte $9A, $89, $8A, $99
    .byte $8A, $99, $9A, $89
    ; high tile
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
; forest - bot
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $9A, $89, $8A, $99
    .byte $9D, $99, $9A, $9C
    .byte $AD, $A9, $AA, $AC
    .byte $00, $8C, $8D, $0E
    ; high tile
    .byte $81, $81, $81, $81
    .byte $41, $81, $81, $41
    .byte $41, $41, $41, $41
    .byte $00, $41, $41, $41
; forest - bot left
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $98, $99
    .byte $A8, $A9
    .byte $00, $8C
    ; high tile
    .byte $41, $81
    .byte $41, $41
    .byte $00, $41
; forest - bot right
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $9A, $9B
    .byte $AA, $AB
    .byte $8D, $0E
    ; high tile
    .byte $81, $41
    .byte $41, $41
    .byte $41, $41
; forest - left
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $98, $99
    .byte $A8, $89
    ; high tile
    .byte $41, $81
    .byte $41, $81
; forest - right
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $9A, $9B
    .byte $8A, $AB
    ; high tile
    .byte $81, $41
    .byte $81, $41
; forest - top left
    ; size
    .byte (1 << 4)+2
    ; low tile
    .byte $88, $89
    ; high tile
    .byte $41, $81
; forest - top right
    ; size
    .byte (1 << 4)+2
    ; low tile
    .byte $8A, $8B
    ; high tile
    .byte $81, $41
; forest - top
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $88, $89, $8A, $8B
    .byte $8A, $99, $9A, $89
    ; high tile
    .byte $41, $81, $81, $41
    .byte $81, $81, $81, $81
; forest - top right 2
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $9A, $89, $8A, $8B
    .byte $8A, $99, $9A, $89
    ; high tile
    .byte $81, $81, $81, $41
    .byte $81, $81, $81, $81
; forest - top left 2
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $88, $89, $8A, $99
    .byte $8A, $99, $9A, $89
    ; high tile
    .byte $41, $81, $81, $81
    .byte $81, $81, $81, $81
; forest - bot left 2
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $9A, $89, $8A, $99
    .byte $9D, $99, $9A, $89
    .byte $AD, $A9, $9D, $99
    .byte $00, $8C, $AD, $89
    ; high tile
    .byte $81, $81, $81, $81
    .byte $41, $81, $81, $81
    .byte $41, $41, $41, $81
    .byte $00, $41, $41, $81
; forest - bot right 2
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $9A, $89, $8A, $99
    .byte $8A, $99, $9A, $9C
    .byte $9A, $9C, $AA, $AC
    .byte $8A, $AC, $8D, $0E
    ; high tile
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $41
    .byte $81, $41, $41, $41
    .byte $81, $41, $41, $41
; forest - bot left 3
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $9D, $99
    .byte $AD, $A9
    .byte $00, $8C
    ; high tile
    .byte $41, $81
    .byte $41, $41
    .byte $00, $41
; forest - bot right 3
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $9A, $9C
    .byte $AA, $AC
    .byte $8D, $0E
    ; high tile
    .byte $81, $41
    .byte $41, $41
    .byte $41, $41
; cliff bottom
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $AD, $AC, $AC, $AC
    .byte $AC, $AC, $AD, $AC
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom left
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $AD, $AC, $AC, $AC
    .byte $A8, $AC, $AD, $AC
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom right
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $AD, $AC, $AC, $AC
    .byte $AC, $AC, $AD, $AB
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom left right
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $AD, $AC, $AC, $AC
    .byte $A8, $AC, $AD, $AB
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; trunk
    ; size
    .byte (1 << 4)+1
    ; low tile
    .byte $E7
    ; high tile
    .byte $81
; log
    ; size
    .byte (3 << 4)+1
    ; low tile
    .byte $B8
    .byte $C8
    .byte $E8
    ; high tile
    .byte $81
    .byte $81
    .byte $81
; shaft
    ; size
    .byte (7 << 4)+7
    ; low tile
    .byte $00, $00, $A0, $94, $A3, $00, $00
    .byte $A0, $A1, $92, $A4, $93, $A2, $A3
    .byte $92, $92, $B0, $B4, $B3, $93, $93
    .byte $B0, $B1, $90, $90, $90, $B2, $B3
    .byte $D8, $90, $90, $90, $90, $90, $D8
    .byte $D8, $90, $C7, $90, $C7, $90, $D8
    .byte $E8, $91, $D7, $91, $91, $91, $E8
    ; high tile
    .byte $00, $00, $81, $81, $81, $00, $00
    .byte $81, $81, $81, $81, $81, $81, $81
    .byte $81, $81, $81, $81, $81, $81, $81
    .byte $81, $81, $81, $81, $81, $81, $81
    .byte $81, $81, $81, $81, $81, $81, $81
    .byte $81, $81, $41, $81, $41, $81, $81
    .byte $81, $81, $41, $81, $81, $81, $81
; gate
    ; size
    .byte (8 << 4)+2
    ; low tile
    .byte $BA, $00
    .byte $CA, $CB
    .byte $B9, $00
    .byte $C9, $00
    .byte $D9, $00
    .byte $B9, $00
    .byte $BA, $CB
    .byte $DA, $00
    ; high tile
    .byte $41, $00
    .byte $41, $81
    .byte $41, $00
    .byte $41, $00
    .byte $41, $00
    .byte $41, $00
    .byte $41, $81
    .byte $81, $00
; waterfall
    ; size
    .byte (4 << 4)+1
    ; low tile
    .byte $C3
    .byte $C3
    .byte $C3
    .byte $C3
    ; high tile
    .byte $A0
    .byte $A0
    .byte $A0
    .byte $A0
