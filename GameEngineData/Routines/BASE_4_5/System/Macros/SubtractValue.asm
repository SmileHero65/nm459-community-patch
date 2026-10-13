
MACRO SubtractValue arg0, arg1, arg2, arg3
    ;; arg0 = how many places this value has.
    ;; arg1 = home variable
    ;; arg2 = amount to subtract
    ;; arg3 = what place value is receiving the subtraction?

    TXA
    PHA

    LDX arg0
    -
        LDA arg1,x ;; the variable that you want to push
        STA value,x
        DEX
    BPL -

    LDX arg3
    LDA arg2
    STA temp

    JSR valueSubLoop ;; will add what is in accumulator.

    ;; now value needs to be unpacked back into the variable.
    LDX arg0
    -
        LDA value,x ;; the variable that you want to push
        STA arg1,x
        DEX
    BPL -

    PLA
    TAX
ENDM

