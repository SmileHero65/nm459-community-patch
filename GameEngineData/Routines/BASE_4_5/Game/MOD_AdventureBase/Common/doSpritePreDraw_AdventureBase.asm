
;; Constants that define which sprite number corresponds with which weapon.
;; You can change the hex values here to change what sprite in the gameobjects
;; tileset correlates to which weapon to be drawn.

WEAPON_SPRITE_0     = #$2C
WEAPON_SPRITE_1     = #$29
WEAPON_SPRITE_2     = #$39
WEAPON_SPRITE_3     = #$74
WEAPON_SPRITE_4     = #$04
WEAPON_SPRITE_5     = #$05
WEAPON_SPRITE_6     = #$06
WEAPON_SPRITE_7     = #$07
WEAPON_SPRITE_BLANK = #$1C


;; Sprite hud drawing handler
.include SCR_DRAW_SPRITE_HUD

;; USE THE FOLLOWING TO DRAW YOUR WEAPON CHOICE TO THE SCREEN.
;; Use the following to draw your weapon choice to the screen.
;; Assumes weaponChoiceTable exists.
;; Uncomment the following codeblock to enable

;    LDY weaponChoice
;    LDA SelectedWeaponSpriteToDraw,y
;    STA temp
;    LDA weaponChoiceTable,y
;    AND weaponsUnlocked
;    BNE +drawWeapon
;        LDA #WEAPON_SPRITE_BLANK;
;        STA temp
;    +drawWeapon:
;    DrawSprite #$8C, #$0F, temp, #$00

