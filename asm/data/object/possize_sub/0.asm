.enum OBJ_SUBPOSSIZE_0
    PATH = $E000
    PATH_HOR
    PATH_VER
    PATH_TL
    PATH_TR
    PATH_BL
    PATH_BR
    PATH_DOWN
    PATH_LEFT
    PATH_RIGHT
    PATH_OPEN
    CLIFF
    CLIFF_TL
    CLIFF_TR
    CLIFF_BL
    CLIFF_BR
    CLIFF_TOP_SIDE
    CLIFF_BOT_SIDE
    CLIFF_LEFT_SIDE
    WATER
    WATER_HOR
    WATER_TL
    WATER_TR
    WATER_BL
    WATER_BR
    WATER_TOP_SIDE
    WATER_BOT_SIDE
    WATER_OPEN
.endenum

object_subpossize_0_base:
; path
    ; type + flags
    .byte %00000000
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path horizontal
    ; type + flags
    .byte %00000011
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path vertical
    ; type + flags
    .byte %00001100
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path top left
    ; type + flags
    .byte %00000101
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path top right
    ; type + flags
    .byte %00000110
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path bottom left
    ; type + flags
    .byte %00001001
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path bottom right
    ; type + flags
    .byte %00001010
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path down
    ; type + flags
    .byte %00000100
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path left
    ; type + flags
    .byte %00000010
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path right
    ; type + flags
    .byte %00000001
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; path open
    ; type + flags
    .byte %00001111
    ; low tiles
    .byte $44, $45, $46
    .byte $54, $55, $56
    .byte $64, $65, $66
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; cliff
    ; type + flags
    .byte %00000000
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff top left
    ; type + flags
    .byte %00000101
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff top right
    ; type + flags
    .byte %00000110
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff bottom left
    ; type + flags
    .byte %00001001
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff bottom right
    ; type + flags
    .byte %00001010
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff top side
    ; type + flags
    .byte %00000111
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff bottom side
    ; type + flags
    .byte %00001011
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; cliff left side
    ; type + flags
    .byte %00001101
    ; low tiles
    .byte $08, $0A, $0B
    .byte $18, $00, $1B
    .byte $2D, $29, $2C
    ; high tiles
    .byte $41, $81, $41
    .byte $41, $00, $41
    .byte $41, $41, $41
; water
    ; type + flags
    .byte %00000000
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water horizontal
    ; type + flags
    .byte %00000011
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water top left
    ; type + flags
    .byte %00000101
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water top right
    ; type + flags
    .byte %00000110
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water bottom left
    ; type + flags
    .byte %00001001
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water bottom right
    ; type + flags
    .byte %00001010
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water top side
    ; type + flags
    .byte %00000111
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water bottom side
    ; type + flags
    .byte %00001011
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $61, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
; water open
    ; type + flags
    .byte %00001111
    ; low tiles
    .byte $40, $41, $42
    .byte $50, $51, $52
    .byte $60, $51, $62
    ; high tiles
    .byte $81, $81, $81
    .byte $81, $81, $81
    .byte $81, $81, $81
