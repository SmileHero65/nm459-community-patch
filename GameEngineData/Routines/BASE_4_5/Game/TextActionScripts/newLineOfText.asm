
      ;; new line of text
      ;; return to the leftmost side of the text string
      ;; by subtracting "counter"
      ;; then add #$20 (32), which jumps it to the next line.

      LDA textOffset_lo
      SEC
      SBC counter
      CLC
      ADC #$20
      STA textOffset_lo

      LDA textOffset_hi
      ADC #$00
      STA textOffset_hi

      ;; start 'counter' over again for the length of the current line
      LDA #$00
      STA counter

      ;; increase the position of the text pointer to get the next offset
      ;; value in the string.
      LDA textPointer
      CLC
      ADC #$01
      STA textPointer

      LDA textPointer+1
      ADC #$00
      STA textPointer+1

