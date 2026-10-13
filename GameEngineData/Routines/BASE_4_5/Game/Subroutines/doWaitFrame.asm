
doWaitFrame:
    INC waiting

    waitLoop:
        LDA waiting
    BNE waitLoop

    RTS

