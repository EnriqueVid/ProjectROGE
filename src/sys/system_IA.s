INCLUDE "src/sys/system_IA.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_playable.h.s"


SECTION "SYS_IA_VARS", WRAM0




SECTION "SYS_IA_FUNCS", ROM0




;;==============================================================================================
;;                                    CHOOSE IA ACTION
;;----------------------------------------------------------------------------------------------
;; Selecciona la accion que va a hacer el enemigo
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_si_choose_IA_action:
    
    push hl

    ld bc, ent_enemy_ia_state
    add hl, bc
    ld a, [hl]
    cp IA_STATE_NO_IA
    cp IA_STATE_ATTACK
    jp z, .failure
    cp IA_STATE_SLEEP
    jr nz, .no_sleep    ;; Comprobamos si el enemigo esta dorimido

        ;;Si esta dormido comprobamos a que distancia esta del jugador
        pop hl
        push hl
        ldi a, [hl]
        ld b, a
        ld a, [hl]
        ld c, a
        call _sp_check_distance_player
        pop hl

        ;;Si esta a mas de una casilla no se hace nada
        ld a, b
        cp 2
        ret nc

        ld a, c
        cp 2
        ret nc

        ;;Si esta a una casilla del jugador, se despierta
        ld bc, ent_enemy_ia_state
        add hl, bc
        ld a, IA_STATE_IDLE
        ld[hl], a
        ret
        

.no_sleep:
    ;;Si no esta dormido, se comprueba que tipo de ataque tiene
    pop hl
    push hl
    ld bc, ent_enemy_atk_type
    add hl, bc
    ld a, [hl]
    cp ATTACK_MELEE
    jr z, .check_melee

        ;;Comprobar ataque a distancia
        ;pop hl
        jr .check_paral

.check_melee:

        ;;Comprobar ataque a melee
        pop hl
        push hl
        ldi a, [hl]
        ld c, [hl]
        ld b, a
        call _sp_check_distance_player
        ;BC -> Distance X,Y 
        ;DE -> Direction X,Y

        ld a, b
        cp 2
        jr nc, .check_paral

        ld a, c
        cp 2
        jr nc, .check_paral


        pop hl
        push hl
        push de

        xor a
        call _sc_check_attack_melee
        
        pop de

        cp $00
        jr z, .check_paral

        pop hl
        ;push hl
        ld bc, ep_dir_x
        add hl, bc

        ld [hl], d
        inc hl
        ld [hl], e
        
        ;pop hl
        
        ;call _sr_attack_animation
        ;db $18, $FE

        ret

    ;;Si no puede atacar, se comprueba si esta paralizado para ver si se mueve
.check_paral:
    pop hl
    push hl

    ld bc, ep_cSTAT
    add hl, bc
    ld a, [hl]
    cp STATUS_PARAL
    jr nz, .check_chase
        
        ;;Si esta paralizado se actualiaza su estado y nada mas

        pop hl
        ;call su_update_status
        ret

.check_chase
    ;;Si no esta paralizado se comprueba si puede perseguir al jugador por distancia al mismo
    pop hl
    push hl

    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a
    call _sp_check_distance_player

    ld a, b
    add c
    ;;Si el jugador está a 2 o menos casillas le perseguimos activamente
    cp $04
    jr nc, .check_room

        pop hl
        push hl
        ld bc, ent_enemy_objective_x
        add hl, bc

        ld bc, mp_player
        ld a, [bc]
        ldi [hl], a
        inc bc
        ld a, [bc]
        ld [hl], a 
        pop hl
        push hl

        call _si_move_to
        
        pop hl
        ld bc, ent_enemy_objective_x
        add hl, bc
        ld a, $80
        ldi [hl], a
        ld [hl], a
        ret

.check_room:
    ;;Si el jugador no esta al alcance comprobamos si el enemigo esta en una sala

    pop hl
    push hl

    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a
    
    call _sl_check_room     ;; A -> room_id ($80 = none)

    pop hl
    push hl
    ld bc, ep_room
    add hl, bc
    ld [hl], a
    
    ;;Si no esta en una sala, hacemos que el enemigo simplemente se mueva por los pasillos
    cp $80
    jr nz, .check_player_room

        pop hl
        push hl
        ld bc, ent_enemy_objective_x
        add hl, bc
        ld a, $80
        ldi [hl], a
        ld [hl], a
        pop hl
        call _si_wander
        ret

.check_player_room:

    ;; Si el enemigo esta en una habitacion, se comprueba si el jugador esta en la misma
    ld hl, mp_player
    ld bc, ep_room
    add hl, bc
    ld b, a
    ld a, [hl]
    cp b
    jr nz, .check_player_was_here
    
    ;;si el enemigo esta en la misma sala que el jugador, este lo persigue de forma directa
        
        ;;Almacenamos que el enemigo ha visto al jugador en la misma sala
        pop hl
        push hl
        ld bc, ent_enemy_last_player_room
        add hl, bc
        ld [hl], a

        pop hl
        push hl
        ld bc, ent_enemy_objective_x
        add hl, bc

        ld bc, mp_player
        ld a, [bc]
        ldi [hl], a
        inc bc
        ld a, [bc]
        ld [hl], a 
        pop hl
        push hl

        call _si_move_to
        
        pop hl
        ld bc, ent_enemy_objective_x
        add hl, bc
        ld a, $80
        ldi [hl], a
        ld [hl], a

        ret


.check_player_was_here:

    ;;Si el jugador no esta en la misma sala comprobamos si lo hemos visto antes
    pop hl
    push hl
    ld bc, ent_enemy_last_player_room
    add hl, bc
    ld a, [hl]
    cp $80
    jr nz, .chase_player_last_pos

        ;;Si el jugador no estaba en esta sala, nos movemos hacia el objetivo, en caso de no haber, elige uno
        pop hl
        push hl

        ld bc, ent_enemy_objective_x
        add hl, bc

        ldi a, [hl]
        ld b, a
        ld a, [hl]
        ld c, a
        cp $80
        jr nz, .continue_move_to

            pop hl
            push hl
            ld bc, ep_room
            add hl, bc
            ld a, [hl]
            call _sl_get_random_exit
            pop hl
            push hl
            ld de, ent_enemy_objective_x
            add hl, de
            ld [hl], b
            inc hl
            ld [hl], c
 


.continue_move_to:
        pop hl
        push hl 

        call _si_move_to
        cp a, $80
        jr z, .not_in_exit

            pop hl

            push hl
            ld bc, ent_enemy_objective_x
            add hl, bc
            ld a, $80
            ldi [hl], a
            ld [hl], a
            pop hl

            call _si_wander

            ret

.not_in_exit:
        
        pop hl
        ret
        

.chase_player_last_pos:
    
    ;;Si el jugador estaba en la misma sala, marcamos la posicion de su salida como objetivo y eliminamos el haberlo visto
    ld a, $80
    ld [hl], a
    
    ld hl, mp_player
    ld de, ep_aux_x
    add hl, de
    ldi a, [hl]
    ld e, [hl]

    ;; AE -> Player exit X,Y

    pop hl
    push hl
    ld bc, ent_enemy_objective_x
    add hl, bc

    ldi [hl], a 
    ld [hl], e

    pop hl
    push hl
    call _si_move_to
    cp a, $80
    jr z, .not_in_exit

        pop hl
        push hl
        
        ld bc, ent_enemy_objective_x
        add hl, bc
        ld a, $80
        ldi [hl], a
        ld [hl], a
        pop hl

        call _si_wander

        ret

.not_in_player_exit:
        
    pop hl
    ret

.failure

    pop hl
    ret


;;==============================================================================================
;;                                            WANDER
;;----------------------------------------------------------------------------------------------
;; Se mueve en una de 4 direcciones sin ir hacia atrás, se usa para el movimiento en los pasillos
;; el orden de movimiento es: R, L, U, D
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_si_wander:

    push hl
    ld bc, ep_aux_x
    add hl, bc
    ld d, [hl]
    inc hl
    ld e, [hl]

    ;;DE -> Previous X,Y

    pop hl
    
    ld b, [hl]
    inc hl
    ld c, [hl]

    ;;BC -> Current X,Y

    dec hl
    ;;HL -> Enemy Ptr

.try_right:
    push de
    push bc
    push hl

    ld bc, $0100
    
    call _sp_playable_collisions
    ld a, b
    or c
    jr z, .try_left
        
        pop hl
        pop bc
        pop de
        push de
        push bc
        push hl

        ld a, $1
        add b
        ld b, a
        ;;BC -> Future position
        
        ;a = b          Comprobamos si la posicion futura y la pasada son la misma
        xor d
        ld d, a
        ld a, c
        xor e
        or d

        jr z, .try_left

            pop hl
            pop bc
            pop de
            
            push hl
            ld a, $1
            add b
            ldi [hl], a
            ld [hl], c
            pop hl

            ld de, ep_aux_x
            add hl, de
            ld [hl], b
            inc hl
            ld [hl], c

            ret

;;---------------------------------------------
.try_left:
    pop hl
    pop bc
    pop de
    push de
    push bc
    push hl

    ld bc, $FF00
    
    call _sp_playable_collisions
    ld a, b
    or c
    jr z, .try_up
        pop hl
        pop bc
        pop de
        push de
        push bc
        push hl

        ld a, $FF
        add b
        ld b, a
        ;;BC -> Future position
        
        ;a = b          Comprobamos si la posicion futura y la pasada son la misma
        xor d
        ld d, a
        ld a, c
        xor e
        or d

        jr z, .try_up

            pop hl
            pop bc
            pop de
            
            push hl
            ld a, $FF
            add b
            ldi [hl], a
            ld [hl], c
            pop hl

            ld de, ep_aux_x
            add hl, de
            ld [hl], b
            inc hl
            ld [hl], c

            ret

;;---------------------------------------------
.try_up:

    pop hl
    pop bc
    pop de
    push de
    push bc
    push hl

    ld bc, $00FF
    
    call _sp_playable_collisions
    ld a, b
    or c
    jr z, .try_down

        pop hl
        pop bc
        pop de
        push de
        push bc
        push hl

        ld a, $FF
        add c
        ld c, a
        ;;BC -> Future position
        
        ;a = c          Comprobamos si la posicion futura y la pasada son la misma
        xor e
        ld e, a
        ld a, b
        xor d
        or e

        jr z, .try_down

            pop hl
            pop bc
            pop de
            
            push hl
            ld [hl], b
            inc hl
            ld a, $FF
            add c
            ld [hl], a
            pop hl

            ld de, ep_aux_x
            add hl, de
            ld [hl], b
            inc hl
            ld [hl], c

            ret

;;---------------------------------------------
.try_down:
    pop hl
    pop bc
    pop de
    push de
    push bc
    push hl

    ld bc, $0001
    
    call _sp_playable_collisions
    ld a, b
    or c
    jr z, .no_move

        pop hl
        pop bc
        pop de
        push de
        push bc
        push hl

        ld a, $01
        add c
        ld c, a
        ;;BC -> Future position
        
        ;a = c          Comprobamos si la posicion futura y la pasada son la misma
        xor e
        ld e, a
        ld a, b
        xor d
        or e

        jr z, .no_move

            pop hl
            pop bc
            pop de
            
            push hl
            ld [hl], b
            inc hl
            ld a, $01
            add c
            ld [hl], a
            pop hl

            ld de, ep_aux_x
            add hl, de
            ld [hl], b
            inc hl
            ld [hl], c

            ret

;;---------------------------------------------
.no_move:
    pop hl
    pop bc
    pop de

    ld de, ep_aux_x
    add hl, de
    ld [hl], b
    inc hl
    ld [hl], c

    ret




;;==============================================================================================
;;                                            MOVE TO
;;----------------------------------------------------------------------------------------------
;; Genera un enemigo en el nivel en una posicion valida a una distancia del jugador
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_si_move_to:
 
   ;Guardamos en BC el objetivo del movimiento
    push hl
    ld bc, ent_enemy_objective_x    
    add hl, bc
    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a
    pop hl

   ;Sacamos el BC la direccion a la que el enemigo debe moverse y en DE la distancia 
    push hl
    ldi a, [hl]
    sub b
    ld b, $00
    jr z, .end_x
    jr nc, .izquierda
        xor %11111111
        inc a
        ld b, $01
        jr .end_x
.izquierda:
        ld b, $FF
.end_x:
    ld d, a

    ld a, [hl]
    sub c
    ld c, $00
    jr z, .end_y
    jr nc, .arriba
        xor %11111111
        inc a
        ld c, $01
        jr .end_y
.arriba:
        ld c, $FF
.end_y:
    ld e, a
    pop hl

    ;;HL -> Puntero al enemigo
    ;;BC -> direccion del movimiento X,Y
    ;;DE -> Distancia al objetivo X,Y

    push bc
    push hl
    push de
    call _sp_playable_collisions
    pop de
    pop hl

    ;;Calculamos si ha llegado a su objetivo
    ld a, b
    or c
    jr nz, .not_arrived

        ld a, d
        or e
        jr nz, .not_arrived

            pop bc
            
            ;;HA LLEGADO AL DESTINO
            
            ld a, $00

            ret

.not_arrived:


    ld a, b
    or c
    jr nz, .moverse 

        pop bc
        push bc
        ld a, d
        cp e
        jr c, .m_y

            ld c, $00
            push hl
            push de
            call _sp_playable_collisions 
            pop de
            pop hl
            jr .moverse
        
.m_y:        
            ld b, $00
            push hl
            push de
            call _sp_playable_collisions 
            pop de
            pop hl
            jr .moverse

.moverse:
    push hl
   
    ld a, [hl]
    ld d, a
    add b
    ldi [hl], a
    ld a, [hl]
    ld e, a
    add c
    ld [hl], a 

    ;;DE -> Previous X,Y
    pop hl
    ld bc, ep_aux_x
    add hl, bc
    ld [hl], d
    inc hl
    ld [hl], e


    pop bc


    ;db $18, $FE

    ld a, $80

ret



;;==============================================================================================
;;                                    RESPAWN ENEMY
;;----------------------------------------------------------------------------------------------
;; Genera un enemigo en el nivel en una posicion valida a una distancia del jugador
;;
;; INPUT:
;;  HL -> Puntero al enemigo a spawnear
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_si_respawn_enemy:

    call _generate_random
    and %00011111

    cp $1E                  ;;30  MAPw - 10
    jr c, .ok_x
        ld a, $1D           ;;29
.ok_x;
    add a, $05
    ld b, a

    call _generate_random
    and %00011111

    cp $1A                  ;;26  MAPh - 8
    jr c, .ok_y
        srl a               ;;Dividimos entre 2 para que no se pase
.ok_y;
    add a, $04
    ld c, a

    ;;BC -> Posicion X, Y aliatoria del mapa para spawnear al enemigo
    push bc
    call _sl_get_map_tile
    ld a, [hl]

    pop bc
    cp $14
    jr c, _si_respawn_enemy
    ld de, $0101

    ld hl, mp_player
    ldi a, [hl]
    sub b

;respawn_HOR
    jr nc, .continue_x
        xor $FF
        inc a
.continue_x:
    cp $06
    jr nc, .no_mod_x
        ld d, $00
.no_mod_x:

    ld a, [hl]
    sub c
;respawn_VERT
    jr nc, .continue_y
        xor $FF
        inc a
.continue_y:
    cp $05
    jr nc, .no_mod_y
        ld e, $00
.no_mod_y:

    ld a, d
    or e

    jr z, _si_respawn_enemy

    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .loop_end

.loop:
    push af

    ldi a, [hl]
    xor b
    ld d, a

    ld a, [hl]
    xor c
    or d

    jr z, .restart
    pop af

    dec hl
    ld de, entity_enemy_size
    add hl, de

    dec a
    jr nz, .loop

.loop_end:

    xor a
    ;;____________DELETE THIS__________________
    ;ld b, $05
    ;ld c, $04
    ;;_________________________________________

    call _mp_new_enemy
    
    

    ret

.restart:
    pop af
    jr _si_respawn_enemy