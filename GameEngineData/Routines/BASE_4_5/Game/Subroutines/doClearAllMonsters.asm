
doClearAllMonsters:
    SwitchBank #$1C
        LDX #$00
        -clearObjectsLoop:
            LDY Object_type,x

            LDA ObjectFlags,y
            AND #%00000001 ;; is it persistent?
            BNE +nextObject
                LDA #$00
                STA Object_status,x
                STA Object_frame,x
                STA Object_direction,x
            +nextObject:

            INX
            CPX #TOTAL_MAX_OBJECTS
        BNE -clearObjectsLoop
    ReturnBank

    RTS

