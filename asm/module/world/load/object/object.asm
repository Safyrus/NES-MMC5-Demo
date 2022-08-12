; screen_draw_obj_buf = object to draw
module_world_draw_object:
    pushreg

    ; get object type
    LDA screen_draw_obj_buf
    AND #$0F
    TAX
    ; get object flags
    LDA screen_draw_obj_buf
    LSR
    LSR
    LSR
    LSR
    TAY

    ; get function to call
    LDA @draw_fct_lo, Y
    STA tmp
    LDA @draw_fct_hi, Y
    STA tmp+1

    ; for rts call
    LDA #>(@end-1)
    PHA
    LDA #<(@end-1)
    PHA

    ; call draw function
    JMP (tmp)

    @end:
    pullreg
    RTS

    @draw_fct_lo:
    .byte <mdl_world_drw_obj_scr
    .byte <mdl_world_drw_entity_scr
    .byte <mdl_world_drw_obj_error
    .byte <mdl_world_drw_entity_error
    .byte <mdl_world_drw_obj_pos
    .byte <mdl_world_drw_entity_pos
    .byte <mdl_world_drw_obj_possize
    .byte <mdl_world_drw_entity_error
    .byte <mdl_world_drw_subobj_scr
    .byte <mdl_world_drw_subentity_scr
    .byte <mdl_world_drw_obj_error
    .byte <mdl_world_drw_entity_error
    .byte <mdl_world_drw_subobj_pos
    .byte <mdl_world_drw_subentity_pos
    .byte <mdl_world_drw_subobj_possize
    .byte <mdl_world_drw_entity_error

    @draw_fct_hi:
    .byte >mdl_world_drw_obj_scr
    .byte >mdl_world_drw_entity_scr
    .byte >mdl_world_drw_obj_error
    .byte >mdl_world_drw_entity_error
    .byte >mdl_world_drw_obj_pos
    .byte >mdl_world_drw_entity_pos
    .byte >mdl_world_drw_obj_possize
    .byte >mdl_world_drw_entity_error
    .byte >mdl_world_drw_subobj_scr
    .byte >mdl_world_drw_subentity_scr
    .byte >mdl_world_drw_obj_error
    .byte >mdl_world_drw_entity_error
    .byte >mdl_world_drw_subobj_pos
    .byte >mdl_world_drw_subentity_pos
    .byte >mdl_world_drw_subobj_possize
    .byte >mdl_world_drw_entity_error


; TODO
mdl_world_drw_obj_possize:
mdl_world_drw_subobj_scr:
mdl_world_drw_obj_error:
mdl_world_drw_entity_scr:
mdl_world_drw_entity_error:
mdl_world_drw_subentity_scr:
    RTS

;
mdl_world_subobj_cat_idx:
    ; ----------------
    ; get object subtype category
    ; ----------------
    ; get high part
    TXA
    ASL
    ASL
    STA tmp+2
    ; get low part
    LDA screen_draw_obj_buf+1
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    CLC
    ADC tmp+2
    TAX
    ; return
    RTS
