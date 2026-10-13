
MACRO WarpToScreen arg0, arg1, arg2
    ;; arg0 = warp to map
    ;;        0 = map1, 1 = map2
    ;; arg1 = screen to warp to
    ;; arg2 = screen transition type (or where the player spawns in)
    ;;        0 = no change
    ;;        1 = warp-in position
    ;;        2 = continue
    LDA arg0
    STA warpMap

    LDA arg1
    STA currentNametable

    LDX player1_object
    STA Object_screen,x
    STA camScreen

    LDA #$00
    STA camX_lo
    STA camX

    LDA arg2
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
ENDM

