;; do handle physics.


    LDA Object_x_lo,x
    STA xHold_lo
    LDA Object_x_hi,x
    STA xHold_hi
    STA xPrev

    LDA Object_screen,x
    STA xHold_screen
    sta screenPrev

    LDA Object_y_lo,x
    STA yHold_lo
    LDA Object_y_hi,x
    STA yHold_hi
    STA yPrev

    ; LDA currentNametable
    ; AND #%00001111
    ; STA xHold_screen

    ; LDA currentNametable
    ; LSR
    ; LSR
    ; LSR
    ; LSR
    ; STA yHold_screen





    LDA Object_status,x
    AND #%00000100
    BNE doHandlePhysics
    JMP skipPhysics
doHandlePhysics:

    LDA #$00
    STA collisionsToCheck ;; blank out collisions to check.

    ;;; check to see if we are using aiming physics.
    ;;; if we are using aim physics, Object_direction will have it's 3rd bit flipped. xxxxXxxx
    LDA Object_direction,x
    AND #%00001000
    BEQ useNormalDirectionalPhysics
        ;; use aimed physics.
        ;; Aimed physics doesn't need to update speed.

        LDA Object_h_speed_lo,x
        BPL AddHspeedToAimedX
            ;; subtract h speed to aimed x
            LDA Object_h_speed_lo,x
            EOR #$FF
            STA temp

            LDA Object_x_lo,x
            sec
            sbc temp
            STA xHold_lo
            LDA Object_x_hi,x
            sbc Object_h_speed_hi,x
            STA xHold_hi
            JMP figureAimedVspeed
        AddHspeedToAimedX:
            LDA Object_x_lo,x
            CLC
            ADC Object_h_speed_lo,x
            STA xHold_lo
            LDA Object_x_hi,x
            ADC Object_h_speed_hi,x
            STA xHold_hi

        figureAimedVspeed:

        LDA Object_v_speed_lo,x
        BPL AddVSpeedToAimedY
            ;; subtract v speed to aimed y
            LDA Object_v_speed_lo,x
            EOR #$FF
            STA temp
            LDA Object_y_lo,x
            clc
            adc temp
            STA yHold_lo
            LDA Object_y_hi,x
            adc Object_v_speed_hi,x
            STA yHold_hi
            JMP doneWithAimedV
        AddVSpeedToAimedY:
            LDA Object_y_lo,x
            sec
            sbc Object_v_speed_lo,x
            STA yHold_lo
            LDA Object_y_hi,x
            sbc Object_v_speed_hi,x
            STA yHold_hi
        doneWithAimedV:


        JMP skipPhysics ;; skips all the acc/dec stuff and goes right to movement based on speed
                            ;; which was figured out in the directional macro.

    useNormalDirectionalPhysics:
    ;;; jump out to bank 1C to load in physics values.
    ;SwitchBank #$1C

        LDY Object_type,x
        LDA ObjectMaxSpeed,y
        ASL
        ASL
        ASL
        ASL
        ;AND #%00001111
        STA myMaxSpeed
        LDA ObjectMaxSpeed,y
        LSR
        LSR
        LSR
        LSR
        STA myMaxSpeed+1
        ;;; now high max speed byte is the actual high byte of speed
        ;;; low max speed byte is the low byte of speed
        LDA #$00
        STA myAcc+1
        LDA ObjectAccAmount,y
        CMP #$FF
        BNE +notMaxedAccAmount
            LDA myMaxSpeed
            STA myAcc
            LDA myMaxSpeed+1
            STA myAcc+1
            JMP +doneWithAccFetch
        +notMaxedAccAmount
        STA myAcc
    +doneWithAccFetch



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



    ;;;; THESE CONSTANTS WILL DETERMINE THE SPEED OF RECOIL
    ;RECOIL_SPEED - which can be changed in the UI
    RECOIL_SPEED_LO = #$00 ;;always stays as 0, because changing it never really produces any effects


        STX temp
        GetActionStep temp
        CMP #OBJECT_HURT_STATE
        BNE +notHurt
            ;;; this object is hurt.
            ;;; so it's speed will be determined by the recoil speed above.
            ;;; any caveats to that, put here.  For instance, if there is a monster bit
            ;;; that prevents recoil.

                    LDA #RECOIL_SPEED_LO
                    STA Object_h_speed_lo,x
                    LDA #RECOIL_SPEED
                    STA Object_h_speed_hi,x

                    ; Match horizontal inertia to the recoil direction.
                    LDA Object_frame,x
                    AND #%10111111
                    STA temp
                    LDA Object_direction,x
                    AND #%01000000
                    ORA temp
                    STA Object_frame,x

                    JMP gotHandVspeeds
        +notHurt

    ; Adopt the requested direction when horizontal speed is zero.
    LDA Object_h_speed_hi,x
    ORA Object_h_speed_lo,x
    BNE PF_HDirectionReady
        LDA Object_frame,x
        AND #%10111111
        STA temp
        LDA Object_direction,x
        AND #%01000000
        ORA temp
        STA Object_frame,x
    PF_HDirectionReady:

    ;;;; deal with acceleration / deceleration


    LDA Object_direction,x
    AND #%10000000
    BNE doHvel
    JMP doHdec
    doHvel:

        ; Brake before accelerating in the opposite direction.
        LDA Object_direction,x
        EOR Object_frame,x
        AND #%01000000
        BEQ PF_HAccelerate
            JMP doHdec
        PF_HAccelerate:

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

        ;;; now, evaluate against max speed.
        Compare16 temp1, temp, myMaxSpeed+1,myMaxSpeed
        +
        ;;;; we have reached the max speed.
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
    ORA Object_h_speed_lo,x
    BEQ skipDoHdec

    LDA Object_h_speed_lo,x
    SEC
    SBC myAcc
    STA temp

    LDA Object_h_speed_hi,x
    SBC myAcc+1
    STA temp1
    BCC zeroHdec ;; if the result of the 16 bit compare is
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

gotHandVspeeds:
    LDA directionByte
    AND #%00001111
    STA directionByte

    LDA Object_h_speed_lo,x
    STA tempA
    LDA Object_h_speed_hi,x
    STA tempB


    LDA Object_frame,x
    AND #%01000000
    BNE isMovingRight
    ;isMovingLeft


    ;;; set to check points 0 and 3 (top left and bottom left.)
    LDA collisionsToCheck
    ORA #%00001111
    STA collisionsToCheck

        LDA tempA
        ORA tempB
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

        ;;; set to check points 1 and 2 (top right and bottom right.)
    LDA collisionsToCheck
    ORA #%00001111
    STA collisionsToCheck
        LDA tempA
        ORA tempB
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

    LDA directionByte
    AND #%01000000
    BEQ doMoveLeft            ;; dale_coop
        JMP doMoveRight        ;; dale_coop
doMoveLeft:                    ;; dale_coop
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
    ;;;;;;;;;;;;;;;;;;;;; TEST AGAINST LEFT CAMERA BOUNDS.
    ;; Get cam clip left position
        LDA camX
        STA temp16 ;; low left cam clip
        LDA camX_hi
        ;AND #%00001111
        SBC #$00
        ;AND #%00001111        ;; dale_coop
        CLC                 ;; dale_coop
        ADC #$01            ;; dale_coop
        STA temp16+1 ;; high left cam clip
    ;;; Player's position is in xHold_lo and xHold_hi

        LDA Object_x_hi,x
        sec
        sbc #$04
        STA temp
        LDA Object_screen,x
        AND #%00001111
        SBC #$00            ;; dale_coop
        CLC                 ;; dale_coop
        ADC #$01            ;; dale_coop
        STA temp1
        Compare16 temp16+1, temp16, temp1, temp
            +
                CPX player1_object
                BNE +notPlayerAtEdge
                    LDA xPrev
                    STA xHold_hi
                    STA Object_x_hi,x
                    LDA screenPrev
                    STA xHold_screen
                    STA Object_screen,x
                +notPlayerAtEdge
                    LDA #$03
                    STA screenUpdateByte
                    JSR doHandleBounds

                JMP doneWithH
            ++



    JMP doneWithH
doMoveRight:
    ;; update x position.

    LDA Object_x_lo,x
    clc
    adc tempA
    STA xHold_lo
    LDA Object_x_hi,x
    adc tempB
    STA xHold_hi
    LDA Object_screen,x
    ADC #$00
    STA xHold_screen



        LDA camX
        STA temp16 ;; low left cam clip
        LDA camX_hi
        CLC
        ADC #$01
        AND #%00001111
        STA temp16+1 ;; high left cam clip
    ;;; Player's position is in xHold_lo and xHold_hi

        ; LDA xHold_hi        ;; dale_coop: I commented out those lines
        ; CLC                ;; dale_coop: I commented out those lines
        ; ADC self_right    ;; dale_coop: I commented out those lines
        ; ADC #$03 ;; a good number here is one more than the speed of the player.  That seems to contain him to a screen edge.
        ; STA temp            ;; dale_coop: I commented out those lines
        ; LDA Object_screen,x; dale_coop: I commented out those lines
        ; ADC #$00            ;; dale_coop: I commented out those lines
        ; AND #%00001111    ;; dale_coop: I commented out those lines
        ; STA temp1            ;; dale_coop: I commented out those lines
        ;; dale_coop: and replaced by:
        LDA self_right        ;; dale_coop
        CLC                    ;; dale_coop
        ADC #$01            ;; dale_coop
        STA temp            ;; dale_coop
        LDA xHold_hi        ;; dale_coop
        CLC                    ;; dale_coop
        ADC temp            ;; dale_coop
        STA temp            ;; dale_coop
        LDA Object_screen,x    ;; dale_coop
        ADC #$00            ;; dale_coop
        AND #%00001111        ;; dale_coop
        STA temp1            ;; dale_coop
        Compare16 temp16+1, temp16, temp1, temp
            JMP +
            ++
                CPX player1_object
                BNE +skipStopAtEdge
                    LDA xPrev
                    STA xHold_hi
                    STA Object_x_hi,x
                    LDA screenPrev
                    STA xHold_screen
                +skipStopAtEdge
                    LDA #$01
                    STA screenUpdateByte
                    JSR doHandleBounds

                JMP doneWithH
            +

JMP doneWithH
        ; LDA Object_x_hi,x
        ; clc
        ; ADC Object_h_speed_hi,x
        ; ADC self_right

    ; ;
        ; BCS doRightBounds
            ; JMP doneWithH
        ; doRightBounds:

        ; LDA scrollTrigger
        ; AND #%00010000
        ; BEQ checkRightBounds_NoScroll
            ; JMP doneWithH
        ; checkRightBounds_NoScroll:
            ; LDA #$01
            ; STA screenUpdateByte
            ; JSR doHandleBounds
            ; JMP skipPhysics
doneWithH:
    LDA Object_vulnerability,x
    AND #%00000001
    BEQ +skip
        ;;; What should we do if vulnerability bit 0 is flipped?
        JMP doneWithGravity
    +skip

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HANDLE GRAVITY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;*OLD* By default, these are NESMaker Gravity's Constants:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;MAX_FALL_SPEED     = the maximum speed a player can fall.  It is good to give this a max speed
;;;;GRAVITY_LO        = the low byte for gravity
;;;;GRAVITY_HI        = the high byte for gravity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;NOTE: the las two bytes work sort of like
;;;;a minute and hour hand on a watch.  So if you thought about it like minutes and hours, if you put "1" in hi and "30" in low
;;;;you would add an hour and a half every time that gravity was engaged.  If you put 1 in hi and 45 in low,
;;;;it would add an hour and 45 minutes every time gravity was engaged (a little faster)
;;;;The explanation is not literal, just a way to easily understand it.
;;;;HI will likely be a low number...0-4, I would imagine.  Not much more.  Written #$xx.
;;;;LO could be anything, #$00 - #$FF if you want to write in hex, or if you just want to write in regular
;;;;decimal values, #x will work, any value between #0 and #255.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;*NEW*
;;For simplicity's sake, this patch will let you control MAX_FALL_SPEED and GRAVITY_LO in the UI, the last one under a different name
;;;GRAVITY_LO is now just called GRAVITY
;;;GRAVITY_HI will not be present in the UI because changing its value of 0 will create unexpected results on the physics
GRAVITY_HI = #$00;

;;In case you want to have different gravity
;;depending on your screen, follow this tutorial by Board-B:
;;https://www.nesmakers.com/index.php?threads/have-different-gravity-on-specific-screen-types-4-5-9.7242/#post-49139
;;The main difference is that the values are no longer here in code
;;So, you will delete the constants from the UI and add variables that ressemble them
;;Apart from that, it's basically the same process
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    LDA Object_x_hi,x
    CLC
    ADC self_left
    STA temp
        JSR getPointColTable
    STA tempB
    LDA Object_x_hi,x
    CLC
    ADC self_right
    STA temp3 ;; the right bottom collision point.
        JSR getPointColTable
    LDA Object_y_lo,x
    CLC
    ADC Object_v_speed_lo,x
    LDA Object_y_hi,x
    ADC Object_v_speed_hi,x
    CLC
    ADC self_bottom
    STA temp1
    ;;; CHECK FOR SOLID TILE, which is tile type 1 in this module.
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;; In this module, we have
        ;; 1 = solid
        ;; 7 = one way platform
        ;; 9 = prize block, which behaves as a solid
        ;; 10 (0A) = ladder, whose top behaves like a solid.
        ;; Here is where we handle the "landing" scenario for all of those possibilities.


    ; Do not land while moving upward.
    LDA Object_v_speed_hi,x
    BPL PF_BeginSupportCheck
    JMP +notSolid
            
            PF_BeginSupportCheck:
                ; Probe both feet at the calculated Y position,
                ; then probe both feet one pixel below it.
                LDA #$00
                STA temp2
            
            PF_ProbeFoot:
                ; Even probes check the left foot.
                ; Odd probes check the right foot.
                LDA temp2
                AND #$01
                BNE PF_ProbeRightFoot
                    GetCollisionPoint temp, temp1, tempB
                JMP PF_ClassifySurface
            
            PF_ProbeRightFoot:
                    GetCollisionPoint temp3, temp1, tempA
            
            PF_ClassifySurface:    ;;Cycle through types of tile surfaces the object can collide
                CMP #TILE_SOLID
                BNE +
                JMP isSolidSoLand
            +
                CMP #TILE_PRIZE_BLOCK
                BNE +
                JMP isSolidSoLand
            +
                CMP #TILE_JUMP_THROUGH
                BNE +
                JMP PF_CheckOneWaySurface
            +
                CMP #TILE_LADDER
                BNE +
                JMP PF_CheckLadderSurface
            +
                ; This point does not support the object.
                JMP PF_NextSupportPoint
            
            PF_CheckOneWaySurface:
                ; Preserve the existing one-way landing check.
                TYA
                AND #%11110000
                CLC
                ADC Object_v_speed_hi,x
                CMP temp1
                BCC PF_OneWayNotSupporting
                JMP isSolidSoLand
            
            PF_OneWayNotSupporting:
                JMP PF_NextSupportPoint
            
            PF_CheckLadderSurface:
                ; Check above the feet to distinguish the top
                ; of a ladder from its continuous interior.
                LDA temp1
                SEC
                SBC #$02
                SEC
                SBC Object_v_speed_hi,x
                STA tempy
            
                GetCollisionPoint temp, tempy, tempB
                BNE PF_LadderLeftAboveNotEmpty
                JMP PF_CheckLadderRightAbove
            
            PF_LadderLeftAboveNotEmpty:
                CMP #TILE_LADDER
                BNE +
                JMP PF_NextSupportPoint
            +
                GetCollisionPoint temp3, tempy, tempA
                BNE PF_LadderRightAboveNotEmpty
                JMP PF_CheckLadderLeftAbove
            
            PF_LadderRightAboveNotEmpty:
                CMP #TILE_LADDER
                BNE +
                JMP PF_NextSupportPoint
            +
                JMP isSolidSoLand
            
            PF_CheckLadderRightAbove:
                GetCollisionPoint temp3, tempy, tempA
                BNE +
                JMP isSolidSoLand
            +
                JMP PF_NextSupportPoint
            
            PF_CheckLadderLeftAbove:
                GetCollisionPoint temp, tempy, tempB
                BNE +
                JMP isSolidSoLand
            +
                JMP PF_NextSupportPoint
            
            PF_NextSupportPoint:
                ; Advance to the next foot.
                INC temp2
                LDA temp2
                CMP #$02
                BNE PF_CheckSupportFinished
            
                ; After checking both feet, check one pixel lower.
                INC temp1
            
            PF_CheckSupportFinished:
                CMP #$04
                BEQ PF_NoSupportingSurface
                JMP PF_ProbeFoot
            
            PF_NoSupportingSurface:
                ; Restore the original probe Y before falling.
                DEC temp1
            
            +notSolid:


            ;; is not solid, don't land.
            ;; Fixed MetroidVania Jumping Up Screen Issue by goatgary
            ;;https://www.nesmakers.com/index.php?threads/4-5-6-metroidvania-jumping-up-screen-issue-solved.6246/

            LDA Object_y_lo,x
            CLC
            ADC Object_v_speed_lo,x
            STA yHold_lo
            LDA Object_y_hi,x
            EOR #$80
            ADC Object_v_speed_hi,x
            EOR #$80
            BVC +setY
                LDA #$00    ; fix wrap to bottom
            +setY
            STA Object_y_hi,x
            STA yHold_hi

            CMP #BOUNDS_BOTTOM
            BCC +notAtBounds
                CPX player1_object
                BNE +destroyNonPlayerObject
                        LDA #$00
                        STA screenUpdateByte
                        JSR doHandleBounds
                    JMP +notAtBounds
                +destroyNonPlayerObject
                    DestroyObject
            +notAtBounds:

            CMP #BOUNDS_TOP
            BEQ +atBoundsTop
            BCS +notAtBoundsTop

            +atBoundsTop
                CPX player1_object
                BNE +destroyNonPlayerObject
                        LDA #$02
                        STA screenUpdateByte
                        JSR doHandleBounds
                    JMP +notAtBoundsTop
                +destroyNonPlayerObject
                    DestroyObject
            +notAtBoundsTop


            LDA Object_v_speed_lo,x
            CLC
            ADC #GRAVITY
            STA Object_v_speed_lo,x
            LDA Object_v_speed_hi,x
            ADC #GRAVITY_HI
            STA Object_v_speed_hi,x

            ;;; Player fall animation
            CPX player1_object
            BNE +notPlayerFalling
                STX temp
                GetActionStep temp        ;;In what states we shall not play the falling state?
                CMP #OBJECT_HURT_STATE
                BEQ +notPlayerFalling
                CMP #PLAYER_FALL_STATE
                BEQ +notPlayerFalling
                    LDA Object_v_speed_hi,x
                    BEQ +notPlayerFalling
                    BMI +notPlayerFalling
                        ChangeActionStep temp, #PLAYER_FALL_STATE ;Plays Fall State Animation
            +notPlayerFalling:

                LDA Object_v_speed_hi,x
                CMP #MAX_FALL_SPEED
                BNE notOverFallSpeed
                    ;; is at least max fall speed.
                    LDA #$00
                    STA Object_v_speed_lo,x
                notOverFallSpeed:

            JMP doneWithGravity


isSolidSoLand:

    ; Use the surface Y before other logic overwrites temp1.
    LDA temp1
    AND #%11110000
    SEC
    SBC self_bottom
    SEC
    SBC #$01
    STA Object_y_hi,x
    STA yHold_hi

    ; Clear fractional position and vertical velocity.
    LDA #$00
    STA Object_y_lo,x
    STA yHold_lo
    STA Object_v_speed_lo,x
    STA Object_v_speed_hi,x

    ; Allow variable jumping again after landing.
    LDA Object_frame,x
    AND #%01111111
    STA Object_frame,x

    ;;Fixed Walking in Place When Landing by Board-B;;
    ;;https://www.nesmakers.com/index.php?threads/walking-in-place-when-landing-platformer-metrovania-4-5-9.8417/
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; move to position
    ;;; load the top of the tile that is being run into.
    ;;check if in a jumping state.
    STX temp
    GetActionStep temp
    CMP #PLAYER_JUMP_STATE ;; presums jump is in state 2
    BNE +dontChangeToIdle
        LDA gamepad
        AND #%11000000
        BNE +isRunningWhenLanding
            ;; is idle when landing
            LDA #PLAYER_IDLE_STATE
            STA temp1
            JMP +gotLandingState
        +isRunningWhenLanding
            LDA #PLAYER_WALK_STATE
            STA temp1
        +gotLandingState
            ChangeActionStep temp, temp1 ;; changes to either idle or running depending on if a direction key is pressed.
    +dontChangeToIdle

doneWithGravity:

;;;Vertical Movement added back in
;;;https://www.nesmakers.com/index.php?threads/vertical-movement-ai-for-enemies-in-metroidvania-project.7841/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VerticalMovement:
    LDA Object_direction,x
    AND #%00100000
    BEQ +noVertMovement
        ;; there is vertical movement
        LDA Object_direction,x
        AND #%00010000
        BEQ +isUpMovement
            ;; is down movement
            LDA Object_y_lo,x
            CLC
            ADC myMaxSpeed;Object_v_speed_lo,x
            STA yHold_lo
            LDA Object_y_hi,x
            ADC myMaxSpeed+1;Object_v_speed_hi,x
            STA yHold_hi
                CLC
                ADC self_bottom
                CMP #BOUNDS_BOTTOM ;#240

                BCS doBottomBounds
                    JMP +noVertMovement
                doBottomBounds:
                        LDA yPrev
                        STA yHold_hi
                        STA Object_y_hi,x
                        JMP skipPhysics
        +isUpMovement
            LDA Object_y_lo,x
            SEC
            SBC myMaxSpeed;Object_v_speed_lo,x
            STA yHold_lo
            LDA Object_y_hi,x
            SBC myMaxSpeed+1;Object_v_speed_hi,x
            BCC +doTopBounds ;; helps if top bounds is zero.
            STA yHold_hi
            CMP #BOUNDS_TOP
                BEQ +doTopBounds
                BCC +doTopBounds
                    JMP +noVertMovement
                +doTopBounds
                        LDA yPrev
                        STA yHold_hi
                        STA Object_y_hi,x

                        JMP skipPhysics
    +noVertMovement:

skipPhysics:
