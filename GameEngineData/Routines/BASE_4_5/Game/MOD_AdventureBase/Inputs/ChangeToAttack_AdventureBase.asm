
;; Constants for melee attack script
;; Weapon x and y pixel offsets and action steps

WEAPON_POSITION_DOWN_X  = $00  ;; Player faces down
WEAPON_POSITION_DOWN_Y  = $10  ;;
WEAPON_DOWN_STATE       = $01  ;;

WEAPON_POSITION_RIGHT_X = $10  ;; Player faces right
WEAPON_POSITION_RIGHT_Y = $00  ;;
WEAPON_RIGHT_STATE      = $00  ;;

WEAPON_POSITION_UP_X    = $00  ;; Player faces up
WEAPON_POSITION_UP_Y    = $F0  ;;
WEAPON_UP_STATE         = $01  ;;

WEAPON_POSITION_LEFT_X  = $F0  ;; Player faces left
WEAPON_POSITION_LEFT_Y  = $00  ;;
WEAPON_LEFT_STATE       = $00  ;;


    ;; Check if the selected weapon is unlocked and usable.
    ;; If not, return.
    LDY weaponChoice
    LDA weaponsUnlocked
    AND weaponChoiceTable,y
    BNE +canCreateWeapon
        RTS
    +canCreateWeapon:

    ;; Store the selected weapon object ID into tempC
    STA tempC

    ;; Set object in attack mode
    ;; - assumes the x-register to be the object slot
    ;; - assumes #2 is the object's attack action step
    STX temp
    ChangeActionStep temp, #$02

    ;; Stop object from moving
    StopMoving temp, #$FF, #$00

    ;; Determine the facing direction of the player
    GetObjectDirection player1_object
    TAY

    ;; The x-register now holds the value of the player slot
    ;; The y-register holds the facing direction of the player

    ;; Apply x-offset to weapon placement
    LDA Object_x_hi,x
    CLC
    ADC weaponXOffsetTable,y
    STA tempA

    ;; Apply y-offset to weapon placement
    LDA Object_y_hi,x
    CLC
    ADC weaponYOffsetTable,y
    STA tempB

    ;; Retrieve weapon action step based on facing direction
    LDA weaponStateTable,y
    STA tempD

    ;; Get player direction, so we can apply it to the weapon
    LDA Object_direction,x
    STA temp1

    ;; Create weapon object
    CreateObject tempA, tempB, tempC, tempD

    ;; Apply player direction to weapon
    LDA temp1
    STA Object_direction,x

    ;; We're done!
    RTS


;; Here are the lookup tables that work with this script.

;; Bitmask table to check if weapon is unlocked yet
weaponChoiceTable:
    .db #%00000001, #%00000010, #%00000100, #%00001000
    .db #%00010000, #%00100000, #%01000000, #%10000000

;; Weapon slot to object ID mapping
weaponObjectTable:
    .db #$03, #$06, #$03, #$03, #$03, #$03, #$03, #$03

;; x-offset for weapon based on player facing direction
weaponXOffsetTable:
    .db WEAPON_POSITION_DOWN_X
    .db WEAPON_POSITION_DOWN_X
    .db WEAPON_POSITION_RIGHT_X
    .db WEAPON_POSITION_RIGHT_X
    .db WEAPON_POSITION_UP_X
    .db WEAPON_POSITION_UP_X
    .db WEAPON_POSITION_LEFT_X
    .db WEAPON_POSITION_LEFT_X

;; y-offset for weapon based on player facing direction
weaponYOffsetTable:
    .db WEAPON_POSITION_DOWN_Y
    .db WEAPON_POSITION_DOWN_Y
    .db WEAPON_POSITION_RIGHT_Y
    .db WEAPON_POSITION_RIGHT_Y
    .db WEAPON_POSITION_UP_Y
    .db WEAPON_POSITION_UP_Y
    .db WEAPON_POSITION_LEFT_Y
    .db WEAPON_POSITION_LEFT_Y

;; weapon action steps based on player facing direction
weaponStateTable:
    .db WEAPON_DOWN_STATE
    .db WEAPON_DOWN_STATE
    .db WEAPON_RIGHT_STATE
    .db WEAPON_RIGHT_STATE
    .db WEAPON_UP_STATE
    .db WEAPON_UP_STATE
    .db WEAPON_LEFT_STATE
    .db WEAPON_LEFT_STATE

