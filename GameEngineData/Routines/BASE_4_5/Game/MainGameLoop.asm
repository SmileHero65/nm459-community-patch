
;; Main game loop
MainGameLoop:

    ;; Wait for NMI (unless potential frame drop)
    LDA waiting
    BEQ +
        LDA vBlankTimer
        -
            CMP vBlankTimer
        BEQ -
    +
    INC waiting

    ;; Check if game is in "normal game loop" mode
    ;; If not, skip the normal game loop
    LDA gameHandler
    AND #%10000000
    BEQ +
        JMP +handleUpdateScreen
    +

    ;; Handle box updates that need to be carried over a frame
    LDA queueFlags
    AND #%00000101
    BNE +
        JMP dontDoBoxUpdate
    +
    TXA
    PHA
    TYA
    PHA
    JSR doDrawBox
    PLA
    TAY
    PLA
    TAX


dontDoBoxUpdate:

    ;; Handle text updates that need to be carried over a frame
    LDA textHandler
    BEQ +
        JSR doDrawText
    +

    ;; Read controller inputs
    SwitchBank #$1A
        JSR doHandleInputReads
    ReturnBank

    ;; Reset sprite RAM pointer
    LDA #$00
    STA spriteRamPointer

    ;; Do screen pre-draw
    SwitchBank #$18
        JSR doScreenPreDraw
    ReturnBank

    ;; Handle objects (drawing, tile collisions, object collisions, ...)
    JSR doHandleObjects

    ;; Update camera
    JSR doCamera

    ;; Do screen post-draw
    SwitchBank #$18
        JSR doScreenPostDraw

        ;; Handle the game timer(s)
        .include SCR_HANDLE_GAME_TIMER
    ReturnBank

    ;; Move unused sprites off screen
    JSR doCleanUpSpriteRam


+handleUpdateScreen:

    ;; Do screen update (if needed)
    JSR doHandleUpdateScreen

    ;; Prepare music updates
    SwitchBank #$1B
        JSR doHandleUpdateMusic
    ReturnBank

    ;; Repeat main game loop routine
    JMP MainGameLoop

