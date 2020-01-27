INCLUDE "src/enemy.h.s"

SECTION "ENEMY_VARS", WRAM0[$C110]
_enemy_X:      ds $01
_enemy_Y:      ds $01
_enemy_view_X: ds $01
_enemy_view_Y: ds $01
_enemy_spr_L:  ds $01
_enemy_spr_R:  ds $01
_enemy_dead:   ds $01


SECTION "ENEMY_FUNC", ROM0

_set_enemy:
    xor a
    ld [_enemy_dead], a
    ld a, $0C
    ld [_enemy_X], a
    ld a, $08
    ld [_enemy_Y], a
    ld a, $06
    ld [_enemy_spr_L], a
    ld [_enemy_spr_R], a
    ;ld a, $48+8
    ld a, $0c*16+16
    ld [_enemy_view_X], a
    ;ld a, $40-16
    ld a, $08*16+16
    ld [_enemy_view_Y], a
    ret

_update_enemy_sprite:
    ret

;
_update_enemy_view_position:
    ld hl, $C008
    ld a, [_enemy_view_Y]
    ldi [hl], a
    ld a, [_enemy_view_X]
    ldi [hl], a

    ld hl, $C00C
    ld a, [_enemy_view_Y]
    ldi [hl], a
    ld a, [_enemy_view_X]
    add $08
    ldi [hl], a
    ret



_move_view_enemy:
    ld a, [scrollDirectionX]
    ld b, a
    ld a, [_enemy_view_X]
    sub b
    ld [_enemy_view_X], a

.move_y:

    ld a, [scrollDirectionY]
    ld b, a
    ld a, [_enemy_view_Y]
    sub b
    ld [_enemy_view_Y], a


    ret

_colision_enemy:
    ld a, [_enemy_X]
    ld b, a
    ld a, [_player_X]
    sub b
    ld b, a

    ld a, [_enemy_Y]
    ld c, a
    ld a, [_player_Y]
    sub c
    or b

    ret nz

    ld a, 1
    ld [_enemy_dead], a
    xor a
    ld [_enemy_X], a
    ld [_enemy_Y], a
    ld [_enemy_spr_L], a
    ld [_enemy_spr_R], a
    ld [_enemy_view_X], a
    ld [_enemy_view_Y], a

    call _update_enemy_view_position
    call _update_enemy_sprite

    ret