
;; Default header file

.db "NES",$1a  ;; iNES identifier
.db 32         ;; # of PRG-ROM blocks (32)
.db 0          ;; # of CHR-ROM blocks (0, using chr ram)

.db %11100011
;;   |||||||+-- Set vertical mirroring
;;   ||||||+--- Cartridge has persistent memory (flash saving)
;;   |||||+---- No trainer
;;   ||||+----- Standard nametable layout
;;   ++++------ Mapper-30 (lower nybble)

.db %00010000
;;   ||||||++-- Standard cartridge (no VS/PC10)
;;   ||||++---- iNES 1.0 format
;;   ++++------ Mapper-30 (upper nybble)

.db $00,$00,$00,$00,$00,$00,$00,$00  ;; Filler

