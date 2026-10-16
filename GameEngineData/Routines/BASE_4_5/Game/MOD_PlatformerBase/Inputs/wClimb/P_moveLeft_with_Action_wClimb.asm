;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MOVE LEFT INPUT  with  ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Check if it is appropriate to move the player to the left.
    STX temp                       ; Store the index of the object to move.
    GetActionStep temp             ; Get the object's current action step.
    CMP #OBJECT_HURT_STATE         ; Block movement while hurt.
    BEQ +blockedLeft
    CMP #PLAYER_CLIMB_STATE         ; Block movement while climbing.
    BEQ +blockedLeft
    CMP #PLAYER_CLIMB_IDLE_STATE    ; Block movement while idle on a ladder.
    BNE +canMoveLeft
+blockedLeft:
    RTS                            ; Return without moving.
+canMoveLeft:


;;;Play Walking Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                      ; Get the current action step of the player
    CMP #PLAYER_IDLE_STATE                  ; If already walking, branch and don't play Walking Animation
    BEQ +dontPlayWalkingAnimation
            CMP #PLAYER_JUMP_STATE          ; If jumping,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation
            CMP #PLAYER_FALL_STATE          ; If falling,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation

            ChangeActionStep temp, #PLAYER_IDLE_STATE       ;Change to walk state

        +dontPlayWalkingAnimation

    ;;;Make the player move to the Left;;;;;;;;;;;;;;;;;

    TXA
    STX temp                                    ; assumes the object we want to move is in x.
    ChangeFacingDirection temp, #FACE_LEFT      ; make player face to the left
    StartMoving temp, #LEFT                     ; move the player to the left

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash
