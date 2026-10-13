
doHandleUpdateScreen:
    LDA hudUpdates
    BEQ noHudUpdatesThisFrame
        ;; There are hud updates this frame.
        ;; Presumes that second screen flags bit is for hiding hud
        LDA ScreenFlags00
        AND #%01000000
        BNE noHudUpdatesThisFrame

        SwitchBank #$18
            JSR doUpdateHudElement_bank18
        ReturnBank
    noHudUpdatesThisFrame:

    ;; Set focus variables to know which nametable is the one to update.
    LDX player1_object
    LDA Object_screen,x
    AND #%00000001
    BEQ updatesToEvenNametable
        ;;updates to odd nametable
        LDA #$24
        STA camFocus_tiles
        LDA #$27
        STA camFocus_att
        JMP gotScreenFocus
    updatesToEvenNametable:
        LDA #$20
        STA camFocus_tiles
        LDA #$23
        STA camFocus_att
    gotScreenFocus:

    LDA gameHandler
    AND #%10000000
    BEQ dontUpdateToNewScreen
        ;; Turn off screen
        LDA #$00
        STA soft2001
        JSR doWaitFrame

        LDA currentNametable
        LDX player1_object
        STA Object_screen,x

        LSR
        LSR
        LSR
        LSR
        STA camY_hi

        LDA currentNametable
        AND #%00001111
        STA camX_hi

        JSR doLoadScreen2
        JSR doLoadScreen

        LDA gameHandler
        AND #%01111111
        STA gameHandler
    dontUpdateToNewScreen:

    RTS

