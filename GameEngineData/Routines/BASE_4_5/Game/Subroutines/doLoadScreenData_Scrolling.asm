
doLoadScreenData:
    LDA #$00
    STA spriteRamPointer
    JSR doCleanUpSpriteRam

    SwitchBank arg0_hold

        ;; #120 - Screen type
        LDY #120
        LDA (collisionPointer),y
        STA screenType

        ;; #121 Legacied
        ;; (was GraphicsBank - now screen bank is handled via logic.)
        INY

        ;; #122 - Screen palette
        INY
        LDA (collisionPointer),y ;; this is the palette data
        STA newPal

        ;; #123 Legacied
        ;; (was MaineTileID / ScreenTileID, now handled in bytes below)
        INY

        ;; #124 - ScreenFlags00
        INY
        LDA (collisionPointer),y
        STA ScreenFlags00

        ;; #125 - ScreenByte01
        INY
        LDA (collisionPointer),y
        STA ScreenByte01

        ;; Load screenSpeed
        AND #%00000011
        STA screenSpeed

        ;; #126 - Load paths, through a loop to figure out path choices
        ;; (Not for scrolling modules)
        INY

        ;; #127 - Warp out screen
        INY
        LDA (collisionPointer),y
        STA warpToScreen

        INY
        ;; #128 - Warp In Position
        LDA screenTransitionType
        BEQ skipSettingWarpInXY

        CMP #$01
        BEQ setToStartValue

        CMP #$02
        BEQ setToContinueValue

        setToContinueValue:
            LDA continueX
            STA newX
            LDA continueY
            STA newY
            JMP skipSettingWarpInXY

        setToStartValue:
            LDA (collisionPointer),y
            AND #%11110000
            STA newY

            LDA (collisionPointer),y
            AND #%00001111
            ASL
            ASL
            ASL
            ASL
            STA newX

        skipSettingWarpInXY:

        LDA #$00
        STA screenTransitionType ;; reset screen transition type

        ;; #129 - Legacied
        ;; (used to be screen type and song number.)
        INY

        ;; #130 - needed bits
        INY
        LDA (collisionPointer),y
        STA screenLoadTemps ;; this is whether screen should load 8x8 or 16x16.

        AND #%00000001 ;; is this overworld or underworld map?
        STA warpToMap

        LDA screenLoadTemps
        AND #%01110000
        LSR
        LSR
        LSR
        LSR
        ;AND #%00000111
        STA gameState

        ;; #182 - ScreenFlags01
        LDY #182
        LDA (collisionPointer),y
        STA ScreenFlags01

        .include ROOT\Game\CommonScripts\userScreenBytes.asm

        ;; #196 - Tile layout
        LDY #196
        LDA (collisionPointer),y
        STA tileLayout

        ;; #197-202 - Background tiles to load
        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad

        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad+1

        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad+2

        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad+3

        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad+4

        INY
        LDA (collisionPointer),y
        STA backgroundTilesToLoad+5

        ;; Handle state based data (get screen trigger info)
        TXA
        PHA
        JSR GetScreenTriggerInfo
        PLA
        TAX

        ;; THERE WILL BE BYTES
        ;; That will contian this information on a screen by screen basis.
        ;; 00 = pacman
        ;; 01 = zelda screen
        ;; 02 = scroll (which updates the Object_screen,x)
        ;; 03 = acts as a solid edge.
        ;; Right now, this is being hard coded to pacman style
        LDA #%00000000
        STA screenEdgeBehavior
    ReturnBank

    SwitchBank #$16
        LDA stringGroupPointer ;; this is the group of the string.
        ASL
        ASL

        TAY
        LDA AllTextGroups,y
        STA screenText

        INY
        LDA AllTextGroups,y
        STA screenText+1

        INY
        LDA AllTextGroups,y
        STA screenText+2

        INY
        LDA AllTextGroups,y
        STA screenText+3
    ReturnBank

    RTS


GetScreenTriggerInfo:
    JSR doClearAllMonsters

    ;; MONSTERS
    ;; constants for banks

    GetTrigger

    ;; result of screenType trigger stored in temp3 and also in accum
    ;; x and y restored.

    BEQ thisScreenIsNotTriggered

    ;; this screen IS triggered:
        LDA gameHandler
        AND #%00000001 ;; one = night
        BEQ isTriggeredDay

    ;; triggered and night:
        LDX #$03
        STX screenState

        LDY #152
        LDA (collisionPointer),y
        LSR
        LSR
        LSR
        LSR
        STA monsterTableOffset

        JMP triggeredStateInfoIsLoaded

    isTriggeredDay:
        ;; triggered and day
        LDX #$02
        STX screenState

        LDY #153
        LDA (collisionPointer),y
        AND #%00001111
        STA monsterTableOffset

        JMP triggeredStateInfoIsLoaded

    thisScreenIsNotTriggered:
        JMP isNormalDay
        LDA gameHandler
        AND #%00000001 ;; one = night
        BEQ isNormalDay

    ;; normal and night:
        LDX #$01
        STX screenState

        LDY #152
        LDA (collisionPointer),y
        LSR
        LSR
        LSR
        LSR
        STA monsterTableOffset

        JMP triggeredStateInfoIsLoaded

    isNormalDay:
        ;; normal and day
        LDA #$00
        STA screenState
        TAX

        LDY #152
        LDA (collisionPointer),y
        AND #%00001111
        STA monsterTableOffset

    triggeredStateInfoIsLoaded:

    ;; Now, here, load all of the state specific stuff. This will use X as an
    ;; offset for small tables in ZeroOutAssets file. We'll have to use the
    ;; stack for any part of these routines that might need X.

    ;; considerations for the states.
    ;; 1: Get Object Graphics Bank
    ;; 2: String Data
    ;; 3: Monster Spawn positions
    ;; 4: Monster group (this is more complicated than a single digit)
    ;; 5: Object palettes (also more complicated than a single digit)
    ;; 6: Object tiles to load.
    ;; 7: Object IDs
    ;; 8: Song to play

    LDA StringDataChoice,x
    TAY
    ;; now y holds the byte offset value for the text string group.

    LDA (collisionPointer),y
    STA stringGroupPointer

    TXA
    PHA

    JSR LoadMonster_1

    LDY Mon2SpawnLocation,x
    LDA (collisionPointer),y
    STA temp

    AND #%11110000
    CMP #%11110000
    BNE loadMon2toPosition
        LDA temp
        AND #%00001111
        CMP #%00000011
        BEQ skipLoadingMonster2
    loadMon2toPosition:
        ;; Load monster 2
        LDY Monster2ID,x
        LDA (collisionPointer),y
        STA mon2_type ;; type of monster loaded into tempA

        LDY Mon2SpawnLocation,x
        LDA (collisionPointer),y
        ASL
        ASL
        ASL
        ASL
        STA tempB ;; x value in tempB

        LDY Mon2SpawnLocation,x
        LDA (collisionPointer),y
        AND #%11110000
        STA tempC ;; y value in tempC

        TXA
        PHA
        CreateObject tempB, tempC, mon2_type, #$00
        LDA #$01
        STA Object_id,x
        PLA
        TAX
    skipLoadingMonster2:

    ;; Handle monster 3
    LDY Mon3SpawnLocation,x
    LDA (collisionPointer),y
    STA temp

    AND #%11110000
    CMP #%11110000
    BNE loadMon3toPosition
        LDA temp
        AND #%00001111
        CMP #%00000011
        BEQ skipLoadingMonster3
    loadMon3toPosition:
        LDY Monster3ID,x
        LDA (collisionPointer),y
        STA mon3_type ;; type of monster loaded into tempA

        LDY Mon3SpawnLocation,x
        LDA (collisionPointer),y
        ASL
        ASL
        ASL
        ASL
        STA tempB ;; x value in tempB

        LDY Mon3SpawnLocation,x
        LDA (collisionPointer),y
        AND #%11110000
        STA tempC ;; y value in tempC

        TXA
        PHA
        CreateObject tempB, tempC, mon3_type, #$00
        LDA #$02
        STA Object_id,x
        PLA
        TAX
    skipLoadingMonster3:

    ;; Handle monster 4
    LDY Mon4SpawnLocation,x
    LDA (collisionPointer),y
    STA temp

    AND #%11110000
    CMP #%11110000
    BNE loadMon4toPosition
        LDA temp
        AND #%00001111
        CMP #%00000011
        BEQ skipLoadingMonster4
    loadMon4toPosition
        ;; Load monster 4
        LDY Monster4ID,x
        LDA (collisionPointer),y
        STA mon4_type ;; type of monster loaded into tempA

        LDY Mon4SpawnLocation,x
        LDA (collisionPointer),y
        ASL
        ASL
        ASL
        ASL
        STA tempB ;; x value in tempB

        LDY Mon4SpawnLocation,x
        LDA (collisionPointer),y
        AND #%11110000
        STA tempC ;; y value in tempC

        TXA
        PHA
        CreateObject tempB, tempC, mon4_type, #$00
        LDA #$03
        STA Object_id,x
        PLA
        TAX
    skipLoadingMonster4:

;       PLA
;       TAX

    ;; Load subpalettes
    ;; HERE is where you could define game object sub palettes by reading
    ;; a specific byte

;       TXA
;       PHA

    LDX screenState

    LDY GoPal1Choice,x
    LDA (collisionPointer),y
    STA spriteSubPal3

    LDY GoPal2Choice,x
    LDA (collisionPointer),y
    STA spriteSubPal4

    LDY MonPal1Choice,x
    LDA (collisionPointer),y
    STA spriteSubPal1

    LDY MonPal2Choice,x
    LDA (collisionPointer),y
    STA spriteSubPal2

    PLA
    TAX

    TYA
    PHA

    LDY #178
    LDA (collisionPointer),y
    STA temp

    CMP #$FF
    BNE notStopSong
        STA songToPlay
        StopSound
        JMP skipSongToPlay
    notStopSong:

    CMP songToPlay
    BEQ skipSongToPlay ;; already playing this song
        PlaySong temp
    skipSongToPlay:

    PLA
    TAY

    RTS

