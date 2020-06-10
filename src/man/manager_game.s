INCLUDE "src/man/manager_game.h.s"
INCLUDE "src/man/manager_playable.h.s"
INCLUDE "src/man/manager_level.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_hud.h.s"
INCLUDE "src/data.h.s"




SECTION "MAN_GAME_VARS", WRAM0

mg_game_state:    ds $01    ;; Indica el estado del juego
mg_win_condition: ds $01    ;; Condicion de victoria en un nivel
mg_actual_level:  ds $01    ;; Nivel de juego actual
mg_input_data:    ds $03    ;; +-> Datos de las pulsaciones de los botones (x, y, btn)
                            ;; | btn Bit 0 = A
                            ;; | btn Bit 1 = B
                            ;; | btn Bit 2 = Select
                            ;; | btn Bit 3 = Start

mg_grab_item: ds $01        ;;Indica si se puede coger un objeto o no

mg_hud:
    m_define_entity_hud

;;Variables auxiliares
aux_prev_input_x: ds $01    ;;
aux_prev_input_y: ds $01    ;;
aux_prev_input_btn: ds $01  ;;
aux_menu_selection: ds $01
aux_max_menu_selections: ds $01 


SECTION "MAN_GAME_FUNCS", ROM0

test_text: db "Hello_World.Here_is_Johnny.Muajajajaja/"

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
    ;;PROBAR COSAS
    ; ld de, test_text
    ; ld bc, $9821
    ; ld hl, $8C00
    ; call _sr_draw_text
    





    ld hl, ml_camera
    ld bc, 10
    add hl, bc
    ld a, [hl]
	cp $0 
	jp nz, .no_input

    ld a, [mg_win_condition]
    cp $00
    ret nz 

;;----------GRAB OBJECT-----------------
    ld a, [mg_grab_item]
    cp $00
    jr z, .no_grab_item
    

    ld hl, mp_player
    ldi a, [hl]
    ld d, a
    ld e, [hl]
    ;DE -> Player X,Y
    
    push de

    call _su_grab_item

    pop de
    cp $00
    jr z, .no_grab_item

    ld hl, ml_map
    ld b, $00
    ld c, d
    ld d, $00
    ;BC -> Player X
    ;DE -> Player Y
    call _sl_get_tilemap_dir

    ld a, $14
    ld [hl], a

    call _ml_load_player_bgmap
    ld a, $14
    call _sr_draw_tile

    ;db $18, $FE

    xor a
    ld [mg_grab_item], a

.no_grab_item:

;;--------------------------------------

;;__________DELETE_THIS__________________
    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .deletethis_loop_end

.deletethis_loop:
    push af
    push hl
    call _sr_enemies_initial_draw
    
    pop hl
    push hl 
    ld bc, ent_enemy_ia_state 
    add hl, bc
    ld a, [hl]
    cp IA_STATE_ATTACK
    jr nz, .continue_deletethis_loop

    pop hl
    push hl
    call _sr_attack_animation

    pop hl
    push hl
    ld bc, ent_enemy_objective_x 
    add hl, bc
    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a

    pop hl
    push hl
    call _sc_attack_melee

    pop hl
    push hl
    ld bc, ent_enemy_ia_state 
    add hl, bc
    ld a, IA_STATE_IDLE
    ld [hl], a


.continue_deletethis_loop:
    pop hl
    pop af
    ld bc, entity_enemy_size
    add hl, bc
    dec a
    jr nz, .deletethis_loop

    call _su_update_player_hud_data
    call _sr_update_draw_player_hud

.deletethis_loop_end:
;;_______________________________________


    ;;Control de reaparición de los enemigos
    
    ld a, [mp_respawn_steps]
    cp $00
    jr nz, .no_spawn_enemy

    ld a, [mp_enemy_num]
    ;cp $01                  ;;Máximo número de enemigos
    cp $06                  ;;Máximo número de enemigos
    jr z, .no_spawn_enemy

    call _si_respawn_enemy
    call _generate_random
    srl a
    srl a
    srl a
    ;srl a
    inc a
    ld [mp_respawn_steps], a

.no_spawn_enemy:

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
        
        push hl
        ld de, ep_dir_x
        add hl, de
        ldi a, [hl]
        ld d, a
        ld a, [hl]
        ld e, a
        ld a, $01

        pop hl
        push hl
        call _sc_check_attack_melee
        
        pop hl
        push hl
        push bc
        push af

        call _sr_attack_animation

        pop af
        pop bc
        cp $00
        jr z, .p_attack_failed

        pop hl
        push hl

        call _sc_attack_melee


.p_attack_failed:
        pop hl
        

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
        jp z, .no_input

        ld a, b
        ld [aux_prev_input_x], a
        ldi[hl], a
        ld a, c
        ld [aux_prev_input_y], a
        ld [hl], a

        ld a, %00000010
        ld [aux_prev_input_btn], a
        jp .no_input
    

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

        ld a, PAUSE_MENU
        ld [mg_game_state], a
        ret

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
    jp z, .no_input

        
        
        ld hl, mp_player                ;; +->Cambiamos la variable direccion del jugador
        ld de, ep_dir_x                 ;; |
        add hl, de                      ;; |
        ld a, b                         ;; |
        ldi [hl], a                     ;; |
        ld a, c                         ;; |
        ld [hl], a                      ;; |
        

        ld hl, mp_player
        ld a, $01
        call _sp_playable_collisions    ;;Comprobamos las colisiones en la direccion del jugador
        ld a, b
        or c
        jp z, .no_input



        ld hl, mp_player                ;; +->Actualizamos la direccion del jugador
        ld de, ep_dir_x                 ;; |
        add hl, de                      ;; |
        ld a, b                         ;; |
        ldi [hl], a                     ;; |
        ld a, c                         ;; |
        ld [hl], a                      ;; |


        push bc                         ;; Comprobamos en que sala esta el jugador
        ld hl, mp_player
        ldi a, [hl]
        add b
        ld b, a
        ld a, [hl]
        add c
        ld c, a
        call _sl_check_room      
        
        push af
        ld hl, mp_player
        ldi a, [hl]
        ld b, a
        ld a, [hl]
        ld c, a
        dec hl
        ;BC -> Player X, Y
        pop af

        ld de, ep_room                  ;; Comprobamos si ha salido/entrado de una habitación
        add hl, de
        cp $80                          ;; A -> Room actual del jugador ($80 = ninguna)
        jr nz, .no_out
        

            ld a, [hl]                  ;;Comprobamos si ya estaba fuera de una habitacion
            cp $80
            jr z, .end_room_check

            ld a, $80
            ldi [hl], a
            ld a, b
            ldi [hl], a
            ld a, c
            ld [hl], a

            jr .end_room_check
.no_out:
        ldi [hl], a 
        ld a, $80
        ldi [hl], a
        ld [hl], a

.end_room_check:
        pop bc


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

.no_move:
    
;;Control de reaparición de los enemigos
ld a, [mp_respawn_steps]
cp $00
jr z, .ia_engine
    dec a
    ld [mp_respawn_steps], a
           

.ia_engine:
    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .no_input

.ia_loop:
    push af

    push hl
    call _si_choose_IA_action
    pop hl

    ;push hl
    ;call _si_move_to
    ;pop hl

    pop af

    ld bc, entity_enemy_size
    add hl, bc

    dec a
    jr nz, .ia_loop


.no_input:

    call _sl_update_scroll
    call _sr_draw_enemies
    ;call _wait_Vblank

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
;;  AF
;;
;;==============================================================================================
_mg_init:

    xor a
    ld [mg_win_condition], a
    ld [mg_input_data], a
    ld [mg_input_data + 1], a
    ld [mg_input_data + 2], a
    ld [aux_prev_input_x], a
    ld [aux_prev_input_y], a
    ld [mg_grab_item], a

    ret



;;==============================================================================================
;;                              MANAGER PLAYABLE INIT MAIN MENU
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en main menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_main_menu_loop:

    call _su_input

    ld hl, mg_input_data
    inc hl
    inc hl
    ld a, [hl]


    cp $DF
    ret nz

    jr _mg_main_menu_loop



;;==============================================================================================
;;                              MANAGER PLAYABLE INIT MAIN MENU
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en main menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_init_main_menu:

    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]              ;; Apagar la pantalla

    ld hl, $9000
    ld a, 3
    call _sr_load_tiles

    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	set     7,[hl]              ;; Encender la pantalla

    ld hl, $FF4A      
    ld a, $90        ;; Window Y
    ldi [hl], a    ;; Seteamos la window 
    ld a, $07
    ld [hl], a

    ld hl, $9800
    ld bc, ent_map_main_menu
    call _sr_draw_screen_8x8

    call _wait_Vblank

    ;db $18, $FE

    ret


;;==============================================================================================
;;                              MANAGER PLAYABLE PAUSE MENU LOOP
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en main menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_pause_menu_loop:



.loop:

    call _su_input

    ;Datos de las pulsaciones de los botones (x, y, btn)
    ;A, B, Select, Start (0,1,2,3)
    ld hl, mg_input_data

    inc hl
    ldi a, [hl]
    cp $00
    jr z, .no_movement

        cp $01
        jr z, .move_down

        ;;COMPROBAMOS EL INPUT HACIA ARRIBA
        xor a
        ld [aux_prev_input_btn], a

        ld a, [aux_prev_input_y]
        cp $FF
        jr z, .end_action

        ld a, $FF
        ld [aux_prev_input_y], a
        ;;FIN DE LA COMPROBACION

        ld hl, $C008
        

        ld a, [aux_menu_selection]
        cp $00
        jr nz, .no_corregir_up

            ld a, $70
            ld [hl], a
            ld a, [aux_max_menu_selections]
            inc a
            ld [aux_menu_selection], a

.no_corregir_up:

        ld a, [hl]
        ld b, $10
        sub b
        ld [hl], a
        ld a, [aux_menu_selection]
        dec a
        ld [aux_menu_selection], a
        jr .end_action

.move_down:

        ;;COMPROBAMOS EL INPUT HACIA ABAJO
        xor a
        ld [aux_prev_input_btn], a

        ld a, [aux_prev_input_y]
        cp $01
        jr z, .end_action

        ld a, $01
        ld [aux_prev_input_y], a
        ;;FIN DE LA COMPROBACION

        ld hl, $C008
        
        ld a, [aux_menu_selection]
        cp $04
        jr nz, .no_corregir_down

            ld a, $10
            ld [hl], a
            ld a, $00
            dec a
            ld [aux_menu_selection], a

.no_corregir_down:

        ld a, [hl]
        ld b, $10
        add b
        ld [hl], a
        ld a, [aux_menu_selection]
        inc a
        ld [aux_menu_selection], a
        jr .end_action

.no_movement:
    xor a
    ld [aux_prev_input_y], a
    ld a, [hl]
    bit 0, a
    jr nz, .check_b

        jr .go_to_selection

.check_b:
    bit 1, a
    jr nz, .check_start

        ld a, GAME_LOOP
        ld [mg_game_state], a
        ret

.check_start:
    bit 3, a
    jr nz, .no_input

        ld a, GAME_LOOP
        ld [mg_game_state], a
        ret

.no_input:
    xor a
    ld [aux_prev_input_btn], a

.end_action:

    jp .loop

    
.go_to_selection:
    ld a, [aux_menu_selection]
    cp $00
    jr nz, .option_2
        ld a, ITEM_MENU
        ld [mg_game_state], a
        ret

.option_2:
    cp $01
    jr nz, .option_3
        ld a, GAME_LOOP
        ld [mg_game_state], a
        ret

.option_3:
    cp $02
    jr nz, .option_4
        ld a, GAME_LOOP
        ld [mg_game_state], a
        ret

.option_4:
    cp $03
    jr nz, .option_5
        ld a, GAME_LOOP
        ld [mg_game_state], a
        ret

.option_5:
    ld a, GAME_LOOP
    ld [mg_game_state], a
    ret

;;==============================================================================================
;;                              MANAGER PLAYABLE ITEM MENU LOOP
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en main menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_item_menu_loop:

    ld a, PAUSE_MENU
    ld [mg_game_state], a

.loop:
    call _su_input

    ld hl, mg_input_data
    inc hl
    inc hl
    ld a, [hl]


    cp $DF
    ret nz

    jr .loop

;;==============================================================================================
;;                              MANAGER GAME INIT PAUSE MENU
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en pause menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_init_pause_menu:

    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]              ;; Apagar la pantalla

    ld hl, $9000
    ld a, 4
    call _sr_load_tiles

    ld hl, $FF4A      
    ld a, $90        ;; Window Y
    ldi [hl], a    ;; Seteamos la window 
    ld a, $07
    ld [hl], a

    ld hl, $9800
    ld bc, ent_map_pause_menu
    call _sr_draw_screen_8x8

    ld hl, $9800
    ld bc, base_hud_end - base_hud 
    ld de, $9C00
    call _ldir_tile

    call _sr_draw_main_menu_info

    ;Borramos los sprites
    ld  hl, $C008                   
    ld  bc, 40*4-8                  
    call _clear_data        

    ld hl, $C008

    ld a, $0020
    ldi [hl], a
    ld a, $0010
    ldi [hl], a
    ld a, $94
    ld [hl], a        

    call _sr_draw_main_menu_info
    
    xor a
    ld [aux_menu_selection], a
    ld a, $04
    ld [aux_max_menu_selections], a


    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	set     7,[hl]              ;; Encender la pantalla

    xor a
    ld hl,$FF42				;; FF42 - FF43  -->  Tile scroll X, Y
	ldi	[hl], a				
	ld	[hl], a	

    ret


;;==============================================================================================
;;                              MANAGER GAME INIT ITEM MENU
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en pause menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_init_item_menu:

    call _wait_Vblank           ;; Esperamos a Vblank para apagar la pantalla
    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	res     7,[hl]              ;; Apagar la pantalla

    ld hl, $9000
    ld a, 4
    call _sr_load_tiles

    ld hl, $FF4A      
    ld a, $90        ;; Window Y
    ldi [hl], a    ;; Seteamos la window 
    ld a, $07
    ld [hl], a

    ld hl, $9800
    ld bc, ent_map_item_menu
    call _sr_draw_screen_8x8

    ;Borramos los sprites
    ld  hl, $C008                   
    ld  bc, 40*4-8                  
    call _clear_data        

    ld hl, $C008

    ld a, $0030
    ldi [hl], a
    ld a, $0010
    ldi [hl], a
    ld a, $94
    ld [hl], a        
    
    xor a
    ld [aux_menu_selection], a
    ld a, $04
    ld [aux_max_menu_selections], a

    ld bc, $0000
    call _sr_draw_item_name


    ld      hl,$FF40		    ;; FF40 - LCD Control (R/W)
	set     7,[hl]              ;; Encender la pantalla

    xor a
    ld hl,$FF42				;; FF42 - FF43  -->  Tile scroll X, Y
	ldi	[hl], a				
	ld	[hl], a	

    ret



;;==============================================================================================
;;                              MANAGER PLAYABLE INIT PAUSE MENU
;;----------------------------------------------------------------------------------------------
;; Inicializa todo lo necesario para mostrar en pause menu
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_mg_level_init:    

    call _mp_init
    call _ml_init

    call _sl_init_level
    call _sr_draw_hud

    ld hl, mp_player
    ld bc, $C000
    call _sr_draw_sprite

    call _su_update_all_hud_data
    call _sr_update_draw_player_hud


    ld a, [mg_actual_level]
    cp $01

    jp z, .level_02

    ld bc, $0A04
    ld de, $0606
    call _ml_new_room
    ld bc, $1403
    ld de, $0805
    call _ml_new_room
    ld bc, $1F03
    ld de, $0507
    call _ml_new_room
    ld bc, $040C
    ld de, $0506
    call _ml_new_room
    ld bc, $0F10
    ld de, $0605
    call _ml_new_room
    ld bc, $1912
    ld de, $0506
    call _ml_new_room
    ld bc, $0A17
    ld de, $0606
    call _ml_new_room

    xor a
    ld bc, $1006
    call _ml_add_exit
    xor a
    ld bc, $0C0A
    call _ml_add_exit

    ld a, 1
    ld bc, $1406
    call _ml_add_exit
    ld a, 1
    ld bc, $1808
    call _ml_add_exit
    ld a, 1
    ld bc, $1C06
    call _ml_add_exit

    ld a, 2
    ld bc, $1F07
    call _ml_add_exit
    ld a, 2
    ld bc, $220A
    call _ml_add_exit

    ld a, 3
    ld bc, $090F
    call _ml_add_exit

    ld a, 4
    ld bc, $0F12
    call _ml_add_exit
    ld a, 4
    ld bc, $1310
    call _ml_add_exit
    ld a, 4
    ld bc, $1215
    call _ml_add_exit

    ld a, 5
    ld bc, $1C12
    call _ml_add_exit
    ld a, 5
    ld bc, $1C18
    call _ml_add_exit

    ld a, 6
    ld bc, $0D17
    call _ml_add_exit
    ld a, 6
    ld bc, $101C
    call _ml_add_exit

    ld a,  $0A
    ld bc, $1504
    ld de, $0001
    call _ml_new_item

    ld a,  $FF
    ld bc, $1607
    ld de, $0050
    call _ml_new_item

    ld a,  $00
    ld bc, $1C15
    ld de, $0001
    call _ml_new_item

    ;db $18, $FE
    ret

.level_02:

    ld bc, $0403
    ld de, $0505
    call _ml_new_room
    ld bc, $1103
    ld de, $0506
    call _ml_new_room
    ld bc, $1D03
    ld de, $0605
    call _ml_new_room
    ld bc, $0411
    ld de, $0505
    call _ml_new_room
    ld bc, $0F0F
    ld de, $0605
    call _ml_new_room
    ld bc, $1912
    ld de, $0506
    call _ml_new_room
    ld bc, $0419
    ld de, $0605
    call _ml_new_room
    ld bc, $0F18
    ld de, $0505
    call _ml_new_room


    xor a
    ld bc, $0708
    call _ml_add_exit

    ld a, 1
    ld bc, $1605
    call _ml_add_exit
    ld a, 1
    ld bc, $1309
    call _ml_add_exit

    ld a, 2
    ld bc, $1D06
    call _ml_add_exit
    ld a, 2
    ld bc, $2108
    call _ml_add_exit

    ld a, 3
    ld bc, $0611
    call _ml_add_exit
    ld a, 3
    ld bc, $0716
    call _ml_add_exit

    ld a, 4
    ld bc, $140F
    call _ml_add_exit
    ld a, 4
    ld bc, $1214
    call _ml_add_exit

    ld a, 5
    ld bc, $1C12
    call _ml_add_exit
    ld a, 5
    ld bc, $1915
    call _ml_add_exit

    ld a, 6
    ld bc, $0519
    call _ml_add_exit
    ld a, 6
    ld bc, $0A1C
    call _ml_add_exit

    ld a, 7
    ld bc, $1218
    call _ml_add_exit
    ld a, 7
    ld bc, $0F1B
    call _ml_add_exit

    ;call _sl_spawn_enemies
    ;call _sr_draw_enemies

    ret