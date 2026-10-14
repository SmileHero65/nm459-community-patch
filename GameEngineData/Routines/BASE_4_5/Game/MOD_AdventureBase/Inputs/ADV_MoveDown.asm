;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygrouptrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp
    GetActionStep temp ;;in which states we want to block player movement?
    CMP #PLAYER_HURT_STATE
    BEQ +blocked
    CMP #PLAYER_ATTACK_STATE
    BNE +canMove
    +blocked:
        RTS
    +canMove:

        ;;Time to Move
        StartMoving temp, #DOWN
        STX temp ;; assumes the object we want to move is in x.
        ChangeFacingDirection temp, #FACE_DOWN ;;Change to the direction we want to move

        GetActionStep temp ;; don't display the walking state if you're not...
        CMP #1                ;; already walking
        BEQ +
            ChangeActionStep temp, #1 ;Change to walk state
        +

    RTS    ;;Return from Subroutine
    ;;always add this at the end of your input scripts so your game doesn't crash
