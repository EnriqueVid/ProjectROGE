INCLUDE "src/data.h.s"
SECTION "DATA", ROM0


;;--------------------------------------------
;;LEVEL INDEX
;;--------------------------------------------
level_index::
    dw ent_map_01
    dw ent_map_02




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
    db $02              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_up_01:
    db $10              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $12              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_left_01:
    db $08              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $0A              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_right_01:
    db $18              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $1A              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_upleft_01:
    db $0C              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $0E              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_upright_01:
    db $14              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $16              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_downleft_01:
    db $04              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $06              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right

sprite_player_downright_01:
    db $1C              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $1E              ;; Sprite ID Right
    db %00000000        ;; Sprite Attributes Right




sprite_bat_01:
    db $20              ;; Sprite ID Left
    db %00000000        ;; Sprite Attributes Left
    db $20              ;; Sprite ID Right
    db %00100000        ;; Sprite Attributes Right



;;--------------------------------------------
;;TILE DATA
;;--------------------------------------------

tile_index::
    dw tile_wall_top                ;; 00 -> $00
    dw tile_wall_right              ;; 01 -> $01
    dw tile_wall_bottom             ;; 02 -> $02
    dw tile_wall_left               ;; 03 -> $03
    dw tile_wall_topleft_int        ;; 04 -> $04
    dw tile_wall_topright_int       ;; 05 -> $05
    dw tile_wall_bottomright_int    ;; 06 -> $06
    dw tile_wall_bottomleft_int     ;; 07 -> $07
    dw tile_wall_topleft_ext        ;; 08 -> $08
    dw tile_wall_topright_ext       ;; 09 -> $09
    dw tile_wall_bottomright_ext    ;; 10 -> $0A
    dw tile_wall_bottomleft_ext     ;; 11 -> $0B
    dw tile_wall_background         ;; 12 -> $0C
    dw tile_wall_misc_01            ;; 13 -> $0D
    dw tile_wall_misc_02            ;; 14 -> $0E
    dw tile_wall_misc_03            ;; 15 -> $0F
    dw tile_wall_misc_04            ;; 16 -> $10
    dw tile_wall_misc_05            ;; 17 -> $11
    dw tile_wall_misc_06            ;; 18 -> $12
    dw tile_wall_misc_07            ;; 19 -> $13


    dw tile_floor_01                ;; 20 -> $14
    dw tile_floor_02                ;; 21 -> $15
    dw tile_staris                  ;; 22 -> $16
    dw tile_item_money              ;; 23 -> $17
    dw tile_item_weapon             ;; 24 -> $18
    dw tile_item_shield             ;; 25 -> $19
    dw tile_item_spell              ;; 26 -> $1A
    dw tile_item_02                 ;; 27 -> $1B
    dw tile_item_03                 ;; 28 -> $1C
    dw tile_item_04                 ;; 29 -> $1D
    dw tile_item_05                 ;; 30 -> $1E
    dw tile_item_06                 ;; 31 -> $1F



tile_wall_top:
    db $00          ;; Tile TL
    db $02          ;; Tile TR
    db $01          ;; Tile BL
    db $03          ;; Tile BR

tile_wall_right:
    db $04          ;; Tile TL
    db $06          ;; Tile TR
    db $05          ;; Tile BL
    db $07          ;; Tile BR

tile_wall_bottom:
    db $08          ;; Tile TL
    db $0A          ;; Tile TR
    db $09          ;; Tile BL
    db $0B          ;; Tile BR

tile_wall_left:
    db $0C          ;; Tile TL
    db $0E          ;; Tile TR
    db $0D          ;; Tile BL
    db $0F          ;; Tile BR

tile_wall_topleft_int:
    db $10          ;; Tile TL
    db $12          ;; Tile TR
    db $11          ;; Tile BL
    db $13          ;; Tile BR

tile_wall_topright_int:
    db $14          ;; Tile TL
    db $16          ;; Tile TR
    db $15          ;; Tile BL
    db $17          ;; Tile BR

tile_wall_bottomright_int:
    db $18          ;; Tile TL
    db $1A          ;; Tile TR
    db $19          ;; Tile BL
    db $1B          ;; Tile BR

tile_wall_bottomleft_int:
    db $1C          ;; Tile TL
    db $1E          ;; Tile TR
    db $1D          ;; Tile BL
    db $1F          ;; Tile BR

tile_wall_topleft_ext:
    db $28          ;; Tile TL
    db $2A          ;; Tile TR
    db $29          ;; Tile BL
    db $2B          ;; Tile BR

tile_wall_topright_ext:
    db $2C          ;; Tile TL
    db $2E          ;; Tile TR
    db $2D          ;; Tile BL
    db $2F          ;; Tile BR

tile_wall_bottomright_ext:
    db $20          ;; Tile TL
    db $22          ;; Tile TR
    db $21          ;; Tile BL
    db $23          ;; Tile BR

tile_wall_bottomleft_ext:
    db $24          ;; Tile TL
    db $26          ;; Tile TR
    db $25          ;; Tile BL
    db $27          ;; Tile BR

tile_wall_background:
    db $30          ;; Tile TL
    db $32          ;; Tile TR
    db $31          ;; Tile BL
    db $33          ;; Tile BR

tile_wall_misc_01:
    db $34          ;; Tile TL
    db $36          ;; Tile TR
    db $35          ;; Tile BL
    db $37          ;; Tile BR

tile_wall_misc_02:
    db $38          ;; Tile TL
    db $3A          ;; Tile TR
    db $39          ;; Tile BL
    db $3B          ;; Tile BR

tile_wall_misc_03:
    db $3C          ;; Tile TL
    db $3E          ;; Tile TR
    db $3D          ;; Tile BL
    db $3F          ;; Tile BR

tile_wall_misc_04:
    db $40          ;; Tile TL
    db $42          ;; Tile TR
    db $41          ;; Tile BL
    db $43          ;; Tile BR

tile_wall_misc_05:
    db $44          ;; Tile TL
    db $46          ;; Tile TR
    db $45          ;; Tile BL
    db $47          ;; Tile BR

tile_wall_misc_06:
    db $48          ;; Tile TL
    db $4A          ;; Tile TR
    db $49          ;; Tile BL
    db $4B          ;; Tile BR

tile_wall_misc_07:
    db $4C          ;; Tile TL
    db $4E          ;; Tile TR
    db $4D          ;; Tile BL
    db $4F          ;; Tile BR



tile_floor_01:
    db $50          ;; Tile TL
    db $52          ;; Tile TR
    db $51          ;; Tile BL
    db $53          ;; Tile BR

tile_floor_02:
    db $54          ;; Tile TL
    db $56          ;; Tile TR
    db $55          ;; Tile BL
    db $57          ;; Tile BR

tile_staris:
    db $58          ;; Tile TL
    db $5A          ;; Tile TR
    db $59          ;; Tile BL
    db $5B          ;; Tile BR

tile_item_money:
    db $5C          ;; Tile TL
    db $5E          ;; Tile TR
    db $5D          ;; Tile BL
    db $5F          ;; Tile BR

tile_item_weapon:
    db $60          ;; Tile TL
    db $62          ;; Tile TR
    db $61          ;; Tile BL
    db $63          ;; Tile BR

tile_item_spell:
    db $64          ;; Tile TL
    db $66          ;; Tile TR
    db $65          ;; Tile BL
    db $67          ;; Tile BR

tile_item_shield:
    db $68          ;; Tile TL
    db $6A          ;; Tile TR
    db $69          ;; Tile BL
    db $6B          ;; Tile BR

tile_item_02:   
    db $6C          ;; Tile TL
    db $6E          ;; Tile TR
    db $6D          ;; Tile BL
    db $6F          ;; Tile BR

tile_item_03:   
    db $70          ;; Tile TL
    db $72          ;; Tile TR
    db $71          ;; Tile BL
    db $73          ;; Tile BR

tile_item_04:   
    db $74          ;; Tile TL
    db $76          ;; Tile TR
    db $75          ;; Tile BL
    db $77          ;; Tile BR

tile_item_05:   
    db $78          ;; Tile TL
    db $7A          ;; Tile TR
    db $79          ;; Tile BL
    db $7B          ;; Tile BR

tile_item_06:
    db $7C          ;; Tile TL
    db $7E          ;; Tile TR
    db $7D          ;; Tile BL
    db $7F          ;; Tile BR



;;--------------------------------------------
;;HUD PARA CARGAR
;;--------------------------------------------
base_hud::
    db $8C, $81, $81, $81, $8B, $81, $81, $81, $80, $8D, $8E, $81, $81, $8B, $81, $81, $80, $8F, $81, $81
base_hud_end::

hud_text_separation::
    db $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91, $91
hud_text_separation_end::

hud_text_area::
    db $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90, $90
hud_text_area_end::

;;--------------------------------------------
;;TILESETS PARA CARGAR
;;--------------------------------------------

tileset_index::
    dw tileset_04       ;;  Tileset 01
    dw tileset_02       ;;  Sprites 01
    dw tileset_03       ;;  HUD 01
    dw tileset_05       ;;  MAIN MENU
    dw tileset_06       ;;  PAUSE MENU
    dw tileset_07       ;;  Enemy Tiles

tileset_size::
    dw tileset_04_end - tileset_04      ;;  Tileset 01
    dw tileset_02_end - tileset_02      ;;  Sprites 01
    dw tileset_03_end - tileset_03      ;;  HUD 01
    dw tileset_05_end - tileset_05      ;;  MAIN MENU
    dw tileset_06_end - tileset_06      ;;  PAUSE MENU
    dw tileset_07_end - tileset_07      ;;  Enemy Tiles
    ;dw tileset_alphabet_end - tileset_alphabet






SECTION "TILE_DATA", ROMX

tileset_01: 
INCBIN "assets/tileset-01.bin"      ;;  Tileset 01
tileset_01_end:

tileset_02:
INCBIN "assets/Player_sprites.bin"    ;;  Sprites 01
tileset_02_end:

tileset_03:
INCBIN "assets/tileset-HUD-01.bin"    ;;  HUD 01
tileset_03_end:

tileset_04:
INCBIN "assets/tileset_castle_01.bin"
tileset_04_end:

tileset_05:                        ;; MAIN MENU
INCBIN "assets/tileset-Main-Menu.bin"
tileset_05_end:

tileset_06:                        ;; PAUSE MENU
INCBIN "assets/tileset-Pause-Menu.bin"
tileset_06_end:

tileset_07:
INCBIN "assets/Enemy_sprites.bin"    ;;  Sprites 01
tileset_07_end:

tileset_08::
INCBIN "assets/tileset-alphabet.bin"    ;;  Sprites 01
tileset_08_end::


