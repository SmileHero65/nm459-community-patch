    CPX player1_object
    BNE notPlayerForWarpTile

    ;;Change player Action Step to 00 - Idle
    ChangeActionStep player1_object, #$00

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Stop the Player from Moving
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    LDX player1_object
    LDA Object_direction,x
    AND #%00000111
    STA Object_direction,x
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;Stop Scroll
    LDA scrollByte
    AND #%00111110
    ORA #%00000010
    STA scrollByte

    WarpToScreen warpToMap, warpToScreen, #$01
        ;; arg0 = warp to map.  0= map1.  1= map2.
        ;; arg1 = screen to warp to.
        ;; arg2 = screen transition type - most likely use 1 here.
            ;; 1 = warp, where it observes the warp in position for the player.

;;;;;;;;;;;;;;;;;;;PROCESS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;The player will change Action Step to Idle - if Hurt, it will still not recoil when warping
    ;;The player will Stop Moving
    ;;The scroll will stop to prevent any glitches on the camera
    ;;The player will Warp
    ;;Additionally, the player will stop moving
    ;;the code the player stopping is inside the WarpToScreen macro

notPlayerForWarpTile: