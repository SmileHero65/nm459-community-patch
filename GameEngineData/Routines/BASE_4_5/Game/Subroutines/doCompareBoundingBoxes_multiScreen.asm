
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Fix to Inivisble hurt on the player by CluckFox
;;https://www.nesmakers.com/index.php?threads/enemies-falling-off-ledges-on-the-left-side-cause-player-to-die-in-platformer.6969/page-2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

doCompareBoundingBoxes:

    ;; Here we will check the horizontal collision. First we need to check the
    ;; RIGHT SCREEN + RIGHT BBOX of self against the LEFT SCREEN + LEFT BBOX of
    ;; other. If it is less, then there is no collision.

    LDA self_screen_right
    CMP other_screen_left
    BEQ +theseAreEqual
        ;; the self screen and other screen are not equal.
        ;; But if the self screen is MORE than the other screen,
        ;; it is still possible that this could return a collision.
        JMP +checkOtherSide
    +theseAreEqual:

    ;; CluckFox for Forums - wrap-around glitch test
    LDA other_screen_left
    CMP other_screen_right
    BEQ +keepChecking         ;; other left == other right
    BCC +keepChecking         ;; other left < other right
        JMP +noBboxCollision  ;; other left > other right???
    +keepChecking:

    ;; we need to check the *other* side
    LDA self_screen_left
    CMP other_screen_right
    BEQ +normalBoundsCheck
        ;; this means bounds are being straddled.
        LDA bounds_right
        CMP other_left
        BCC +noBboxCollision
            JMP +hCol

    +normalBoundsCheck:
    ;; the self screen and other screen are equal
    ;; which means now it is a matter of checking the
    ;; self right bbox against the left bbox.
    LDA bounds_right
    CMP other_left
    BCC +noBboxCollision

+checkOtherSide:
    LDA self_screen_left
    CMP other_screen_right
    BEQ +theseAreEqual
        JMP +noBboxCollision
    +theseAreEqual:

    ;; check the *other* side
    LDA self_screen_right
    CMP other_screen_left
    BEQ +normalBoundsCheck
        JMP +noBboxCollision
    +normalBoundsCheck:

    LDA bounds_left
    CMP other_right
    BCS +noBboxCollision

+hCol:
    LDA other_bottom
    CMP bounds_top
    BCC +noBboxCollision

    LDA bounds_bottom
    CMP other_top
    BCC +noBboxCollision

    LDA #$01 ;; read that YES, there was a collision here.
             ;; (could make this the object ID)
    RTS

+noBboxCollision: ;; there is no collision here horizontally.
    LDA #$00      ;; read that NO, there was no collision.
    RTS


getOtherColBox:
    TYA
    PHA

    LDY Object_type,x

    LDA Object_x_hi,x
    CLC
    ADC ObjectBboxLeft,y
    STA other_left

    LDA Object_screen,x
    ADC #$00
    STA other_screen_left

    LDA other_left
    CLC
    ADC ObjectWidth,y
    STA other_right

    LDA Object_screen,x
    ADC #$00
    STA other_screen_right

    LDA other_right
    SEC
    SBC other_left
    LSR
    STA other_center_x

    LDA ObjectBboxTop,y
    CLC
    ADC Object_y_hi,x
    STA other_top

    CLC
    ADC ObjectHeight,y
    STA other_bottom

    SEC
    SBC other_top
    LSR
    STA other_center_y ;; self center in the vertical direction.

    PLA
    TAY

    RTS

