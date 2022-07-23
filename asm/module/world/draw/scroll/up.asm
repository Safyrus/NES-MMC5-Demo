;
module_world_draw_up:
    pushreg
    push_scroll

    JSR inc_scroll_y_tile
    ; JSR inc_scroll_y_hi
    JSR mdl_world_drw_y

    pull_scroll
    pullreg
    RTS


