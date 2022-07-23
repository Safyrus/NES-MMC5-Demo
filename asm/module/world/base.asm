.define WORLD_DATA_START_ADDR $A000

; --------
; Draw
; --------
; general
.include "draw/anim.asm"
.include "draw/screen.asm"
.include "draw/sprite.asm"

; scroll
.include "draw/scroll/down.asm"
.include "draw/scroll/left.asm"
.include "draw/scroll/right.asm"
.include "draw/scroll/up.asm"
.include "draw/scroll/utils.asm"

; --------
; Load
; --------

.include "load/level.asm"
.include "load/one.asm"
.include "load/screens_all.asm"
.include "load/screens.asm"
.include "load/utils.asm"

; objects
.include "load/object/entity_pos.asm"
.include "load/object/object.asm"
.include "load/object/object_scr.asm"
.include "load/object/object_pos.asm"
.include "load/object/object_possize.asm"

; --------
; other
; --------

.include "utils.asm"
