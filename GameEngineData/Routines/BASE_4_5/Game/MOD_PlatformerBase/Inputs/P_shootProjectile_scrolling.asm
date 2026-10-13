;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Create a Projectile in Scrolling Modules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;Objects used;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; #$01 - normal projectile        (second obj)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TXA
    STX temp                            ; assumes the object we want to move is in x.
    GetActionStep temp                  ; Get the current action step of the player
    CMP #$07                            ; Check if action step is 7, which is commonly the "hurt" state)
        BNE +notHurt                    ; If the player is NOT in the hurt state, branch to continue checking movement
            RTS                         ; If the player is in the hurt state, don't execute this
        +notHurt

    LDA myAmmo               ;; If ammo > 0, you're allowed to shoot
    BNE +canShoot
        JMP +canNotShoot
    +canShoot:

    ;; Limit the number of projectiles on screen.
    CountObjectType #$01
    CMP myAmmoLimit
    BNE +belowNumber         ;; If the number of projectiles is below the limit, proceed to shooting.

        JMP +canNotShoot     ;; If the limit is reached, jump to canNotShoot.

    +belowNumber

    ;; there is ammo here.
    DEC myAmmo

    TXA
    PHA
    TYA
    PHA
        LDX player1_object
        LDA Object_x_hi,x
            CLC
        ADC #$04
        STA tempA
        LDA Object_screen,x
        ADC #$00
        STA tempD
        LDA Object_y_hi,x
            CLC
        ADC #$04
        STA tempB
        LDA Object_direction,x
        AND #%00000111
        STA tempC
        CreateObjectOnScreen tempA, tempB, #$01, #$00, tempD
            ;;; x, y, object, starting action.
            ;;; and now with that object, copy the player's
            ;;; direction and start it moving that way.
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
    RTS