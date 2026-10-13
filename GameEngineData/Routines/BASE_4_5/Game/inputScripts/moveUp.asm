
    STX temp ;; assumes the object we want to move is in x.

    GetActionStep temp
    CMP #$07
    BNE +notHurt
        RTS
    +notHurt

    StartMoving temp, #UP
    ;STX temp
    ChangeFacingDirection temp, #FACE_UP

    RTS

