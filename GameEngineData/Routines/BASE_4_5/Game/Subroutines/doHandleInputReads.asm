
doHandleInputReads:
    ;; Do GamePadCheck
    LDA #$01
    STA $4016
    LSR
    STA $4016

    LDA #$80
    STA gamepad
    STA gamepad2

    -readControllerBytesLoop:
        LDA $4016
        AND #%00000011
        CMP #%00000001
        ROR gamepad
        LDA $4017
        AND #%00000011
        CMP #%00000001
        ROR gamepad2
    BCC -readControllerBytesLoop
    ;; END GamePadCheck

    ;; Read input definitions
    TXA
    PHA
    TYA
    PHA

    ;; @TODO  Verify we can omit this code
;   LDA currentBank
;   STA tempBank

    LDA gamepad
    STA gamepad_hold
    LDA buttonStates
    STA buttonStates_hold

    LDA #$00
    STA controllerNumber_hold

    JSR doCheckControllerInputStates

    LDA gamepad2
    STA gamepad_hold
    LDA buttonStates2
    STA buttonStates_hold

    LDA #$01
    STA controllerNumber_hold

    JSR doCheckControllerInputStates

    PLA
    TAY
    PLA
    TAX

    LDA gamepad
    STA buttonStates
    LDA gamepad2
    STA buttonStates2

    RTS


findObjectOfType:
    LDX #$00
    -findObjectOfTypeLoop:
        LDA Object_type,x
        CMP tempB
        BEQ xIsNowCorrect

        INX
        CPX #TOTAL_MAX_OBJECTS
    BNE -findObjectOfTypeLoop

    LDX #$FF

    xIsNowCorrect:
    RTS


doCheckControllerInputStates:
    ;; Handle held inputs
    LDA #HELD_INPUTS
    BNE +
        JMP +checkPressedInputs
    +

    LDA #$00
    STA loopTemp

    -heldInputsLoop:
        LDX loopTemp ;; Set x temporarily to loopTemp variable for table reads.
                     ;; We need to check to see if this input uses current
                     ;; game state. If not, skip it.
        LDA DefinedScriptGameStates_Held,x
        CMP gameState
        BEQ +
            JMP +checkNextHeldInput
        +

        LDA DefinedTargetController_Held,x
        CMP controllerNumber_hold
        BEQ +
            JMP +checkNextHeldInput
        +

        ;; now check gamepad variable against the
        ;; DefinedInputs table to see if the current
        ;; gamepad state matches any of the chosen inputs.

        LDA buttonStates_hold
        AND DefinedInputs_Held,x ;; this AND checks button states and logically
                                 ;; only checks about those states being asked
                                 ;; about. If we remove this, the buttons have
                                 ;; to be in the exact input state as
                                 ;; DefinedInputs_Pressed.  With it in, left
                                 ;; will still do left things even if b-button
                                 ;; is pressed, for example.
        CMP DefinedInputs_Held,x
        BNE +checkNextHeldInput
            LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT BEING
                         ;; CALLED from the ScriptAddress table.
            LDA DefinedTargetObjects_Held,y ;; this is the type of object we're
                                            ;; looking for.
            STA tempB
            JSR findObjectOfType
            CPX #$FF
            BEQ +checkNextHeldInput

            LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT
                         ;; BEING CALLED from the ScriptAddress table.
            LDA DefinedTargetScripts_Held,y
            TAY

            LDA ScriptAddressLo,y
            STA temp16
            LDA ScriptAddressHi,y
            STA temp16+1
            JSR doTemp16
        +checkNextHeldInput:

        INC loopTemp
        LDA loopTemp
        CMP #HELD_INPUTS ;; the total number of scripts to jump through
        BCS +checkPressedInputs
    JMP -heldInputsLoop


    ;; Pressed
    +checkPressedInputs:

    LDA #PRESSED_INPUTS
    BNE +
        JMP +checkReleasedInputs
    +

    LDA #$00
    STA loopTemp

    -pressedInputsLoop:

        LDX loopTemp ;; Set x temporarily to loopTemp variable for table reads
                     ;; We need to check to see if this input uses current game
                     ;; stat. If not, skip it.
        LDA DefinedScriptGameStates_Pressed,x
        CMP gameState
        BEQ +
            JMP +checkNextPressedInput
        +

        LDA DefinedTargetController_Pressed,x
        CMP controllerNumber_hold
        BEQ +
            JMP +checkNextPressedInput
        +

        LDA buttonStates_hold
        AND DefinedInputs_Pressed,x
        BNE +checkNextPressedInput

        LDA gamepad_hold
        AND DefinedInputs_Pressed,x
        BEQ +checkNextPressedInput

        ;; Trampoline
        LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT BEING CALLED
                     ;; from the ScriptAddress table
        LDA DefinedTargetObjects_Pressed,y ;; this is the type of object we're looking for.
        STA tempB
        JSR findObjectOfType
        CPX #$FF
        BEQ +checkNextPressedInput

            LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT BEING
                         ;; CALLED from the ScriptAddress table.
            LDA DefinedTargetScripts_Pressed,y
            TAY

            LDA ScriptAddressLo,y
            STA temp16
            LDA ScriptAddressHi,y
            STA temp16+1
            JSR doTemp16
        +checkNextPressedInput:

        INC loopTemp
        LDA loopTemp
        CMP #PRESSED_INPUTS ;;; the total number of scripts to jump through
        BCS +checkReleasedInputs
    JMP -pressedInputsLoop


    ;; Released
    +checkReleasedInputs:
    LDA #RELEASED_INPUTS
    BNE +
        JMP +doneCheckingInputs
    +

    LDA #$00
    STA loopTemp

    -releasedInputsLoop:
        LDX loopTemp ;; set x temporarily to loopTemp variable for table reads
                     ;; we need to check to see if this input uses current game
                     ;; state. if not, skip it.
        LDA DefinedScriptGameStates_Released,x
        CMP gameState
        BEQ +
            JMP +checkNextReleasedInput
        +

        LDA DefinedTargetController_Released,x
        CMP controllerNumber_hold
        BEQ +
            JMP +checkNextReleasedInput
        +

        ;; now check gamepad variable against the
        ;; DefinedInputs table to see if the current
        ;; gamepad state matches any of the chosen inputs.

        LDA buttonStates_hold
        AND DefinedInputs_Released,x
        BEQ +checkNextReleasedInput

        LDA gamepad_hold
        AND DefinedInputs_Released,x
        BNE +checkNextReleasedInput

            ;; TRAMPOLINE
            LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT BEING
                         ;; CALLED from the ScriptAddress table.
            LDA DefinedTargetObjects_Released,y ;; this is the type of object
                                                ;; we're looking for.
            STA tempB

            JSR findObjectOfType
            CPX #$FF
            BEQ +checkNextReleasedInput

            LDY loopTemp ;; THIS NEEDS TO EQUAL THE INDEX OF THE SCRIPT BEING
                         ;; CALLED from the ScriptAddress table.
            LDA DefinedTargetScripts_Released,y
            TAY

            LDA ScriptAddressLo,y
            STA temp16
            LDA ScriptAddressHi,y
            STA temp16+1
            JSR doTemp16
        +checkNextReleasedInput:

        INC loopTemp
        LDA loopTemp
        CMP #RELEASED_INPUTS ;;; the total number of scripts to jump through
        BCS +doneCheckingInputs
    JMP -releasedInputsLoop

    +doneCheckingInputs:

    RTS

