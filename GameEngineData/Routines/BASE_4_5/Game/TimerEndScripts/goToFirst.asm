
    LDA #$00
    STA tempB

    ;; Hurt end
    LDA Object_frame,x
    AND #%00111000
    CMP #%00111000
    BNE +notHurtFrame
        LDA #$00
        STA Object_h_speed_hi,x
        STA Object_h_speed_lo,x
        STA Object_v_speed_hi,x
        STA Object_v_speed_lo,x
        LDA Object_direction,x
        AND #%00001111
        STA Object_direction,x
    +notHurtFrame:

    LDA Object_frame,x
    AND #%11000111
    STA Object_frame,x

    STX tempA
    DoObjectAction tempA, tempB

