;
module_world_draw_left:
    pushreg
    push_scroll

    ; move scroll one column to the right
    JSR inc_scroll_x_tile
    ; draw
    JSR mdl_world_drw_x

    pull_scroll
    pullreg
    RTS


