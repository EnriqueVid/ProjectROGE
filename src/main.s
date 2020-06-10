INCLUDE "src/main.h.s"
INCLUDE "src/ent/entity_room.h.s"
INCLUDE "src/ent/entity_player.h.s"
INCLUDE "src/man/manager_game.h.s"
INCLUDE "src/data.h.s"



SECTION "MAIN", ROM0
;; DMA CODE
DMACopy:
    push af
    ld a, %11100111             ;;Reiniciamos el mostreo de Sprites
    ld [$FF40], a
    ld a, _sprite_buffer/256
    ld [$FF46], a
    ld a, $28
DMACopyWait:
    dec a
    jr nz, DMACopyWait
    pop af
    reti 
DMACopyEnd:


_main:
    ;INITIAL LOAD


    
    
    


    ld a, $01       ;Activate external RAM
    ld [$6000], a

    ld a, $0A       ;Enable external RAM
    ld [$0000], a

    ld a, $01       ;Load bank 0 in external RAM
    ld [$4000], a


    ld a, $AA
    ld [$A000], a
    
    
    ld a, $00       ;Disable external RAM
    ld [$0000], a

    ;db $18, $FE

    ld a, MAIN_MENU
    ld [mg_game_state], a

    ;;PALETTE
    ld a, %11100100		        ;;DDCCBBAA .... A=Background 0=White, 3=Black
    call _define_palette



    



    ;;LOAD FROM SAVE DATA
    xor a
    ld [mg_actual_level], a
        ;;Incializamos al jugador
    ld hl, mp_player             ;; Destino
    ld de, default_entity_player ;; Origen
    ld bc, entity_player_size    ;; Cantidad
    call _ldir

    call _mi_init
    ;ld bc, $0000
    ;ld  d, $00
    ;call _mi_add_money
    
    


.reboot:

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
    set     4,[hl]              ;; BG tiles de $8800 - $97F0
    set     1,[hl]				;; Activa el uso de Sprites
    set     2,[hl]				;; Activa el uso de Sprites Grandes


    
    ld      a, $88              ;; Seteamos el LYC para que cuando el hsync coincida con el LYC se active el bit de coincidencia del LCDSTAT
    ld      [$FF45], a

    ld hl, $FF41                ;; Activamos la comprobacion en el bit de coincidencia de LCDSTAT
    set 6, [hl]
;;---------------  INICIAR RELOJ  ---------------
    ld a, %00000101
    ld [$FF07], a


;;---------------  ACTIVAR INTERRUPCIONES --------------
    ld  a, %00000011            ;;Activamos las interrupciones en VBLANK y LCDSTAT
    ld [$FFFF], a
    ei 


;;---------------  ENCENDER LA PANTALLA  ---------------
    ld      hl, $FF40		;LCDC - LCD Control (R/W)	EWwBbOoC 
    set      7, [hl]          ;Turn on the screen


;;--------------- LOGICA DEL JUEGO ---------------------

    call _mg_init





.main_loop:
;;MAIN MENU
    ld a, [mg_game_state]
    cp MAIN_MENU
    jr nz, .return_game_loop
    
    call _mg_init_main_menu
    call _mg_main_menu_loop
    ld a, GAME_LOOP
    ld [mg_game_state], a
    ld a, $FF
    call _sr_fade_out
    ;jr .reboot



;GAME_LOOP
    
.init_game_loop:
    ;call _mg_init
    call _mg_level_init

.return_game_loop:
    ld a, [mg_game_state]
    cp GAME_LOOP
    jr nz, .init_pause_menu

    call _mg_init

    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]              ;; Apagar la pantalla

    ld hl, $9000
    xor a
    call _sr_load_tiles

    ld hl, $8800
    ld a, $02
    call _sr_load_tiles

    ld hl, $8000
    ld a, $01
    call _sr_load_tiles

    ld hl, $8200
    ld a, $05
    call _sr_load_tiles

    ld hl, $FF4A      
    ld a, $88        ;; Window Y
    ldi [hl], a    ;; Seteamos la window 
    ld a, $07
    ld [hl], a

    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	set     7,[hl]              ;; Encender la pantalla
    ;call _su_update_all_hud_data


    ld hl, mp_player
    ld bc, $C000
    call _sr_draw_sprite

    call _sl_init_level

    ld a, $FF
    call _sr_fade_in

    call _mg_game_loop

    ld a, $FF
    call _sr_fade_out


    ld a, [mg_game_state]
    cp PAUSE_MENU
    jr z, .init_pause_menu


    ld a, [mg_actual_level]

    inc a
    ld [mg_actual_level], a
    cp $02
    jp nz, .reboot
    ld hl, $9800
    jr .loop_clear
    

;;PAUSE MENU

.init_pause_menu:
    ld a, [mg_game_state]
    cp PAUSE_MENU
    jr nz, .init_item_menu

    call _mg_init_pause_menu

    ld a, $FF
    call _sr_fade_in

    ;db $18, $FE

    call _mg_pause_menu_loop

    ld a, $FF
    call _sr_fade_out

    


.init_item_menu:
    ld a, [mg_game_state]
    cp ITEM_MENU
    jr nz, .main_loop_end

    call _mg_init_item_menu

    ld a, $FF
    call _sr_fade_in


    call _mg_item_menu_loop

    ld a, $FF
    call _sr_fade_out

.main_loop_end:
    jp .main_loop

.loop_clear:

    db $18, $FE
    
    ld a, $90
    call _VRAM_wait
    ldi [hl], a

    ld a, h
    cp $9B
    jr nz, .loop_clear

    ld a, l
    cp $FF
    jr nz, .loop_clear

    ld hl, $9800

jr .loop_clear







