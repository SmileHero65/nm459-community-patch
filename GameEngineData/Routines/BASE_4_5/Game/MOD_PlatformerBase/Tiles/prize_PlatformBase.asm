;;; prize tile;;;
;;;Fix Prize tile not always dissappearing by m8si
;; https://www.nesmakers.com/index.php?threads/prize-tile-not-always-dissappearing-4-5-9.7643/

    LDA updateScreenData
    AND #%00000100
    BEQ +doScript
        RTS
    +doScript
    LDA scrollOffsetCounter
    BEQ +doIt
        RTS
    +doIt
CPX player1_object
BEQ +isPlayer
    JMP +notPlayer
    +isPlayer


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BELOW WILL CHANGE TILE AT COLLISION.

    ChangeTileAtCollision #$00, #$00
    JSR doWaitFrame

    ;MACRO AddValue arg0, arg1, arg2, arg3
    ;arg0 = how many places this value has.
    ;arg1 = home variable
    ;arg2 = amount to add
    ;arg3 = what place value is receiving the addition?
        ;;; 0 = ones place, 1 = tens place, 2 = hundreds place, etc.
        inc myPrizes
        LDA myPrizes
        CMP #10
        BNE +notTenYet
            ;; is ten
            ;; reset myPrizes
            LDA #$00
            STA myPrizes
            ;; increase lives

            INC myLives
            LDA myLives
            CMP #$09
            BNE +notMaxLivesAt8
                ;;; normalize lives at max of 6
                LDA #$08
                STA myLives
            +notMaxLivesAt8

        +notTenYet
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;;;;; Do we need to update the HUD to reflect this?
        ;;;;;;;;;;;;;;;;;;;;;;;;; If so, which element is the above variable represented in?
        ;UpdateHudElement #$03


    +notPlayer