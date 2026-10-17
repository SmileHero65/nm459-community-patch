;; UNDER WHAT CONDITIONS SHOULD WE HIDE THE HUD?
    LDA ScreenFlags00
    AND #%01000000
    BEQ doNotTurnOffHud
        HideHud
        JMP doneWithExtraScreenCheckForHud
    doNotTurnOffHud:
        ShowHud
    doneWithExtraScreenCheckForHud:

;;; ARE THERE ANY SPECIAL CONSIDERATIONS FOR TRIGGERED SCREENS?
    ;;; if a screen is triggered, make the lock block go away.
    GetTrigger
    BNE +screenIsTriggered
        JMP +noTrigger
    +screenIsTriggered

    +noTrigger

    doneWithExtraCheck:
