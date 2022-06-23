
world_0:
    @screen_address:
    .word @screens

    @levels:
        @level_0:
        ; height, width
        .byte (5<<4) + 5

        ; colors
        .byte %10000000
        .byte %01101000
        .byte %10001101
        .byte %10101100
        .byte %11001001
        .byte %00000111
        .byte %00001110
        .byte %00011100

        ; level screens
        .byte 0 , 6 , 6 , 2 , 4
        .byte 5 , 1 , 7 , 8 , 9
        .byte 10, 11, 12, 13, 14
        .byte 15, 16, 17, 18, 19
        .byte 20, 21, 22, 23, 24

    @screens:
        @screen_0:
            ; size
            .byte 1
            ; obj 0
            .byte %00000001
        @screen_1:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $77
        @screen_2:
            ; size
            .byte 5
            ; obj 0
            .byte %00000000
            ; obj 1
            .byte %01000000, $22
            ; obj 2
            .byte %01000000, $AA
        @screen_3:
            ; size
            .byte 7
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $12
            ; obj 2
            .byte %01000000, $47
            ; obj 3
            .byte %01000000, $A1
        @screen_4:
            ; size
            .byte 9
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $22
            ; obj 2
            .byte %01000000, $2A
            ; obj 3
            .byte %01000000, $A2
            ; obj 4
            .byte %01000000, $AA
        @screen_5:
            ; size
            .byte 11
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $22
            ; obj 2
            .byte %01000000, $2A
            ; obj 3
            .byte %01000000, $A2
            ; obj 4
            .byte %01000000, $AA
            ; obj 5
            .byte %01000000, $77
        @screen_6:
            ; size
            .byte (2*28)+1
            ; objects
            .byte %00000001
            .byte OBJ_POS::TREE, $31
            .byte OBJ_POS::TREE, $52
            .byte OBJ_POS::TREE, $AE
            .byte OBJ_POS::TREE, $89
            .byte OBJ_POS::TREE, $83
            .byte OBJ_POS::TREE, $85
            .byte OBJ_POS::TREE, $A5
            .byte OBJ_POS::TREE, $70
            .byte OBJ_POS::TREE, $91
            .byte OBJ_POS::TREE, $D3
            .byte OBJ_POS::TREE, $E5
            .byte OBJ_POS::TREE, $ED
            .byte OBJ_POS::TALL_BUSH, $38
            .byte OBJ_POS::TALL_BUSH, $3A
            .byte OBJ_POS::TALL_BUSH, $58
            .byte OBJ_POS::TALL_BUSH, $5A
            .byte OBJ_POS::BUSH, $B8
            .byte OBJ_POS::BUSH, $2C
            .byte OBJ_POS::BUSH, $35
            .byte OBJ_POS::FOREST_TOP, $C0
            .byte OBJ_POS::FOREST_TOP, $C2
            .byte OBJ_POS::FOREST_TOP, $DE
            .byte OBJ_POS::FOREST, $D0
            .byte OBJ_POS::FOREST, $D2
            .byte OBJ_POS::FOREST, $E0
            .byte OBJ_POS::FOREST, $E2
            .byte OBJ_POS::FOREST, $E4
            .byte OBJ_POS::FOREST, $EE
        @screen_7:
            ; size
            .byte 7
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $67
            ; obj 2
            .byte %01000000, $87
            ; obj 3
            .byte %01000000, $A7
        @screen_8:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
        @screen_9:
            ; size
            .byte 5
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $A7
        @screen_10:
            ; size
            .byte 5
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $87
        @screen_11:
            ; size
            .byte 7
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $87
            ; obj 3
            .byte %01000000, $A7
        @screen_12:
            ; size
            .byte 5
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $67
        @screen_13:
            ; size
            .byte 7
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $67
            ; obj 3
            .byte %01000000, $A7
        @screen_14:
            ; size
            .byte 7
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $67
            ; obj 3
            .byte %01000000, $87
        @screen_15:
            ; size
            .byte 9
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $47
            ; obj 2
            .byte %01000000, $67
            ; obj 3
            .byte %01000000, $87
            ; obj 4
            .byte %01000000, $A7
        @screen_16:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $26
        @screen_17:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $27
        @screen_18:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $28
        @screen_19:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $29
        @screen_20:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $C2
        @screen_21:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $31
        @screen_22:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $32
        @screen_23:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $33
        @screen_24:
            ; size
            .byte 3
            ; obj 0
            .byte %00000001
            ; obj 1
            .byte %01000000, $DD
