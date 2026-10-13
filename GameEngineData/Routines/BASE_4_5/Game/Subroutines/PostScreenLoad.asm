
;; This script unlocks locked tiles when the screen has been triggered.

LOCK_BLOCK_VALUE = #$06  ;; change this to whatever value you are looking for.
                         ;; here, we're looking to see if the collision type is
                         ;; a lock block, which we currently have in our 6th
                         ;; tile spot.


    GetTrigger
    BNE +
        JMP +doneWithLockTiles
    +

    ;; Before we turn the screen on, check for lock blocks.
    ;; If a tile is a lock block, and the trigger is tripped,
    ;; turn it into a null block.
    LDY #$00
    checkForLockTilesLoop:
        ;; first, do we check colTab1 or colTab2?
        LDA camScreen
        AND #%00000001
        BNE +isOddScreen
            ;; is even screen
            LDA collisionTable,y
            CMP #LOCK_BLOCK_VALUE
            BEQ +isALockTile

            CMP #MONSTER_BLOCK_TILE
            BEQ +isALockTile
                JMP +checkNextTile
            +isALockTile:

            LDA #$00
            STA collisionTable,y

            LDA #$20
            STA temp1
            JMP +doUpdateGraphicsForThisTile

        +isOddScreen:
            LDA collisionTable2,y
            CMP #LOCK_BLOCK_VALUE
            BEQ +isALockTile

            CMP #MONSTER_BLOCK_TILE
            BEQ +isALockTile
                JMP +checkNextTile
            +isALockTile:

            LDA #$00
            STA collisionTable2,y

            LDA #$24
            STA temp1

        +doUpdateGraphicsForThisTile:
        TYA
        STA temp

        LSR
        LSR
        LSR
        LSR
        LSR
        LSR
        CLC
        ADC temp1
        STA temp2

        TYA
        AND #%11110000
        ASL
        ASL
        STA tempz

        TYA
        AND #%00001111
        ASL
        ORA tempz
        STA temp3

        LDA temp2
        STA $2006
        LDA temp3
        STA $2006
        LDA #$00
        STA $2007

        LDA temp2
        STA $2006
        LDA temp3
        CLC
        ADC #$01
        STA $2006
        LDA #$01
        STA $2007

        LDA temp3
        CLC
        ADC #$20
        STA temp3
        LDA temp2
        ADC #$00
        STA temp2

        LDA temp2
        STA $2006
        LDA temp3
        STA $2006
        LDA #$10
        STA $2007

        LDA temp2
        STA $2006
        LDA temp3
        CLC
        ADC #$01
        STA $2006
        LDA #$11
        STA $2007

        +checkNextTile:
        INY
        CPY #$F0 ;; 240 - last collision byte.
        BEQ +doneWithLockTiles
    JMP checkForLockTilesLoop

    +doneWithLockTiles:

