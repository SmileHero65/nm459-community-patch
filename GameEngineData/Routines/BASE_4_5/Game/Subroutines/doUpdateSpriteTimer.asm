
;;Do update object timers with EndAnimation working with 8 Frames Animation by DaleCoop
;;https://www.nesmakers.com/index.php?threads/4-5-9-end-animation-not-working-with-8-frame-animations-fix.7557/

    ;; Check to see if this object in this state animates.
    ;; If the animation speed is zero, it does not animate.
    DEC Object_animation_timer,x
    LDA Object_animation_timer,x
    BEQ endOfAnimTimer
        JMP animationTimerNotFinished
    endOfAnimTimer:

    ;; here, the animation timer has rounded down to zero.
    ;; so we will increase the frame
    LDA Object_frame,x
    ;AND #%00000111
    CLC
    ADC #%00000001
    AND #%00000111
    BEQ atMaxAnimFrame    ;; dale_coop: fix the end animation with 8 frames
        CMP animationFrameHolder
        BNE notAtMaxAnimFrame
    atMaxAnimFrame:       ;; dale_coop: fix the end animation with 8 frames

    ;; Is at max anim frame, so set anim to 00.
    ;; Here, we have reached the max anim frame.
    ;; we need to check to see what we should do if the max anim is reached.
    LDY Object_type,x
    LDA EndActionAnimationTableLo,y
    STA pointer
    LDA EndActionAnimationTableHi,y
    STA pointer+1

    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    TAY

    LDA (pointer),y
    LSR
    LSR
    LSR
    LSR
    STA tempD

    ;LDA tempD
    TAY

    LDA EndAnimAndActions_Lo,y
    STA temp16
    LDA EndAnimAndActions_Hi,y
    STA temp16+1
    JSR doTemp16

    LDA #$00

    notAtMaxAnimFrame:
    STA temp

    LDA Object_frame,x
    AND #%11111000
    ORA temp
    STA Object_frame,x

    ;; here, we will reset the animation timer.
    LDY Object_type,x
    LDA ObjectAnimationSpeedTableLo,y
    STA temp16
    LDA ObjectAnimationSpeedTableHi,y
    STA temp16+1

    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    TAY

    LDA (temp16),y  ;; this now points to the proper spot on the
                    ;; anim speed table.
                    ;; we need to capture that number.
                    ;; Its high nibble is the "animation type"
    AND #%00001111  ;; Now we have a value 0-16. This correlates to animation
                    ;; speed, but it probably shouldn't be a one-to-one
                    ;; comparision.
    ASL
    ASL
    STA Object_animation_timer,x

    animationTimerNotFinished:

