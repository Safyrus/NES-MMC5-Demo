;**********
; Constants
;**********

; Replace the value with the name of your CHR file
.define GAME_CHR "MMC5_Demo.chr"



;----------
; PPU
;----------
PPU_CTRL   := $2000
PPU_MASK   := $2001
PPU_STATUS := $2002
PPU_SCROLL := $2005
PPU_ADDR   := $2006
PPU_DATA   := $2007

; PPU MASK
PPU_MASK_GREY = %00000001
PPU_MASK_BKG8 = %00000010
PPU_MASK_SPR8 = %00000100
PPU_MASK_BKG  = %00001000
PPU_MASK_SPR  = %00010000
PPU_MASK_R    = %00100000
PPU_MASK_G    = %01000000
PPU_MASK_B    = %10000000

; PPU CTRL
PPU_CTRL_NM_1     = %00000001
PPU_CTRL_NM_2     = %00000010
PPU_CTRL_INC      = %00000100
PPU_CTRL_SPR      = %00001000
PPU_CTRL_BKG      = %00010000
PPU_CTRL_SPR_SIZE = %00100000
PPU_CTRL_SEL      = %01000000
PPU_CTRL_NMI      = %10000000



;----------
; APU
;----------
APU := $4000

APU_SQ1_VOL   := $4000
APU_SQ1_SWEEP := $4001
APU_SQ1_LO    := $4002
APU_SQ1_HI    := $4003

APU_SQ2_VOL   := $4004
APU_SQ2_SWEEP := $4005
APU_SQ2_LO    := $4006
APU_SQ2_HI    := $4007

APU_TRI_LINEAR := $4008
APU_TRI_LO     := $400A
APU_TRI_HI     := $400B

APU_NOISE_VOL := $400C
APU_NOISE_LO  := $400E
APU_NOISE_HI  := $400F

APU_DMC_FREQ  := $4010
APU_DMC_RAW   := $4011
APU_DMC_START := $4012
APU_DMC_LEN   := $4013

APU_SND_CHN := $4015
APU_CTRL    := $4015
APU_STATUS  := $4015
APU_FRAME   := $4017



;----------
; OAM
;----------
OAMDMA := $4014



;----------
; IO
;----------
IO_JOY1 := $4016
IO_JOY2 := $4017


;----------
; NMI
;----------
NMI_DONE = %10000000
NMI_MAIN = %01000000
NMI_SCRL = %00010000
NMI_PLT  = %00001000
NMI_ATR  = %00000100
NMI_SPR  = %00000010
NMI_BKG  = %00000001


;----------
; MMC5
;----------
.ifdef MMC5
; PRG Mode
MMC5_PRG_MODE  := $5100
; CHR Mode
MMC5_CHR_MODE  := $5101
; RAM protection
MMC5_RAM_PRO1  := $5102
MMC5_RAM_PRO2  := $5103
; Extended RAM mode
MMC5_EXT_RAM   := $5104
; Nametable mapping
MMC5_NAMETABLE := $5105
; Fill nametable
MMC5_FILL_TILE := $5106
MMC5_FILL_COL  := $5107
; RAM Bank
MMC5_RAM_BNK   := $5113
; PRG Banks
MMC5_PRG_BNK0  := $5114
MMC5_PRG_BNK1  := $5115
MMC5_PRG_BNK2  := $5116
MMC5_PRG_BNK3  := $5117
; CHR Banks
MMC5_CHR_BNK0  := $5120
MMC5_CHR_BNK1  := $5121
MMC5_CHR_BNK2  := $5122
MMC5_CHR_BNK3  := $5123
MMC5_CHR_BNK4  := $5124
MMC5_CHR_BNK5  := $5125
MMC5_CHR_BNK6  := $5126
MMC5_CHR_BNK7  := $5127
MMC5_CHR_BNK8  := $5128
MMC5_CHR_BNK9  := $5129
MMC5_CHR_BNKA  := $512A
MMC5_CHR_BNKB  := $512B
MMC5_CHR_UPPER := $5130
; Vertical Split
MMC5_SPLT_MODE := $5200
MMC5_SPLT_SCRL := $5201
MMC5_SPLT_BNK  := $5202
; IRQ Scanline counter
MMC5_SCNL_VAL  := $5203
MMC5_SCNL_STAT := $5204
; Unsigned 8x8 to 16 Multiplier
MMC5_MUL_A     := $5205
MMC5_MUL_B     := $5206
; Expansion RAM
MMC5_EXP_RAM   := $5C00
; RAM
MMC5_RAM       := $6000
.endif


;----------
; Game
;----------
.define HIGHER_MODULE_SIZE  2
.define LOWER_MODULE_SIZE  4
.define LOWER_MODULE_MAX_PRIO  3

.define MODULE_CTRL  0+$80
.define MODULE_WORLD 1+$80

.define WORLD_BANK_START 2

.define NB_PRGRAM_BNK 1

.define OBJ_BANK 4+$80

.enum STATE
    START
    WAIT
    DRAW_SCREEN
    DRAW_SCREEN_WAIT
    LOAD_SCR_ALL
    NORMAL
.endenum

.define BTN_TIMER 0

.enum DIR
    UP
    DOWN
    LEFT
    RIGHT
.endenum

.define PRGRAM_LEVEL_BANK 0
.define PRGRAM_SCREEN_BANK 1

.define SCR_UPD_SCR_X_R $A0
.define SCR_UPD_SCR_X_L $61
.define SCR_UPD_SCR_Y_D $90
.define SCR_UPD_SCR_Y_U $70

.define NAMETABLE_SCROLL %00000000
.define NAMETABLE_FILL %11111111

.define ANIM_BASE_SPD_MASK %00001111
.define ANIM_MAX_FRAME_MASK %00000011
