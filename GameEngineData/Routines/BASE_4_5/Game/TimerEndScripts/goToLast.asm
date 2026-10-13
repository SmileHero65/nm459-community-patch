
    LDA #$07
    STA tempB

    LDA Object_frame,x
    ORA #%00111000
    STA Object_frame,x

    STX tempA
    DoObjectAction tempA, tempB

