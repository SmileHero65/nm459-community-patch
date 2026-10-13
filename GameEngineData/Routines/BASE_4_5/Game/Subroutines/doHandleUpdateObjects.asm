
    LDA ObjectUpdateByte
    AND #%00000001 ;; is it solid?
    BNE +
        JMP maybeUpdatePosition
    +

    ;; Do solid edge behavior for this object
    LDA EdgeSolidReaction
    LSR
    LSR
    LSR
    LSR
    BNE +
        JMP maybeUpdatePosition ;; because 0 is null.
    +

    ;; the reaction was not null.
    CMP #$01
    BNE +
        ;; is one object reaction
        JSR doAiReaction1
        JMP donePositionUpdate
    +

    CMP #$02
    BNE +
        ;; is two object reaction
        JSR doAiReaction2
        JMP donePositionUpdate
    +

    CMP #$03
    BNE +
        ;; is three object reaction
        JSR doAiReaction3
        JMP donePositionUpdate
    +

    CMP #$04
    BNE +
        ;; is four object reaction
        JSR doAiReaction4
        JMP donePositionUpdate
    +

    CMP #$05
    BNE +
        ;; is five object reaction
        JSR doAiReaction5
        JMP donePositionUpdate
    +

    CMP #$06
    BNE +
        ;; is six object reaction
        JSR doAiReaction6
        JMP donePositionUpdate
    +

    ;; must be 7
    JSR doAiReaction7
    JMP donePositionUpdate

    maybeUpdatePosition:
        LDA xHold_lo
        STA Object_x_lo,x
        LDA xHold_hi
        STA Object_x_hi,x

        LDA yHold_lo
        STA Object_y_lo,x
        LDA yHold_hi
        STA Object_y_hi,x

        LDA xHold_screen
        STA Object_screen,x

        JMP donePositionUpdate

    dontUpdateObjectPosition:
        LDA #$00
        STA Object_x_lo,x
        STA Object_y_lo,x
        STA Object_h_speed_hi,x
        STA Object_h_speed_lo,x
        STA Object_v_speed_hi,x
        STA Object_v_speed_lo,x

        LDA xPrev
        STA Object_x_hi,x
        LDA yPrev
        STA Object_y_hi,x

    donePositionUpdate:
    ; RTS


