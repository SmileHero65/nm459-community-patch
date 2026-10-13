
    ;; This presumes you have a variable called myKeys.
    ;; This also presumes that variable for keys is drawn in element 5.

    ;; Lock tile

    ;; This part does solid behavior
    LDA ObjectUpdateByte
    ORA #%00000001
    STA ObjectUpdateByte ;; makes solid

    LDA myKeys
    BNE +doUnlockDoor
        RTS ;; no keys, so can not unlock door.
    +doUnlockDoor

    DEC myKeys
    UpdateHudElement #$05 ;; Change #$05 if keys are drawn in a different
                          ;; hud element.

    ;; This part will check the lock:
    LDY temp1
    LDA temp2
    BEQ +isEvenCt
        ;; is an odd ct, so looking in collisionTable2
        LDA #$00
        STA collisionTable2,y
        JMP +doneWithTileUpdate
    +isEvenCt
;       LDA #$00
        STA collisionTable,y
    +doneWithTileUpdate

    ;; This part will actually update the tile with tile 0 in the tile set.
    ;; ys is carried over from above.

    ;; Get the high byte of the tile to change
    LDA temp2
    BEQ +isEvenNt
        ;; is odd nt
        LDA #$24
        JMP +gotNt
    +isEvenNt:
        ;; is even nt
        LDA #$20
    +gotNt:
    STA temp1

    ;; Get the low byte of the tile to change
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

    ;; Set the tile number to change to
    LDA #$00 ;; the tile to change.
             ;; this is in tiles, so if you wanted the second "metatile",
             ;; use 2, not 1.  If you wanted the tile in the next row,
             ;; use #$20, not #$10.  Etc.
    STA tempA

    CLC
    ADC #$01
    STA tempB

    CLC
    ADC #$0F
    STA tempC

    CLC
    ADC #$01
    STA tempD

    LDY #$00

    LDA temp2
    STA scrollUpdateRam,y

    INY
    LDA temp3
    STA scrollUpdateRam,y

    INY
    LDA tempA
    STA scrollUpdateRam,y

    INY
    LDA temp2
    STA scrollUpdateRam,y

    INY
    LDA temp3
    CLC
    ADC #$01
    STA scrollUpdateRam,y

    INY
    LDA tempB
    STA scrollUpdateRam,y

    LDA temp3
    CLC
    ADC #$20
    STA temp3
    LDA temp2
    ADC #$00
    STA temp2

    INY
    LDA temp2
    STA scrollUpdateRam,y

    INY
    LDA temp3
    STA scrollUpdateRam,y

    INY
    LDA tempC
    STA scrollUpdateRam,y

    INY
    LDA temp2
    STA scrollUpdateRam,y

    INY
    LDA temp3
    CLC
    ADC #$01
    STA scrollUpdateRam,y

    INY
    LDA tempD
    STA scrollUpdateRam,y

    INY
    STY maxScrollOffsetCounter

    ;; Turn on update screen on next frame.
    LDA updateScreenData
    ORA #%0000100
    STA updateScreenData

    TriggerScreen screenType

    RTS

