  ;; UNDER WHAT CONDITIONS SHOULD WE HIDE THE HUD?
    LDA ScreenFlags00
    AND #%01000000
    BEQ +show
        HideHud
        JMP +continue
    +show:
        ShowHud
    +continue:

;    ;; Are there any special considerations for triggered screens?
;    ;; For example: if a screen is triggered, should the lock block go away?
;
;    GetTrigger
;    BNE +screenIsTriggered
;        JMP +noTrigger
;    +screenIsTriggered
;
;    +noTrigger
;
;    doneWithExtraCheck:

