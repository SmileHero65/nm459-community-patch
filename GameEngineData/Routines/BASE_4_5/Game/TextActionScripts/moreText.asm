
      ;; There is more text.
      ;; so first, we need to clear the text field.
      ;; We will set up a queue for drawing a new black box and then more text.
      LDA textQueued
      ORA #%00000001
      STA textQueued

      ;; now, increase the text value so that it will read from the very next
      ;; value when a new box is created.
      LDA textOffset_lo
      CLC
      ADC #$02
      STA textOffset_lo

      LDA textOffset_hi
      ADC #$00
      STA textOffset_hi

      ;; Also, add a "MORE" indicator after finished text.
      LDA textPointer
      CLC
      ADC #$01
      STA textPointer

      LDA textPointer+1
      ADC #$00
      STA textPointer+1

      LDA #$00
      STA textHandler

      LDA #TEXT_MORE_INDICATOR
      STA temp

      CLC
      ADC #HUD_OFFSET
      STA scrollUpdateRam,y
      INY

      STY maxScrollOffsetCounter

      INC counter ;; we will use counter for "length" of the current line.

      LDA gameStatusByte
      AND #%11111101
      STA gameStatusByte

