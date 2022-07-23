;
module_world_draw_down:
    pushreg
    push_scroll

    ; move scroll one screen to the bottom minus one row
    JSR inc_scroll_y_hi
    ; JSR dec_scroll_y_tile
    ; draw
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
    RTS


