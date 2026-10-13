
    CPX player1_object
    BNE +notPlayerForWarpTile
        WarpToScreen warpToMap, warpToScreen, #$01
        LDA #$05
        STA bossHealth ;; resets boss health for the new level.
    +notPlayerForWarpTile:

