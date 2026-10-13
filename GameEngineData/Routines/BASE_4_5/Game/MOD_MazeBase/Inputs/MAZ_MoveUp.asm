;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygrouptrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp             ;; assumes the object we want to move is in x.
    GetActionStep temp     ;; don't move if you're in Action Step...
    CMP #$07            ;; 07 - Hurt
    BNE +notHurt
        RTS
    +notHurt

        ;;Time to Move
        StartMoving temp, #UP
        STX temp ;; assumes the object we want to move is in x.
        ChangeFacingDirection temp, #FACE_UP ;;Change to the direction we want to move

        GetActionStep temp ;; don't display the walking state if you're not...
        CMP #1                ;; already walking
        BEQ +
            ChangeActionStep temp, #1 ;Change to walk state
        +

    RTS    ;;Return from Subroutine
    ;;always add this at the end of your input scripts so your game doesn't crash