
    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    SEC
    SBC #$01
    AND #%00000111
    STA tempB ;; the action frame that was assigned during create macro.
              ;; object behavior tables are with the lut table.
              ;; the lut table is in bank 1C.

    ASL
    ASL
    ASL
    STA tempC

    LDA Object_frame,x
    AND #%11000111
    ORA tempC
    STA Object_frame,x

    STX tempA
    DoObjectAction tempA, tempB

