
doDrawText:

    ; Count down without advancing the text.
    LDA textHandler
    CMP #$02
    BCC +textDelayReady
    DEC textHandler
    RTS
+textDelayReady:
    ; Wait until the shared PPU buffer is available.
    LDA updateScreenData
    AND #%00000111
    BEQ +textQueueReady
    RTS
+textQueueReady:

    TXA
    PHA
    TYA
    PHA

    ;; If the text handler is zero, it means we have to yet start
    ;; drawing text in the box. So we need to get the correct position
    ;; on screen to start drawing first.
    LDA textHandler
    BNE +continueDrawingText

        ;; Text handler is zero

        ;; Multiply the x-value of the starting text position by 2
        ;; (to convert metatile units to tile unites)
        LDA arg2_hold
        ASL
        STA temp

        ;; Multiply the y-value of the starting text position by 2
        ;; (to convert metatile units to tile unites)
        LDA arg3_hold
        ASL
        STA temp1

        ;; Convert the (x,y) values of the text pointer to the
        ;; corresponding PPU address (low byte)
        ASL
        ASL
        ASL
        ASL
        ASL
        CLC
        ADC temp
        STA textOffset_lo

        ;; Convert the (x,y) values of the text pointer to the
        ;; corresponding PPU address (high byte)
        LDA temp1
        LSR
        LSR
        LSR
        CLC
        ADC camFocus_tiles
        STA textOffset_hi

        ;; Increment the text handler so we can handle the first
        ;; character of text directly
        INC textHandler

        ;; Reset the text character counter
        LDA #$00
        STA counter
    +continueDrawingText:

    ;; Reset the scroll offset counter
    LDA #$00
    STA scrollOffsetCounter

    ;; Switch to the text bank
    SwitchBank textBank

        ;; Store the PPU address to update into the PPU buffer
        LDY #$00
        LDA textOffset_hi
        STA scrollUpdateRam,y
        INY
        LDA textOffset_lo
        STA scrollUpdateRam,y
        INY

        ;; Store the text character into a temp variable.
        ;; Also backup and restore the Y-register using the stack.
        TYA
        PHA
        LDY #$00
        LDA (textPointer),y
        STA temp
        PLA
        TAY

        ;; HERE, we will check for "end string" values.
        ;; These are set up by default from the GUI.
        ;; Mostly, they add a value from HUD_CONSANTS.dat
        ;; that act as an opcode rather than a string value.
        ;; Since there are 256 values, there are many at the end that
        ;; will never be used.

        ;; These are the ones that are default:
        ;; _ENDTRIGGER = $F9
        ;; _ENDWIN     = $FA
        ;; _ENDITEM    = $FB
        ;; _ENDSHOP    = $FC
        ;; _MORE       = $FD
        ;; _BREAK      = $FE
        ;; _END        = $FF

        ;; FOR MANUAL USE:
        ;; Drawing from a library of values based on a numeric offset
        ;; can be invoked by using F8.

        ;; First we check for special characters #$F6-F8, because these have to
        ;; continue handling text after we're done handling these characters.
        CMP #$F6
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\drawVariableNumber.asm
            JMP +continueRoutine
        +checkNext:

        CMP #$F7
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\restoreFromLibrary.asm
            JMP +continueRoutine
        +checkNext:

        LDA temp
        CMP #$F8
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\drawFromLibrary.asm
            ;JMP +continueRoutine
        +checkNext:


        ;; After handling #$F6-F8, a new character is stored into `temp`. To
        ;; continue the routine, we have to reload `temp` in the accumulator.
        +continueRoutine:
        LDA temp

        ;; #$F9-FC are text ending scripts. These JMP to +endText when they
        ;; have been handled.

        CMP #$F9 ; #_ENDTRIGGER
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\triggerScreen.asm
            JMP +endText
        +checkNext:

        CMP #$FA ; #_ENDWIN
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\endWin.asm
            JMP +endText
        +checkNext:

        CMP #$FB ; #_ENDITEM
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\unlockItem.asm
            JMP +endText
        +checkNext:

        CMP #$FC ; #_ENDSHOP
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\shopWarp.asm
            JMP +endText
        +checkNext:

        ;; #$FD is a "show more text" function, which shouldn't end the
        ;; text box routine, but rather just update the screen data, so
        ;; that it can continue handling the rest of the text. Therefore,
        ;; after this script is handled, it JMPs to the +updateScreenData
        ;; routine.
        CMP #$FD ; #_MORE
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\moreText.asm
            JMP +updateScreenData
        +checkNext:

        ;; #$FE is a line break; this just updates the text pointer (the
        ;; x,y position of the next character on screen) and should not
        ;; output anything new. Therefore, after a new line, we JMP to
        ;; the +returnBank routine so that the script can handle the rest
        ;; of the text by itself.
        CMP #$FE ; #_BREAK
        BNE +checkNext
            .include ROOT\Game\TextActionScripts\newLineOfText.asm
            JMP +returnBank
        +checkNext:

        ;; #$FF is the end of text handler. This just JMPs to +endText
        ;; and has no additional actions. You can override this by changing
        ;; the `.include` line below.
        CMP #$FF ; #_END
        BNE +checkNext
            .include ROOT\Game\Subroutines\blank.asm
            JMP +endText
        +checkNext:


        ;; Additional special character checks can go here, like this:
        ;;  CMP #$..
        ;;  BNE +checkNext
        ;;      .include Path\To\TextActionScript.asm
        ;;  +checknext:


        ;; Add normal text character graphic to the PPU buffer
        LDA temp
        CLC
        ADC #HUD_OFFSET
        STA scrollUpdateRam,y
        INY

        ;; Update the max offset scroll counter
        STY maxScrollOffsetCounter
        ; Reload the delay after queuing a normal character.
        LDA #(TEXT_DELAY + 1)
        STA textHandler

        ;; Increment counter; we will use counter to keep track of the
        ;; length of the current line
        INC counter

        ;; Update the 16-bit text offset value
        INC textOffset_lo
        BNE +
            INC textOffset_hi
        +

        ;; Update the 16-bit text pointer value
        INC textPointer
        BNE +
            INC textPointer+1
        +

        ;; Tell game to update the PPU buffer for the next frame
        +updateScreenData:
            LDA updateScreenData
            ORA #%00000100
            STA updateScreenData
            JMP +returnBank

        ;; Handle the end of the text stream
        +endText:
            ;; Reset text handler
            LDA #$00
            STA textHandler

            ;; Cue "turn off"
            LDA textQueued
            ORA #%00000010
            STA textQueued

            ;; Unset bit-1 of game status byte
            ;; @TODO find gameStatusByte in NESMaker UI and update description
            LDA gameStatusByte
            AND #%11111101
            STA gameStatusByte

        ;; Switch back to previous bank
        +returnBank:
    ReturnBank

    ;; Pull original X- and Y-register values from stack
    PLA
    TAY
    PLA
    TAX

    ;; Return
    RTS

