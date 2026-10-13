;;;;;;;;;;;Cuttercross Pause Script;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Pros: Stops Autoscroll;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Works when Pressing the Start Button;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;Cons: By default, sprites are not shown;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;https://www.nesmakers.com/index.php?threads/4-5-6-non-textbox-pause-script.6339/;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    LDA gameStatusByte
    AND #%00000001
    BNE unpausegame
    INC gameStatusByte
    ;; OPTIONAL: Play pause sfx:
    ;PlaySound #SND_PAUSE
    ;; OPTIONAL: Make the screen dark - set all 3 emphasis bits of $2001 to 1
    LDA soft2001
    ORA #%11100000
    STA soft2001
    RTS
unpausegame:
    LDA gameStatusByte
    AND #%11111110
    STA gameStatusByte
    ;; OPTIONAL: Play unpause sfx:
    ;PlaySound #SND_UNPAUSE
    ;; OPTIONAL: Make the screen normal - set all 3 emphasis bits of $2001 to 0
    LDA soft2001
    AND #%00011111
    STA soft2001
    RTS