



valueAddLoop:
    ;; the accumulator holds how much to add by.
    ;; x holds what place is being added to.
    CLC
    ADC value,x
    CMP #$0A
    BCC +skipCarryDecValue
        SEC
        SBC #$0A
        STA value,x

        INX
        CPX #$08 ;; how many 'places' the value has
        BCS +overflowThisNumber

        LDA #$01
        JMP valueAddLoop
    +skipCarryDecValue:

    STA value,x

+overflowThisNumber:
    RTS


valueSubLoop:
    ;; temp holds the value to subtract.
    LDA value,x
    SEC
    SBC temp
    ;CMP #$00
    BPL +skipCarryIncValue
        CLC
        ADC #$0A
        STA value,x

        INX
        CPX #$08 ;; how many 'places' the value has
        BCS +underflowThisNumber

        LDA #$01
        STA temp
        JMP valueSubLoop
    +skipCarryIncValue:

    STA value,x

+underflowThisNumber:
    RTS

