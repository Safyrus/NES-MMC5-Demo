;**********
; Memory
;**********



.segment "ZEROPAGE"

    ; NMI Flags to activate graphical update
    ; Note: You cannot activate all updates.
    ;       You need to have a execution time
    ;       < ~2273 cycles (2000 to be sure)
    ; 7  bit  0
    ; ---- ----
    ; EFRD PASB
    ; |||| ||||
    ; |||| |||+- Background tiles update
    ; |||| |||   Execution time depend on data
    ; |||| |||   (cycles ~= 16 + 38*p + for i:p do (14*p[i].n))
    ; |||| |||   (p=packet number, p[i].n = packet data size)
    ; |||| ||+-- Sprites update (513+ cycles)
    ; |||| |+--- Nametables Attributes update (821 cycles)
    ; |||| +---- Palettes update (356 cycles)
    ; |||+------ read Data from PPU.
    ; ||+------- ScRoll update (31 cycles)
    ; |+-------- Force jump to main loop when nmi end.
    ; +--------- 1 when NMI has ended, should be set to 0 after reading.
    ;            If let to 1, it means the NMI is disable
    nmi_flags: .res 1

    ; Scroll X position
    scroll_x: .res 1

    ; Scroll Y position
    scroll_y: .res 1

    ; Nametable high adress to update attributes for
    ; $23 = Nametable 1
    ; $27 = Nametable 2
    ; $2B = Nametable 3
    ; $2F = Nametable 4
    atr_nametable: .res 1
    
    ; value of the PPU_CTRL (need to be refresh manually)
    ppu_ctrl_val: .res 1

    ; number of bytes to read from PPU
    ppu_read_n: .res 1

    ; MMC5 CHR bank index to place at the last 1K bank
    ppu_read_mmc5_bnk: .res 1

    ; Palettes data to send to PPU during VBLANK
    ;   byte 0   = transparente color
    ;   byte 1-3 = background palette 1
    ;   byte 4-6 = background palette 2
    ;   ...
    ;   byte 13-16 = sprite palette 1
    ;   ...
    palettes: .res 25

    ; Attributes data to send to PPU during VBLANK
    attributes: .res 64

    ; Index for the background data
    background_index: .res 1

    ; Background data to send to PPU during VBLANK
    ; Packet structure:
    ; byte 0   = v.ssssss (v= vertical draw, s= size)
    ; byte 1-2 = ppu adress
    ; byte 3-s = tile data
    ; packet of size 0 means there is no more data to draw
    background: .res 95

    ; adress to read from PPU (hi, lo)
    ppu_read_adr: .res 2

    ; buffer to store data read from ppu
    ppu_data_buf: .res PPU_RD_BUF_SIZE

    ; nametable configuration when entering NMI
    nmi_mmc5_nametable: .res 1

    ; 8 temporary variables
    ; not reserved to overlap famistudio temporary variables
    tmp:

;****************
; OAM SEGMENT
;****************
.segment "OAM"
OAM:
    .export _OAM=OAM


;****************
; BSS SEGMENT
;****************

.segment "BSS"

    ; ----------------
    ; Module arrays
    ; ----------------
    ; list of module of higher priority
    higher_module_array:
        .tag Module
        .tag Module
    ; list of module of lower priority
    lower_module_array:
        .tag Module
        .tag Module
        .tag Module
        .tag Module
        .tag Module
        .tag Module
        .tag Module
        .tag Module
    lower_module_array_prio: .res LOWER_MODULE_SIZE
    lower_module_prio: .res 1

    ; ----------------
    ; Game variables
    ; ----------------
    ; game state
    game_state: .res 1
    ; game substate
    game_substate: .res 1
    ; scroll position for x
    game_scroll_x: .res 2
    ; scroll position for y
    game_scroll_y: .res 2
    ;
    game_flag: .res 1
    ;....UDLR
    game_scroll_flag: .res 1
    ; the number of frame elapsed
    game_framecount: .res 2

    ; ----------------
    ; Last frame variables
    ; ----------------
    ; 0: RAM, 1-3: PRG
    last_frame_BNK: .res 4
    ;
    last_frame_adr: .res 2
    ;
    last_frame_flag: .res 1
    ;
    last_frame_prio_idx: .res 1
    ;
    last_frame_prio_arr: .res LOWER_MODULE_MAX_PRIO

    ; ----------------
    ; World variables
    ; ----------------
    ; current world index
    world: .res 1
    ; current level index
    level: .res 1
    ; current level size
    level_size: .res 1
    ; current level width and height (hhhhwwww)
    level_wh: .res 1
    ; color palettes of the current level
    level_pal: .res 7


    ; ----------------
    ; Screen buffers variables
    ; ----------------
    ; value to know, for each screen buffer, if it need an update (0=no)
    scrbuf_update_array_act: .res 9
    ; screen to load each screen buffer
    scrbuf_update_array_scr: .res 9
    ;
    scrbuf_update_array_idx: .res 1
    ; 0: is updating
    ; 1: internal update check
    scrbuf_update_flag: .res 1
    ; bits 0-1: ram bank offset
    ; bits 2-3: screen buffer index
    scrbuf_index: .res 1
    ;
    scr_index: .res 1

    ; ----------------
    ; Screen variables
    ; ----------------
    ; size of the screen_objects_buffer
    screen_objbuf_size: .res 1
    ; bit 0: inc x
    ; bit 1: last obj is entity
    ; bit 5: inc y
    screen_draw_flag: .res 1
    ; byte 0: type
    ;      1: sybtype
    ;      2: pos
    ;      3: size
    screen_draw_obj_buf: .res 4
    ;
    screen_draw_subobj_possize_buf:
    ;
    screen_draw_subobj_possize_buf_lo: .res 9
    ;
    screen_draw_subobj_possize_buf_hi: .res 9

    ; ----------------
    ; Inputs
    ; ----------------
    ; joypad 1 input
    buttons_1: .res 1
    ; joypad 2 input
    buttons_2: .res 1
    ; time to wait between inputs for joypad 1
    buttons_1_timer: .res 1

    ; ----------------
    ; Sprites
    ; ----------------
    ;
    sprite_banks: .res 8
    ;
    sprite_number: .res 1
    ;
    free_sprite_idx: .res 1


    ; ----------------
    ; Dialog
    ; ----------------
    ; from where scanline - 1 to start drawing the dialog box
    dialog_scanline: .res 1
    ;
    dialog_char_buf: .res 2
    ;
    dialog_buf_data_idx: .res 1
    ; (hi, lo)
    dialog_data_idx: .res 2
    ;
    dialog_data_bit_offset: .res 1
    ;
    dialog_last_char: .res 1
    ; (hi,lo)
    dialog_ppu_adr: .res 2
    ;
    dialog_remaining_char: .res 1
    ;
    dialog_nl_offset: .res 1
    ;
    dialog_scroll_end_tmp: .res 2
    ;
    dialog_speed: .res 1
    ;
    dialog_speed_counter: .res 1
    ;
    dialog_word_size: .res 1
    ;
    dialog_word_buffer: .res 15

    ; ----------------
    ; Misc. variables
    ; ----------------
    ; a counter
    counter: .res 1
    ; seed to generate pseudo random values
    seed: .res 2
    ; some temporary variables
    var: .res 16
    ; 7: wait for scanline, cleare when scanline IRQ occured
    ; 6: in frame
    ; 0-5: scanline IRQ state
    scanline: .res 1
    ;
    anim_counter: .res 1
    ;
    mmc5_chr_hi_bits: .res 1


;****************
; MMC5 WRAM SEGMENTS
;****************

.segment "RAM0"
    ; buffer containing screens of the last loaded level
    level_screens_buffer: .res 256
    ; buffer containing objects of the last loaded screen
    screen_objects_buffer: .res 256

.segment "RAM1"
    screen_buffer_0: .res 2048
    screen_buffer_1: .res 2048
    screen_buffer_2: .res 2048

.segment "RAM2"
    screen_buffer_3: .res 2048
    screen_buffer_4: .res 2048
    screen_buffer_5: .res 2048

.segment "RAM3"
    screen_buffer_6: .res 2048
    screen_buffer_7: .res 2048
    screen_buffer_8: .res 2048

.segment "RAM4"
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf
    res_entity_buf

    entity_draw_pos_y: .res 256
    entity_draw_spr: .res 256
    entity_draw_atr: .res 256 ; bit 4 = sprite taken, bit 3 = global
    entity_draw_pos_x: .res 256
    entity_draw_pos_hi: .res 256

    global_entity_buffer_adr_bnk: .res 64
    global_entity_buffer_adr_lo: .res 64
    global_entity_buffer_adr_hi: .res 64
    global_entity_buffer_state: .res 64
    global_entity_buffer_draw_idx: .res 64
    global_entity_buffer_pos_x: .res 64
    global_entity_buffer_pos_y: .res 64
    global_entity_buffer_pos_hi: .res 64
    global_entity_buffer_data_bnk: .res 64
    global_entity_buffer_data_lo: .res 64
    global_entity_buffer_data_hi: .res 64
