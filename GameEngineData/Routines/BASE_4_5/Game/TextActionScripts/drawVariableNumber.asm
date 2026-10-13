
      TYA
      PHA

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

      LDA (pointer),y
      TAY

      LDA #<NumberBaseTable
      STA pointer

      LDA #>NumberBaseTable
      STA pointer+1

      LDA (pointer),y
      STA temp

      PLA
      TAY

