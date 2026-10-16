;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Fix abrupt stop when player collides with solid above;;;;;;;;;
;;https://www.nesmakers.com/index.php?threads/4-5-9-physics-script-help-abrupt-stop-when-player-collides-with-solid-above.7133/#post-52144
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ...this will only work if the current labels are observed.
;;;; This assumes that the label "donePositionUpdate" precedes stop-code at the end of this subroutine.
;;;; Assumes that
;;;; In a a platform game, there are different things that happen if an object runs into a block from below, above, or the side.

    ; Preserve the current object index.
    TXA
    PHA
    STA tempx

    LDA Object_v_speed_hi,x
    BMI +isJumpingUpWhenHittingSolid
    JMP +isFallingDownWhenHittingSolid

+isJumpingUpWhenHittingSolid:
    ; Check the left side of the object's head.
    LDY Object_type,x
    LDA Object_x_hi,x
    CLC
    ADC self_left
    STA temp
    JSR getPointColTable

    ; Use the vertical position already calculated by physics.
    LDA yHold_hi
    CLC
    ADC self_top
    SEC
    SBC #$01
    STA temp1

    CheckCollisionPoint temp, temp1, #$01, tempA
    BNE +
    JMP +stopVerticalMovementOnSolidHit
+
    ; Check the right side of the object's head.
    LDX tempx
    LDY Object_type,x
    LDA Object_x_hi,x
    CLC
    ADC self_right
    STA temp
    JSR getPointColTable

    CheckCollisionPoint temp, temp1, #$01, tempA
    BNE +
    JMP +stopVerticalMovementOnSolidHit
+
    ; No ceiling was detected.
    JMP +isFallingDownWhenHittingSolid

+stopVerticalMovementOnSolidHit:
    ; Stop upward movement without clearing horizontal momentum.
    LDA #$00
    STA Object_v_speed_lo,x
    STA Object_v_speed_hi,x
    STA Object_y_lo,x
    STA yHold_lo

    ; Restore the vertical position before the collision.
    LDA yPrev
    STA Object_y_hi,x
    STA yHold_hi
    JMP +finishSolidReaction

+isFallingDownWhenHittingSolid:
    ; Stop horizontal movement when no ceiling was detected.
    LDX tempx
    LDA #$00
    STA Object_x_lo,x
    STA Object_h_speed_hi,x
    STA Object_h_speed_lo,x

+finishSolidReaction:
    PLA
    TAX
    JMP donePositionUpdate
