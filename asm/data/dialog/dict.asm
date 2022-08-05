dict:
    ; 'WORLD' at idx:0x0 (appear 2 times)
    .byte 5 ; size
    .byte $20, $18, $1B, $15, $0D
    ; 'HELLO' at idx:0x1 (appear 1 times)
    .byte 5 ; size
    .byte $11, $0E, $15, $15, $18
    ; 'THIS' at idx:0x2 (appear 1 times)
    .byte 4 ; size
    .byte $1D, $11, $12, $1C
    ; 'DIALOG' at idx:0x3 (appear 1 times)
    .byte 6 ; size
    .byte $0D, $12, $0A, $15, $18, $10
    ; 'WITH' at idx:0x4 (appear 1 times)
    .byte 4 ; size
    .byte $20, $12, $1D, $11
    ; 'MULTIPLE' at idx:0x5 (appear 1 times)
    .byte 8 ; size
    .byte $16, $1E, $15, $1D, $12, $19, $15, $0E
    ; 'LINES' at idx:0x6 (appear 1 times)
    .byte 5 ; size
    .byte $15, $12, $17, $0E, $1C
    ; 'TEXT' at idx:0x7 (appear 1 times)
    .byte 4 ; size
    .byte $1D, $0E, $21, $1D
ldict: ; empty

ldict_table_lo:
ldict_table_hi:
