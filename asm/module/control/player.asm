; X = global entity index of player
; return in tmp
get_player_pos_x:
    PHA

    LDA global_entity_buffer_pos_x, X
    STA tmp
    LDA global_entity_buffer_pos_hi, X
    AND #$0F
    STA tmp+1

    PLA
    RTS

; X = global entity index of player
; tmp = new pos
set_player_pos_x:
    PHA

    LDA tmp
    STA global_entity_buffer_pos_x, X
    LDA global_entity_buffer_pos_hi, X
    AND #$F0
    CLC
    ADC tmp+1
    STA global_entity_buffer_pos_hi, X

    PLA
    RTS

; X = global entity index of player
; return in tmp
get_player_pos_y:
    PHA

    LDA global_entity_buffer_pos_y, X
    STA tmp
    LDA global_entity_buffer_pos_hi, X
    LSR
    LSR
    LSR
    LSR
    STA tmp+1

    PLA
    RTS

; X = global entity index of player
; tmp = new pos
; affect tmp
set_player_pos_y:
    PHA

    LDA tmp
    STA global_entity_buffer_pos_y, X
    LDA tmp+1
    ASL
    ASL
    ASL
    ASL
    STA tmp+1
    LDA global_entity_buffer_pos_hi, X
    AND #$0F
    CLC
    ADC tmp+1
    STA global_entity_buffer_pos_hi, X

    PLA
    RTS


; A = anim index
; X = global entity index of player
draw_player_move:
    ; store anim index
    STA tmp+2
    pushreg

    ;
    LDA global_entity_buffer_data_bnk, X
    STA last_frame_BNK+3
    STA MMC5_PRG_BNK2
    LDA global_entity_buffer_data_hi, X
    AND #$1F
    ORA #$C0
    STA tmp+1
    LDA global_entity_buffer_data_lo, X
    STA tmp+0
    ; get player sprite number
    LDA #$04
    JSR add_tmp
    LDY #$00
    LDA (tmp), Y
    STA tmp+3

    ; load player sprite index
    LDA global_entity_buffer_draw_idx, X
    ; is player sprites reserved ?
    BNE @draw
        ; get sprite index
        LDA free_sprite_idx
        STA global_entity_buffer_draw_idx, X
        ; sprite index += player sprite number
        LDA tmp+3
        CLC
        ADC free_sprite_idx
        STA free_sprite_idx
        ; sprite_number += player sprite number
        LDA tmp+3
        CLC
        ADC sprite_number
        STA sprite_number
        ; load player sprite index
        LDA global_entity_buffer_draw_idx, X

    @draw:
    ; get sprite idx anim offset
    ; anim idx += (framecount & 8) >> 1
    LDA game_framecount+1
    AND #$08
    LSR
    ORA tmp+2
    ; anim idx * player sprite number
    STA MMC5_MUL_A
    LDA tmp+3
    STA MMC5_MUL_B
    ; sprite start idx
    LDA MMC5_MUL_A
    ASL
    STA tmp+2
    INY
    LDA (tmp), Y
    CLC
    ADC tmp+2

    ;
    LDA global_entity_buffer_draw_idx, X
    TAY
    LDA #$02
    JSR add_tmp
    @loop:
        ; set high position
        LDA global_entity_buffer_pos_hi, X
        STA entity_draw_pos_hi, Y

        ; set sprite
        LDA tmp+2
        STA entity_draw_spr, Y
        CLC
        ADC #$02
        STA tmp+2

        ; get sprite offset
        STY tmp+4
        LDY #$00
        LDA (tmp), Y
        JSR inc_tmp
        LDY tmp+4
        STA tmp+4

        ; set x position
        AND #$0F
        CMP #$08
        BCS @x_sub
        @x_add:
            ADC global_entity_buffer_pos_x, X
            JMP @x
        @x_sub:
            ORA #$F0
            CLC
            ADC global_entity_buffer_pos_x, X
        @x:
        STA entity_draw_pos_x, Y
        ; set y position
        LDA tmp+4
        LSR
        LSR
        LSR
        LSR
        CMP #$08
        BCS @y_sub
        @y_add:
            ADC global_entity_buffer_pos_y, X
            CMP #$F0
            BCC @set_yadd
            @set_yadd_plus:
                SBC #$F0
                STA entity_draw_pos_y, Y
                JMP @y_end
            @set_yadd:
                STA entity_draw_pos_y, Y
            JMP @y_end
        @y_sub:
            ORA #$F0
            CLC
            ADC global_entity_buffer_pos_y, X
            CMP #$F0
            BCC @set_ysub
            @set_ysub_plus:
                SBC #$10
                STA entity_draw_pos_y, Y
                LDA entity_draw_pos_hi, Y
                SEC
                SBC #$10
                STA entity_draw_pos_hi, Y
                JMP @y_end
            @set_ysub:
                STA entity_draw_pos_y, Y
        @y_end:

        @atr:
        ; set attribute
        STY tmp+4
        LDY #$00
        LDA (tmp), Y
        JSR inc_tmp
        LDY tmp+4
        STA entity_draw_atr, Y

        ; flip sprite if needed
        TYA
        AND #$01
        BEQ @no_flip
            LDA game_framecount+1
            AND #$10
            ASL
            ASL
            CLC
            ADC entity_draw_atr, Y
            STA entity_draw_atr, Y
        @no_flip:

        ; loop
        INY
        LDA tmp+3
        SEC
        SBC #$01
        STA tmp+3
        BEQ @loop_end
        JMP @loop
    @loop_end:

    pullreg
    RTS

setScroll2PlayerPos:
    ; get player_y_hi
    LDA global_entity_buffer_pos_hi, X
    LSR
    LSR
    LSR
    LSR
    ; set game_scroll_y to player_y
    STA game_scroll_y+0
    LDA global_entity_buffer_pos_y, X
    STA game_scroll_y+1
    ; get player_x_hi
    LDA global_entity_buffer_pos_hi, X
    AND #$0F
    ; set game_scroll_x to player_x
    STA game_scroll_x+0
    LDA global_entity_buffer_pos_x, X
    STA game_scroll_x+1

    RTS
