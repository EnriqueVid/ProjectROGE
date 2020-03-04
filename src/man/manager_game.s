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

;;Variables auxiliares
aux_prev_input_x: ds $01    ;;
aux_prev_input_y: ds $01    ;;
aux_prev_input_btn: ds $01  ;;



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

    ;ei

    ld hl, ml_camera
    ld bc, 10
    add hl, bc
    ld a, [hl]
	cp $0 
	jp nz, .no_input

    ld a, [mg_win_condition]
    cp $00
    ret nz 

    call _su_input

    ;;Comprobamos el input de los botones de accion
    ld hl, mg_input_data
    inc hl
    inc hl
    
    ld a, [hl]
    bit 0, a
    jr nz, .check_B
        xor a
        ld [aux_prev_input_x], a
        ld [aux_prev_input_y], a
        ld hl, mp_player
        call _sr_attack_animation
        call _sc_physical_attack

        ld a, %00000001
        ld [aux_prev_input_btn], a
        jp .no_move

.check_B:
    bit 1, a
    jr nz, .check_select
        
        ld hl, mg_input_data
        ldi a, [hl]
        ld b, a
        ld a, [hl]
        ld c, a

        ld a, b
        cp $00
        jr nz, .input_x_no_zero
            ld a, [aux_prev_input_x]
            ld b, a

.input_x_no_zero:
        ld a, c
        cp $00
        jr nz, .input_y_no_zero
            ld a, [aux_prev_input_y]
            ld c, a

.input_y_no_zero:
        ld hl, mp_player
        ld de, ep_dir_x 
        add hl, de
        or b
        jp z, .no_move

        ld a, b
        ld [aux_prev_input_x], a
        ldi[hl], a
        ld a, c
        ld [aux_prev_input_y], a
        ld [hl], a

        ld a, %00000010
        ld [aux_prev_input_btn], a
        jp .no_move
    

.check_select:
    bit 2, a
    jr nz, .check_start
        ld a, [aux_prev_input_btn]
        bit 2, a
        jp nz, .no_move

        xor a
        ld [aux_prev_input_x], a
        ld [aux_prev_input_y], a

        ld a, %00000100
        ld [aux_prev_input_btn], a
        jp .no_move

.check_start:
    bit 3, a
    jr nz, .no_action
        xor a
        ld [aux_prev_input_x], a
        ld [aux_prev_input_y], a

        ld a, %00001000
        ld [aux_prev_input_btn], a
        jr .no_move

.no_action:

    xor a
    ld [aux_prev_input_x], a
    ld [aux_prev_input_y], a
    ld [aux_prev_input_btn], a

    ;;Comprobamos el input de movimiento
    ld hl, mg_input_data
    ldi a, [hl]
    ld b, a
    ldi a, [hl]
    ld c, a
    or b
    jr z, .no_input

        
        
        ld hl, mp_player                ;; +->Cambiamos la variable direccion del jugador
        ld de, ep_dir_x                 ;; |
        add hl, de                      ;; |
        ld a, b                         ;; |
        ldi [hl], a                     ;; |
        ld a, c                         ;; |
        ld [hl], a                      ;; |
        

        ld hl, mp_player
        call _sp_playable_collisions    ;;Comprobamos las colisiones en la direccion del jugador
        ld a, b
        or c
        jr z, .no_input


        ld hl, mp_player                ;; +->Actualizamos la direccion del jugador
        ld de, ep_dir_x                 ;; |
        add hl, de                      ;; |
        ld a, b                         ;; |
        ldi [hl], a                     ;; |
        ld a, c                         ;; |
        ld [hl], a                      ;; |

        ld hl, mp_player                ;; Actualizamos la posicion del jugador
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


        ;;Control de reaparición de los enemigos
        ld a, [mp_respawn_steps]
        cp $00
        jr z, .spawn_enemy

            dec a
            ld [mp_respawn_steps], a
            jr .no_move
.spawn_enemy:

            ld a, [mp_enemy_num]
            cp $06
            jr z, .no_move

            inc a
            ld [mp_enemy_num], a

            ;db $18, $FE
            call _si_respawn_enemy

            call _generate_random
            srl a
            srl a
            srl a
            srl a
            inc a
            ld [mp_respawn_steps], a

        jr .no_move
.no_move:
    ;;Comprobamos el input de accion
    
        

.ia_engine:


.no_input:

    call _sl_update_scroll
    call _sr_draw_enemies

    jp _mg_game_loop

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
    ld [aux_prev_input_x], a
    ld [aux_prev_input_y], a
    
    call _mp_init
    call _ml_init

    call _sl_init_level
    call _sr_draw_hud

    ld hl, mp_player
    ld bc, $C000
    call _sr_draw_sprite

    xor a
    call _mp_new_enemy
    xor a
    call _mp_new_enemy
    xor a
    call _mp_new_enemy
    xor a
    call _mp_new_enemy
    xor a
    call _mp_new_enemy
    xor a
    call _mp_new_enemy

    call _sl_spawn_enemies
    call _sr_draw_enemies

    ret