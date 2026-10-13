
    ;; Reset the end result variable
    LDA #$00
    STA tempA
    STA tempy

    ;; Store if current screen is odd or even in a temp variable
    LDA xHold_screen
    AND #%00000001
    STA tempx

    ;; Check point 1 (the top right of the object)
    LDA yHold_hi
    CLC
    ADC self_top
    STA tileY

    LDA xHold_hi
    CLC
    ADC self_right
    STA tileX
    BCC +getTileOffset
        ;; We've crossed a page boundary; flip the screen number
        LDA tempx
        EOR #%00000001
        STA tempx
    +getTileOffset:
    CheckCollisionAtTileXY

    ;; Check point 2 (the bottom right of the object)
    LDA yHold_hi
    CLC
    ADC self_bottom
    STA tileY
    CheckCollisionAtTileXY

    ;; Check point 3 (the middle right of the object)
    LDA self_bottom
    SEC
    SBC self_top
    LSR
    CLC
    ADC yHold_hi
    CLC
    ADC self_top
    STA tileY
    CheckCollisionAtTileXY

    ;; Reset xHold_screen for left boundary check
    LDA xHold_screen
    AND #%00000001
    STA tempx

    ;; Check point 4 (the middle left of the object)
    LDA xHold_hi
    CLC
    ADC self_left
    STA tileX
    BCC +getTileOffset
        ;; We've crossed a page boundary; flip the screen number
        LDA tempx
        EOR #%00000001
        STA tempx
    +getTileOffset:
    CheckCollisionAtTileXY

    ;; Check point 5 (the bottom left of the object)
    LDA xHold_hi
    CLC
    ADC self_left
    STA tileX
    CheckCollisionAtTileXY

    ;; Check point 6 (the top left of the object)
    LDA yHold_hi
    CLC
    ADC self_top
    STA tileY
    CheckCollisionAtTileXY

    ;; All checked: load tile offset and type and return
    LDY tempy
    LDA tempA
    ;RTS

