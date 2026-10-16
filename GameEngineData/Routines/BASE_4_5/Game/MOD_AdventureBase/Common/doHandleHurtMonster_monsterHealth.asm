
    STX temp

    ;; Check if object is not hurting yet.
    GetActionStep temp
    CMP #OBJECT_HURT_STATE ;; we will use action step 7 for hurt.
    BEQ +doSkipHurtingThisObject ;; if he is hurt, he can't be hurt again.

        ;; Put object in hurt state
        ChangeActionStep temp, #OBJECT_HURT_STATE

        ;; Take health point
        DEC Object_health,x

        ;; If no health left, destroy object
        BNE +doSkipHurtingThisObject
        DestroyObject
    +doSkipHurtingThisObject

