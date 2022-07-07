
world_0:
    @screen_address:
    .word @screens

    @levels:
        @level_0:
        ; height, width
        .byte (4<<4) + 3

        ; colors
        .byte %10000000
        .byte %11101000
        .byte %10001101
        .byte %00101100
        .byte %01100001
        .byte %01101000
        .byte %00001101
        .byte %10101100

        ; level sprite banks
        .byte 0, 6, 2, 3, 4, 5, 1, 7

        ; level screens
        .byte 1, 2, 3
        .byte 4, 5, 6
        .byte 7, 8, 9
        .byte 10, 11, 12

    @screens:
        @screen_0:
            ; size
            .byte @screen_1-@screen_0-1
            ; objects
            .byte OBJ_SCR::FILL
        @screen_1:
            ; size
            .byte @screen_2-@screen_1-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .byte ENTITY_POS::PLAYER
            .byte $78

            .byte OBJ_CMD_RLE, 16
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $00
            .byte $02
            .byte $04
            .byte $06
            .byte $08
            .byte $0A
            .byte $0C
            .byte $0E
            .byte $28
            .byte $2A
            .byte $BE
            .byte $DC
            .byte $DE
            .byte $2C
            .byte $D4
            .byte $E4
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $20
            .byte $22
            .byte $24
            .byte $48
            .byte $4A
            .byte $4C
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $47
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $4E
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $26
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $2E
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $AE
            .byte $CC
            .byte $C4
            .byte OBJ_CMD_RLE, 5
            .dbyt OBJ_SUBPOS_0::BUSH
            .byte $73
            .byte $C2
            .byte $B9
            .byte $AB
            .byte $7C
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::PATH_HOR
            .byte $50, $2A
            .byte $86, $2E
            .byte $8D, $26
            .dbyt OBJ_SUBPOSSIZE_0::PATH_VER
            .byte $65, $42
            .dbyt OBJ_SUBPOSSIZE_0::PATH_TR
            .byte $55, $22
            .dbyt OBJ_SUBPOSSIZE_0::PATH_BL
            .byte $85, $22
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::PATH
            .byte $98, $22
            .byte $B8, $22
            .byte $D8, $22
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF
            .byte $70, $94
            .byte $B0, $68
            .dbyt OBJ_SUBPOS_0::CLIFF_BOT
            .byte $E0
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTRIGHT
            .byte $E2
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $D6
            .byte $E6

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $C6
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $82
            .byte $94
            .byte $B0
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $CB
            .byte $AD
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $C4
            .byte $D4
            .byte $E4

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $BD
            .byte $DB
            .byte $EB

        @screen_2:
            ; size
            .byte @screen_3-@screen_2-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .byte OBJ_CMD_RLE, 10
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $00
            .byte $B0
            .byte $D0
            .byte $D2
            .byte $D4
            .byte $D6
            .byte $D8
            .byte $DA
            .byte $DC
            .byte $BE
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $A0
            .byte $C4
            .byte $C6
            .byte $C8
            .byte $CA
            .byte $BE
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $0C
            .byte $0E
            .byte $2D
            .byte $4E
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $22
            .byte $04
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $02
            .byte $DE
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $20
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT2
            .byte $C2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT2
            .byte $CC
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $B2
            .byte OBJ_CMD_RLE, 5
            .dbyt OBJ_SUBPOS_0::TRUNK
            .byte $15
            .byte $1B
            .byte $2A
            .byte $4B
            .byte $5C
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::LOG
            .byte $0A
            .byte $2C
            .byte $4D
            .byte $8B
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::PATH_HOR
            .byte $80, $28
            .byte $7A, $2C

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOSSIZE_0::PATH
            .byte $65, $8B
            .dbyt OBJ_SUBPOSSIZE_0::PATH_RIGHT
            .byte $74, $42
            .dbyt OBJ_SUBPOSSIZE_0::PATH_OPEN
            .byte $75, $41
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $A2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $BD
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $BF
            .byte $CF
            .dbyt OBJ_SUBPOS_0::SHAFT
            .byte $06
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $DF

            .byte OBJ_SCR::INC_X

            .dbyt OBJ_SUBPOSSIZE_0::PATH_DOWN
            .byte $55, $27
            .dbyt OBJ_SUBPOSSIZE_0::PATH_OPEN
            .byte $65, $17
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::LOG
            .byte $0A
            .byte $2B

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::LOG
            .byte $05
            .dbyt OBJ_SUBPOS_0::TRUNK
            .byte $19

            .byte OBJ_SCR::INC_X

            .dbyt OBJ_SUBPOSSIZE_0::PATH_OPEN
            .byte $84, $21
            .dbyt OBJ_SUBPOSSIZE_0::PATH_OPEN
            .byte $7A, $21

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOSSIZE_0::PATH_OPEN
            .byte $47, $31
        @screen_3:
            ; size
            .byte @screen_4-@screen_3-1
            ; objects
            .byte OBJ_SCR::FILL_RND
            .byte OBJ_CMD_RLE, 11
            .dbyt OBJ_SUBPOS_0::CLIFF_BOT
            .byte $10
            .byte $12
            .byte $14
            .byte $16
            .byte $18
            .byte $1A
            .byte $1C
            .byte $2E
            .byte $36
            .byte $3E
            .byte $52
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTLEFT
            .byte $50
            .byte $3C
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTRIGHT
            .byte $54
            .byte $38
            .dbyt OBJ_SUBPOSSIZE_0::PATH_LEFT
            .byte $70, $27
            .dbyt OBJ_SUBPOSSIZE_0::PATH_RIGHT
            .byte $74, $2A
            .dbyt OBJ_SUBPOSSIZE_0::PATH_HOR
            .byte $79, $2E
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BL
            .byte $20, $76
            .byte $00, $3E
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BR
            .byte $33, $56
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BOT_SIDE
            .byte $07, $3E
            .byte $1E, $34
            .byte $26, $38
            .byte $2C, $34
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TL
            .byte $92, $88
            .byte $D0, $44
            .byte $9E, $C4
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TR
            .byte $96, $44
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TOP_SIDE
            .byte $B8, $2C
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $B0
            .byte $A4
            .byte $D7
            .byte $CB

            .byte OBJ_SCR::INC_X
            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::GATE
            .byte $53
        @screen_4:
            ; size
            .byte @screen_5-@screen_4-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .byte OBJ_CMD_RLE, 23
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $00
            .byte $02
            .byte $0C
            .byte $0E
            .byte $04
            .byte $20
            .byte $22
            .byte $2E
            .byte $40
            .byte $60
            .byte $6E
            .byte $80
            .byte $8C
            .byte $A0
            .byte $AA
            .byte $AC
            .byte $B0
            .byte $BA
            .byte $BC
            .byte $D0
            .byte $DA
            .byte $DC
            .byte $DE
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $00
            .byte $02
            .byte OBJ_CMD_RLE, 14
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $06
            .byte $52
            .byte $62
            .byte $72
            .byte $82
            .byte $92
            .byte $A2
            .byte $9E
            .byte $B2
            .byte $AE
            .byte $C2
            .byte $BE
            .byte $D2
            .byte $E2
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $14
            .byte $32
            .byte $8E
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $34
            .byte $16
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $1B
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $1C
            .byte OBJ_CMD_RLE, 8
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $0B
            .byte $5F
            .byte $8B
            .byte $A9
            .byte $B9
            .byte $C9
            .byte $D9
            .byte $E9
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $3E
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT2
            .byte $9A
            .byte $7C
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT2
            .byte $CE

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $1D
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $3E
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $99
            .byte $7B
            .byte $6D
        @screen_5:
            ; size
            .byte @screen_6-@screen_5-1
            ; objects
            .byte OBJ_SCR::FILL_RND
            .byte OBJ_CMD_RLE, 21
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $00
            .byte $02
            .byte $04
            .byte $06
            .byte $08
            .byte $0A
            .byte $0C
            .byte $0E
            .byte $20
            .byte $22
            .byte $2A
            .byte $2C
            .byte $2E
            .byte $40
            .byte $42
            .byte $4E
            .byte $60
            .byte $62
            .byte $6E
            .byte $DA
            .byte $BA
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $A6
            .byte $9A
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $6D
            .byte $7D
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $8D
            .byte $AF
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT3
            .byte $72
            .byte $80
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $CC
            .byte $D0
            .byte $DC
            .byte $E0
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $C9
            .byte $D9
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT2
            .byte $EC
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT2
            .byte $E8
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $E6
            .byte $E4
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $0F

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $63
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT3
            .byte $71
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $13
            .byte $17
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $15
            .byte $19
            .byte $3B
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $3A
            .byte OBJ_CMD_RLE, 9
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $36
            .byte $46
            .byte $56
            .byte $66
            .byte $76
            .byte $86
            .byte $96
            .byte $9A
            .byte $AA
            .byte OBJ_CMD_RLE, 13
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $0F
            .byte $37
            .byte $47
            .byte $57
            .byte $67
            .byte $77
            .byte $87
            .byte $97
            .byte $9B
            .byte $AB
            .byte $33
            .byte $43
            .byte $53
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $C0
            .byte $BC
            .byte $EE
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $B9
            .byte $E3

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $4C
            .byte $8E

        @screen_6:
            ; size
            .byte @screen_7-@screen_6-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $3A
            .byte $9C
            .byte $BC
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $B8
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $C8
            .byte $42
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $40
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $C1
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $A0
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $C6
            .byte $C4
            .byte $C2

            .byte OBJ_SCR::INC_Y

            .dbyt OBJ_SUBPOS_0::TREE
            .byte $11
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTLEFT
            .byte $00
            .byte $59
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTLR
            .byte $76
            .byte OBJ_CMD_RLE, 8
            .dbyt OBJ_SUBPOS_0::CLIFF_BOT
            .byte $02
            .byte $04
            .byte $06
            .byte $08
            .byte $0A
            .byte $0C
            .byte $0E
            .byte $1E
            .dbyt OBJ_SUBPOS_0::CLIFF_BOTRIGHT
            .byte $5B
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_LEFT_SIDE
            .byte $2E, $E2
            .byte $9E, $B2
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $9C
            .byte $AC
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $9D
            .byte $AD
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $10
            .byte $84
            .byte $A8

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $20
            .byte $80
            .byte $82
            .byte $A2
            .byte $A4
            .byte $A6
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $22
            .byte $32
            .byte $60
            .byte $70
            .byte $94
            .byte $B8
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $81
            .byte $A5
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $82
            .byte $A6
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BL
            .byte $00, $2E
            .byte $0E, $24
            .byte $39, $66
            .byte $56, $62
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BR
            .byte $3C, $62
            .byte $57, $62
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BOT_SIDE
            .byte $07, $2E

        @screen_7:
            ; size
            .byte @screen_8-@screen_7-1
            ; objects
            .byte OBJ_SCR::FILL_RND
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::CLIFF_BOT
            .byte $80
            .byte $AE
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BOT_SIDE
            .byte $70, $34
            .byte $72, $2C
            .byte $88, $22
            .byte $99, $22
            .byte $AA, $28
            .byte $9E, $34
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $C0
            .byte OBJ_CMD_RLE, 8
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $00
            .byte $0A
            .byte $0C
            .byte $0E
            .byte $20
            .byte $2C
            .byte $2E
            .byte $40
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $02
            .byte $12
            .byte $22
            .byte $32
            .byte $42
            .byte $52
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $62
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $60
            .byte $3C
            .byte $3E
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $09
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $19
            .byte $3B
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $1A
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::WATER_HOR
            .byte $90, $44
            .byte $82, $4A
            .byte $BA, $4C
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TR
            .byte $A9, $22
            .byte $98, $22
            .byte $87, $22
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::WATER_OPEN
            .byte $B9, $22
            .byte $A8, $22
            .byte $97, $22
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BL
            .byte $C9, $22
            .byte $B8, $22
            .byte $A7, $22
            .dbyt OBJ_SUBPOS_0::WATERFALL
            .byte $82
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_LEFT_SIDE
            .byte $A2, $82
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TL
            .byte $E1, $22

        @screen_8:
            ; size
            .byte @screen_9-@screen_8-1
            ; objects
            .byte OBJ_SCR::FILL_RND
            .byte OBJ_CMD_RLE, 8
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $04
            .byte $06
            .byte $08
            .byte $0A
            .byte $0C
            .byte $16
            .byte $18
            .byte $1A
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $00
            .byte $0E
            .byte $10
            .byte $20
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT
            .byte $1E
            .byte $30
            .byte $3C
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_BOT
            .byte $36
            .byte $38
            .byte $3A
            .dbyt OBJ_SUBPOS_0::FOREST_BOTRIGHT2
            .byte $1C
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $13
            .byte $35
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $14
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $03
            .dbyt OBJ_SUBPOSSIZE_0::WATER_HOR
            .byte $A0, $44
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BOT_SIDE
            .byte $A2, $44
            .byte OBJ_CMD_RLE, 5
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TL
            .byte $92, $24
            .byte $84, $24
            .byte $66, $4C
            .byte $5C, $24
            .byte $4E, $24
            .byte OBJ_CMD_RLE, 5
            .dbyt OBJ_SUBPOSSIZE_0::WATER_OPEN
            .byte $94, $64
            .byte $86, $AC
            .byte $6C, $54
            .byte $5E, $A4
            .byte $AE, $A4
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BL
            .byte $C4, $24
            .byte $D6, $4C
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TOP_SIDE
            .byte $AC, $A4
            .dbyt OBJ_SUBPOS_0::WATERFALL
            .byte $A0
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_LEFT_SIDE
            .byte $C0, $62

        @screen_9:
            ; size
            .byte @screen_10-@screen_9-1
            ; objects
            .byte OBJ_SCR::FILL_RND
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TL
            .byte $20, $48
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TR
            .byte $24, $48
            .byte $48, $44
            .byte $6A, $C4
            .byte $CC, $62
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOSSIZE_0::WATER_OPEN
            .byte $40, $DA
            .byte $45, $E6
            .byte $90, $C6
            .byte $B5, $8A
            .byte $68, $A4
            .byte $CA, $64
            .dbyt OBJ_SUBPOSSIZE_0::WATER_TOP_SIDE
            .byte $C3, $64

            .dbyt OBJ_SUBPOS_0::CLIFF_BOTLEFT
            .byte $1E
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_BL
            .byte $0E, $34

            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $1C
            .byte $3E
            .byte $5E
            .byte OBJ_CMD_RLE, 10
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $1B
            .byte $2B
            .byte $7F
            .byte $8F
            .byte $9F
            .byte $AF
            .byte $BF
            .byte $CF
            .byte $DF
            .byte $EF
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT2
            .byte $3C
            .byte $5E
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $3B
            .byte $5D
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $0C
            .byte $2E

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $0D
            .byte $1D
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $0B

        @screen_10:
            ; size
            .byte @screen_11-@screen_10-1
            ; objects
            .byte OBJ_SCR::FILL_RND

        @screen_11:
            ; size
            .byte @screen_12-@screen_11-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BL
            .byte $0C, $44
            .byte $2E, $44
            .dbyt OBJ_SUBPOSSIZE_0::WATER_OPEN
            .byte $0E, $44
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TL
            .byte $D0, $48
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TR
            .byte $D4, $48
            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $DE
            .byte $DC
            .byte $DA
            .byte $D8
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $D8

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $C9
            .byte $CB
            .byte $CD
            .dbyt OBJ_SUBPOS_0::FOREST_TOPLEFT
            .byte $CF
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $D8
            .byte $E8

        @screen_12:
            ; size
            .byte @screen_13-@screen_12-1
            ; objects
            .byte OBJ_SCR::FILL_RND

            .dbyt OBJ_SUBPOSSIZE_0::WATER_BOT_SIDE
            .byte $00, $84
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BL
            .byte $42, $4A
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::WATER_BR
            .byte $37, $6A
            .byte $0C, $62
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOSSIZE_0::WATER_OPEN
            .byte $02, $8A
            .byte $07, $6A
            .byte OBJ_CMD_RLE, 6
            .dbyt OBJ_SUBPOS_0::FOREST_LEFT
            .byte $0F
            .byte $1F
            .byte $2F
            .byte $3F
            .byte $4F
            .byte $5F
            .dbyt OBJ_SUBPOS_0::FOREST_BOTLEFT
            .byte $6F
            .byte OBJ_CMD_RLE, 5
            .dbyt OBJ_SUBPOS_0::FOREST_MID
            .byte $D0
            .byte $D2
            .byte $D4
            .byte $D6
            .byte $D8
            .byte OBJ_CMD_RLE, 3
            .dbyt OBJ_SUBPOSSIZE_0::CLIFF_TL
            .byte $DA, $44
            .byte $BC, $44
            .byte $7E, $84
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $D9
            .dbyt OBJ_SUBPOS_0::TREE
            .byte $9C

            .byte OBJ_SCR::INC_Y

            .byte OBJ_CMD_RLE, 4
            .dbyt OBJ_SUBPOS_0::FOREST_TOP
            .byte $C1
            .byte $C3
            .byte $C5
            .byte $C7
            .byte OBJ_CMD_RLE, 2
            .dbyt OBJ_SUBPOS_0::FOREST_RIGHT
            .byte $D9
            .byte $E9
            .dbyt OBJ_SUBPOS_0::FOREST_TOPRIGHT
            .byte $C0

        @screen_13:
