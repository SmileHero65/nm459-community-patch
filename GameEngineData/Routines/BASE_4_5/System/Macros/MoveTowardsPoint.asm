
MACRO MoveTowardsPoint arg0, arg1, arg2, arg3
    ;; arg0 = point of origin, x
    ;; arg1 = point of origin, y
    ;; arg2 = point to move towards, x
    ;; arg3 = point to move towards, y

    TXA
    PHA
    TYA
    PHA

    LDA arg0
    STA arg0_hold
    LDA arg1
    STA arg1_hold
    LDA arg2
    STA arg2_hold
    LDA arg3
    STA arg3_hold

    STX tempx
    SwitchBank #$18
        JSR doMoveTowardsPoint
    ReturnBank
    LDX tempx

    LDA tempA
    STA Object_h_speed_lo,x
    LDA #$00
    STA Object_h_speed_hi,x
    LDA tempB
    STA Object_v_speed_lo,x
    LDA #$00
    STA Object_v_speed_hi,x

    PLA
    TAY
    PLA
    TAX
ENDM

