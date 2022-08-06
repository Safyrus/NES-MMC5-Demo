; return in X
get_player_global_entity_index:
    PHA
    LDA #(ENTITY_POS::PLAYER & $0F) + $10
    LDX global_entity_counter
    DEX
    @loop:
        CMP global_entity_buffer_id, X
        BEQ @end
        DEX
        BPL @loop
    @end:
    PLA
    RTS

; return in tmp
get_player_pos_x:
    push_ax
    JSR get_player_global_entity_index
    LDA global_entity_buffer_pos_x, X
    STA tmp
    LDA global_entity_buffer_pos_hi, X
    AND #$0F
    STA tmp+1
    pull_ax
    RTS

; tmp = new pos
set_player_pos_x:
    push_ax
    JSR get_player_global_entity_index
    LDA tmp
    STA global_entity_buffer_pos_x, X
    LDA global_entity_buffer_pos_hi, X
    AND #$F0
    CLC
    ADC tmp+1
    STA global_entity_buffer_pos_hi, X

    pull_ax
    RTS

; return in tmp
get_player_pos_y:
    push_ax
    JSR get_player_global_entity_index
    LDA global_entity_buffer_pos_y, X
    STA tmp
    LDA global_entity_buffer_pos_hi, X
    LSR
    LSR
    LSR
    LSR
    STA tmp+1

    pull_ax
    RTS

; tmp = new pos
; affect tmp
set_player_pos_y:
    push_ax
    JSR get_player_global_entity_index
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

    pull_ax
    RTS


; A = anim index
draw_player_move:
    ; store anim index
    STA tmp+2
    pushreg
    ;
    JSR get_player_global_entity_index
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
    ;
    TAY
    ;
    LDA global_entity_buffer_pos_hi, X
    STA tmp+4
    LDA global_entity_buffer_pos_x, X
    STA tmp+5
    LDA global_entity_buffer_pos_y, X
    STA tmp+6

    ;
    TYA
    TAX
    LDY #$01
    @loop:
        ; set high position
        LDA tmp+4
        STA entity_draw_pos_hi, X

        ; set sprite
        LDA (tmp), Y
        INY
        STA tmp+7
        AND #ANIM_FLIP
        BEQ @sprite_no_anim
        @sprite_anim:
            LDA tmp+7
            AND #$3F
            CLC
            ADC tmp+2
            STA entity_draw_spr, X
            LDA game_framecount+1
            AND #$08
            LSR
            EOR #$04
            CLC
            ADC entity_draw_spr, X
            STA entity_draw_spr, X
            JMP @sprite_end
        @sprite_no_anim:
            LDA tmp+7
            AND #$3F
            CLC
            ADC tmp+2
            STA entity_draw_spr, X
        @sprite_end:

        ; set x position
        LDA (tmp), Y
        AND #$0F
        CMP #$08
        BCS @x_sub
        @x_add:
            ADC tmp+5
            JMP @x
        @x_sub:
            ORA #$F0
            CLC
            ADC tmp+5
        @x:
        STA entity_draw_pos_x, X

        ; set y position
        LDA (tmp), Y
        INY
        LSR
        LSR
        LSR
        LSR
        CMP #$08
        BCS @y_sub
        @y_add:
            ADC tmp+6
            CMP #$F0
            BCC @set_yadd
            @set_yadd_plus:
                SBC #$F0
                STA entity_draw_pos_y, X
                JMP @y_end
            @set_yadd:
                STA entity_draw_pos_y, X
            JMP @y_end
        @y_sub:
            ORA #$F0
            CLC
            ADC tmp+6
            CMP #$F0
            BCC @set_ysub
            @set_ysub_plus:
                SBC #$10
                STA entity_draw_pos_y, X
                LDA entity_draw_pos_hi, X
                SEC
                SBC #$10
                STA entity_draw_pos_hi, X
                JMP @y_end
            @set_ysub:
                STA entity_draw_pos_y, X
        @y_end:
        LDA tmp+7
        AND #ANIM_INC
        BEQ @atr
        LDA game_framecount+1
        AND #$08
        BNE @atr
            LDA entity_draw_pos_y, X
            CLC
            ADC #$01
            STA entity_draw_pos_y, X
            BCC @atr
            LDA entity_draw_pos_hi, X
            CLC
            ADC #$10
            STA entity_draw_pos_hi, X

        @atr:
        ; set attribute
        LDA (tmp), Y
        INY
        STA entity_draw_atr, X
        ;
        LDA tmp+7
        AND #ANIM_FLIP
        BEQ @next
            LDA game_framecount+1
            AND #$10
            ASL
            ASL
            ORA entity_draw_atr, X
            STA entity_draw_atr, X

    @next:
    ; loop
    INX
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
    JSR get_player_global_entity_index
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
