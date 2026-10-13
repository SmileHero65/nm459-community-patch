
doLoadScreen:
    ;; zero out objects
    JSR doClearAllMonsters

    LDA currentNametable
    AND #%00000001
    BEQ isEvenNtForcamFocus_tiles
        LDA #$24
        STA camFocus_tiles
        LDA #$27
        STA camFocus_att
        JMP gotcamFocus_tiles_forScreenLoad
    isEvenNtForcamFocus_tiles
        LDA #$20
        STA camFocus_tiles
        LDA #$23
        STA camFocus_att
    gotcamFocus_tiles_forScreenLoad:

    LDA currentNametable
    LSR
    LSR
    LSR
    LSR
    LSR
    STA temp ;; this is the screen bank.

    LDA warpMap ;; and other screen bytes needed - warp map is either 0 or 1
    STA temp2

    LoadScreenTableData temp, currentNametable, temp2
    ;; Loads from the collision table, all of the screen info that needs to be
    ;; loaded. This needs to be BEFORE nametable, because it will determine if
    ;; we're loading a meta table or a full table.

    .include SCR_EXTRA_SCREEN_LOAD

    ;;;;;;Moved to Load Screen 16;;;;;;
    ;;https://www.nesmakers.com/index.php?threads/4-5-x-move-doloadscreen-to-bank-16.7019/
    SwitchBank #$16
        JSR doLoadScreen16
    ReturnBank

    LDA currentNametable
    AND #%00000001
    BNE isOddNametable_loadToRightNT
        ;;is even nametable.  20/23
        LDA #$20
        STA tempx
        LDA #$23
        STA tempy
        JMP gotStartingNT
    isOddNametable_loadToRightNT:
        LDA #$24
        STA tempx
        LDA #$27
        STA tempy
    gotStartingNT:

    ;; check if load full or meta nametable
    LDA screenLoadTemps
    AND #%10000000
    BEQ loadMetaNametable

        ;;; load 8x8 nametable.
        LDA currentNametable
        LSR
        LSR
        LSR
        LSR
        LSR
        STA temp ;; this is the screen bank.

        LDA warpMap
        STA temp2

        LoadNametableDataFull temp, currentNametable, temp2, tempx
        Jmp DoneLoadingNametable_metaOr8x8x
    loadMetaNametable:

    LDA currentNametable
    LSR
    LSR
    LSR
    LSR
    LSR
    STA temp ;; this is the screen bank.

    LDA warpMap
    STA temp2

    LoadNametableData temp, currentNametable, temp2, #$10, #$0f, tempx, #$00, #$00

    DoneLoadingNametable_metaOr8x8x:

    ;JSR doWaitFrame

    LDA currentNametable
    LSR
    LSR
    LSR
    LSR
    LSR
    STA temp ;; this is the screen bank.

    LDA warpMap
    STA temp2

    LoadAttributeData temp, currentNametable, temp2, #$08, #$08, tempy, #$C0, #$00

    ;JSR doWaitFrame

    LDA currentNametable
    LSR
    LSR
    LSR
    LSR
    LSR
    STA temp ;; this is the screen bank.

    LDA warpMap
    STA temp2

    LoadCollisionData temp, currentNametable, temp2, #$10, #$0F, #$00, #$00, #$00

    ;JSR doWaitFrame

    LDX player1_object
    LDA newX
    STA Object_x_hi,x
    LDA newY
    STA Object_y_hi,x

    LDA screenUpdateByte
    AND #%00000100
    BEQ nevermindSettingNewContinueByte
        LDA warpMap
        STA continueMap
        LDA currentNametable
        STA continueScreen
        LDA newX
        STA continueX
        LDA newY
        STA continueY
        LDA screenUpdateByte
        AND #%11111011
        STA screenUpdateByte
    nevermindSettingNewContinueByte:

    ;JSR doWaitFrame

    ;; In case we want to do something custom, edit the post screen load script.
    .include SCR_POST_SCREEN_LOAD

    LDA #%00011110
    STA soft2001
    JSR doWaitFrame

    RTS

