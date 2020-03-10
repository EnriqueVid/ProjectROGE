INCLUDE "src/main.h.s"
INCLUDE "src/ent/entity_room.h.s"


SECTION "MAIN", ROM0

_main:
    nop
    ld sp, $FFFF                ;; Stack Pointer a FFFF

    ;; Cambiamos la funcion DMA de ROM a HRAM para su futuro uso
    ld bc, DMACopyEnd-DMACopy       ;; Cantidad
    ld de, DMACopy                  ;; Inicio
    ld hl, VblankInterruptHandler   ;; Destino
    call _ldir

    ;;Seteamos el Sprite Buffer
    ld  hl, $C000                   ;; Declaramos el sprite buffer
    ld  bc, 40*4                    ;; Tamano 40*4 = 160 = $A0
    call _clear_data                ;; Limpiamos la basura que pueda haber en la RAM



;;---------------  POSICION DEL LA VISTA  ---------------
    xor a					;; Sets a to 0 [xor a - 4 ticks  |  ld a, $0 - 7 ticks]
	ld hl,$FF42				;; FF42 - FF43  -->  Tile scroll X, Y
	ldi	[hl], a				;; FF42: SCY --> Tile Scroll Y  |
	ld	[hl], a				;; FF43: SCX --> Tile Scroll X  +- Setea el scroll de la pantalla a (0, 0)


;;---------------  CONFIGURACION DE LA PANTALLA  ---------------
    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]      	    ;; Apaga la pantalla (Resetea el bit 7 del control LCD, que indica si la pantalla esta encendida o apagada)
    set     6,[hl]              ;; Indica que la Window se lee de las direcciones 9C00 - 9FFF
    set     5,[hl]              ;; Activa el uso de Window
    res     4,[hl]              ;; BG tiles de $8800 - $97F0
    set     1,[hl]				;; Activa el uso de Sprites
    set     2,[hl]				;; Activa el uso de Sprites Grandes


    
    ld      a, $88              ;; Seteamos el LYC para que cuando el hsync coincida con el LYC se active el bit de coincidencia del LCDSTAT
    ld      [$FF45], a

    ld hl, $FF41                ;; Activamos la comprobacion en el bit de coincidencia de LCDSTAT
    set 6, [hl]
;;---------------  INICIAR RELOJ  ---------------
    ld a, %00000101
    ld [$FF07], a



;;---------------  DEFINIR PALETA  ---------------
    ld a, %11100100		        ;;DDCCBBAA .... A=Background 0=Black, 3=White
    call _define_palette


;;---------------  CARGAR LOS TILES EN VRAM  ---------------
    ; ld  hl, $8010                        ;; Destiny
    ; ld	de, tileset_01                    ;; Source 
	; ld	bc, tileset_01_end-tileset_01      ;; Cuantity
    ; call _ldir

    ld hl, $9000
    ld a, 0
    call _sr_load_tiles

    ld hl, $8000
    ld a, 1
    call _sr_load_tiles

    ld hl, $8800
    ld a, 2
    call _sr_load_tiles

    ld  hl, $9800
    ld  bc, $9BFF-9801
    call _clear_data


;;---------------  ACTIVAR INTERRUPCIONES --------------
    ld  a, %00000011            ;;Activamos las interrupciones en VBLANK y LCDSTAT
    ld [$FFFF], a
    ei 


;;---------------  ENCENDER LA PANTALLA  ---------------
    ld      hl, $FF40		;LCDC - LCD Control (R/W)	EWwBbOoC 
    set      7, [hl]          ;Turn on the screen


;;---------------  DIBUJAMOS EL MAPA  ---------------


    ;ld a, 4
    ;ld [_mActual_X], a
    ;ld [_mActual_Y], a
    ;call _draw_map_scroll
    ;;call _set_player
    ;;call _draw_player

    ;;call _set_enemy
    ;;call _draw_enemy

    ;call _draw_map
    ;ld bc, $0003
    ;ld de, $0005
    ;call _set_scroll_map
    ;call _draw_column
    ;call _draw_row

    call _mg_init

    ld hl, mp_player
    ld bc, $C000
    call _sr_draw_sprite

    call _sl_init_level

    call _sr_draw_hud

    call _mg_game_loop

    jp _main


_collisions:
    push bc

    ld a, [_player_X]
    add b
    ld b, a
    ld a, [_player_Y]
    ld c, a
    call _sl_get_map_tile

    pop bc
    ld a, [hl]
    cp 02
    jr z, .continue
    cp 0
    jr nz, .end_collisions
.continue:

    push bc

    ld a, [_player_X]
    ld b, a
    ld a, [_player_Y]
    add c
    ld c, a
    call _sl_get_map_tile

    pop bc
    ld a, [hl]
    cp 02
    jr z, .continue2
    cp 0
    jr nz, .end_collisions

.continue2:
    push bc

    ld a, [_player_X]
    add b
    ld b, a
    ld a, [_player_Y]
    add c
    ld c, a
    call _sl_get_map_tile

    pop bc
    ld a, [hl]
    cp 02
    jr z, .collision_win
    cp 0
    jr nz, .end_collisions

    ret

.end_collisions:
    ld bc, $0000
    ret

.collision_win:
    ld a, 01
    ld [_win], a
    ret


