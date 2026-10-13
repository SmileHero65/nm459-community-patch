;;Before drawing HUD, let's check if we want to
LDA ScreenFlags00               ; Load ScreenFlags
AND #%01000000                  ; Is the HideHud box checked on Screen Details?
BEQ +doNotTurnOffSpriteHud      ; If not, jump to the label +doNotTurnOffSpriteHud (continue showing HUD)
    JMP skipDrawingSpriteHud     ; If so, jump to the label skipDrawingSpriteHud (this skips drawing the sprite HUD)
+doNotTurnOffSpriteHud:

;;; Here is an example of how to do a sprite hud.
;;; Arg5, the one that has the value of myVar, must correspond to a user variable you have in your game.
;;; Don't forget, you can only draw 8 sprites per scanline, so a sprite hud can only be 8 sprites wide max.


;DrawSpriteHud #$08, #$08, #$11, #$10, #$10, myVar, #$00
    ; arg0 = starting position in pixels, x
    ; arg1 = starting position in pixels, y
    ; arg2 = sprite to draw, CONTAINER
    ; arg3 = MAX
    ; arg4 = sprite to draw, FILLED
    ; arg5 = variable.
    ; arg6 = attribute

DrawSpriteHud #16, #16, #$1C, #$03, #$1D, myLives, #%00000010  ;;;; this draws health

DrawSpriteHud #16, #24, #$7F, #$05, #$0C, myAmmo, #$00 ;; this draws ammo

skipDrawingSpriteHud: