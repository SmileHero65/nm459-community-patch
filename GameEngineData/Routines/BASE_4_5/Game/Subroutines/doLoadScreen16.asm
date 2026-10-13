doLoadScreen16:

    LoadBackgroundPalettes newPal
    ;JSR doWaitFrame

    ;; We wait this frame because the LoadBackgroundPalettes routine
    ;; sets bckpal variables and activates the update palette.
    ;; waiting this frame holds up on the next routine until the
    ;; background palettes are loaded into the PPU.

    LoadObjectSubPalettes spriteSubPal1, #$00
    LoadObjectSubPalettes spriteSubPal2, #$04
    LoadObjectSubPalettes spriteSubPal3, #$08
    LoadObjectSubPalettes spriteSubPal4, #$0C

    ;JSR doWaitFrame

    LDA tileLayout
    CMP #%01000000
    BEQ LOAD_MSP
        JMP notMSP

    LOAD_MSP:
        LDA backgroundTilesToLoad
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$10, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB
        ;; arg0 - bank where graphics live
        ;; arg1 - row
        ;; arg2 - column (by 10s...must end in zero)
        ;; arg3 - how many tiles to load.  If 00, will load whole sheet.
        ;; arg4 - Label in bank 16 table, low.
        ;; arg5 - Label in bank 16 table, hi.
        ;; arg6 - Bank 16 table offset

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+1
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+1
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$16, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB
        ;; load paths.

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+2
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+2
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$18, #$00, #$40, PathCHRAddLo, PathCHRAddHi, tempB

        ;; Load Hud
        LoadChrData #$1E, #$1C, #$00, #$40, OtherChrTiles_Lo, OtherChrTiles_Hi, #$00

        JMP doneLoadingChrs

    notMSP:

    ;;DOUBLE MAIN;;;;;;;;;;;;;;;;;;;;;;;
    CMP #%00000000
    BEQ Load_MM
        JMP notMM

    Load_MM:
        LDA backgroundTilesToLoad
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$10, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        LDA backgroundTilesToLoad+1
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+1
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$16, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        ;; Load Hud
        LoadChrData #$1E, #$1C, #$00, #$40, OtherChrTiles_Lo, OtherChrTiles_Hi, #$00

        JMP doneLoadingChrs
    notMM:

    CMP #%01110000
    BEQ LOAD_MSSS
        JMP notMSSS

    LOAD_MSSS:
        LDA backgroundTilesToLoad
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$10, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+1
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+1
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$16, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+2
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+2
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$18, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+3
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+3
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1A, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;; Load Hud
        LoadChrData #$1E, #$1C, #$00, #$40, OtherChrTiles_Lo, OtherChrTiles_Hi, #$00

        JMP doneLoadingChrs
    notMSSS:

    CMP #%01111100
    BEQ doMSSSSS
        JMP notMSSSSS

    doMSSSSS:
        LDA backgroundTilesToLoad
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$10, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+1
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+1
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$16, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+2
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+2
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$18, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+3
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+3
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1A, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+4
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+4
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1C, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+5
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+5
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1E, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        JMP doneLoadingChrs
    notMSSSSS:

    CMP #%00001100
    BEQ doMMSS
        JMP notMMSS

    doMMSS:
        LDA backgroundTilesToLoad
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$10, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        LDA backgroundTilesToLoad+1
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+1
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$16, #$00, #$60, BckCHRAddLo, BckCHRAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+2
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+2
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1C, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        ;JSR doWaitFrame

        LDA backgroundTilesToLoad+3
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC #$0F
        STA tempA

        LDA backgroundTilesToLoad+3
        AND #%00001111
        STA tempB

        LoadChrData tempA, #$1E, #$00, #$20, BckSSChrAddLo, BckSSChrAddHi, tempB

        JMP doneLoadingChrs
    notMMSS:

    doneLoadingChrs:

    LoadChrData #$15, #$00, #$00, #$80, GameObjectCHRAddLo, GameObjectCHRAddHi, #$00

    LDA monsterTableOffset
    CMP #$08
    BCC inMonsterBank0
        ;; in monster bank 1
        LDA #$14
        JMP gotMonsterBank
    inMonsterBank0:
        LDA #$13
    gotMonsterBank:
    STA temp

    LoadChrData temp, #$08, #$00, #$80, MonsterAddressLo, MonsterAddressHi, monsterTableOffset
    ;; arg0 - bank where graphics live
    ;; arg1 - row
    ;; arg2 - column (by 10s...must end in zero)
    ;; arg3 - how many tiles to load.  If 00, will load whole sheet.
    ;; arg4 - Label in bank 16 table, low.
    ;; arg5 - Label in bank 16 table, hi.
    ;; arg6 - Bank 16 table offset

    ;JSR doWaitFrame

    RTS

