;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygroUPLEFTtrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp             ;; assumes the object we want to move is in x.
    GetActionStep temp     ;; don't move if you're in Action Step...
    CMP #$07            ;; 07 - Hurt
    BNE +notHurt
        RTS
    +notHurt
    CMP #$02             ;; 02 - Attack
    BNE +notAttack
        RTS
    +notAttack

        ;;Time to Move
        StartMoving temp, #UPLEFT
        STX temp ;; assumes the object we want to move is in x.
        ChangeFacingDirection temp, #FACE_UPLEFT ;;Change to the direction we want to move

        GetActionStep temp ;; don't display the walking state if you're not...
        CMP #1                ;; already walking
        BEQ +
            ChangeActionStep temp, #1 ;Change to walk state
        +

    RTS    ;;Return from Subroutine
    ;;always add this at the end of your input scripts so your game doesn't crash