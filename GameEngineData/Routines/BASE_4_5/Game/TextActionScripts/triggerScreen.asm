
      LDA textPointer
      CLC
      ADC #$01
      STA textPointer

      LDA textPointer+1
      ADC #$00
      STA textPointer+1

      ;; NOW, get the modifier
      TYA
      PHA

      LDY #$00
      LDA (textPointer),y
      ;; accumulators now contains the trigger type
      STA temp
      TriggerScreen temp

      PLA
      TAY
      LDA #$00
      STA textHandler

