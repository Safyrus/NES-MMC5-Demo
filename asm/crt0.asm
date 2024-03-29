;****************
; Author: Safyrus
;****************

; Header of the file (not part of the cartridge, used by the emulator)
.segment "HEADER"
    ; 0-3: Identification String
    .byte "NES", $1A

    ; 4: PRG ROM size in 16KB
    .byte $04

    ; 5: CHR ROM size in 8KB
    .byte $80

    ; 6: Flags 6
    ; NNNN FTBM
    ; |||| |||+-- Hard-wired nametable mirroring type
    ; |||| |||     0: Horizontal or mapper-controlled
    ; |||| |||     1: Vertical
    ; |||| ||+--- "Battery" and other non-volatile memory
    ; |||| ||      0: Not present
    ; |||| ||      1: Present
    ; |||| |+--- 512-byte Trainer
    ; |||| |      0: Not present
    ; |||| |      1: Present between Header and PRG-ROM data
    ; |||| +---- Hard-wired four-screen mode
    ; ||||        0: No
    ; ||||        1: Yes
    ; ++++------ Mapper Number D0..D3
    .byte %01010000

    ; 7: Flags 7
    ; NNNN 10TT
    ; |||| ||++- Console type
    ; |||| ||     0: Nintendo Entertainment System/Family Computer
    ; |||| ||     1: Nintendo Vs. System
    ; |||| ||     2: Nintendo Playchoice 10
    ; |||| ||     3: Extended Console Type
    ; |||| ++--- NES 2.0 identifier
    ; ++++------ Mapper Number D4..D7
    .byte %00001000

    ; 8: Mapper MSB/Submapper
    ; SSSS NNNN
    ; |||| ++++- Mapper number D8..D11
    ; ++++------ Submapper number
    .byte %00000000

    ; 9: PRG-ROM/CHR-ROM size MSB
    ; CCCC PPPP
    ; |||| ++++- PRG-ROM size MSB
    ; ++++------ CHR-ROM size MSB
    .byte %00000000

    ; 10: PRG-RAM/EEPROM size
    ; pppp PPPP
    ; |||| ++++- PRG-RAM (volatile) shift count
    ; ++++------ PRG-NVRAM/EEPROM (non-volatile) shift count
    ; If the shift count is zero, there is no PRG-(NV)RAM.
    ; If the shift count is non-zero, the actual size is
    ; "64 << shift count" bytes, i.e. 8192 bytes for a shift count of 7.
    .byte %00001010

    ; 11: CHR-RAM size
    ; cccc CCCC
    ; |||| ++++- CHR-RAM size (volatile) shift count
    ; ++++------ CHR-NVRAM size (non-volatile) shift count
    ; 
    ; If the shift count is zero, there is no CHR-(NV)RAM.
    ; If the shift count is non-zero, the actual size is
    ; "64 << shift count" bytes, i.e. 8192 bytes for a shift count of 7.
    .byte %00000000

    ; 12: CPU/PPU Timing
    ; .... ..VV
    ;        ++- CPU/PPU timing mode
    ;             0: RP2C02 ("NTSC NES")
    ;             1: RP2C07 ("Licensed PAL NES")
    ;             2: Multiple-region
    ;             3: UMC 6527P ("Dendy")
    .byte %00000000

    ; 13: When Byte 7 AND 3 =1: Vs. System Type
    ;       MMMM PPPP
    ;       |||| ++++- Vs. PPU Type
    ;       ++++------ Vs. Hardware Type
    ;
    ;     When Byte 7 AND 3 =3: Extended Console Type
    ;       .... CCCC
    ;            ++++- Extended Console Type
    .byte %00000000

    ; 14: Miscellaneous ROMs
    ; .... ..RR
    ;        ++- Number of miscellaneous ROMs present
    .byte %00000000

    ; 15: Default Expansion Device
    ; ..DD DDDD
    ;   ++-++++- Default Expansion Device
    .byte %00000000



.include "constant.asm"
.include "macro.asm"
.include "struct.asm"
.include "memory.asm"

.segment "LOWCODE"
    ; 6502 vectors subroutines
    .include "vector/nmi.asm"
    .include "vector/rst.asm"
    .include "vector/irq.asm"
    ; MMC5 interrupt
    .include "vector/scanline.asm"

.if FAMISTUDIO=1
    ; FamiStudio Sound Engine
    .include "audio/famistudio_config.asm"
    .include "audio/famistudio_ca65.s"
.endif


.segment "STARTUP"
    .include "main.asm"
    .include "utils/joypad.asm"
    .include "utils/math.asm"
    .include "utils/operation.asm"
    .include "utils/rand.asm"
    .include "utils/scroll.asm"
    .include "utils/subroutines.asm"

.segment "BNK1"
    .include "module/world/base.asm"
.segment "BNK4"
    .include "data/object.asm"
    .include "data/entity.asm"
.segment "BNK2"
    .include "data/world_0.asm"
    .include "data/palette.asm"
.segment "BNK0"
    .include "module/control/base.asm"
    .include "module/dialog/base.asm"
    .include "data/dialog/cypher.asm"
    .include "data/dialog/dict.asm"
    .include "data/dialog/pointer.asm"


; 6502 vectors
.segment "VECTORS"
    ; 6502 vectors
    .word NMI    ; fffa nmi/vblank
    .word RST    ; fffc reset
    .word IRQ    ; fffe irq/brk


; CHR ROM data 
.segment "CHARS"
.incbin "MMC5_Demo_world.chr"
.incbin "MMC5_Demo_empty.chr"
.incbin "MMC5_Demo_ui.chr"
.incbin "MMC5_Demo_text.chr"
