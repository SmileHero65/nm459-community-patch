
;; This is great for a game that functions like the scrolling platformer, but
;; uses the top and bottom to advance to a new screen on the map.

    CPX player1_object
    BEQ +isPlayerForBounds
        RTS
    +isPlayerForBounds

    LDA screenUpdateByte
    AND #%11111101
    BEQ +doBounds ;; if it is zero or two, that means it is moving down or up
        RTS
    +doBounds

    ;; Update screen
    LDA gameHandler
    ORA #%10000000
    STA gameHandler

    ;; Turn screen off
    LDA #$00
    STA soft2001
    JSR doWaitFrame

    ;; Get the screen number the player is leaving
    LDX player1_object
    LDA Object_screen,x
    STA currentNametable

    ;; Reset the camera offset
    LDA #$00
    STA camX
    STA camY
    STA camX_lo
    STA camY_lo

    ;; Check if the player is moving up or down
    LDA screenUpdateByte
    BNE notHandlingBottomBounds

        ;; Player is moving down a screen
        LDA #BOUNDS_TOP
        CLC
        ADC #$02
        STA newY
        LDA Object_x_hi,x
        STA newX
        LDA currentNametable
        CLC
        ADC #$10
        JMP DoScreenUpdate

    notHandlingBottomBounds:
        ;; Player is moving up a screen
        LDA #BOUNDS_BOTTOM ; #$EF
        SEC
        SBC #$02
        SEC
        SBC self_bottom
        STA newY
        LDA Object_x_hi,x
        STA newX
        LDA currentNametable
        SEC
        SBC #$10

    DoScreenUpdate:

    ;; Non normal screen updates
    STA currentNametable
    STA Object_screen,x

