
.include GameData\UserDefinedConstants.asm
.include GameData\HUD_BOX_CONSTANTS.dat
.include GameData\HUD_CONSTANTS.dat

;; Directions for physics engine to use with movement byte.
;; These pertain to actual physics inertia, not facing directions.
DOWN      = #%00110000
UP        = #%00100000
LEFT      = #%10000000
RIGHT     = #%11000000
DOWNRIGHT = #%11110000
UPRIGHT   = #%11100000
UPLEFT    = #%10100000
DOWNLEFT  = #%10110000

;; Facing direction, for animation engine.
;; These determine which facing direction the sprite uses.
FACE_DOWN      = #%00000000
FACE_DOWNRIGHT = #%00000001
FACE_RIGHT     = #%00000010
FACE_UPRIGHT   = #%00000011
FACE_UP        = #%00000100
FACE_UPLEFT    = #%00000101
FACE_LEFT      = #%00000110
FACE_DOWNLEFT  = #%00000111

TEXT_FREE = #$01
TEXT_NPC  = #$04

DATABANK1 = #$18

;;CONSTANTS FOR PLAYER ACTION STEPS
;;Temporary - they will be translated to UI later
PLAYER_IDLE_STATE     = #$00
PLAYER_WALK_STATE     = #$01
PLAYER_ATTACK_STATE   = #$02
PLAYER_JUMP_STATE     = #$02
PLAYER_FALL_STATE     = #$02
PLAYER_CLIMB_STATE    = #$03
PLAYER_CLIMB_IDLE_STATE    = #$04

OBJECT_HURT_STATE = #$07

OBJ_PROJECTILE = #$02
OBJ_MELEE = #$01

;;Other CONSTANTS FOR UI LATER
BOUNCE_STRENGHT = #$08

TILE_NULL = #$00
TILE_SOLID = #$01
TILE_JUMP_THROUGH = #$07
TILE_PRIZE_BLOCK = #$09
TILE_MONSTER_LOCK = #$08
TILE_LADDER = #$0A

PRIZE_BLOCK_USED_GRAPHIC = #$00
BLANK_GRAPHIC = #$00

MY_PRIZE          = $01  ; Object type to create.
MY_PRIZE_STATE    = $00  ; Initial action step.
MY_PRIZE_X_OFFSET = $00  ; Horizontal spawn offset.
MY_PRIZE_Y_OFFSET = $10  ; Distance above the block.

TEXT_DELAY = #$00

HUD_PALETTE = #$03
