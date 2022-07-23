;
module_world_draw_right:
    pushreg
    push_scroll

    ; move scroll one screen to the right
    JSR inc_scroll_x_hi
    ; draw
    JSR mdl_world_drw_x

    pull_scroll
    pullreg
    RTS


