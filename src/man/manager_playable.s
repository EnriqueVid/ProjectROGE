INCLUDE "src/man/manager_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s" ;; entity_enemy.h.s incluye entity_player.h.s que incluye entity_playable.h.s

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


max_enemies = 8

SECTION "MAN_PLAYABLE_FUNCS", ROM0

;;==============================================================================================
;;                                    MANAGER PLAYABLE MEW ENEMY
;;----------------------------------------------------------------------------------------------
;; Anade un nuevo enemigo al vector
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
_mp_new_enemy:

    ld a, [mp_enemy_num]
    inc a
    ld [mp_enemy_num], a

    ld a, [mp_enemy_next_h]
    ld h, a
    ld a, [mp_enemy_next_l]
    ld l, a

    push hl
    
    ;; DE -> Origen
    ;; HL -> Destino
    ;; BC -> Cantidad
    ld de, ent_enemy_bat_01
    ld bc, entity_enemy_size
    call _ldir

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

    ld bc, entity_enemy_size
    add hl, bc

    ld a, h
    ld [mp_enemy_next_h], a
    ld a, l
    ld [mp_enemy_next_l], a

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
    ld [mp_enemy_num], a    ;; Numero de enemigos

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