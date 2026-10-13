
SoundRam            = $0100
SpriteRam           = $0200
CollisionRam        = $0300
FlashRamPage        = $0300 ;; because collision data will not be used on
                            ;; saving/loading of data; this should always be
                            ;; utilized on a non-screen, and reload the screen
                            ;; when saving/loading is finished.
ObjectRam           = $0400
CollisionRam2       = $0500 ;; A whole page for scratch ram as a buffer space.
OverflowRam         = $0600 ;; User defined, game specific variable space.
                            ;; Currently 256 bytes capable by default.
scrollUpdateRam     = $0700 ;; Used for a buffer.


;; Zero Page RAM & User Variables
.enum $0000
    .include GameData/ZP_RAM.asm
    .include GameData/Variables/UserVariables.asm
.ende


;; Sound RAM
;; also used by the stack, but should never conflict.
.enum SoundRam
    .include ROOT\System\ggsound_ram.asm
.ende


;; Collision RAM
.enum CollisionRam
    collisionTable .dsb 256
.ende

.enum CollisionRam2
    collisionTable2 .dsb 240
.ende

;; Overflow RAM
.enum OverflowRam ;; 256 bytes.
    .include GameData/System_RAM.asm
.ende

;; Object Variables
.enum ObjectRam ;; 256 bytes
    .include GameData/Object_RAM.asm
.ende

