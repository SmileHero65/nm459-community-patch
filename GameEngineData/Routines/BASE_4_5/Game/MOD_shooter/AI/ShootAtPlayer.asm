
   ;; @TODO  Add x- and y-offsets, set correct object and action step

   LDA Object_x_hi,x
   STA tempA

   LDA Object_y_hi,x
   STA tempB

   LDA #$02 ;; game object to create.
   STA tempC

   LDA #$00 ;; action step for that object
   STA tempD

   LDA Object_screen,x
   STA tempz

   CreateObjectOnScreen tempA, tempB, tempC, tempD, tempz

