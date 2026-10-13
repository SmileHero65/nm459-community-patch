
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
    CheckCollisionAtTileXY

    ;; Check point 2 (the bottom right of the object)
    LDA yHold_hi
    CLC
    ADC self_bottom
    STA tileY
    CheckCollisionAtTileXY

    ;; Check point 3 (the bottom left of the object)
    LDA xHold_hi
    CLC
    ADC self_left
    STA tileX
    CheckCollisionAtTileXY

    ;; Check point 4 (the top left of the object)
    LDA yHold_hi
    CLC
    ADC self_top
    STA tileY
    CheckCollisionAtTileXY

    ;; All checked: load tile offset and type and return
    LDY tempy
    LDA tempA
    ;RTS

