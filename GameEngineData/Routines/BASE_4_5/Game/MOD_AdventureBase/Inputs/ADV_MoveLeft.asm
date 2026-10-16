;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygrouptrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp
    GetActionStep temp
    CMP #OBJECT_HURT_STATE
    BEQ +LeftBlocked
    CMP #PLAYER_ATTACK_STATE
    BNE +canMoveLeft
    +LeftBlocked:
        RTS
    +canMoveLeft:

        ;;Time to Move
        StartMoving temp, #LEFT
        STX temp ;; assumes the object we want to move is in x.
        ChangeFacingDirection temp, #FACE_LEFT ;;Change to the direction we want to move

        GetActionStep temp                 ;; don't display the walking state if you're not...
        CMP #PLAYER_WALK_STATE             ;; already walking
        BEQ +
            ChangeActionStep temp, #PLAYER_WALK_STATE ;Change to walk state
        +

    RTS ;;Return from Subroutine
    ;;always add this at the end of your input scripts so your game doesn't crash
