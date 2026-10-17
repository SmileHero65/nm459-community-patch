;;;;;;;
;;;;;;;
;; UNDER WHAT CONDITION SHOULD WE HIDE HUD?
    LDA ScreenFlags00
    AND #%01000000
    BEQ doNotTurnOffHud
        HideHud
        JMP doneWithExtraScreenCheckForHud
    doNotTurnOffHud:
        ShowHud
    doneWithExtraScreenCheckForHud:



    doneWithExtraCheck:
