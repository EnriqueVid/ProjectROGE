INCLUDE "src/man/manager_playable.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_player.h.s"
INCLUDE "src/ent/entity_enemy.h.s"

SECTION "MAN_PLAYABLE_VARS", WRAM0

mp_player:
    m_define_entity_player

mp_enemy_num: ds $01

mp_enemy_next_l: ds $01
mp_enemy_next_h: ds $01

mp_enemy_array:
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy
    m_define_entity_enemy

mp_respawn_steps: ds $01

max_enemies = 8

SECTION "MAN_PLAYABLE_FUNCS", ROM0

;;==============================================================================================
;;                                    MANAGER PLAYABLE DELETE ENEMY
;;----------------------------------------------------------------------------------------------
;; Anade un nuevo enemigo al vector
;;
;; INPUT:
;;  HL -> Puntero al enemigo a eliminar
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mp_delete_enemy:

    ld a, [mp_enemy_num]
    cp $00
    ret z

    push hl

    ld bc, ep_spr_ptr_L         ;; BC -> Sprite Buffer Ptr
    add hl, bc
    ldi a, [hl]                 
    ld c, a
    ld a, [hl]
    ld b, a

    ld a, [mp_enemy_next_h]
    ld h, a
    ld a, [mp_enemy_next_l]
    ld l, a 
    ld de, entity_enemy_size * -1
    add hl, de
    ld a, l
    ld [mp_enemy_next_l], a
    ld a, h
    ld [mp_enemy_next_h], a

    ld d, h                     ;; DE -> Puntero al ultimo enemigo del vector
    ld e, l

    pop hl
    push hl
    push bc

    ld bc, entity_enemy_size    ;; Sustituimos el enemigo muerto por el último del vector
    ;; DE -> Origen
    ;; HL -> Destino
    ;; BC -> Cantidad
    call _ldir

    pop bc                      ;;Recuperamos el punero al buffer de sprites
    pop hl
    ld de, ep_spr_ptr_L
    add hl, de
    ld a, c
    ldi [hl], a
    ld a, b
    ld [hl], a

    ld a, [mp_enemy_num]
    dec a
    ld [mp_enemy_num], a


    ld a, [mp_enemy_next_h]
    ld h, a
    ld a, [mp_enemy_next_l]
    ld l, a                     ;; HL -> Puntero al ultimo enemigo del vector

    ld bc, ep_spr_ptr_L
    add hl, bc
    ldi a, [hl]
    ld c, a
    ld a, [hl]
    ld h, a
    ld a, c
    ld l,a

    ld bc, $0008
    call _clear_data

    ;db $18, $FE

    ld a, [mp_respawn_steps]    ;; Comprueba si ya se va a spawnear un nuevo enemigo
    cp 0
    ret nz

    call _generate_random
    srl a
    srl a
    srl a
    srl a
    inc a
    ld [mp_respawn_steps], a    ;; Establece los pasos hasta el spawn del próximo enemigo de 1 a 16
    
    ret


;;==============================================================================================
;;                                    MANAGER PLAYABLE NEW ENEMY
;;----------------------------------------------------------------------------------------------
;; Anade un nuevo enemigo al vector
;;
;; INPUT:
;;  A  -> Enemy_ID
;;  BC -> Enemy X, Y 
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mp_new_enemy:

    push bc
    ld e, a
    
    ld a, [mp_enemy_num]
    inc a
    ld [mp_enemy_num], a

    ld a, [mp_enemy_next_h]
    ld h, a
    ld a, [mp_enemy_next_l]
    ld l, a

    push hl
    
    ;; HL -> Destino
    ;; BC -> Cantidad
    ld bc, entity_enemy_size
    call _clear_data
 
    ld hl, ent_enemy_index
    sla e
    ld d, $00
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]              ;; DE -> Puntero a la platilla del enemigo

    pop hl
    pop bc
    push hl

    ld a, b
    ldi [hl], a
    ld a, c
    ld [hl], a

    pop hl
    push hl

    ld bc, ep_spr
    add hl, bc

    ld a, [de]
    ldi [hl], a             ;; HL -> ep_spr
    inc hl
    inc hl       

    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_mHP
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_mMP
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_mAtk
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_mDef

    dec de
    dec de
    dec de

    ld a, [de]
    ldi [hl], a             ;; HL -> ep_cHP
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_cMP
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_cAtk
    inc de
    ld a, [de]
    ldi [hl], a             ;; HL -> ep_cDef

    inc de
    ld a, [de]

    pop hl
    push hl

    ld de, ent_enemy_id
    add hl, de
    ld [hl], a              ;; HL -> ent_enemy_id


    pop hl
    push hl

    ld hl, $C008
    ld bc, $0008

    ld a, [mp_enemy_num]
    dec a
    cp $00
    jr z, .continue
.loop:
    add hl, bc 
    dec a
    jr nz, .loop
.continue:

    ld d, h
    ld a, l

    pop hl
    push hl

    ld bc, ep_spr_ptr_L
    add hl, bc

    ldi [hl], a
    ld a, d
    ld [hl], a

    pop hl
    push hl

    ld bc, entity_enemy_size
    add hl, bc

    ld a, h
    ld [mp_enemy_next_h], a
    ld a, l
    ld [mp_enemy_next_l], a

    pop hl
    call _sr_enemies_initial_draw

    ret



;;==============================================================================================
;;                                    MANAGER PLAYABLE INIT
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_playable
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
_mp_init:

    ;;Incializamos al jugador
    ld hl, mp_player             ;; Destino
    ld de, default_entity_player ;; Origen
    ld bc, entity_player_size    ;; Cantidad
    call _ldir

    ;;Incializamos las variables de los enemigos
    xor a
    ld [mp_enemy_num], a        ;; Numero de enemigos
    ld [mp_respawn_steps], a    ;; Numero de pasos para generar un nuevo enemigo

    ld hl, mp_enemy_array
    ld a, h
    ld [mp_enemy_next_h], a ;; Puntero al enemigo actual H
    ld a, l
    ld [mp_enemy_next_l], a ;; Puntero al enemigo actual L

    ld a, $EA
    ldi [hl], a                         ;; hl = mp_enemy_array + 1   --> Destino
    ld de, mp_enemy_array               ;; Origen  
    ld bc, entity_enemy_size * 8 - 1    ;; Cantidad
    call _ldir


    ret