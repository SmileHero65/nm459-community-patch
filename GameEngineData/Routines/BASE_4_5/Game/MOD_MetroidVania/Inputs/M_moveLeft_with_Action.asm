;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MOVE LEFT INPUT  with  ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Check if it's appropiate to move the player to the left

    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt


;;;Play Walking Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                      ; Get the current action step of the player
    CMP #1                                  ; If already walking, branch and don't play Walking Animation
    BEQ +dontPlayWalkingAnimation
            CMP #2                          ; If jumping,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation

            ChangeActionStep temp, #1       ;Change to walk state

        +dontPlayWalkingAnimation

    ;;;Make the player move to the Left;;;;;;;;;;;;;;;;;

    TXA
    STX temp                                    ; assumes the object we want to move is in x.
    ChangeFacingDirection temp, #FACE_LEFT      ; make player face to the left
    StartMoving temp, #LEFT                     ; move the player to the left

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash