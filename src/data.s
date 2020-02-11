
SECTION "DATA", ROM0

;;--------------------------------------------
;;SPRITE DATA
;;--------------------------------------------

sprites_index::
    ;PLAYER SPRITES
    dw sprite_player_down_01        ;; 00
    dw sprite_player_up_01          ;; 01     
    dw sprite_player_left_01        ;; 02
    dw sprite_player_right_01       ;; 03
    dw sprite_player_upleft_01      ;; 04
    dw sprite_player_upright_01     ;; 05
    dw sprite_player_downleft_01    ;; 06
    dw sprite_player_downright_01   ;; 07

    ;ENEMY SPRITES
    dw sprite_bat_01                ;; 08

sprite_player_down_01:
    db $00              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $00              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_up_01:
    db $02              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $02              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_left_01:
    db $06              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $04              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_right_01:
    db $04              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $06              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_upleft_01:
    db $08              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $04              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_upright_01:
    db $04              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $08              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_downleft_01:
    db $0A              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $04              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right

sprite_player_downright_01:
    db $04              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $0A              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right




sprite_bat_01:
    db $04              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $04              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right



;;--------------------------------------------
;;TILE DATA
;;--------------------------------------------

tile_index::
    dw tile_floor_01    ;; 00
    dw tile_wall_01     ;; 01

tile_wall_01:
    db $04          ;; Tile TL
    db $06          ;; Tile BL
    db $05          ;; Tile TR
    db $07          ;; Tile BR

tile_floor_01:
    db $0C          ;; Tile TL
    db $0E          ;; Tile BL
    db $0D          ;; Tile TR
    db $0F          ;; Tile BR



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
