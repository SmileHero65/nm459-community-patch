
      ;; a value of F6 is an opcode that lets the game know to draw the value
      ;; of a variable in a given position within a manual string.
      ;; 1) First, we see it is an F6 opcode.
      ;; 2) The next two bytes are the address of the variable that we want
      ;;    to read.
      ;; 3) It pushes that to y as an offset to NumberBaseTable, and then
      ;;    continues on to the routine.

      TYA
      PHA

      ;; The library can have 256 values. Conceivably, you could make multiple
      ;; libraries, and assign them to different end of text reads.
      ;; So here is what this does.
      ;;
      ;; 1) Reads an #$F8, so it knows to read from the library.
      ;; 2) Increases position.  Gets the low value of var address to read
      ;; 3) Increases position.  Gets the high value of var address to read.
      ;;    Puts the result of var into Y.
      ;; 3) Increases position and SAVES that program counter position.
      ;; 4) Reads the y offest of library table.  That position becomes the
      ;;    new textPointer location.
      ;; 5) Writes as normal from that position.
      ;; 6) If it reads #$F7, it turns off library draw (so every library read
      ;;    should end in #$F7.
      ;; 7) Saved program counter position gets restored to textPointer, and
      ;;    draw text continues on as normal.

      LDA textPointer
      CLC
      ADC #$01
      STA textPointer

      LDA textPointer+1
      ADC #$00
      STA textPointer+1

      LDY #$00
      LDA (textPointer),y
      STA pointer

      LDA textPointer
      CLC
      ADC #$01
      STA textPointer

      LDA textPointer+1
      ADC #$00
      STA textPointer+1

      LDY #$00
      LDA (textPointer),y
      STA pointer+1

      LDY #$00
      LDA (pointer),y
      TAY ;; Y now represents the offset value from the Library pointer table

      ;; store next offset position for a return point.
      LDA textPointer
      CLC
      ADC #$01
      STA textPosHold

      LDA textPointer+1
      ADC #$00
      STA textPosHold+1

      ;; get the library table value
      LDA TextLibrary_lo,y
      STA textPointer

      LDA TextLibrary_hi,y
      STA textPointer+1

      PLA
      TAY

