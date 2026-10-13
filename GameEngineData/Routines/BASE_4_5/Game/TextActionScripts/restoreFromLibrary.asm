      TYA
      PHA

      ;; restorying from library.
      LDA textPosHold
      STA textPointer
      LDA textPosHold+1
      STA textPointer+1
      LDY #$00
      LDA (textPointer),y
      STA temp ;; flow into the rest of the text routine.

      PLA
      TAY

