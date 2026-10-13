;;;;;;;;;;;Dale Coop Pause Script;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Pros: Works well and sprites are shown;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Cons: Just works when Releasing the Start Button;;;;;;;;;;;;;;;;;;;;;;;;;
;https://www.nesmakers.com/index.php?threads/4-5-non-textbox-based-pause.5421/;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Pause

LDA textHandler
BEQ +notDrawingText
    RTS ;;; We don't want to pause when text is drawing.
+notDrawingText

LDA isPaused
BNE +unpausegame
    ;;; Disable scrolling
    LDA ScreenFlags00
    ORA #%00100000
    STA ScreenFlags00

    LDA gameStatusByte
    ORA #%00000001 ;;; This will skip object handling.
    STA gameStatusByte
    LDA #$01
    STA isPaused

    ;; We play the pause sfx:
    ;------------------------
    ;PlaySound #SND_PAUSE

    ;; We make the screen dark:
    LDA soft2001
    ORA #%11100000
    STA soft2001
    JMP +thePauseEnd
+unpausegame:
    ;;; Enable scrolling
    LDA ScreenFlags00
    AND #%11011111
    STA ScreenFlags00

    LDA gameStatusByte
    AND #%11111110
    STA gameStatusByte
    LDA #$00
    STA isPaused

    ;; We play the unpause sfx:
    ;--------------------------
    ;PlaySound #SND_UNPAUSE

    ;; We make the screen back normal:
    LDA soft2001
    AND #%00011111
    STA soft2001
+thePauseEnd:

    RTS