
doLoadNametableDataFull:
    TXA
    PHA
    TYA
    PHA

    SwitchBank arg0_hold
        LDA arg3_hold
        STA $2006
        LDA #$00
        STA $2006

        LDX #$04
        LDY #$00
        loadNametableLoop:
            LDA (temp16),y
            STA $2007
            INY
            BNE loadNametableLoop

            INC temp16+1
            DEX
        BNE loadNametableLoop
    ReturnBank

    PLA
    TAY
    PLA
    TAX

    RTS
