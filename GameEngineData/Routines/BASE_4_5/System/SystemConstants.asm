
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

;;Constants moved from UI to Dedicated Script
;;In this way, we have more room for customizable constants
;;like Object States, Physics, etc.
OBJECT_OBSERVES_INPUT           = 32
OBJECT_OBSERVES_PHYSICS         = 16
OBJECT_OBSERVES_TILES           = 8
OBJECT_OBSERVES_OBJECTS         = 4
OBJECT_OBSERVES_DRAWING         = 2
OBJECT_QUEUED_FOR_ACTIVATION    = 64
OBJECT_IS_ACTIVE                = 128
OBJECT_QUEUED_FOR_DESTRUCTION   = 1
HUD_OFFSET                      = 192
TEXT_MORE_INDICATOR             = 0
HUD_BANK                        = 30
