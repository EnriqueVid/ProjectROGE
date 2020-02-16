
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
    db $0C              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $0C              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right



;;--------------------------------------------
;;TILE DATA
;;--------------------------------------------

tile_index::
    dw tile_floor_01                ;; 00
    dw tile_wall_background         ;; 01
    dw tile_wall_top                ;; 02
    dw tile_wall_bottom             ;; 03
    dw tile_wall_left               ;; 04
    dw tile_wall_right              ;; 05
    dw tile_wall_topleft_int        ;; 06
    dw tile_wall_topright_int       ;; 07
    dw tile_wall_bottomleft_int     ;; 08
    dw tile_wall_bottomright_int    ;; 09
    dw tile_wall_topleft_ext        ;; 0A
    dw tile_wall_topright_ext       ;; 0B
    dw tile_wall_bottomleft_ext     ;; 0C
    dw tile_wall_bottomright_ext    ;; 0D
    dw tile_staris                  ;; 0E
    dw tile_hud_01                  ;; 0F

tile_wall_background:
    db $03          ;; Tile TL
    db $03          ;; Tile TR
    db $03          ;; Tile BL
    db $03          ;; Tile BR

tile_wall_top:
    db $14          ;; Tile TL
    db $14          ;; Tile TR
    db $15          ;; Tile BL
    db $15          ;; Tile BR

tile_wall_bottom:
    db $17          ;; Tile TL
    db $17          ;; Tile TR
    db $16          ;; Tile BL
    db $16          ;; Tile BR

tile_wall_left:
    db $19          ;; Tile TL
    db $1B          ;; Tile TR
    db $19          ;; Tile BL
    db $1B          ;; Tile BR

tile_wall_right:
    db $1A          ;; Tile TL
    db $18          ;; Tile TR
    db $1A          ;; Tile BL
    db $18          ;; Tile BR

tile_wall_topleft_int:
    db $1C          ;; Tile TL
    db $1E          ;; Tile TR
    db $1D          ;; Tile BL
    db $1F          ;; Tile BR

tile_wall_topright_int:
    db $20          ;; Tile TL
    db $22          ;; Tile TR
    db $21          ;; Tile BL
    db $23          ;; Tile BR

tile_wall_bottomleft_int:
    db $28          ;; Tile TL
    db $2A          ;; Tile TR
    db $29          ;; Tile BL
    db $2B          ;; Tile BR

tile_wall_bottomright_int:
    db $24          ;; Tile TL
    db $26          ;; Tile TR
    db $25          ;; Tile BL
    db $27          ;; Tile BR

tile_wall_topleft_ext:
    db $34          ;; Tile TL
    db $36          ;; Tile TR
    db $35          ;; Tile BL
    db $37          ;; Tile BR

tile_wall_topright_ext:
    db $38          ;; Tile TL
    db $3A          ;; Tile TR
    db $39          ;; Tile BL
    db $3B          ;; Tile BR

tile_wall_bottomleft_ext:
    db $30          ;; Tile TL
    db $32          ;; Tile TR
    db $31          ;; Tile BL
    db $33          ;; Tile BR

tile_wall_bottomright_ext:
    db $2C          ;; Tile TL
    db $2E          ;; Tile TR
    db $2D          ;; Tile BL
    db $2F          ;; Tile BR

tile_floor_01:
    db $0C          ;; Tile TL
    db $0D          ;; Tile TR
    db $0E          ;; Tile BL
    db $0F          ;; Tile BR

tile_staris:
    db $08          ;; Tile TL
    db $0A          ;; Tile TR
    db $09          ;; Tile BL
    db $0B          ;; Tile BR

tile_hud_01:
    db $3C          ;; Tile TL
    db $3C          ;; Tile TR
    db $00          ;; Tile BL
    db $00          ;; Tile BR



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
