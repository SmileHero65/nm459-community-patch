;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Create a Projectile - Super Ammo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Objects used;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; #$01 - normal projectile        (second obj)
;;; #$02 - mega   projectile        (third  obj)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt

    LDA myAmmo
    BNE +canShootMega         ;; If ammo exists, check for special ammo (Mega Shot)
        LDA #$01              ;; No special ammo; use normal projectile type (1)
        STA tempz             ;; Store the projectile type in tempz.
        ;;; If no special ammo, use normal projectile type.

    ;; Limit the number of projectiles on screen.
    CountObjectType tempz
    CMP myAmmoLimit
    BNE +belowNumber         ;; If the number of projectiles is below the limit, proceed to shooting.

        JMP +canNotShoot     ;; If the limit is reached, jump to canNotShoot.

    +belowNumber
        ;; Continue to shoot the projectile.
        JMP +shootThing

    +canShootMega:
        ;;; If ammo exists, shoot a Mega Shot instead.
        LDA #$02              ;; Set projectile type to Mega Shot (2).
        STA tempz             ;; Store the projectile type in tempz.

    +belowNumber
    ;; Decrease the ammo count by one
        DEC myAmmo

    +shootThing
        ;; Set up and fire the projectile.
        TXA
        PHA
        TYA
        PHA

        LDX player1_object
        LDA Object_x_hi,x
        CLC
        ADC #$04              ;; Offset to determine the projectile's x-coordinate.
        STA tempA
        LDA Object_screen,x
        ADC #$00
        STA tempD
        LDA Object_y_hi,x
        CLC
        ADC #$04              ;; Offset to determine the projectile's y-coordinate.
        STA tempB
        LDA Object_direction,x
        AND #%00000111        ;; Mask direction to fit in 8-bit value.
        STA tempC

        ;; Create the projectile on screen.
        CreateObjectOnScreen tempA, tempB, tempz, #$00, tempD
        ;;; Parameters:
        ;;; - x and y coordinates (tempA, tempB)
        ;;; - projectile type (tempz)
        ;;; - starting action (#$00)
        ;;; - screen (tempD)

        ;; Set the direction for the newly created projectile.
        LDA tempC
        STA Object_direction,x
        TAY
        LDA DirectionTableOrdered,y
        STA temp1
        STX temp
        StartMoving temp, temp1
        PLA
        TAY
        PLA
        TAX

    +canNotShoot:

     RTS   ; Return from subroutine - in input scripts, it is
    ;;;;;;; imperative for input scripts to end on RTS, so
    ;;;;;;; the game won't crash