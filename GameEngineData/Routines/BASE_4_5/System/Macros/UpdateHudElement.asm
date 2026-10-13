
MACRO UpdateHudElement arg0
    ;; arg 0 = which element to update.

    ;;;Update multiple HUD elements simultaneously
    ;;;https://www.nesmakers.com/index.php?threads/update-multiple-hud-elements-simultaneously-4-5-9.8360/
    ;;;by Dale Coop

    TYA
    PHA

    LDY arg0
    LDA hudUpdates                ;; dale_coop: for multiple updates at once
    ORA ValToBitTable_inverse,y   ;; dale_coop: for multiple updates at once
    STA hudUpdates

    PLA
    TAY
ENDM

