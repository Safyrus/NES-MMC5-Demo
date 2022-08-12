; tmp+2 = entity location in screen buffer
; Y = entity buffer index
; X = entity index
ai_dialog:
    ; if the gamestate != DIALOG
    LDA game_state
    CMP STATE::DIALOG
    BEQ @end
        ; if input A was pressed
        LDA buttons_1_timer
        BNE @end
        JSR readjoy
        LDA buttons_1
        AND #INPUT::_A
        BEQ @end
            ; get hi pos of player
            STX tmp+5
            JSR get_player_global_entity_index
            LDA global_entity_buffer_pos_hi, X
            ; if hi pos of ourself == hi pos of player
            CMP entity_buffer_hi_pos, Y
            BNE @end
                ;
                STY tmp+4
                LDY #$00
                LDA #$FF
                JSR add_tmp2
                LDA #$41
                JSR add_tmp2
                ; if player x pos == our x pos
                LDA (tmp+2), Y
                CMP global_entity_buffer_pos_x, X
                BNE @end
                    ;
                    LDA #$40
                    JSR add_tmp2
                    ; if player y pos == our y pos
                    LDA (tmp+2), Y
                    CMP global_entity_buffer_pos_y, X
                    BNE @end
                        LDA game_state
                        CMP #STATE::DIALOG
                        BEQ @end
                            LDA #STATE::DIALOG
                            STA game_state
                            LDA #$00
                            STA game_substate
                            JMP setup_dialog
    @end:
    RTS


; setup the dialog
setup_dialog:
    ; get first entity buffer adr
    LDX tmp+4
    LDA #>entity_buffers
    STA tmp+1
    LDA #<entity_buffers
    STA tmp+0
    ; entity buffer idx * entity buffer size
    @mul:
        CPX #$00
        BEQ @mul_end
        DEX
        LDA tmp+1
        CLC
        ADC #$02
        STA tmp+1
        LDA #$80
        JSR add_tmp
        JMP @mul
    @mul_end:
    LDA tmp+5
    JSR add_tmp
    ; add offset
    LDA #$FF
    JSR add_tmp
    LDA #$C1
    JSR add_tmp
    ; get data adr bnk
    LDA (tmp), Y
    STA last_frame_BNK+3
    STA MMC5_PRG_BNK2
    ; get data adr low
    LDA #$40
    JSR add_tmp
    LDA (tmp), Y
    STA tmp+2
    ; get data adr high
    LDA #$40
    JSR add_tmp
    LDA (tmp), Y
    AND #$1F
    ORA #$C0
    STA tmp+3
    ; get dialog index
    LDA #$04
    JSR add_tmp2
    LDA (tmp+2), Y
    TAX
    ; setup the dialog adr
    LDA dialog_table_hi, X
    STA dialog_data_idx+0
    LDA dialog_table_lo, X
    STA dialog_data_idx+1
    LDA dialog_table_offset, X
    STA dialog_data_bit_offset
    ; setup the other variables
    LDA #$00
    STA dialog_last_char
    LDA #(PPU_RD_BUF_SIZE-1)
    STA dialog_buf_data_idx
    LDA #$08
    STA dialog_nl_offset
    LDA #$03
    STA dialog_speed

    RTS
