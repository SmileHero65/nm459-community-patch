
doBankswitchY:
    STY currentBank

    TYA
    AND #%00011111
    ORA chrRamBank
    STA $C000

    RTS

