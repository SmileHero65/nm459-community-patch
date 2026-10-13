
;; @TODO  Either move this to macros, or remove if unused

MACRO UpdateHudTiles arg0, arg1, arg2, arg3, arg4
    ;; This macro is similar to the DrawTilesDirect macro; however, it draws
    ;; when the screen is turned on.
    ;;
    ;; arg0: bank
    ;; arg1: label
    ;; arg2: x
    ;; arg3: y
    ;; arg4: offset

    LDA arg0
    STA arg0_hold
    LDA arg1
    STA arg1_hold
    LDA arg2
    STA arg2_hold
    LDA arg3
    STA arg3_hold
    LDA arg4
    STA arg4_hold

    JSR doUpdateHudTiles
ENDM

