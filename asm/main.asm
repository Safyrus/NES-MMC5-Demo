;**********
; Main
;**********

MAIN:
    ; ----------------------------------------
    ; INIT
    ; ----------------------------------------
    main_init:
    ; enable ppu background
    LDA #(PPU_MASK_BKG)
    STA PPU_MASK


    ; ----------------------------------------
    ; LOOP
    ; ----------------------------------------
    main_loop:
    ; wait for the NMI to activate and finish
    @wait_vblank:
        LDA nmi_flags
        BPL @wait_vblank

    ; acknowledge the NMI
    AND #($ff-NMI_DONE)
    STA nmi_flags

    ; increase framecount
    LDX game_framecount+1
    INX
    STX game_framecount+1
    BNE @framecount_end
        LDX game_framecount+0
        INX
        STX game_framecount+0
    @framecount_end:

    ; update ppu scroll for next frame
    LDA game_scroll_x+1
    STA scroll_x
    LDA game_scroll_y+1
    STA scroll_y
    LDA game_scroll_x+0
    AND #$01
    STA tmp
    LDA ppu_ctrl_val
    AND #$FE
    ORA tmp
    STA ppu_ctrl_val
    LDA game_scroll_y+0
    AND #$01
    ASL
    STA tmp
    LDA ppu_ctrl_val
    AND #$FD
    ORA tmp
    STA ppu_ctrl_val

    ; ----------------
    ; run higher modules
    ; ----------------
    ; setup loop
    LDA #$00
    PHA
    @run_higher_modules:
        ; for module return
        NOP
        pull_x
        ; if it is the end of the array
        CPX #HIGHER_MODULE_SIZE*4
        ; then end the loop
        BEQ @run_higher_modules_end

        ; check if the module is not empty
        LDA higher_module_array, X
        BNE @run_higher_modules_next
            INX
            INX
            INX
            INX
            push_x
            JMP @run_higher_modules
        @run_higher_modules_next:
        INX
        ; load the module bank in the first bank space
        STA MMC5_PRG_BNK0
        ; load the module pointer
        LDA higher_module_array, X
        INX
        STA tmp
        LDA higher_module_array, X
        INX
        STA tmp+1
        ; padding
        INX

        ; run the module
        push_x
        LDA #>@run_higher_modules
        PHA
        LDA #<@run_higher_modules
        PHA
        JMP (tmp)
    @run_higher_modules_end:


    ; ----------------
    ; handle last frame adresse and state
    ; ----------------
    ; return to last frame module if it has not finished its task
    LDA game_flag
    AND #$01
    BEQ @lastframe_ok
    @lastframe_lag:
        LDX last_frame_prio_idx
        BEQ @lastframe_lag_new
        DEX
        LDA last_frame_prio_arr, X
        CMP lower_module_prio
        BEQ @lastframe_lag_same
        INX

        @lastframe_lag_new:
            ;
            LDA lower_module_prio
            STA last_frame_prio_arr, X
            INX
            STX last_frame_prio_idx
        @lastframe_lag_same:
            JMP @set_work_flag
    @lastframe_ok:
        TSX
        CPX #$FF
        BEQ @set_work_flag
        ; remove last adr from the stack
        LDX #$12
        @lastframe_ok_loop:
            PLA
            DEX
            BNE @lastframe_ok_loop
    @set_work_flag:
    ; set working flag
    LDA #$01
    ORA game_flag
    STA game_flag

    ; ----------------
    ; run lower modules
    ; ----------------
    @run_lower_modules:
        JSR find_next_module
        LDA tmp+2
        BNE @run_lower_modules_next
        JMP @run_lower_modules_end

        @run_lower_modules_next:
        LDX last_frame_prio_idx
        BEQ @run_lower_modules_exec
            DEX
            LDA last_frame_prio_arr, X
            CMP tmp+2
            BCC @run_lower_modules_exec
                LDA tmp+2
                STA lower_module_prio
                ; restore BNK
                LDX #$00
                @lastframe_bnk:
                    PLA
                    STA MMC5_RAM_BNK, X
                    STA last_frame_BNK, X
                    INX
                    CPX #$04
                    BNE @lastframe_bnk
                ; restore tmp variables
                LDX #$00
                @lastframe_tmp:
                    PLA
                    STA tmp, X
                    INX
                    CPX #$08
                    BNE @lastframe_tmp
                ; force the nmi end to jump to main loop
                LDA nmi_flags
                ORA #NMI_MAIN
                STA nmi_flags
                ; restore registers
                pullreg
                ; return to module
                RTI

        @run_lower_modules_exec:
        LDA tmp+2
        STA lower_module_prio
        ; index * 4 (because module size in array)
        TYA
        ASL
        ASL
        TAY

        ; load the module bank in the first bank space
        LDA lower_module_array, Y
        INY
        STA MMC5_PRG_BNK0
        STA last_frame_BNK+1
        ; load the module pointer
        LDA lower_module_array, Y
        INY
        STA tmp
        LDA lower_module_array, Y
        STA tmp+1

        ; push y/4 (module size)
        TYA
        LSR
        LSR
        PHA
        ; run the module
        LDA #>(@lower_modules_finish-1)
        PHA
        LDA #<(@lower_modules_finish-1)
        PHA
        ; force the nmi end to jump to main loop
        LDA nmi_flags
        ORA #NMI_MAIN
        STA nmi_flags
        JMP (tmp)
        ; for module return
        @lower_modules_finish:
        ; the nmi can return as normal
        LDA nmi_flags
        AND #($FF-NMI_MAIN)
        STA nmi_flags
        ; pull y
        PLA
        TAY
        ; remove module from priority array
        LDA #$00
        STA lower_module_array_prio, Y

        ; check if module lagged
        LDX last_frame_prio_idx
        BEQ @run_lower_modules_jmp
        DEX
        LDA last_frame_prio_arr, X
        CMP lower_module_prio
        BNE @run_lower_modules_jmp
        ; it is the one that lagged
        LDA #$00
        STA last_frame_prio_arr, X
        STX last_frame_prio_idx
        @run_lower_modules_jmp:
        JMP @run_lower_modules
    @run_lower_modules_end:

    ; unset working flag
    LDA #$FE
    AND game_flag
    STA game_flag

    ; loop
    JMP main_loop


find_next_module:
    ; find the module with the highest priority
    LDA #<lower_module_array_prio
    STA tmp+0
    LDA #>lower_module_array_prio
    STA tmp+1
    LDY #LOWER_MODULE_SIZE-1
    JSR max_arr
    ; end
    RTS
