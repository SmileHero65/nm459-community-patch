
    ;; Check if game handler is in a state where the player can get hurt
    LDA gameHandler
    AND #%10000000
    BEQ +canHurtPlayer
        RTS
    +canHurtPlayer:

    ;; Check if hurting object is not in hurt state (action step 7)
    STX temp
    GetActionStep temp
    CMP #$07
    BNE +canHurtPlayer
        RTS
    +canHurtPlayer

    ;; Check if player is in hurt state (action step 7) already
    GetActionStep player1_object
    CMP #$07
    BEQ +alreadyInHurtState

        ;; Take a health point
        DEC myHealth
        ;; If health points are zero, player is dead
;       BMI +healthBelowZero
        BEQ +healthBelowZero
            JMP +notDeadYet
        +healthBelowZero:
            JMP +playerHealthIsZero
        +notDeadYet:

        ;; Player is not dead
        ;; Update HUD
        UpdateHudElement #$02

        ;; Put player in hurt state
        ChangeActionStep player1_object, #$07

        ;; Reset player speed
        LDA #$00
        STA Object_h_speed_hi,x
        STA Object_h_speed_lo,x
        STA Object_v_speed_hi,x
        STA Object_v_speed_lo,x
        LDA xPrev
        STA Object_x_hi,x
        LDA yPrev
        STA Object_y_hi,x
    +alreadyInHurtState:

    ;; Get player position on screen
    LDA Object_x_hi,x
    CLC
    ADC self_center_x
    STA tempA
    LDA Object_y_hi,x
    CLC
    ADC self_center_y
    STA tempB

    ;; Get damaging object position on screen
    TXA
    PHA
    LDX otherObject

    LDA Object_x_hi,x
    CLC
    ADC other_center_x
    STA tempC

    LDA Object_y_hi,x
    CLC
    ADC other_center_y
    STA tempD

    PLA
    TAX

    ;; Check distance between player and object (horizontally)
    LDA tempA
    SEC
    SBC tempC
    BPL +gotAbs ;; if positive, this is abs value
        EOR #$FF
        CLC
        ADC #$01
    +gotAbs:
    STA temp

    ;; Check distance between player and object (vertically)
    LDA tempB
    SEC
    SBC tempD
    BPL +gotAbs
        EOR #$FF
        CLC
        ADC #$01
    +gotAbs:

    ;; Compare distances to decide whether to recoil
    ;; horizontally or vertically.
    CMP temp
    BCC +recoilHor

        ;; Vertical recoil required

        ;; Check if recoil goes up or down
        LDA tempB
        CMP tempD
        BCS +recoilDown

            ;recoilUp:
            LDA Object_direction,x
            AND #%00001111
            ORA #%00100000
            STA Object_direction,x
            RTS

        +recoilDown:
        LDA Object_direction,x
        AND #%00001111
        ORA #%00110000
        STA Object_direction,x
        RTS
    +recoilHor:

    ;; Horizontal recoil required

    ;; Check if recoil goes left or right
    LDA tempA
    CMP tempC
    BCS +recoilRight

        ;recoilLeft:
        LDA Object_direction,x
        AND #%00001111
        ORA #%10000000
        STA Object_direction,x
        RTS

    +recoilRight:
    LDA Object_direction,x
    AND #%00001111
    ORA #%11000000
    STA Object_direction,x
    RTS

    +playerHealthIsZero:

    ;; Player is dead

    ;; Set continue screen as warp screen
    LDA continueMap
    STA warpMap
    LDA continueScreen
    STA currentNametable
    LDX player1_object
    STA Object_screen,x

    ;; Set screen transition type to "warp" (#$02)
    LDA #$02
    STA screenTransitionType

    ;; Tell game to update the screen next loop
    LDA gameHandler
    ORA #%10000000
    STA gameHandler

    ;; Reset health
    LDA myMaxHealth
    STA myHealth

    ;RTS

