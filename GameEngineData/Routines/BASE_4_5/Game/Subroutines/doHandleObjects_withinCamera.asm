
doHandleObjects:
    LDA gameStatusByte
    AND #%00000001 ;; this will skip object handling.
    BEQ +
        RTS
    +

    LDA gameHandler
    AND #%10000000
    BEQ +
        ;; this was in the middle of a screen transition
        RTS
    +

    ;; Reset any variables that need reset before evaluation
    LDA npcTrigger
    AND #%11111110
    STA npcTrigger

    ;; Create state
    LDX #$00

    -handleObjectsLoop:
        LDA Object_status,x
        AND #%11000000
        BNE +
            ;; this object is not being created and is not active.
            JMP objectIsInactive
        +

        LDA Object_status,x
        AND #OBJECT_QUEUED_FOR_DESTRUCTION
        BEQ +
            ;; Destroy
            .include SCR_DESTROY_STATE
            LDA #$00
            STA Object_status,x
            JMP objectIsInactive
            ;; destroying will automatically set this object to inactive
        +

        LDA Object_status,x
        AND #OBJECT_IS_ACTIVE
        BEQ +
            JMP activeObject
        +

        LDA Object_status,x
        AND #OBJECT_QUEUED_FOR_ACTIVATION
        BNE +
            JMP objectIsInactive
        +

        ;; Here, we create a new object. It will exist upon the next frame.
        .include SCR_CREATE_STATE
        JSR doHandleCreateState

        SwitchBank #$1C
            LDY Object_type,x
            LDA ObjectFlags,y
            STA Object_flags,x
        ReturnBank
        JMP objectIsInactive


        ;; Below is everything that happens for an active object.
        activeObject:

        ;; Evaluate the camera position
        LDA Object_x_hi,x
        STA pointer
        LDA Object_screen,x
        AND #%00001111
        STA pointer+1

        Compare16 pointer+1, pointer, camX_hi, camX
        +
            JMP +checkRightForDrawingOffCamera
        ++
            ;; object is outside camera
            ;; so skip updating this object.
            JMP objectIsInactive

        +checkRightForDrawingOffCamera:

        LDA Object_x_hi,x
        ;CLC
        ;ADC #$10 ;; arbitrary - approximate width of objects
        STA pointer

        LDA Object_screen,x
        ;ADC #$00
        AND #%00001111
        STA pointer+1

        LDA camX
        STA pointer5

        LDA camX+1
        clc
        ADC #$01
        STA temp

        Compare16 pointer+1, pointer, temp, pointer5
        +
            ;; this camera is out of camera range.
            JMP objectIsInactive
        ++
            ;; This object is in camera range.
            ;; Continue evaluating this object.

            ;; ORDER OF OPERATIONS
            ;;  1) Check to see if this object reads input (status byte).
            ;;     If not (0), skip input read.
            ;;  2) We have the states from each button (8 buttons, two
            ;;     controllers) from input management. So now we compare it
            ;;     to this object, and whether or not it should have any
            ;;     behaviors associated with it's pressed, down, released, or
            ;;     up states.
            ;;  3) Switch banks to the one that contains our LUTs for object
            ;;     data (sizes and whatnot)
            ;;  4) Check to see if this object observes physics (status byte).
            ;;     If not (0), skip physics.
            ;;  5) Do a basic physics update for this object.
            ;;  6) Check to see if this object observes tile collisions.
            ;;     If not (0), skip tile collisions.
            ;;  7) Check tile collisions.
            ;;  8) Check to see if this object observes object collisions.
            ;;     If not (0), skip object collisions.
            ;;  9) Check object collisions.
            ;; 10) Check bounds.
            ;; 11) Update the object's position and behavior based on above.
            ;; 12) Check to see if this object should be drawn.
            ;;     If not (0), skip drawing.
            ;; 13) Draw this object.
            ;; 14) Return to main bank.

            ;; So status byte would be:
            ;; #% 7 6 5 4 3 2 1 0
            ;;       | | | | | | | + - Queued for deactivation (?)
            ;;       | | | | | | + --- Observes drawing
            ;;       | | | | | + ----- Observes Object Collisions
            ;;       | | | | + ------- Observes Tile Collisions
            ;;       | | | + --------- Observes Physics
            ;;       | | + -----------    Observes Input
            ;;       | + ------------- Queued for activation
            ;;       + --------------- Active

            LDA Object_type,x
            STA tempObjType ;; not corrupted by any other routines
                            ;; used in timer handlings so no reference
                            ;; to bank1c is needed.

            SwitchBank #$18
                LDY Object_type,x
                LDA ObjectReaction,y
                STA EdgeSolidReaction ;; temporarily holds this data.
            ReturnBank

            LDA Object_status,x
            AND #OBJECT_OBSERVES_INPUT
            BNE +
                JMP objectDoesNotRecieveInput
            +

            ;; Input state
            .include SCR_INPUT_STATE

            objectDoesNotRecieveInput:

            LDA Object_status,x
            AND #OBJECT_OBSERVES_PHYSICS
            BNE +
                JMP objectDoesNotObservePhysics
            +

            ;; SYSTEM PHYSICS
            ;; We will use bank #$1C for physics since it has our lut tables
            ;; in it.
            SwitchBank #$1C
                TXA
                PHA
                .include SCR_HANDLE_PHYSICS
                PLA
                TAX
            ReturnBank

            objectDoesNotObservePhysics:

            SwitchBank #$18
                JSR doTileObservationLogic
            ReturnBank

            LDA Object_status,x
            AND #OBJECT_OBSERVES_OBJECTS
            BNE +
                JMP objectDoesNotObserveObjects
            +

            ;; Object collisions
            SwitchBank #$1C
                JSR doObjectCollisions_bank1C
            ReturnBank

            objectDoesNotObserveObjects:

            ;; Update state
            ;; At ths point, physics and positioning are all figured out. Now
            ;; we update the object. This includes pushing temp positions to
            ;; new positions, handling timers, doing AI mode updates and
            ;; whatnot, etc, and anything that should happen specifically for
            ;; this object in the update state.
            SwitchBank #$18
                TXA
                PHA
                JSR doUpdateState
                JSR doHandleObjectUpdate
                PLA
                TAX
            ReturnBank

            ;; Timer
            SwitchBank #$1C
                TXA
                PHA
                JSR doUpdateActionTimer
                PLA
                TAX

                LDA Object_status,x
                AND #OBJECT_OBSERVES_DRAWING
                BEQ +
                    ;; Lastly, we draw the sprite.
                    ;; The sprite should be drawn anyway, HERE.
                    TXA
                    PHA
                    TYA
                    PHA
                    JSR doDrawSprites
                    PLA
                    TAY
                    PLA
                    TAX

                    JSR doUpdateSpriteTimer
                    .include SCR_DRAW_STATE
                +
            ReturnBank
        objectIsInactive:

        ;; End Object Update.

        INX
        CPX #TOTAL_MAX_OBJECTS ;; A number that is configured in the
                               ;; Object Variables tab of project settings.

        ;; This space makes use of ObjectRam. By default, it is one page in
        ;; size (256 bytes), however, it could stretch into the scratch ram
        ;; if desired allowing for 512 bytes for object use.

        BEQ DoneHandlingObjects
    JMP -handleObjectsLoop

    DoneHandlingObjects:

    RTS

