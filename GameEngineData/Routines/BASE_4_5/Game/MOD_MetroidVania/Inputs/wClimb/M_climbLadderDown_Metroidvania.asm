;;;;;;;;;;;;;;;;;;;;;;
;;CIMBING UP INPUT;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Improved ladder script by Board-B + fixes by Smile Hero
;;  https://www.nesmakers.com/index.php?threads/mega-man-style-ladders-4-5-9-platform-module-updated.7805/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;Metroidvania ladders are functionally the same as the platformer ones
;;;;EXCEPT for the starting logic
;;;;Before getting to the usual climbing stuff... we first need to check our boundaries with the screen
;;;;
    TXA
    PHA
    LDX player1_object

    ;;;As always, check if it's appropiate to make the player climb
    GetActionStep player1_object        ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            JMP +notClimbing            ; If the player is in the hurt state, don't execute this by jumping to the end of the code
        +notHurt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For checking bottom boundary.
    LDA Object_y_hi,x
    CLC
    ADC ObjectHeight,y ;#$24 ;; height of player, bbox, wherever you want the bottom bounds to test
    ADC #LADDER_SPEED ;; ladder speed
    BCC +notAtBottom
        GetActionStep player1_object
        CMP #$03 ;; in this module, the player's action step 3 is for climbing
        BNE +notAtBottom
            LDA #BOUNDS_TOP ;#$02
            CLC
            ADC #$02
            STA newY
            LDA Object_x_hi,x
            STA newX
            LDA currentNametable
            CLC
            ADC #$10
            STA currentNametable
            STA Object_screen,x
            STA camScreen
            STA temp2
            WarpToScreen #$00, temp2, #$00
    ;; arg0 = warp to map.  0= map1.  1= map2.
    ;; arg1 = screen to warp to.
    ;; arg2 = screen transition type - most likely use 1 here.
            JMP +notClimbing
    +notAtBottom


    ;;;;First let's make some calculations on player's height (just so we we it out of the way)
    LDA #PLAYER_HEIGHT    ;;Load the height of the player - can be modified on the UI
    CLC                    ;;Clear Carry
    ADC #1                ;;ADD 1
    STA tempz            ;;store it on tempz, which will be used later
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; We do this becase...
    ;; if we give the exact player height, the player will never be able to go down if standing on top of a ladder

;;; if up is engaged, check for a collision with a ladder.
;;; check the pixel just below feet, and the pixel just below top of bounding box.

    LDX player1_object
    LDA Object_x_hi,x
    CLC
    ADC #$08       ;; MIDDLE OF PLAYER
    STA temp
    JSR getPointColTable

    LDA Object_y_hi,x
    CLC
    ADC tempz       ;;
    STA temp1
    ;;; CHECK FOR SOLID TILE, which is tile type 1 in this module.
    CheckCollisionPoint temp, temp1, #$0A, tempA ;; is it a solid?
    BNE +notLadder

    ;; there is a ladder under my feet..
    LDA Object_y_hi,x
    CLC
    ADC #LADDER_SPEED       ;; ladder speed
    STA Object_y_hi,x

    LDA tileX
    AND #%11110000
    ;; Add or subtract player offset here if
    ;; you need to adjust the player position
    ;;
    ;; -- Subtract offset:
    ; SEC
    ; SBC #0 ;; Player x position
    ;;
    ;; -- Or add offset:
    ; CLC
    ; ADC #0 ;; Player x position
    ;;
    STA Object_x_hi,x

    GetActionStep player1_object
    CMP #$03       ;; in this module, the player's action step 3 is for climbing
    BEQ +alreadyOnLadder

    ChangeActionStep player1_object, #$03
    LDA Object_direction,x
    AND #%00001111
    STA Object_direction,x

+alreadyOnLadder
    PLA
    TAX
    RTS

+notLadder
    GetActionStep player1_object
    CMP #$03
    BNE +notClimbing
    ChangeActionStep player1_object, #$00

+notClimbing
    PLA
    TAX
    RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash