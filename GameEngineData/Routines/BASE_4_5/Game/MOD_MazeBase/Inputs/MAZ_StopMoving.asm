;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygrouptrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp             ;; assumes the object we want to move is in x.
    GetActionStep temp     ;; don't move if you're in Action Step...
    CMP #$07            ;; 07 - Hurt
    BNE +notHurt
        RTS
    +notHurt

        ; use this for 4 directional game - adventure
         LDA gamepad
         AND #%11110000
         BEQ changeToStop_NoDpadPressed
         JMP +done

    changeToStop_NoDpadPressed:
        ChangeActionStep temp, #$00 ;; assumes that "idle" is in action 0
        StopMoving temp, #$FF, #$00

        +done
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    RTS