;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Simplified Movement Base - crazygrouptrio;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    STX temp
    GetActionStep temp
    CMP #OBJECT_HURT_STATE
    BEQ +StopBlocked
    CMP #PLAYER_ATTACK_STATE
    BNE +canStop
    +StopBlocked:
        RTS
    +canStop:

        ; use this for 4 directional game - adventure
         LDA gamepad
         AND #%11110000
         BEQ changeToStop_NoDpadPressed
         JMP +done

    changeToStop_NoDpadPressed:
        ChangeActionStep temp, #PLAYER_IDLE_STATE ;; changes to idle state
        StopMoving temp, #$FF, #$00

        +done
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    RTS
