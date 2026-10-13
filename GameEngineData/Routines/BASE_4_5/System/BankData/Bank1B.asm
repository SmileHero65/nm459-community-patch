
;; Music Bank

;; Music handler (from the main loop)
doHandleUpdateMusic:
    LDA updateSoundByte
    AND #%00000001
    BEQ +
        ;; Stop music
        JSR sound_stop
        LDA updateSoundByte
        AND #%11111110
        STA updateSoundByte
    +

    LDA updateSoundByte
    AND #%00000010
    BEQ +
        ;; Play sound
        LDA sfxToPlay
        STA sound_param_byte_0
        LDA #soundeffect_one
        STA sound_param_byte_1
        JSR play_sfx
        LDA updateSoundByte
        AND #%11111101
        STA updateSoundByte
    +

    LDA updateSoundByte
    AND #%00000100
    BEQ +
        ;; Play song
        LDA songToPlay
        STA sound_param_byte_0
        JSR play_song
        LDA updateSoundByte
        AND #%11111011
        STA updateSoundByte
    +
    RTS


;; Sound engine update routine
doSoundEngineUpdate:
    soundengine_update
    RTS


;; Sound engine script
.include ROOT\System\ggsound.asm


;; Music data
.include "Sound\AllSongs_WithSFX.asm"

