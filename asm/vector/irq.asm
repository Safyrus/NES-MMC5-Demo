;***********
; IRQ vector
;***********


IRQ:
    ; save register
    PHA

    ; clear APU interrupt
    LDA APU_STATUS
    AND #$40
    BEQ @apu_irq_end
    @apu_irq:
        JMP @end
    @apu_irq_end:

    ; clear scanline interrupt
    LDA MMC5_SCNL_STAT
    AND #$80
    BEQ @scanline_irq_end
    @scanline_irq:
        JMP scanline_irq_handler
    @scanline_irq_end:

    @end:
    ; restore register
    PLA
    ; return
    RTI
