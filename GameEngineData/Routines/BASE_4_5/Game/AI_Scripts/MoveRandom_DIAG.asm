
    ;; Choose out of 4 diagonals
    TXA
    STA tempA

    JSR doGetRandomNumber
    AND #%00000011
    CLC
    ADC #$04
    TAY

    LDA DirectionTable,y
    STA tempB

    LDA FacingTable,y
    STA tempC

    StartMoving tempA, tempB, #$00
    ChangeFacingDirection tempA, tempC

