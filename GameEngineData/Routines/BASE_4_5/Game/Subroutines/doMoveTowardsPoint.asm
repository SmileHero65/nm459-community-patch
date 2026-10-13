
doMoveTowardsPoint:
    LDA arg0_hold
    SBC arg1_hold
    BCS +
        EOR #$ff
    +

    TAX
    ROL octant

    LDA arg2_hold
    SBC arg3_hold
    BCS +
        EOR #$ff
    +

    TAY
    ROL octant

    LDA log2_tab,x
    SBC log2_tab,y
    BCC +
        EOR #$ff
    +
    TAX

    LDA octant
    ROL
    AND #%111
    TAY

    LDA atan_tab,x
    EOR octant_adjust,y

    ;; now, loaded into a should be a value between 0 and 255
    ;; this is the 'angle' towards the player from the object calling it
    TAY

    LDA AngleToHVelLo,y
    SEC
    SBC #$80
    STA tempA

    LDA AngleToVVelLo,y
    CLC
    ADC #$80
    STA tempB

    RTS

