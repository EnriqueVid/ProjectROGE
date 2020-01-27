INCLUDE "src/main.h.s"


SECTION "MAIN", ROM0

_main:
    nop
    ld sp, $FFFF                ;; Stack Pointer a FFFF

    ld bc, DMACopyEnd-DMACopy       ;; Cantidad
    ld de, DMACopy                  ;; Inicio
    ld hl, VblankInterruptHandler   ;; Destino
    call _ldir

    ld  hl, $C000
    ld  bc, 40*4
    call _clear_data




;;---------------  POSICION DEL LA VISTA  ---------------
    xor a					;; Sets a to 0 [xor a - 4 ticks  |  ld a, $0 - 7 ticks]
	ld hl,$FF42				;; FF42 - FF43  -->  Tile scroll X, Y
	ld a, $E0+16
	ldi	[hl], a				;; FF42: SCY --> Tile Scroll Y  |
    ld a, $E8+16
	ld	[hl], a				;; FF43: SCX --> Tile Scroll X  +- Setea el scroll de la pantalla a (0, 0)


;;---------------  CONFIGURACION DE LA PANTALLA  ---------------
    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]      	    ;; Apaga la pantalla (Resetea el bit 7 del control LCD, que indica si la pantalla esta encendida o apagada)
    set     6,[hl]              ;; Indica que la Window se lee de las direcciones 9C00 - 9FFF
    set     5,[hl]              ;; Activa el uso de Window
    set     1,[hl]				;; Activa el uso de Sprites
    set     2,[hl]				;; Activa el uso de Sprites Grandes

;;---------------  CARGAR LOS TILES EN VRAM  ---------------
    ld  hl, $8010                        ;; Destiny
    ld	de, Sprite_01                    ;; Source 
	ld	bc, Sprite_01_end-Sprite_01      ;; Cuantity
    call _ldir

    ld  hl, $9800
    ;ld  a, $00
    ld  bc, $9BFF-9801
    call _clear_data



;;---------------  DEFINIR PALETA  ---------------
    ld a, %11100100		        ;;DDCCBBAA .... A=Background 0=Black, 3=White
    call _define_palette


;;---------------  ACTIVAR INTERRUPCIONES --------------
    ld  a, %00000001
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
    call _set_player
    call _draw_player

    call _set_enemy
    call _draw_enemy

    ;call _draw_map
    ld bc, $0003
    ld de, $0005
    call _set_scroll_map
    ;call _draw_column
    ;call _draw_row

    ld a, 10
    ld hl, $9C00
    
_window_loop:
    push af
    ld a, $0
    call _draw_tile
    ld bc, 02
    add hl, bc
    pop af
    dec a
    jr nz, _window_loop


    ld hl, $FF4A      ;; Seteamos la window 
    ld a, $80         ;; Window Y
    ldi [hl], a
    ld a, $07
    ld [hl], a


    xor a
    ld [scroll], a
    ld [_win], a


_main_loop:

    ei
	ld a, [scroll]
	cp $0 
	jr nz, no_buttons 

    ;ld a, [_win]
    ;cp 01
    ;jr z, _main

    ;call _colision_enemy

	xor a
	ld b, $0
	ld c, $0


    ld a, %11101111         ;; Comprobar D-Pad
    ld [$FF00], a

    ld a, [$FF00]           ;; Obtenemos las teclas pulsadas

	bit 0, a
	jr nz, check_move_left
		inc b 


check_move_left:
	bit 1, a
	jr nz, check_move_up
		dec b

check_move_up:
	bit 2, a
	jr nz, check_move_down
		dec c

check_move_down:
	bit 3, a
	jr nz, end_check_move
		inc c

end_check_move:
	ld a, b
	or c
	jr z, no_move
        
        ;call _collisions
        ;ld a, b
        ;or c
        ;jr z, no_move

        push bc
        call _update_scroll_map 
        pop bc

		call _set_scroll_screen
		ld a, [_player_X]
        add a, b
        ld [_player_X], a
        ld a, [_player_Y]
        add a, c
        ld [_player_Y], a
        jr no_buttons

no_move:

	

no_buttons:

	call _update_scroll

    ;ld a, [$FF42]
    ;ld [scrollPositionX], a
    ;ld a, [$FF43]
    ;ld [scrollPositionY], a


    jp _main_loop


_collisions:
    push bc

    ld a, [_player_X]
    add b
    ld b, a
    ld a, [_player_Y]
    ld c, a
    call _get_map_tile

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
    call _get_map_tile

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
    call _get_map_tile

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




Sprite_01: 
INCBIN "assets/Sprites01.bin"
Sprite_01_end: