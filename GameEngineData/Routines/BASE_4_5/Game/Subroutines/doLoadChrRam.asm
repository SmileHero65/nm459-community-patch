
doLoadChrRam:
    ;; this uses the LoadChrData macro
    SwitchBank tempBank
        BIT $2002
        LDA arg1_hold
        STA $2006
        LDA arg2_hold
        STA $2006

        ;; arg3_hold holds the number of tiles to be drawn.

        loadTilesOuterLoop:
            LDA #$10
            STA temp1 ;; tile counter.

            LDY #$00
            loadTilesLoop:
                LDX #$10
                loadChrRamLoop:
                    LDA (temp16),y
                    STA $2007
                    INY
                    DEX
                BNE loadChrRamLoop

                DEC temp1
                BEQ +nextTile

                DEC arg3_hold
            BNE loadTilesLoop

            ;; now a full tile has been loaded.
            +nextTile:

            DEC arg3_hold
            BEQ doneLoadingTiles

            INC temp16+1
        JMP loadTilesOuterLoop

        doneLoadingTiles:
    ReturnBank

    RTS

