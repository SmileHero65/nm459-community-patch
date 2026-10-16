    ; Do not shorten an automatic trampoline bounce.
    LDA Object_frame,x
    BMI +skipJump

    ; Shorten a normal jump only while moving upward.
    LDA Object_v_speed_hi,x
    BPL +skipJump
    LDA #$FF
    STA Object_v_speed_hi,x
+skipJump:
    RTS
