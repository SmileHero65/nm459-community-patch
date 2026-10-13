    ;; Before drawing HUD, let's check if we want to

    LDA ScreenFlags00            ;; Load ScreenFlags
    AND #%01000000               ;; Is the HideHud box checked?
    BEQ +doNotTurnOffSpriteHud
        JMP skipDrawingSpriteHud ;; If so, skip drawing the sprite HUD
    +doNotTurnOffSpriteHud:

    ;; Here is an example of how to do a sprite hud. arg5, the one that has the
    ;; value of myVar, must correspond to a user variable you have in your game.
    ;; Don't forget, you can only draw 8 sprites per scanline, so a sprite hud
    ;; can only be 8 sprites wide max.

    DrawSpriteHud #HUD_LIVES_X, #HUD_LIVES_Y, #$7F, #$03, #$30, myLives, #%00000000  ;;;; this draws lives

    skipDrawingSpriteHud:

