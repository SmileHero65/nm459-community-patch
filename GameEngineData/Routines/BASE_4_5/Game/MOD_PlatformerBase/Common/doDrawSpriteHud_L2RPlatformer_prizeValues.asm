;; Before drawing HUD, check if the HUD should be hidden
LDA ScreenFlags00            ; Load ScreenFlags
AND #%01000000                ; Check if the HideHud box is checked on Screen Details
BEQ +doNotTurnOffSpriteHud    ; If not, jump to +doNotTurnOffSpriteHud to continue showing HUD
JMP skipDrawingSpriteHud      ; If so, skip drawing the sprite HUD

+doNotTurnOffSpriteHud:

; Example of drawing a sprite HUD:
; Arg5 must be a user-defined variable in your game (myVar in this example)
; Note: Only 8 sprites per scanline are allowed, so the sprite HUD can be 8 sprites wide max.

    ; Draw the sprite HUD for lives/health
    DrawSpriteHud #HUD_LIVES_X, #HUD_LIVES_Y, #$7f, myLives, #$32, myLives, #%00000000

;; Draw a sprite (carrot icon), followed by "x", then a number representing a quasi-score value
;; The game object tileset has numbers 0-9 located at 40-49, and 4A represents "X"

    ; Draw the "carrot" sprite
    DrawSprite #HUD_PRIZE_ROW_X, #HUD_PRIZE_ROW_Y, #$22, #%00000001

; Draw the "x" sprite 8 pixels to the right of the "carrot"
LDA #HUD_PRIZE_ROW_X
CLC
ADC #8
STA tempz

    DrawSprite tempz, #HUD_PRIZE_ROW_Y, #$4a, #$00

; Calculate and draw the prize count sprite
LDA tempz
CLC
ADC #8
STA tempz

LDA myPrizes
CLC
ADC #$40                ; Add 40 to get the correct graphic for the prize count (0-9)
STA temp

    DrawSprite tempz, #HUD_PRIZE_ROW_Y, temp, #$00

skipDrawingSpriteHud:
