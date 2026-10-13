;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MOVE RIGHT INPUT with  ACTION ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;        by Board-B           ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Check if it's appropiate to move the player to the right
    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt
    CMP #$03                            ; Check if action step is 3, which is commonly the "climb" state
        BNE +notClimb                   ; If the player is NOT in the climb state, branch to continue checking movement
            RTS                         ; If the player is in the climb state, don't execute this
        +notClimb
    CMP #$04                            ; Check if action step is 4, which is commonly the "climb idle" state
        BNE +notClimbIdle               ; If the player is NOT in the climb idle state, branch to continue checking movement
            RTS                         ; If the player is in the climb idle state, don't execute this
        +notClimbIdle

;;;Play Walking Animation;;;;;;;;;;;;;;;;;

    GetActionStep temp                      ; Get the current action step of the player
    CMP #1                                  ; If already walking, branch and don't play Walking Animation
    BEQ +dontPlayWalkingAnimation
            CMP #2                          ; If jumping,         branch and don't play Walking Animation
            BEQ +dontPlayWalkingAnimation

            ChangeActionStep temp, #1       ;Change to walk state

        +dontPlayWalkingAnimation

;;;Make the player move to the Right;;;;;;;;;;;;;;;;;

    TXA
    STX temp                                  ; assumes the object we want to move is in x.
    ChangeFacingDirection temp, #FACE_RIGHT   ; make player face to the right
    StartMoving temp, #RIGHT                  ; move the player to the right

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash