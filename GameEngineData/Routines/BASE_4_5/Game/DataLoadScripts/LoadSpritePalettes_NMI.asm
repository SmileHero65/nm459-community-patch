
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Load sprites palettes;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Quick fix for the 1st background/sprite color palette issue by Dale Coop
;;https://www.nesmakers.com/index.php?threads/4-5-quick-fix-for-the-1st-background-sprite-color-palette-issue.5474/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; this script runs in-line.

    BIT $2002
    LDA #$3F
    STA $2006
    LDA #$11
    STA $2006

    LDX #$01
    loadSpritePal_NMI:
        LDA sprPal,x
        STA $2007
        INX
        CPX #$10
    BNE loadSpritePal_NMI

    LDA updateScreenData
    AND #%11111101
    STA updateScreenData

