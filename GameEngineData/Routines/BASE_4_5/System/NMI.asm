
NMI:

    ;; Push whatever is in the accumulator to the stack
    PHA

    ;; Check if we're in NMI already; if so, skip
    LDA doNMI
    BEQ +
        JMP +skipWholeNMI
    +

    ;; Tell game that we're in NMI
    INC doNMI

    ;; Push registers to stack
    TXA
    PHA
    TYA
    PHA
    PHP

    ;; Push RAM values to stack
    LDA currentBank
    PHA
    LDA prevBank
    PHA

    ;; Check if PPU updates must be skipped or not
    LDA skipNMI
    BEQ +
        JMP +updateNmiCounters
    +

    LDA #$00
    STA $2000
    LDA soft2001
    STA $2001

    ;; Set OAM DMA (update sprites on screen)
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    ;; Check if screen is on; if not, skip PPU updates
    LDA soft2001
    BNE +
        JMP +updateViewportScreen
    +

    ;; Reset PPU high/low latch
    BIT $2002


;checkBackgroundPaletteUpdates:
    ;; Check for background palette updates
    LDA updateScreenData
    AND #%00000001
    BNE +
        JMP +checkSpritePaletteUpdates
    +
    .include SCR_LOAD_PALETTES
    JMP +updateViewportScreen


+checkSpritePaletteUpdates:
    ;; Check for sprite palette updates
    LDA updateScreenData
    AND #%00000010
    BNE +
        JMP +checkPpuUpdates
    +
    .include SCR_LOAD_SPRITE_PALETTES
    JMP +updateViewportScreen


+checkPpuUpdates:
    ;; Check for other PPU updates
    LDA updateScreenData
    AND #%00000100
    BNE +
        JMP +updateViewportScreen
    +
    .include SCR_UPDATE_SCROLL_COLUMN


+updateViewportScreen:
    ;; Update current screen number in viewport
    LDA camY_hi
    ASL
    ASL
    ASL
    ASL
    CLC
    ADC camX_hi
    STA camScreen

    ;; Update nametable in PPUCTRL
    AND #%00000001
    ORA #%10010000
    STA $2000

    ;; Update camera offset
    ;; (only if screen is turned on)
    LDA soft2001
    BEQ +ignorePpuScroll
        LDA camX
        STA $2005
        LDA camY
        STA $2005
    +ignorePpuScroll:


+updateNmiCounters:
    INC vBlankTimer
    INC randomSeed

    ;; music player things
    SwitchBank #$1B
        JSR doSoundEngineUpdate
    ReturnBank

    ;; Pull RAM values from stack
    PLA
    STA prevBank
    PLA
    STA currentBank

    ;; Tell game that NMI is done
    DEC doNMI

    ;; Pull registers from stack
    PLP
    PLA
    TAY
    PLA
    TAX


+skipWholeNMI:
    ;; Tell game to stop waiting
    LDA #$00
    STA waiting

    ;; Pull accumulator from stack
    PLA

    ;; Return from interrupt
    RTI

