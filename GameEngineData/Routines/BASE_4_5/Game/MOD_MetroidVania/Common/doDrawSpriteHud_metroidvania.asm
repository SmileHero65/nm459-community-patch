
    ;; Before drawing HUD, let's check if we want to
    LDA ScreenFlags00             ;; Load ScreenFlags
    AND #%01000000                ;; Is the HideHud box checked?
    BEQ +doNotTurnOffSpriteHud    ;; If not, jump to +doNotTurnOffSpriteHud
                                  ;; (continue showing HUD)
        JMP skipDrawingSpriteHud  ;; If so, jump to skipDrawingSpriteHud
                                  ;; (this skips drawing the sprite HUD)
    +doNotTurnOffSpriteHud:

    ;; Here is an example of how to do a sprite hud.
    ;; arg5, the one that has the value of myVar, must correspond to a user
    ;; variable you have in your game. Don't forget, you can only draw 8 sprites
    ;; per scanline, so a sprite hud can only be 8 sprites wide max.
    ;;
    ;; DrawSpriteHud arg0, arg1, arg2, arg3, arg4, arg5, arg6
    ;;
    ;; arg0 = starting position in pixels, x
    ;; arg1 = starting position in pixels, y
    ;; arg2 = sprite to draw, CONTAINER
    ;; arg3 = MAX
    ;; arg4 = sprite to draw, FILLED
    ;; arg5 = variable.
    ;; arg6 = attribute

    ;; Draw health
    DrawSpriteHud #HUD_HEALTH_X, #HUD_HEALTH_Y, #$78, #$03, #$76, myHealth, #%00000001

    ;; Draw ammo
    DrawSpriteHud #HUD_AMMO_X, #HUD_AMMO_Y, #$79, #$05, #$77, myAmmo, #%00000000

skipDrawingSpriteHud:

