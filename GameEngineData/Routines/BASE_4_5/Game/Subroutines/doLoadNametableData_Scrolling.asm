;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Removes Paths and HUD loads
;;from Method for Freeing Some Space & Reduce Glitched Tiles in Scrolling Modules by Smile Hero
;;https://www.nesmakers.com/index.php?threads/4-5-9-updated-method-for-freeing-some-space-reduce-glitched-tiles-in-scrolling-modules.8657/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

doLoadNametableData:
    ;; arg0_hold = screen bank
    ;; arg1_hold has the screen index, if it is needed.
    ;; arg2_hold has screen bits.
    ;;  - bit 0: overworld (0) or underworld (1)
    ;;  - bit 1: metaTable (0) or 8x8 table (1)
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

    ;; Now we can use the (pointer) to know the PPU address to write the
    ;; nametable, whilte (temp16) denotes where the nametable data is being
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

        doneDrawingThisMetatile:
            INY
            DEC tempB ;; is a surrogate for columns
            LDA tempB
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
                BNE dontWaitFrame
                    JSR doWaitFrame
                dontWaitFrame:
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
    BNE notBlankTile
        LDA temp
        CMP #$F5
        BEQ isBlankTile
        CMP #$FD
        BEQ isBlankTile ;; solid "RED" translate
        CMP #$FE
        BEQ isBlankTile ;; solid "GREEN" translate
        CMP #$FF
        BEQ isBlankTile ;; solid "BLACK" translate
            JMP notBlankTile
        isBlankTile:

        ;; it was a blank tile. They are all now blank tiles
        STA updateTile_00
        STA updateTile_01
        STA updateTile_02
        STA updateTile_03
        RTS
    notBlankTile:

    LDA temp            ;; dale_coop
    STA updateTile_00

    INC temp
    LDA temp
    STA updateTile_01

    ;; now, what we need is a row down from our current position...
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
    STA $2007 ;; write 1
    LDA updateTile_01
    STA $2007 ;; write 2

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

