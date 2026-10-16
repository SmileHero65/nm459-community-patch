;;;;;;;;;;;;;;;;;;;;;;
;; CLIMBING UP INPUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Improved ladder script by Board-B + fixes by Smile Hero
;;; https://www.nesmakers.com/index.php?threads/mega-man-style-ladders-4-5-9-platform-module-updated.7805/
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Check whether the player is allowed to climb.
    GetActionStep player1_object    ;; Load the player's current action step.
    CMP #OBJECT_HURT_STATE          ;; Do not climb while hurt.
    BNE +notHurt
    JMP +notClimbing
+notHurt:
    ;; Save prevBank because SwitchBank uses it to remember the return bank.
    ;; Restore it afterward so this lookup does not disturb an outer bank switch.
    LDA prevBank
    PHA

    ;; ObjectBboxTop and ObjectHeight are stored in bank $1C.
    SwitchBank #$1C

    LDX player1_object              ;; X = player object slot.
    LDY Object_type,x               ;; Y = player object type.

    ;; Calculate the bottom of the collision box relative to the object origin.
    ;; Subtract two pixels to preserve the original upward ladder probe.
    LDA ObjectBboxTop,y
    CLC
    ADC ObjectHeight,y
    SEC
    SBC #$02
    STA tempz                      ;; Save the vertical probe offset.

    ;; Return to the bank that was active before reading the object tables.
    ReturnBank
    PLA
    STA prevBank                   ;; Restore the original bank bookkeeping.

    ;; Check the point near the player's feet for a ladder tile.
    LDX player1_object
    LDA Object_x_hi,x
    CLC
    ADC #$08                       ;; Original horizontal probe: eight pixels right.
    STA temp                       ;; X coordinate of the collision probe.
    JSR getPointColTable           ;; Select the collision table for this point.

    LDA Object_y_hi,x
    CLC
    ADC tempz
    STA temp1                      ;; Y coordinate of the collision probe.

    CheckCollisionPoint temp, temp1, #$0A, tempA
    BEQ +onLadder                   ;; Tile type $0A is a ladder.
    JMP +notLadder

+onLadder:
    ;; Move upward directly. Ladder movement does not use accumulated velocity.
    LDA Object_y_hi,x
    SEC
    SBC #LADDER_SPEED
    STA Object_y_hi,x

    ;; Align the player with the left edge of the 16-pixel ladder tile.
    ;; This preserves the original alignment for a 16-pixel-wide player.
    LDA tileX
    AND #%11110000

    ;; Optional horizontal alignment adjustment:
    ;; SEC
    ;; SBC #$00                    ;; Move the player farther left.
    ;; Or:
    ;; CLC
    ;; ADC #$00                    ;; Move the player farther right.

    STA Object_x_hi,x

    ;; Enter the climbing state only when necessary.
    ;; Reapplying it every frame would restart its animation and behavior.
    GetActionStep player1_object
    CMP #PLAYER_CLIMB_STATE
    BEQ +alreadyOnLadder
    ChangeActionStep player1_object, #PLAYER_CLIMB_STATE

+alreadyOnLadder:
    ;; Clear velocity every frame, including frames already spent climbing.
    ;; This prevents horizontal inertia from pulling the player off alignment
    ;; and removes any remaining jump or fall velocity.
    LDX player1_object
    LDA #$00
    STA Object_h_speed_hi,x
    STA Object_h_speed_lo,x
    STA Object_v_speed_hi,x
    STA Object_v_speed_lo,x

    ;; Clear fractional coordinates after positioning the player directly.
    STA Object_x_lo,x
    STA Object_y_lo,x

    ;; Disable automatic horizontal and vertical movement.
    ;; Preserve the lower four bits, including the facing direction.
    LDA Object_direction,x
    AND #%00001111
    STA Object_direction,x
    RTS

+notLadder:
    ;; Leave the climbing state when the probe no longer detects a ladder.
    ;; Do not change unrelated action steps.
    GetActionStep player1_object
    CMP #PLAYER_CLIMB_STATE
    BNE +notClimbing
    ChangeActionStep player1_object, #PLAYER_IDLE_STATE

+notClimbing:

    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash
