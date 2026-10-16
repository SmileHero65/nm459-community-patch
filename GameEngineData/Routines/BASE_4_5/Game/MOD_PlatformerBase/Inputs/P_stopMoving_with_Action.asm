;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; STOP MOVING INPUT with ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Check if it's appropiate to stop the player
    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #OBJECT_HURT_STATE              ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt


;;;Play Idle Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                  ; Get the current action step of the player
    BEQ +NotIdleAnimation               ; If already Idle,   branch and don't play Idle Animation
        CMP #PLAYER_JUMP_STATE          ; If Jumping,        branch and don't play Idle Animation
            BEQ +NotIdleAnimation
        CMP #PLAYER_FALL_STATE          ; If Falling,        branch and don't play Idle Animation
            BEQ +NotIdleAnimation

            ChangeActionStep temp, #PLAYER_IDLE_STATE   ;Change to idle state

    +NotIdleAnimation

;;;Stop Player Movement;;;;;;;;;;;;;;;;;

    StopMoving temp, #$FF, #$00
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash
