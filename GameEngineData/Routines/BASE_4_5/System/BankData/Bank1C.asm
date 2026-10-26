
;; Object data
.include "ScreenData\ObjectInfo.dat"
.include "ScreenData\ObjectPointers.pnt"
.include "ScreenData\ObjectData\ObjectLutTable.dat"


;; Timer end scripts
.include ROOT\Game\Subroutines\TimerEndScripts.asm


;; Sprite/object related subroutines
.include ROOT\Game\Subroutines\doObjectAction.asm

.include SCR_COMPARE_BBOX

doDrawSprites:
    .include SCR_HANDLE_DRAWING_SPRITES
    ; RTS handled within script now

doUpdateSpriteTimer:
    .include SCR_UPDATE_SPRITE_TIMER
    RTS

doUpdateActionTimer:
    .include SCR_UPDATE_ACTION_TIMER
    RTS

doObjectCollisions_bank1C:
    .include SCR_OBJECT_COLLISION_STATE
    .include SCR_HANDLE_OBJECT_COLLISIONS
    RTS

doHandleHurtPlayer:
    .include SCR_HANDLE_PLAYER_HURT
    RTS

doHandleHurtMonster:
    .include SCR_HANDLE_MONSTER_HURT
    RTS


;; Object lookup tables
.include "ScreenData\ObjectData\ObjectSpriteAddresses.dat"
