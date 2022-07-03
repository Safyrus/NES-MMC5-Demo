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
    .byte $08, $09, $0A, $0B
    .byte $18, $19, $1A, $1B
    .byte $28, $29, $2A, $2B
    .byte $00, $0C, $0D, $0E
    ; high tile
    .byte $41, $81, $81, $41
    .byte $41, $81, $81, $41
    .byte $41, $41, $41, $41
    .byte $00, $41, $41, $41
; tall bush
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
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $1C, $1D
    .byte $2C, $2D
    ; high tile
    .byte $41, $41
    .byte $41, $41
; bush
    ; size
    .byte (1 << 4)+3
    ; low tile
    .byte $08, $09, $0B
    ; high tile
    .byte $41, $81, $41
; forest - middle
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $1A, $09, $0A, $19
    .byte $0A, $19, $1A, $09
    .byte $1A, $09, $0A, $19
    .byte $0A, $19, $1A, $09
    ; high tile
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $81
; forest - bot
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $1A, $09, $0A, $19
    .byte $1D, $19, $1A, $1C
    .byte $2D, $29, $2A, $2C
    .byte $00, $0C, $0D, $0E
    ; high tile
    .byte $81, $81, $81, $81
    .byte $41, $81, $81, $41
    .byte $41, $41, $41, $41
    .byte $00, $41, $41, $41
; forest - bot left
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $18, $19
    .byte $28, $29
    .byte $00, $0C
    ; high tile
    .byte $41, $81
    .byte $41, $41
    .byte $00, $41
; forest - bot right
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $1A, $1B
    .byte $2A, $2B
    .byte $0D, $0E
    ; high tile
    .byte $81, $41
    .byte $41, $41
    .byte $41, $41
; forest - left
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $18, $19
    .byte $28, $09
    ; high tile
    .byte $41, $81
    .byte $41, $81
; forest - right
    ; size
    .byte (2 << 4)+2
    ; low tile
    .byte $1A, $1B
    .byte $0A, $2B
    ; high tile
    .byte $81, $41
    .byte $81, $41
; forest - top left
    ; size
    .byte (1 << 4)+2
    ; low tile
    .byte $08, $09
    ; high tile
    .byte $41, $81
; forest - top right
    ; size
    .byte (1 << 4)+2
    ; low tile
    .byte $0A, $0B
    ; high tile
    .byte $81, $41
; forest - top
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $08, $09, $0A, $0B
    .byte $0A, $19, $1A, $09
    ; high tile
    .byte $41, $81, $81, $41
    .byte $81, $81, $81, $81
; forest - top right 2
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $1A, $09, $0A, $0B
    .byte $0A, $19, $1A, $09
    ; high tile
    .byte $81, $81, $81, $41
    .byte $81, $81, $81, $81
; forest - top left 2
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $08, $09, $0A, $19
    .byte $0A, $19, $1A, $09
    ; high tile
    .byte $41, $81, $81, $81
    .byte $81, $81, $81, $81
; forest - bot left 2
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $1A, $09, $0A, $19
    .byte $1D, $19, $1A, $09
    .byte $2D, $29, $1D, $19
    .byte $00, $0C, $2D, $09
    ; high tile
    .byte $81, $81, $81, $81
    .byte $41, $81, $81, $81
    .byte $41, $41, $41, $81
    .byte $00, $41, $41, $81
; forest - bot right 2
    ; size
    .byte (4 << 4)+4
    ; low tile
    .byte $1A, $09, $0A, $19
    .byte $0A, $19, $1A, $1C
    .byte $1A, $1C, $2A, $2C
    .byte $0A, $2C, $0D, $0E
    ; high tile
    .byte $81, $81, $81, $81
    .byte $81, $81, $81, $41
    .byte $81, $41, $41, $41
    .byte $81, $41, $41, $41
; forest - bot left 3
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $1D, $19
    .byte $2D, $29
    .byte $00, $0C
    ; high tile
    .byte $41, $81
    .byte $41, $41
    .byte $00, $41
; forest - bot right 3
    ; size
    .byte (3 << 4)+2
    ; low tile
    .byte $1A, $1C
    .byte $2A, $2C
    .byte $0D, $0E
    ; high tile
    .byte $81, $41
    .byte $41, $41
    .byte $41, $41
; cliff bottom
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $2D, $2C, $2C, $2C
    .byte $2C, $2C, $2D, $2C
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom left
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $2D, $2C, $2C, $2C
    .byte $28, $2C, $2D, $2C
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom right
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $2D, $2C, $2C, $2C
    .byte $2C, $2C, $2D, $2B
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; cliff bottom left right
    ; size
    .byte (2 << 4)+4
    ; low tile
    .byte $2D, $2C, $2C, $2C
    .byte $28, $2C, $2D, $2B
    ; high tile
    .byte $41, $41, $41, $41
    .byte $41, $41, $41, $41
; trunk
    ; size
    .byte (1 << 4)+1
    ; low tile
    .byte $67
    ; high tile
    .byte $81
; log
    ; size
    .byte (3 << 4)+1
    ; low tile
    .byte $38
    .byte $48
    .byte $68
    ; high tile
    .byte $81
    .byte $81
    .byte $81
; shaft
    ; size
    .byte (7 << 4)+7
    ; low tile
    .byte $00, $00, $20, $14, $23, $00, $00
    .byte $20, $21, $12, $24, $13, $22, $23
    .byte $12, $12, $30, $34, $33, $13, $13
    .byte $30, $31, $10, $10, $10, $32, $33
    .byte $58, $10, $10, $10, $10, $10, $58
    .byte $58, $10, $47, $10, $47, $10, $58
    .byte $68, $11, $57, $11, $11, $11, $68
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
    .byte $3A, $00
    .byte $4A, $4B
    .byte $39, $00
    .byte $49, $00
    .byte $59, $00
    .byte $39, $00
    .byte $3A, $4B
    .byte $5A, $00
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
    .byte $43
    .byte $43
    .byte $43
    .byte $43
    ; high tile
    .byte $81
    .byte $81
    .byte $81
    .byte $81
