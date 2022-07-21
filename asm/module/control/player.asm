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
    ;
    STA tmp
    ;
    LDA game_framecount+1
    AND #$08
    LSR
    ORA tmp
    STA MMC5_MUL_A
    ;
    LDA global_entity_buffer_spr_nb, X
    TAY
    STA MMC5_MUL_B
    ;
    LDA MMC5_MUL_A
    ASL
    STA tmp

    ;
    LDA #$00
    @find_global_idx:
        CPX #$00
        BEQ @find_global_idx_end
        DEX

        CLC
        ADC global_entity_buffer_spr_nb, X

        JMP @find_global_idx
    @find_global_idx_end:
    TAX

    ;
    LDA global_entity_buffer_spr, X
    AND #%11000001
    CLC
    ADC tmp
    STA tmp

    ;
    @draw:
        LDA tmp
        STA global_entity_buffer_spr, X
        CLC
        ADC #$02
        STA tmp

        ;
        TXA
        AND #$01
        BNE @no_flip
        @flip:
            LDA game_framecount+1
            AND #$10
            ASL
            ASL
            STA tmp+1
            JMP @flip_end
        @no_flip:
            LDA #$00
            STA tmp+1
        @flip_end:

        LDA global_entity_buffer_atr, X
        AND #%10111111
        ORA tmp+1
        STA global_entity_buffer_atr, X

        INX
        DEY
        BNE @draw

    RTS

