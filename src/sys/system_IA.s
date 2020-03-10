INCLUDE "src/sys/system_IA.h.s"
INCLUDE "src/ent/entity_enemy.h.s"


SECTION "SYS_IA_VARS", WRAM0




SECTION "SYS_IA_FUNCS", ROM0


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
        cp $02
        jr nc, .not_arrived
        ld a, e
        cp $02
        jr nc, .not_arrived

            pop bc
            ;;HA LLEGADO AL DESTINO
            ;;Comprobar si debe atacar o moverse a otro lado
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
    add b
    ldi [hl], a
    ld a, [hl]
    add c
    ld [hl], a 
    pop hl

    pop bc


    ;db $18, $FE


ret




;;==============================================================================================
;;                                    CHOOSE IA ACTION
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
_si_choose_IA_action:
    
;     ld de, mp_player
;     ld a, [de]
;     ld b, [hl]
;     sub b
;     jr c, .derecha
;         ld b, $FF
; .derecha:
;         ld b, $01


;     inc hl
;     inc de

    ld bc, ent_enemy_ia_state
    add hl, bc
    
    ld a, $01
    ldi [hl], a

    ld bc, mp_player
    ld a, [bc]
    ldi [hl], a
    inc bc
    ld a, [bc]
    ld [hl], a


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