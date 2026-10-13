
    ;;
    ;; PROCESS:
    ;; - The player will change Action Step to Idle
    ;;   so fixes if Hurt, it will still not recoil when warping
    ;; - The player will Stop Moving
    ;; - The player will Warp
    ;; - Additionally, the player will stop moving
    ;;
    ;;the code the player stopping is inside the WarpToScreen macro

    CPX player1_object
    BEQ +
        RTS
    +

    ;; Change player Action Step to 00 - Idle
    ChangeActionStep player1_object, #$00

    ;; Stop the Player from Moving
    LDX player1_object
    LDA Object_direction,x
    AND #%00000111
    STA Object_direction,x

    ;; Warp to screen
    WarpToScreen warpToMap, warpToScreen, #$01

