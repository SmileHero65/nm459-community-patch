
MACRO CheckCollisionAtTileXY
    JSR GetTileAtPosition
    LDA tempx
    BEQ +evenCollisionTable

    +oddCollisionTable:
    LDA collisionTable2,y
    JMP +checkPoint

    +evenCollisionTable:
    LDA collisionTable,y

    +checkPoint:
    BEQ +checkNextPoint
    CMP #$01
    BNE +checkIfFirstNonZeroCollision
        ;STA tempA
        LDA tempx
        STA temp2
        STY tempy
        LDA #$01
        RTS

    +checkIfFirstNonZeroCollision:
    STA temp
    LDA tempy
    BNE +checkNextPoint
        LDA tempx
        STA temp2
        LDA temp
        STA tempA
        STY tempy
    +checkNextPoint:
ENDM

