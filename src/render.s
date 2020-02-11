INCLUDE "src/render.h.s"


SECTION "VB_INTERRUPT_HANDLER", HRAM[$FF80]
VblankInterruptHandler:;; Destination for DMA commands (Comienzo de la pila)

SECTION "RENDER_VARS", WRAM0[$C000]
_sprite_buffer: ds 40*4



SECTION "RENDER_FUNCS", ROM0

;; DMA CODE
DMACopy:
    push af
    ld a, %11100111             ;;Reiniciamos el mostreo de Sprites
    ld [$FF40], a
    ld a, _sprite_buffer/256
    ld [$FF46], a
    ld a, $28
DMACopyWait:
    dec a
    jr nz, DMACopyWait
    pop af
    reti 
DMACopyEnd:


_draw_player:
    ld hl, $C000
    ld a, [_player_view_Y]
    ldi [hl], a
    ld a, [_player_view_X]
    ldi [hl], a
    ld a, [_player_spr_L]
    ldi [hl], a
    xor a
    ldi [hl], a

    ld a, [_player_view_Y]
    ldi [hl], a
    ld a, [_player_view_X]
    add a, 8
    ldi [hl], a
    ld a, [_player_spr_L]
    ldi [hl], a
    ld a, %00100000
    ldi [hl], a
    
    ret


_draw_enemy:
    ld hl, $C008
    ld a, [_enemy_view_Y]
    ldi [hl], a
    ld a, [_enemy_view_X]
    ldi [hl], a
    ld a, [_enemy_spr_L]
    ldi [hl], a
    xor a
    ldi [hl], a

    ld a, [_enemy_view_Y]
    ldi [hl], a
    ld a, [_enemy_view_X]
    add a, 8
    ldi [hl], a
    ld a, [_enemy_spr_L]
    ldi [hl], a
    ld a, %00100000
    ldi [hl], a
    
    ret
