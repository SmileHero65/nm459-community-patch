;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Only can jump if the place below feet is free.
    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt
    CMP #$02                            ; Check if action step is 2, which is commonly the "jump" state)
    BNE +notAlreadyJump                 ; If the player is NOT in the jump state, branch to continue checking movement
            RTS                         ; If the player is in the jump state, don't execute this
     +notAlreadyJump                    ; This extra check is to partially fix a bug where you can infinitely jump
                                        ; on a ladder


    SwitchBank #$1C
    LDY Object_type,x
    LDA ObjectBboxTop,y
    CLC
    ADC ObjectHeight,y
    sta temp2

    LDA Object_x_hi,x
    CLC
    ADC ObjectBboxLeft,y
    STA temp
    JSR getPointColTable

    LDA Object_y_hi,x
    CLC
    ADC #$02
    CLC
    ADC temp2
    STA temp1
    CheckCollisionPoint temp, temp1, #$01, tempA ;; check below feet to see if it is solid.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
    BNE +checkMore
        JMP +doJump
    +checkMore

    CheckCollisionPoint temp, temp1, #$07, tempA ;; check below feet to see if it is jumpthrough platform.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
    BNE +checkMore
        JMP +doJump
    +checkMore
     CheckCollisionPoint temp, temp1, #$09, tempA ;; check below feet to see if it is prize block .
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
    BNE +checkMore
        JMP +doJump
    +checkMore
    CheckCollisionPoint temp, temp1, #$0A, tempA ;; check below feet to see if it is ladder.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
     BNE +dontDoJump
          JMP  +doJump
        +dontDoJump
            ;; check second point.
        LDY Object_type,x
        LDA ObjectWidth,y
        CLC
        ADC temp
        STA temp
        JSR getPointColTable
        CheckCollisionPoint temp, temp1, #$01, tempA ;; check below feet to see if it is solid.
                                            ;;; if it is (equal), can jump.
                                            ;;; if not, skips jumping.
        BEQ +doJump

        CheckCollisionPoint temp, temp1, #$07, tempA ;; check below feet to see if it is jumpthrough platform.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
        BEQ +doJump
        CheckCollisionPoint temp, temp1, #$09, tempA ;; check below feet to see if it is jumpthrough platform.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
        BEQ +doJump
        CheckCollisionPoint temp, temp1, #$0A, tempA ;; check below feet to see if it is ladder.
                                        ;;; if it is (equal), can jump.
                                        ;;; if not, skips jumping.
        BEQ +doJump
            JMP +skipJumping
+doJump:
    ;PlaySound #sfx_thump

    LDY Object_type,x
    LDA ObjectJumpSpeedLo,y
    EOR #$FF
    STA Object_v_speed_lo,x
    LDA ObjectJumpSpeedHi,y
    EOR #$FF
    STA Object_v_speed_hi,x

    STX temp ;; assumes the object we want to move is in x.
 ;  change the object's action so that he is in jump mode.
    ChangeActionStep temp, #2 ;Jump

+skipJumping:
    ReturnBank

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash