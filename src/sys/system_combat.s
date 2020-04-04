INCLUDE "src/sys/system_combat.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"


SECTION "SYS_COMBAT_FUNCS", ROM0

;;==============================================================================================
;;                                        CALCULATE DAMAGE
;;----------------------------------------------------------------------------------------------
;; Ataca a la entidad que haya en la direccion asignada
;;
;; INPUT:
;;  HL -> Puntero de la entidad atacante
;;  DE -> Puntero de la entidad que recibe el ataque
;;
;; OUTPUT:
;;   A -> Daño del ataque
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sc_calculate_damage:

    ld bc, ep_cATK
    add hl, bc
    ld a, [hl]
    push af
    
    ld h, d
    ld l, e
    ld bc, ep_cDEF 
    add hl, bc
    ld a, [hl]

    sra a
    ld b, a
    pop af
    sub b

    jr nc, .continue
    xor a

.continue
    inc a

    ret

;;==============================================================================================
;;                                        ATTACK MELEE
;;----------------------------------------------------------------------------------------------
;; Ataca a la entidad que haya en la direccion asignada
;;
;; INPUT:
;;  HL -> Puntero de la entidad atacante
;;  BC -> Objetivo del ataque (X, Y)
;;
;; OUTPUT:
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sc_attack_melee:

    push bc
    ld de, mp_player
    ld a, [de]
    xor b
    ld b, a

    inc de
    ld a, [de]
    xor c
    or b

    cp $00
    jr nz, .no_player

    dec de

    pop bc
    push de

    call _sc_calculate_damage
    ld b, a

    pop de

    ld h, d
    ld l, e
    ld de, ep_cHP
    add hl, de
    ld a, [hl]
    sub b
    ld [hl], a


    ret


.no_player:
    ;;HL -> Ptr al atacante
    ;;BC -> Posicion X,Y a la que se ataca
    pop bc

    ld a, [mp_enemy_num]    ;Comprobamos si hay algun enemigo con vida
    cp $00
    ret z


    push hl
    ld hl, mp_enemy_array

.loop:
    push af
    push bc
    ld d, h
    ld e, l

    ld a, [de]
    xor b
    ld b, a

    inc de
    ld a, [de]
    xor c
    or b

    cp $00
    jr nz, .continue

    dec de

    pop bc
    pop af
    pop hl

    ;;DE -> Enemy_ptr
    ;;HL -> Atacant_ptr
    ;;AF -> Enemy_num counter
    ;;BC -> Atack X,Y 
    push de

    call _sc_calculate_damage
    ld b, a

    pop de

    ld h, d
    ld l, e
    push hl

    ld de, ep_cHP
    add hl, de
    ld a, [hl]
    sub b
    ld [hl], a

    jr nc, .survives

    pop hl
    call _mp_delete_enemy


    ;db $18, $FE
    ret

.continue:
    
    pop bc
    pop af

    ld de, entity_enemy_size
    add hl, de

    dec a
    jr nz, .loop

.survives:
    pop hl
    ret


;;==============================================================================================
;;                                     CHECK ATTACK MELEE
;;----------------------------------------------------------------------------------------------
;; Ataca a la entidad que haya en la direccion asignada
;;
;; INPUT:
;;  HL -> Puntero de la entidad atacante
;;  DE -> Direccion del ataque X, Y
;;   A -> Indica si se trata de un jugador o un enemigo (0 = Enemigo, 1 = Jugador)
;;
;; OUTPUT:
;;  A  -> Indica si ha podido golpear ($00 indica fallo)
;;  BC -> En el caso de que pueda golpear, indica la posicion.
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sc_check_attack_melee:

    push hl
    push af

    ld b, [hl]      ;;Obtenemos la posicion de la entidad
    inc hl
    ld c, [hl]
                    ;; BC -> Ent. X,Y
                    ;; DE -> Atk. DirX, DirY

    push bc
    push de

    ld a, d         ;;Comprobamos los obstaculos en la direccion X
    add b
    ld b, a
    call _sl_get_map_tile
    ld a, [hl] 
    cp $14
    jr c, .faulure  ;;Si hay algún obstaculo se cancela el ataque

    pop de
    pop bc
    push bc
    push de

    ld a, e         ;;Comprobamos los obstaculos en la direccion Y
    add c
    ld c, a
    call _sl_get_map_tile
    ld a, [hl] 
    cp $14
    jr c, .faulure  ;;Si hay algún obstaculo se cancela el ataque

    pop de
    pop bc
    

    ld a, d
    add b
    ld b, a
    ld a, e
    add c
    ld c, a

    pop af
    pop hl    


    cp $00
    jr nz, .player_exit


    ;BC -> Posicion X,Y a atacar

    ;ld hl, mp_player
    ;ldi a, [hl]
    ;xor b
    ;ld d, a
    ;ld a, [hl] 
    ;xor c
    ;or d

    ;db $18, $FE

                      ;; Guardamos el estado de ataque y la posicion objetivo del ataque
    ld de, ent_enemy_ia_state
    add hl, de
    ld a, IA_STATE_ATTACK
    ldi [hl], a 
    ld [hl], b
    inc hl
    ld [hl], c

    ld a, $1
    ret

.player_exit:
    ld a, $01
    ret

.faulure:

    ;db $18, $FE
    pop de
    pop bc
    pop af
    pop hl


    xor a
    ret



;;==============================================================================================
;;                                    PHYSICAL ATTACK
;;----------------------------------------------------------------------------------------------
;; Ataca a la entidad que haya en la direccion del ataque
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
_sc_physical_attack:

    ld hl, mp_player
    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a 

    ld hl, mp_player
    ld de, ep_dir_x
    add hl, de
    ldi a, [hl]
    add b 
    ld b, a
    ld a, [hl]
    add c
    ld c, a
    ;BC -> player attack_x, player attack_y
    
    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .loop_end
    
.loop:
    push af
    push bc
    
    ldi a, [hl]
    xor b
    ld d, a
    
    ld a, [hl]
    xor c
    or d
    jr z, .dead
    pop bc
    pop af

    dec hl
    ld de, entity_enemy_size
    add hl, de

    dec a
    jr nz, .loop

.loop_end:
    ret

.dead:
    pop bc
    pop af

    xor a
    dec hl
    call _mp_delete_enemy

    ret