;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Fix abrupt stop when player collides with solid above;;;;;;;;;
;;https://www.nesmakers.com/index.php?threads/4-5-9-physics-script-help-abrupt-stop-when-player-collides-with-solid-above.7133/#post-52144
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ...this will only work if the current labels are observed.
;;;; This assumes that the label "donePositionUpdate" precedes stop-code at the end of this subroutine.
;;;; Assumes that
;;;; In a a platform game, there are different things that happen if an object runs into a block from below, above, or the side.

    TXA
    PHA
    STA tempx

     LDA Object_v_speed_hi,x
     BMI +isJumpingUpWhenHittingSolid
        JMP +isFallingDownWhenHittingSolid
    +isJumpingUpWhenHittingSolid

        ;; is jumping up when hitting a solid.
        ;; ONLY do this is there is a solid directly over head.
        LDY Object_type,x
        LDA Object_x_hi,x
        CLC
        ADC self_left
        STA temp
        JSR getPointColTable


        LDA yHold_hi
        CLC
        ADC self_top
        SEC
        SBC #$01
        STA temp1
        CheckCollisionPoint temp, temp1, #$01, tempA
        BNE +dontStopVertMove
            JMP +stopVerticalMovementOnSolidHit
        +dontStopVertMove:
        CheckCollisionPoint temp, temp1, #$09, tempA
        BNE +notPrizeBlock
            JMP +isPrizeBlock
        +notPrizeBlock
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
            CheckCollisionPoint temp, temp1, #$09, tempA
            BNE +notPrizeBlock
                JMP +isPrizeBlock
            +notPrizeBlock
                ;; there is nothing above head.
                LDX tempx
                JMP +isFallingDownWhenHittingSolid

            +isPrizeBlock

                LDX tempx

                ; Preserve the prize position before updating the tile.
                LDA tileX
                AND #%11110000
                CLC
                ADC #MY_PRIZE_X_OFFSET
                PHA

                LDA tileY
                AND #%11110000
                SEC
                SBC #MY_PRIZE_Y_OFFSET
                PHA

                LDA Object_screen,x
                PHA

                ; Select the collision table of the actual collision point.
                LDA tempA
                AND #%00000001
                STA temp2
            
                ; Prepare the collision table index for the tile macro.
                JSR GetTileAtPosition
                STY temp1

                PrizeBlock_WaitForTileQueue:
                    ; Wait until the shared background update queue is free.
                    LDA updateScreenData
                    AND #%00000100
                    BEQ +updatePrizeTile
                    JSR doWaitFrame
                    JMP PrizeBlock_WaitForTileQueue
                
               +updatePrizeTile:
                ; Replace the graphics and collision together.
                LDA #$00
                STA scrollOffsetCounter
                ChangeTileAtCollision #PRIZE_BLOCK_USED_GRAPHIC, #TILE_SOLID
                ;;Prize Block converts into a regular solid tile and changes graphic
            
                ; Restore the prize screen and position.
                PLA
                STA tempC
                PLA
                STA tempB
                PLA
                STA tempA
            
                ; Create the prize and preserve the original object index.
                TXA
                PHA
                    CreateObjectOnScreen tempA, tempB, #MY_PRIZE, #MY_PRIZE_STATE, tempC
                PLA
                TAX

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
