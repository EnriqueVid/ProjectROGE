INCLUDE "src/sys/system_combat.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"


SECTION "SYS_COMBAT_FUNCS", ROM0

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