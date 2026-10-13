
    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    STA tempB

    STX tempA
    DoObjectAction tempA, tempB

