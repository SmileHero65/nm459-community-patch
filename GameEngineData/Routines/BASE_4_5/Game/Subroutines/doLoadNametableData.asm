;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Fixed graphical glitches after warping WITHOUT buffer screens by Dale Coop
;; https://www.nesmakers.com/index.php?threads/4-5-x-how-to-fix-graphical-glitches-after-warping-without-buffer-screens.7295/#post-40092
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

doLoadNametableData:
    ;; arg0_hold = screen bank
    ;; arg1_hold has the screen index, if it is needed.
    ;; arg2_hold has screen bits.
    ;;  - bit 0: overworld (0) underworld (1)
    ;;  - bit 1: metaTable (0) 8x8 table (1)
    ;; arg3_hold = columns to load
    ;; arg4_hold = rows to load
    ;; arg5_hold = start position hi
    ;; arg6_hold = start position lo
    ;; arg7_hold = start column

    ;; decreasing arg3_holder / arg4_holder will track if there are more
    ;; columns/rows to load. If zero, that part is done.
    LDA arg6_hold
    STA pointer
    LDA arg5_hold
    STA pointer+1

    LDA arg3_hold
    STA tempB ;; we will use tempB to hold the number of columns, so when we
              ;; start a new row, we can return to the proper number of columns.

    ;; now we can use the (pointer) to know the PPU address to write the
    ;; nametable, while (temp16) denotes where the nametable data is being
    ;; pulled from.

    SwitchBank arg0_hold

        LDY arg7_hold ;; in what column should the nametable begin?
        loop_LoadNametableMeta:
            BIT $2002
            LDA pointer+1
            STA $2006
            LDA pointer
            STA $2006

            LDA (temp16),y
            STA temp

            ;; now we have to do an evaluation, to compare this to potential
            ;; "blank" values and paths.
            JSR doGetSingleMetaTileValues
            JSR doDrawSingleMetatile

            ;; We're done drawing this metatile
            INY
            DEC tempB ;; is a surrogate for columns
            BEQ doneWithMetaTileColumn
                LDA pointer
                CLC
                ADC #$02
                STA pointer
                JMP loop_LoadNametableMeta
            doneWithMetaTileColumn:

            DEC arg4_hold
            LDA arg4_hold
            BEQ noMoreMetaTilesToLoad
                CMP #$08
                BNE +
                    JSR doWaitFrame
                +

                LDA arg3_hold
                STA tempB ;; resets the amount of columns.

                ;; calculate based on the number of columns drawn
                ;; where the "beginning of the column" should be,
                ;; and skip down to the next free line.

                ASL
                STA tempC

                LDA pointer
                CLC
                ADC #$02
                SEC
                SBC tempC
                CLC
                ADC #$40
                STA pointer

                LDA pointer+1
                ADC #$00
                STA pointer+1

                ;; now, calculate where y should read from
                ;; based on the number of columns being drawn.
                TYA
                CLC
                ADC #$10
                SEC
                SBC arg3_hold
                TAY
            JMP loop_LoadNametableMeta
        noMoreMetaTilesToLoad:

    ReturnBank
    RTS


doGetSingleMetaTileValues:
    STA temp

    LDA screenLoadTemps
    AND #%10000000
    BNE notPath
    LDA temp

    CMP #$f5
    BEQ isBlankTile
    CMP #$FD
    BEQ isBlankTile ;isFDtile ;; solid "RED" translate
    CMP #$FE
    BEQ isBlankTile ;isFEtile ;; solid "GREEN" translate
    CMP #$FF
    BEQ isBlankTile ;isFFtile ;; solid "BLACK" translate

        JMP notBlankTile
    isBlankTile:

    ;; it was a blank tile.  They are all now blank tiles
    STA updateTile_00
    STA updateTile_01
    STA updateTile_02
    STA updateTile_03
    RTS

    notBlankTile:

    ;; check for screen modes.
    LDA tileLayout
    CLC                ;; dale_coop
    CMP #%01000000
    BEQ checkForPathUpdates
        CMP #%01100000
        BEQ checkForPathUpdates1
            ;; This does not use paths, so just restore the temp value and
            ;; proceed with metatiles as if it wasn't a path value.
            LDA temp
            JMP notPath
            RTS
        checkForPathUpdates1:

        ;; This mode uses only the first two "paths" as paths.
        LDA temp
        CLC            ;; dale_coop
        CMP #$A0
        BEQ doPathUpdate

        CMP #$B0
        BEQ doPathUpdate

        JMP notPath
    checkForPathUpdates:

    ;; This mode uses all four "paths" as paths.

    LDA temp
    CLC            ;; dale_coop
    CMP #$80
    BEQ doPathUpdate

    CMP #$90
    BEQ doPathUpdate

    CMP #$A0
    BEQ doPathUpdate

    CMP #$B0
    BEQ doPathUpdate
        JMP notPath
    doPathUpdate:

    ;; now we have to do evaluations of other tiles around us to know
    ;; exactly what to draw here.
    JSR doHandlePath
    RTS

    notPath:
    LDA temp            ;; dale_coop
    STA updateTile_00

    INC temp
    LDA temp
    STA updateTile_01

    ;; Now, what we need is a row down from our current position...
    ;; updateNT_pointer and temp, increased to its next row.
    CLC
    ADC #$0F
    STA temp
    STA updateTile_02

    INC temp
    LDA temp
    STA updateTile_03
    RTS


doDrawSingleMetatile:
    BIT $2002
    LDA pointer+1
    STA $2006
    LDA pointer
    STA $2006

    LDA updateTile_00
    STA $2007  ;; write 1
    LDA updateTile_01
    STA $2007  ;; write 2

    ;; now, what we need is a row down from our current position...
    ;; pointer and temp, increased to its next row.
    BIT $2002
    LDA pointer+1
    STA $2006
    LDA pointer
    CLC
    ADC #$20 ;; dont store it into pointer
             ;; because then it will be easy to just add 2 to
             ;; for the next place to write.
    STA $2006

    ;; now get the tile
    LDA updateTile_02
    STA $2007 ;; write 3
    LDA updateTile_03
    STA $2007 ;; write 4

    RTS


doHandlePath:
    TXA
    PHA
    TYA
    PHA
    .include SCR_HANDLE_PATHS
    PLA
    TAY
    PLA
    TAX
    RTS

