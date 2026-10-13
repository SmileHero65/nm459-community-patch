
RESET:
    SEI        ;; ignore interrupts for the reset
    LDA #$00   ;; load the number 00
    STA $2000  ;; disables NMI
    STA $2001  ;; disables rendering
    STA $4010  ;; disables DMC IRQ
    STA $4015  ;; disables APU sound
    LDA #$40   ;; Loads the number 64
    STA $4017  ;; disables the APU IRQ
    CLD        ;; disables decimal mode
    LDX #$FF
    TXS        ;; initializes the stack

;; First vblank wait
    ;; What is vblank?
    ;; NES draws scan lines from top to bottom.  During the time it takes
    ;; for the light beam to move back up to the top is a waiting period
    ;; called vblank...it gives us time to update what is drawn to the screen.
    BIT $2002
    -
        BIT $2002
    BPL -

;; Clear all ram
    LDX #$00
    -clearMemoryLoop:
        LDA #$00
        STA $0000,x
        STA $0100,x
        ;; Skip 200, this is where the sprites are drawn
        ;; We'll set them to $FE to draw them off screen
        STA $0300,x
        STA $0400,x
        STA $0500,x
        STA $0600,x
        STA $0700,x
        LDA #$FE      ;; instead of zero, write #$FE to 0200,x
        STA $0200,x   ;; to place sprites off screen.
        INX
    BNE -clearMemoryLoop

;; Second vblank
    -
        BIT $2002
    BPL -

;; Enable NMI
    LDA #%10010000    ;; Turn on NMI, set sprites $0000, bkg to $1000
    STA $2000
    LDA #%00011110
    STA $2001
    STA soft2001

    LDA #$00
    STA $2005
    STA $2005

    ;; Don't turn on rendering until first graphics are drawn.

