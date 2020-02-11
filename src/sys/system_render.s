INCLUDE "src/sys/system_render.h.s"


SECTION "SYS_RENDER_FUNCS", ROM0

;;==============================================================================================
;;                                SYSTEM RENDER DRAW SPRITE
;;----------------------------------------------------------------------------------------------
;; Carga un tileset especificado en la posicion de memoria especificada
;;
;; INPUT:
;;  BC -> Destino del sprite en intervalos de 4 Bytes (C000 - C09C)
;;  HL -> Puntero a la Entidad  
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_draw_sprite:
    
    di
    
    push hl
    ld de, ep_wx
    add hl, de                  ;; hl apunta a entity_playable_window_x
    ldi a,[hl]
    ld e, a                     ;; E = entity_playable_window_x
    ld a, [hl]
    ;ld d, a                    ;; A = entity_playable_window_y

    ld h, b
    ld l, c                     ;; HL = Destino del sprite (C000, C004, C008, ... , C09C)
    
    ldi [hl], a
    ld a, e
    ldi [hl], a

    ld b, h
    ld c, l

    pop hl
    push hl
    ld de, ep_sprL
    ld a, [hl]


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

    ei
    ret



;;==============================================================================================
;;                                 SYSTEM RENDER LOAD TILES
;;----------------------------------------------------------------------------------------------
;; Carga un tileset especificado en la posicion de memoria especificada
;;
;; INPUT:
;;  A -> Numero del tileset a cargar (0 - 255)
;;  HL -> Destino del tileset 
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_load_tiles:
    
    sla a                   ;; Multiplicamos a x2 para corregir el desfase a la hora cargar una direccion de 2 bytes
    ld bc, $0000
    ld c, a                 ;; BC es la cantidad a sumar a HL para acceder a la posicion que queremos

    push hl
    ld hl, tileset_index    ;; Indice de todos los tilesets
    add hl, bc

    ldi a, [hl]
    ld e, a
    ld a, [hl]
    ld d, a                 ;; DE apunta a la direccion de origen del tileset

    ld hl, tileset_size     ;; Indice con los tamaños de los tlesets
    add hl, bc

    ldi a, [hl]
    ld c, a                 ;; BC es la cantidad de Bytes del tileset
    ld a, [hl]
    ld b, a
    pop hl

    call _VRAM_wait
    call _ldir              ;; HL -> Destino | DE -> Origen | BC -> Cantidad

    ret

