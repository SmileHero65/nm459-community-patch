;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; STOP MOVING INPUT with ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Climbing Idle Animation included;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Check if it's appropiate to stop the player
    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt


;;;Play Idle Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                  ; Get the current action step of the player
    BEQ +NotIdleAnimation               ; If already Idle,           branch and don't play Idle Animation
        CMP #$02                        ; If Jumping,                branch and don't play Idle Animation
        BEQ +NotIdleAnimation
        CMP #$04                        ; If already climb Idle,     branch and don't play Idle Animation
        BEQ +NotIdleAnimation

            CMP #$03                        ; Are we climbing?
            BNE normalIdle                  ; If we're climbing, we play the climb Idle animation

                ChangeActionStep temp, #$04 ; change action, assuming that "climb idle" is in action 4

            JMP +stopPlayerMovement     ;Now make the player stop immediately

        normalIdle:
        ChangeActionStep temp, #$00       ;Change to idle state

    +NotIdleAnimation

;;;Stop Player Movement;;;;;;;;;;;;;;;;;
   +stopPlayerMovement:

    StopMoving temp, #$FF, #$00
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash