
    ;; Choose out of 8 directions
    TXA
    STA tempA

    JSR doGetRandomNumber
    AND #%00000111
    TAY

    LDA DirectionTable,y
    STA tempB

    LDA FacingTable,y
    STA tempC

    StartMoving tempA, tempB, #$00
    ChangeFacingDirection tempA, tempC

