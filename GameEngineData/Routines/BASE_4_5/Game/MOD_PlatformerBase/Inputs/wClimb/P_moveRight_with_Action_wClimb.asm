;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MOVE RIGHT INPUT with  ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Check if it's appropiate to move the player to the right
    STX temp                       ; Store the index of the object to move.
    GetActionStep temp             ; Get the object's current action step.
    CMP #OBJECT_HURT_STATE         ; Block movement while hurt.
    BEQ +blockedRight
    CMP #PLAYER_CLIMB_STATE         ; Block movement while climbing.
    BEQ +blockedRight
    CMP #PLAYER_CLIMB_IDLE_STATE    ; Block movement while idle on a ladder.
    BNE +canMoveRight
+blockedRight:
    RTS                            ; Return without moving.
+canMoveRight:

;;;Play Walking Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                      ; Get the current action step of the player
    CMP #PLAYER_WALK_STATE                  ; If already walking, branch and don't play Walking Animation
    BEQ +dontPlayWalkingAnimation
            CMP #PLAYER_JUMP_STATE          ; If jumping,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation
            CMP #PLAYER_FALL_STATE          ; If falling,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation

            ChangeActionStep temp, #PLAYER_IDLE_STATE   ;Change to walk state

        +dontPlayWalkingAnimation

;;;Make the player move to the Right;;;;;;;;;;;;;;;;;

    TXA
    STX temp                                  ; assumes the object we want to move is in x.
    ChangeFacingDirection temp, #FACE_RIGHT   ; make player face to the right
    StartMoving temp, #RIGHT                  ; move the player to the right

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash
