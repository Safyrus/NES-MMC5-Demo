.enum OBJ_SCR
    FILL
    FILL_RND
    INC_X
    INC_Y
.endenum

object_screen_lo:
    .byte <object_screen_0
    .byte <object_screen_1
    .byte <object_screen_2
    .byte <object_screen_3
    .byte <object_screen_4
    .byte <object_screen_5
    .byte <object_screen_6
    .byte <object_screen_7
    .byte <object_screen_8
    .byte <object_screen_9
    .byte <object_screen_A
    .byte <object_screen_B
    .byte <object_screen_C
    .byte <object_screen_D
    .byte <object_screen_E
    .byte <object_screen_F
object_screen_hi:
    .byte >object_screen_0
    .byte >object_screen_1
    .byte >object_screen_2
    .byte >object_screen_3
    .byte >object_screen_4
    .byte >object_screen_5
    .byte >object_screen_6
    .byte >object_screen_7
    .byte >object_screen_8
    .byte >object_screen_9
    .byte >object_screen_A
    .byte >object_screen_B
    .byte >object_screen_C
    .byte >object_screen_D
    .byte >object_screen_E
    .byte >object_screen_F


object_screen_0:
    ; mode
    .byte 1
    ; data
    .byte 0
    .byte 1+$00
object_screen_1:
    ; mode
    .byte 2
    ; random chance
    .byte $80
    ; max random
    .byte 7
    ; data
    .byte 0
    .byte 32+$00
object_screen_2:
    .byte 3
object_screen_3:
    .byte 4
object_screen_4:
object_screen_5:
object_screen_6:
object_screen_7:
object_screen_8:
object_screen_9:
object_screen_A:
object_screen_B:
object_screen_C:
object_screen_D:
object_screen_E:
object_screen_F:
    .byte 0
