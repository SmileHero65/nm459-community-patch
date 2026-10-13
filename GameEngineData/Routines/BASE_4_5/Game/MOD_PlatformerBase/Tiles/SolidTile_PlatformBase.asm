;;Fix abrupt stop when player collides with solid above;;;;;;;;;
;;https://www.nesmakers.com/index.php?threads/4-5-9-physics-script-help-abrupt-stop-when-player-collides-with-solid-above.7133/#post-52144
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Note: in order for this to work:
;;
;;             1 - The player's acceleration must be 255
;;            2 - The height and width of your player's bounding box must be multiples of 8.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SOLID FOR ALL OBJECTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    LDA ObjectUpdateByte
    ORA #%00000001
    STA ObjectUpdateByte

;;; CHECK SOLID ABOVE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    LDY Object_type,x
    LDA Object_x_hi,x
    CLC
    ADC self_left
    STA temp
    JSR getPointColTable

    LDA Object_y_hi,x
    CLC
    ADC self_top
    CLC
    ADC Object_v_speed_hi,x
    SEC
    SBC #$01
    STA temp1
    CheckCollisionPoint temp, temp1, #$01, tempA
    BNE dontStopVerticalMovement

;;; STOP VERTICAL MOVEMENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    LDA yPrev
    STA Object_y_hi,x
    STA yHold_hi

dontStopVerticalMovement: