
;; Please note that this is _not_ a subroutine.

;; These constants will determine the speed of recoil.
;RECOIL_SPEED (set through NESMaker UI)
;RECOIL_SPEED_HI (unused)
RECOIL_SPEED_LO = #$00


    ;; Do handle physics.

    LDA Object_x_lo,x
    STA xHold_lo
    LDA Object_x_hi,x
    STA xHold_hi
    STA xPrev

    LDA Object_y_lo,x
    STA yHold_lo
    LDA Object_y_hi,x
    STA yHold_hi
    STA yPrev

    ;; For adventure physics, don't update position if attacking.
    CPX player1_object
    BNE +notPlayer
        ;; It was the player.
        ;; If this object is in attack action, currently set to 2,
        ;; he should not move, and should skip physics check.
        STX temp
        GetActionStep temp
        CMP #$02
        BNE +notPlayer ;; skip, because was not 2.

        RTS
    +notPlayer:

    ;; Ignore physics if not in main game mode
    LDA gameState
    BEQ +doHandlePhysics
        JMP skipPhysics
    +doHandlePhysics

    ;; Reset the vars we will use for movement.
    LDA #$00
    STA tempA
    STA tempB
    STA tempC
    STA tempD

    LDA Object_status,x
    AND #%00000100
    BNE doHandlePhysics
        JMP skipPhysics
    doHandlePhysics:

    LDA #$00
    STA collisionsToCheck ;; blank out collisions to check.

    ;; Check to see if we are using aiming physics. If we are using aim physics,
    ;; Object_direction will have it's 3rd bit flipped. xxxxXxxx

    LDA Object_direction,x
    AND #%00001000
    BNE +useAimedPhysics
        JMP useNormalDirectionalPhysics
    +useAimedPhysics

    LDA #%00001111
    STA collisionsToCheck

    LDY Object_type,x

    LDA ObjectMaxSpeed,y
    LSR
    LSR
    LSR
    LSR
    STA tempA ;; high byte of "speed" will determine how many times we should
              ;; update move towards speed.

    LDA Object_x_lo,x
    STA xHold_lo
    LDA Object_x_hi,x
    STA xHold_hi

    LDA Object_y_lo,x
    STA yHold_lo
    LDA Object_y_hi,x
    STA yHold_hi

    LDA Object_h_speed_lo,x
    BPL AddHspeedToAimedX

        ;; subtract h speed to aimed x
        LDA Object_h_speed_lo,x
        EOR #$FF
        STA temp

        LDY tempA
        aimLoop1:
            LDA xHold_lo
            SEC
            SBC temp
            STA xHold_lo

            LDA xHold_hi
            SBC Object_h_speed_hi,x
            STA xHold_hi

            DEY
        BPL aimLoop1
        JMP figureAimedVspeed

    AddHspeedToAimedX:
        LDY tempA
        aimLoop2:
            LDA xHold_lo
            CLC
            ADC Object_h_speed_lo,x
            STA xHold_lo

            LDA xHold_hi
            ADC Object_h_speed_hi,x
            STA xHold_hi

            DEY
        BPL aimLoop2
    figureAimedVspeed:

    LDA Object_v_speed_lo,x
    BPL AddVSpeedToAimedY
        ;; subtract v speed to aimed y
        LDA Object_v_speed_lo,x
        EOR #$FF
        STA temp

        LDY tempA
        doAimLoop3:
            LDA yHold_lo
            CLC
            ADC temp
            STA yHold_lo

            LDA yHold_hi
            ADC Object_v_speed_hi,x
            STA yHold_hi

            DEY
        BPL doAimLoop3

        JMP doneWithAimedV

    AddVSpeedToAimedY:
        LDY tempA
        aimLoop4:
            LDA yHold_lo
            SEC
            SBC Object_v_speed_lo,x
            STA yHold_lo

            LDA yHold_hi
            SBC Object_v_speed_hi,x
            STA yHold_hi

            DEY
        BPL aimLoop4
    doneWithAimedV:

    ;; check xHold_hi and yHold_hi against bounds.
    LDA yHold_hi
    CMP #BOUNDS_TOP
    BEQ +doTopBounds
    BCC +doTopBounds
        JMP +doneWithTop

    +doTopBounds:
        LDA #$02
        STA screenUpdateByte
        JSR doHandleBounds
        JMP +skipPhysics

    +doneWithTop:

    STA yHold_hi
    CLC
    ADC self_bottom
    CMP #BOUNDS_BOTTOM ;#240
    BCS +doBottomBounds
        JMP +doneWithBottom

    +doBottomBounds:
        STA screenUpdateByte
        JSR doHandleBounds
        JMP +skipPhysics

    +doneWithBottom:

    LDA xHold_hi
    CLC
    ADC self_right
    BCS +doRightBounds
        JMP +doneWithRight

    +doRightBounds:
        LDA #$01
        STA screenUpdateByte
        JSR doHandleBounds
        JMP +skipPhysics

    +doneWithRight:

    LDA xHold_hi
    CMP #BOUNDS_LEFT
    BEQ +doLeftBounds
    BCC +doLeftBounds
        JMP +doneWithLeft

    +doLeftBounds:
        LDA #$03
        STA screenUpdateByte
        JSR doHandleBounds
        JMP +skipPhysics

    +doneWithLeft:

    JMP +skipPhysics ;; skips all the acc/dec stuff and goes right to movement
                     ;; based on speed, which was figured out in the directional
                     ;; macro.


    useNormalDirectionalPhysics:

    LDY Object_type,x

    LDA ObjectBboxLeft,y
    STA self_left

    CLC
    ADC ObjectWidth,y
    STA self_right

    SEC
    SBC self_left
    LSR
    STA self_center_x

    LDA ObjectBboxTop,y
    STA self_top

    CLC
    ADC ObjectHeight,y
    STA self_bottom

    SEC
    SBC self_top
    LSR
    STA self_center_y ;; self center in the vertical direction.

    STX temp
    GetActionStep temp
    CMP #$07
    BNE +notHurt
        ;; This object is hurt, so it's speed will be determined by the recoil
        ;; speed above. Any caveats to that, put here. For instance, if there is
        ;; a monster bit that prevents recoil.
        LDA Object_direction,x
        AND #%10000000
        BNE +isMovingH
            ;; is not moving h
            LDA Object_direction,x
            AND #%00100000
            BNE +isMovingV
                ;; is not moving V
                JMP +skipPhysics
            +isMovingV:

            LDA #RECOIL_SPEED_LO
            STA Object_v_speed_lo,x
            LDA #RECOIL_SPEED
            STA Object_v_speed_hi,x

            LDA #$00
            STA Object_h_speed_hi,x
            STA Object_h_speed_lo,x

            JMP gotHandVspeeds
        +isMovingH:

        LDA #RECOIL_SPEED_LO
        STA Object_h_speed_lo,x
        LDA #RECOIL_SPEED
        STA Object_h_speed_hi,x

        LDA #$00
        STA Object_v_speed_hi,x
        STA Object_v_speed_lo,x
        JMP gotHandVspeeds
    +notHurt:

    LDY Object_type,x

    LDA ObjectMaxSpeed,y
    ASL
    ASL
    ASL
    ASL
    STA myMaxSpeed

    LDA ObjectMaxSpeed,y
    LSR
    LSR
    LSR
    LSR
    STA myMaxSpeed+1

    ;; Now, high max speed byte is the actual high byte of speed, and
    ;; low max speed byte is the low byte of speed.

    LDA #$00
    STA myAcc+1
    LDA ObjectAccAmount,y
    STA myAcc

    ;; deal with acceleration / deceleration
    LDA Object_direction,x
    AND #%10000000
    BNE doHvel
        JMP doHdec
    doHvel:

    ;; we have activated horizontal inertia for this object
    LDA Object_h_speed_lo,x
    CLC
    ADC myAcc
    STA Object_h_speed_lo,x
    STA temp

    LDA Object_h_speed_hi,x
    ADC myAcc+1
    STA Object_h_speed_hi,x
    STA temp1

    ;; now, evaluate against max speed.
    Compare16 temp1, temp, myMaxSpeed+1,myMaxSpeed
    +
        ;; We have reached the max speed.
        LDA myMaxSpeed
        STA Object_h_speed_lo,x
        LDA myMaxSpeed+1
        STA Object_h_speed_hi,x
        JMP doneWithAccFetch
    ++
        LDA temp
        STA Object_h_speed_lo,x
        LDA temp1
        STA Object_h_speed_hi,x
    doneWithAccFetch:

    JMP skipDoHdec

    doHdec:

    LDA Object_h_speed_hi,x
    CLC
    ADC Object_h_speed_lo,x
    BEQ skipDoHdec

        LDA Object_h_speed_lo,x
        SEC
        SBC myAcc
        STA temp

        LDA Object_h_speed_hi,x
        SBC myAcc+1
        STA temp1
        BCC zeroHdec ;; If the result of the 16 bit compare is
                     ;; less than zero, clamp the acc to zero.
                     ;; Otherwise, make it the stored values.
            LDA temp1
            STA Object_h_speed_hi,x
            LDA temp
            STA Object_h_speed_lo,x

            JMP skipDoHdec
        zeroHdec:

        LDA #$00
        STA Object_h_speed_hi,x
        STA Object_h_speed_lo,x
    skipDoHdec:

    ;; Do vertical check.

    LDA Object_direction,x
    AND #%00100000
    BNE doVvel
        JMP doVdec
    doVvel:

    ;; We have activated horizontal inertia for this object
    LDA Object_v_speed_lo,x
    CLC
    ADC myAcc
    STA Object_v_speed_lo,x
    STA temp

    LDA Object_v_speed_hi,x
    ADC myAcc+1
    STA Object_v_speed_hi,x
    STA temp1

    ;; Now, evaluate against max speed.
    Compare16 temp1, temp, myMaxSpeed+1,myMaxSpeed
    +
        ;; We have reached the max speed.
        LDA myMaxSpeed
        STA Object_v_speed_lo,x
        LDA myMaxSpeed+1
        STA Object_v_speed_hi,x

        JMP doneWithAccFetchV
    ++
        LDA temp
        STA Object_v_speed_lo,x
        LDA temp1
        STA Object_v_speed_hi,x
    doneWithAccFetchV:

    JMP skipDoVdec

    doVdec:

    LDA Object_v_speed_hi,x
    CLC
    ADC Object_v_speed_lo,x
    BEQ skipDoVdec
        LDA Object_v_speed_lo,x
        SEC
        SBC myAcc
        STA temp

        LDA Object_v_speed_hi,x
        SBC myAcc+1
        STA temp1
        BCC zeroVdec ;; if the result of the 16 bit compare is
                     ;; less than zero, clamp the acc to zero.
                     ;; Otherwise, make it the stored values.
            LDA temp1
            STA Object_v_speed_hi,x
            LDA temp
            STA Object_v_speed_lo,x

            JMP skipDoVdec
        zeroVdec:

        LDA #$00
        STA Object_v_speed_lo,x
        STA Object_v_speed_hi,x
    skipDoVdec:

    gotHandVspeeds:

    LDA directionByte
    AND #%00001111
    STA directionByte

    LDA Object_h_speed_lo,x
    STA tempA
    LDA Object_h_speed_hi,x
    STA tempB

    LDA Object_direction,x
    AND #%01000000
    BNE isMovingRight
        ;; isMovingLeft
        ;; Set to check points 0 and 3 (top left and bottom left.)
        LDA collisionsToCheck
        ORA #%00001001
        STA collisionsToCheck

        LDA tempA
        CLC
        ADC tempB
        BNE hSpeedIsNotZero
            ;; h speed is zero, which means no h direction
            LDA directionByte
            AND #%01111111
            STA directionByte
            JMP gotHmoveDirection
        hSpeedIsNotZero:

        LDA directionByte
        ORA #%10000000
        AND #%10111111 ;; "left"
        STA directionByte
        JMP gotHmoveDirection
    isMovingRight:

    ;; Set to check points 1 and 2 (top right and bottom right.)
    LDA collisionsToCheck
    ORA #%00000110
    STA collisionsToCheck

    LDA tempA
    CLC
    ADC tempB
    BNE hSpeedIsNotZero2
        ;; h speed is zero, which means no h direction
        LDA directionByte
        AND #%01111111
        STA directionByte
        JMP gotHmoveDirection
    hSpeedIsNotZero2:

    LDA directionByte
    ORA #%11000000 ;; "right"
    STA directionByte

    gotHmoveDirection:

    LDA Object_v_speed_lo,x
    STA tempC
    LDA Object_v_speed_hi,x
    STA tempD

    LDA Object_direction,x
    AND #%00010000
    BNE isMovingDown
        ;; isMovingUp
        ;; Set to check points 0 and 1 (top left and top right.)
        LDA collisionsToCheck
        ORA #%00000011
        STA collisionsToCheck

        LDA tempC
        CLC
        ADC tempD
        BNE vSpeedIsNotZero
            ;; h speed is zero, which means no h direction
            LDA directionByte
            AND #%11011111
            STA directionByte
            JMP gotVmoveDirection
        vSpeedIsNotZero:

        LDA directionByte
        ORA #%00100000
        AND #%11101111 ;; "up"
        STA directionByte

        JMP gotVmoveDirection
    isMovingDown:

    ;; set to check points 2 and 3 (bottom left and bottom right.)
    LDA collisionsToCheck
    ORA #%00001100
    STA collisionsToCheck

    LDA tempC
    CLC
    ADC tempD
    BNE vSpeedIsNotZero2
        ;; h speed is zero, which means no h direction
        LDA directionByte
        AND #%11011111
        STA directionByte
        JMP gotVmoveDirection
    vSpeedIsNotZero2:

    LDA directionByte
    ORA #%00110000 ;; "right"
    STA directionByte

    gotVmoveDirection:

    LDA directionByte
    AND #%01000000
    BNE doMoveRight
        ;; doMoveLeft
        LDA Object_x_lo,x
        SEC
        SBC tempA
        STA xHold_lo

        LDA Object_x_hi,x
        SBC tempB
        STA xHold_hi

        LDA Object_screen,x
        SBC #$00
        STA xHold_screen

        LDA #BOUNDS_LEFT
        BNE doNonZeroBoundsLeftCheck
            LDA Object_x_lo,x
            SEC
            SBC tempA
            LDA Object_x_hi,x
            SBC tempB
            BEQ doLeftBounds
            BCC doLeftBounds

            JMP doneWithH
        doNonZeroBoundsLeftCheck:

        LDA Object_x_lo,x
        SEC
        SBC tempA

        ;; check xHold_hi against left bounds.
        LDA Object_x_hi,x
        SBC tempB
        CMP #BOUNDS_LEFT
        BEQ doLeftBounds
        BCC doLeftBounds
            JMP doneWithH
        doLeftBounds:

        LDA scrollTrigger
        AND #%00100000
        BEQ checkLeftBounds_NoScroll
            JMP doneWithH
        checkLeftBounds_NoScroll:

        STX temp
        GetActionStep temp
        CMP #$07
        BNE +notHurt
            JMP stopMovingDueToHurtState
        +notHurt

        LDA #$03
        STA screenUpdateByte
        JSR doHandleBounds

        JMP skipPhysics
    doMoveRight:

    ;; update x position.
    LDA Object_x_lo,x
    CLC
    ADC tempA
    STA xHold_lo

    LDA Object_x_hi,x
    ADC tempB
    STA xHold_hi

    LDA Object_screen,x
    ADC #$00
    STA xHold_screen

    LDA Object_x_hi,x
    CLC
    ADC Object_h_speed_hi,x
    ADC self_right
    BCS doRightBounds
        JMP doneWithH
    doRightBounds:

    LDA scrollTrigger
    AND #%00010000
    BEQ checkRightBounds_NoScroll
        JMP doneWithH
    checkRightBounds_NoScroll:

    STX temp
    GetActionStep temp
    CMP #$07
    BNE +notHurt
        JMP stopMovingDueToHurtState
    +notHurt:

    LDA #$01
    STA screenUpdateByte

    JSR doHandleBounds
    JMP skipPhysics

    doneWithH:

    ;; Skip edge check if scrolling is enabled. Can handle on bit basis,
    ;; set up in init scripts by using the high bits.

    LDA directionByte
    AND #%00010000
    BNE doMoveDown
        ;; doMoveUp:
        LDA #BOUNDS_TOP
        BNE doNonZeroBoundsTopCheck
            LDA Object_y_lo,x
            SEC
            SBC tempC
            STA yHold_lo
            LDA Object_y_hi,x
            SBC tempD
            STA yHold_hi
            BEQ doTopBounds
            BCC doTopBounds

            JMP doneWithV
        doNonZeroBoundsTopCheck:

        LDA Object_y_lo,x
        SEC
        SBC tempC
        STA yHold_lo

        LDA Object_y_hi,x
        SBC tempD
        STA yHold_hi

        ;; check yHold_hi against left bounds.
        CMP #BOUNDS_TOP
        BEQ doTopBounds
        BCC doTopBounds
            JMP doneWithV
        doTopBounds:

        LDA scrollTrigger
        AND #%10000000
        BEQ checkTopBounds_NoScroll
            JMP doneWithV
        checkTopBounds_NoScroll:

        STX temp
        GetActionStep temp
        CMP #$07
        BNE +notHurt
            JMP stopMovingDueToHurtState
        +notHurt:

        LDA #$02
        STA screenUpdateByte

        JSR doHandleBounds
        JMP skipPhysics
    doMoveDown:

    ;; update y position.

    LDA Object_y_lo,x
    CLC
    ADC tempC
    STA yHold_lo

    LDA Object_y_hi,x
    ADC tempD
    STA yHold_hi
    CLC
    ADC self_bottom
    CMP #BOUNDS_BOTTOM ;#240
    BCS doBottomBounds
        JMP doneWithV
    doBottomBounds:

    LDA scrollTrigger
    AND #%01000000
    BEQ checkBottomBounds_NoScroll
        JMP doneWithV
    checkBottomBounds_NoScroll:

    STX temp
    GetActionStep temp
    CMP #$07
    BNE +notHurt
        JMP stopMovingDueToHurtState
    +notHurt

    LDA #$00
    STA screenUpdateByte
    JSR doHandleBounds
    JMP skipPhysics

    doneWithV:
    JMP skipPhysics

    stopMovingDueToHurtState:

    LDA #$00
    STA Object_x_lo,x
    STA Object_y_lo,x
    STA Object_h_speed_hi,x
    STA Object_h_speed_lo,x
    STA Object_v_speed_hi,x
    STA Object_v_speed_lo,x
    STA xHold_lo
    STA yHold_lo

    LDA xPrev
    STA Object_x_hi,x
    STA xHold_hi

    LDA yPrev
    STA Object_y_hi,x
    STA yHold_hi

    skipPhysics:

