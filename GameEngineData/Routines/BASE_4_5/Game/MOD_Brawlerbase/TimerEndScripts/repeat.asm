
    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    STA tempB

    TXA
    STA tempA

    LDA Object_frame,x
    AND #%00000111
    STA tempz
    LDA Object_animation_timer,x
    STA tempy

    DoObjectAction tempA, tempB

    STA tempz
    LDA Object_frame,x
    AND #%11111000
    ORA tempz
    STA Object_frame,x
    LDA tempy
    STA Object_animation_timer,x

