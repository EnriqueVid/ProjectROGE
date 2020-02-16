INCLUDE "src/man/manager_game.h.s"
INCLUDE "src/man/manager_playable.h.s"
INCLUDE "src/man/manager_level.h.s"


SECTION "MAN_GAME_VARS", WRAM0

mg_win_condition: ds $01    ;;Condicion de victoria en un nivel
mg_actual_level: ds $01     ;;Nivel de juego actual
mg_input_data: ds $03       ;; +-> Datos de las pulsaciones de los botones (x, y, btn)
                            ;; | btn Bit 0 = A
                            ;; | btn Bit 1 = B
                            ;; | btn Bit 2 = Select
                            ;; | btn Bit 3 = Start



SECTION "MAN_GAME_FUNCS", ROM0


;;==============================================================================================
;;                                    MANAGER PLAYABLE GAME LOOP
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_game
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mg_game_loop:

    ei

    ld hl, ml_camera
    ld bc, 10
    add hl, bc
    ld a, [hl]
	cp $0 
	jr nz, .no_input

    ld a, [mg_win_condition]
    cp $00
    ret nz 

    call _su_input

    ;;Comprobamos el input de movimiento
    ld hl, mg_input_data
    ldi a, [hl]
    ld b, a
    ldi a, [hl]
    ld c, a
    or b
    jr z, .no_move

        ld hl, mp_player
        ld de, ep_dir_x
        add hl, de
        ld a, b
        ldi [hl], a 
        ld a, c
        ld [hl], a
        
        ld hl, mp_player
        call _sp_playable_collisions
        ld a, b
        or c
        jr z, .no_input

        ld hl, mp_player
        ld a, [hl]
        add a, b
        ldi [hl], a
        ld a, [hl]
        add a, c
        ld [hl], a

        push bc
        call _sr_update_scroll_map
        pop bc

		call _sl_set_scroll_screen
		ld a, [_player_X]
        add a, b
        ld [_player_X], a
        ld a, [_player_Y]
        add a, c
        ld [_player_Y], a
        jr .no_input

.no_move:
    ;;Comprobamos el input de accion
    ld a, [hl]
    bit 0, a
    jr nz, .no_input

        ld hl, mp_player
        call _sr_attack_animation
        call _sc_physical_attack
        

.ia_engine:


.no_input:

    call _sl_update_scroll
    call _sr_draw_enemies

    jr _mg_game_loop

    ret



;;==============================================================================================
;;                                    MANAGER PLAYABLE INIT
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_game
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mg_init:

    xor a
    ld [mg_win_condition], a
    ld [mg_actual_level], a
    ld [mg_input_data], a
    ld [mg_input_data + 1], a
    ld [mg_input_data + 2], a
    
    call _mp_init
    call _ml_init

    call _sl_init_level
    call _sr_draw_hud

    ld hl, mp_player
    ld bc, $C000
    call _sr_draw_sprite

    call _mp_new_enemy
    call _mp_new_enemy
    call _mp_new_enemy
    call _mp_new_enemy
    call _mp_new_enemy
    call _mp_new_enemy

    call _sl_spawn_enemies
    call _sr_draw_enemies

    ret