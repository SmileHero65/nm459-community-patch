
;; This block will become walkable after all monsters in a room are destroyed.

    LDA ObjectUpdateByte
    ORA #%00000001
    STA ObjectUpdateByte ;; makes solid

