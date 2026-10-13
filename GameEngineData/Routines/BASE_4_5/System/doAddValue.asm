
doAddValue:

    TXA
    PHA

    ;arg0 = how many places this value has.
    ;arg1 = home variable
    ;arg2 = amount to add
    ;arg3 = to what place?

    LDX arg0_hold ;; How many places this value has
    -
        LDA arg1_hold,x ;; The variable that you want to push
        STA value,x
        DEX
    BPL -

    LDX arg3_hold ;; Sets the place to push
    LDA arg2_hold
    JSR valueAddLoop ;; Will add what is in accumulator
    
    ;; Now value needs to be unpacked back into the variable.

    LDX arg0_hold
    -
        LDA value,x ;; The variable that you want to push
        STA arg1_hold,x
        DEX
    BPL -

    PLA
    TAX
    RTS


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

