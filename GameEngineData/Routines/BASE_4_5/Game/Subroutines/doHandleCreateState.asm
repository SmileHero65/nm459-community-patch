
;; read the first behavior and do the thing.
doHandleCreateState:
    LDA Object_frame,x
    LSR
    LSR
    LSR
    AND #%00000111
    STA tempB

    STX tempA
    DoObjectAction tempA, tempB

    LDA Object_status,x
    AND #%00111111
    ORA #%10000000
    STA Object_status,x ;; kick it to active

    RTS

