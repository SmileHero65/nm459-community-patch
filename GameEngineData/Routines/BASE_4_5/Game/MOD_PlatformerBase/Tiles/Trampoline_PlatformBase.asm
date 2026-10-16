;;;; trampoline
    CPX player1_object
    BNE +skip
    LDA Object_v_speed_hi,x
    BEQ +skip
    BMI +skip

        ChangeActionStep player1_object, #PLAYER_JUMP_STATE
        LDX player1_object
        LDA #$00
        STA Object_v_speed_lo,x
        SEC
        SBC #BOUNCE_STRENGHT
        STA Object_v_speed_hi,x

        ; Mark this jump as an automatic bounce.
        LDA Object_frame,x
        ORA #%10000000
        STA Object_frame,x

    +skip
    RTS
