INCLUDE "src/player.h.s"

SECTION "PLAYER_VARS", WRAM0[$C100]
_player_X:      ds $01
_player_Y:      ds $01
_player_view_X: ds $01
_player_view_Y: ds $01
_player_spr_L:  ds $01
_player_spr_R:  ds $01


SECTION "PLAYER_FUNC", ROM0

_set_player:
    ld a, $04
    ld [_player_X], a
    ld [_player_Y], a
    ld a, $04
    ld [_player_spr_L], a
    ld [_player_spr_R], a
    ld a, $48+8
    ld [_player_view_X], a
    ld a, $40+16
    ld [_player_view_Y], a
    ret
    