
    ;; Load background palettes
    ;; this script runs in-line.

    BIT $2002
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
    loadBackgroundPal_NMI:
        LDA bckPal,x
        STA $2007
        INX
        CPX #$10
    BNE loadBackgroundPal_NMI

    LDA updateScreenData
    AND #%11111110
    STA updateScreenData

