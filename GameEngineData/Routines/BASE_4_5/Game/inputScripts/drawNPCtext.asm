
;;Prevent button mashing during text boxes fix by Dale Coop
;;https://www.nesmakers.com/index.php?threads/4-5-9-prevent-button-mashing-during-text-boxes.8424/

NPC_WIDTH = #$10
NPC_HEIGHT = #$10


    ;; checking if the text box is already displayed
    LDA gameStatusByte
    AND #%00000001
    BEQ +continue
        ;; we also check if text box is about to be drawn/currently drawing
        LDA textQueued
        AND #%00000011
        BEQ +skip
            JMP dontSkipNPCtext
        +skip:

        RTS
    +continue:

    LDX player1_object
    LDA Object_direction,x
    AND #%00000111
    TAY

    LDA NpcFocusTableX,y
    STA tempA
    LDA NpcFocusTableY,y
    STA tempB

    LDA Object_x_hi,x
    CLC
    ADC tempA
    STA tempC

    LDA Object_y_hi,x
    CLC
    ADC tempB
    STA tempD

    LDX #$00
    checkForNpcLoop:
        LDA Object_status,x
        AND #%10000000
        BNE +keepChecking
            JMP +noNPCcollision
        +keepChecking

        ;; we have confirmed it is active.
        LDA Object_flags,x
        AND #%10000000
        BNE +keepChecking
            JMP +noNPCcollision
        +keepChecking

        ;; we have confirmed it is an NPC type.
        LDA tempC
        CMP Object_x_hi,x
        BCC +noNPCcollision

        ;; still possible.
        LDA Object_x_hi,x
        CLC
        ADC #NPC_WIDTH
        CMP tempC
        BCC +noNPCcollision

        ;; still possible
        LDA tempD
        CMP Object_y_hi,x
        BCC +noNPCcollision

        LDA Object_y_hi,x
        CLC
        ADC #NPC_HEIGHT
        CMP tempD
        BCC +noNPCcollision

            LDA Object_id,x

            ;TXA
            ;PHA
            LDA stringGroupPointer,x
            STA npc_text
            ;PLA
            ;TAX

            LDA npcTrigger
            ORA #%00000001
            STA npcTrigger

            JMP +doNpc
        +noNPCcollision:

        INX
        CPX #TOTAL_MAX_OBJECTS
    BNE checkForNpcLoop

    RTS

    +doNpc:

    LDA npcTrigger
    AND #%00000001
    BNE dontSkipNPCtext
        RTS
    dontSkipNPCtext:

    DrawBox #BOX_1_ORIGIN_X, #BOX_1_ORIGIN_Y, #BOX_1_WIDTH , #BOX_1_HEIGHT, #TEXT_NPC, npc_text
    ;; arg0: x
    ;; arg1: y
    ;; arg2: width
    ;; arg3: height
    ;; arg4: text mode
    ;;   - #TEXT_NPC pulls from the index in the following argument.
    ;;   - #TEXT_FREE allows you to just write a label definition in the
    ;;     following argument, and as long as you're in the right bank, will
    ;;     draw it.
    ;; arg5: string or index.


NpcFocusTableX:
    ;; DOWN  DR    RIGHT   UR  UP    UL    LEFT  DL
    .db #$08, #$00, #$18, #$00, #$08, #$00, #$F8, #$00

NpcFocusTableY:
    .db #$18, #$00, #$08, #$00, #$F8, #$00, #$08, #$00

