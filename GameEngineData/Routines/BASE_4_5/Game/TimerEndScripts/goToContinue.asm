
    LDA continueMap
    STA warpMap

    LDA continueScreen
    STA currentNametable

    LDX player1_object
    STA Object_screen,x
    STA camScreen

    LDA #$00
    STA camX_lo
    STA camX

    LDX player1_object
    STA Object_screen,x

    LDA #$02 ;; this is continue type warp
    STA screenTransitionType ;; is of warp type

    LDA updateScreenData
    AND #%11111011
    STA updateScreenData

    LDA scrollByte
    AND #%11111110
    STA scrollByte

    LDA #$00
    STA scrollOffsetCounter

    LDA gameHandler
    ORA #%10000000
    STA gameHandler ;; this will set the next game loop to update the screen.

    ChangeActionStep player1_object, #$00

    ;; Stop the Player from Moving
    LDX player1_object
    LDA #%00000000
    STA Object_direction,x

