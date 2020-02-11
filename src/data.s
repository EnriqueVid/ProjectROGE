
SECTION "DATA", ROM0

;;--------------------------------------------
;;SPRITE DATA
;;--------------------------------------------

sprites_index::
    dw sprite_player_01 ;; 00
    dw sprite_bat_01    ;; 01

sprite_player_01:
    db $0              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $0              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_bat_01:
    db $4              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $4              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

;;--------------------------------------------
;;TILESETS PARA CARGAR
;;--------------------------------------------

tileset_index::
    dw tileset_01       ;;  Tileset 01
    dw tileset_02       ;;  Sprites 01

tileset_size::
    dw tileset_01_end - tileset_01      ;;  Tileset 01
    dw tileset_02_end - tileset_02      ;;  Sprites 01


tileset_01: 
INCBIN "assets/tileset-01.bin"      ;;  Tileset 01
tileset_01_end:

tileset_02:
INCBIN "assets/spriteset-01.bin"    ;;  Sprites 01
tileset_02_end:
