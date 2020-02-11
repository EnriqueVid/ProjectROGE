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
    ld d, a                     ;; D = entity_playable_window_y

    ld h, b
    ld l, c                     ;; HL = Destino del sprite (C000, C004, C008, ... , C09C)
    
    ldi [hl], a ;; C000
    ld a, e
    ldi [hl], a  ;; C001
    
    push bc
    ld bc, $02
    add hl, bc              ;; HL -> C004

    ld a, d
    ldi [hl], a
    ld a, e
    add 8
    ld [hl], a

    pop bc
    pop hl

    ld de, ep_spr
    add hl, de
    ld a, [hl]

    sla a
    
    ld hl, sprites_index
    ld d, $00
    ld e,a
    add hl, de

    ldi a, [hl]
    ld e, a
    ld a, [hl]
    ld h, a
    ld l, e

    ldi a, [hl]
    ld e, a
    ldi a, [hl]
    ld d, a
    push hl

    ld h, b
    ld l, c
    
    inc hl
    inc hl

    ld a, e
    ldi [hl],a
    ld a, d
    ld [hl], a

    pop hl
    ldi a, [hl]
    ld e, a
    ld a, [hl]
    ld d, a

    ld h, b
    ld l, c
    ld bc, $0006
    add hl, bc

    ld a, e
    ldi [hl],a
    ld a, d
    ld [hl], a

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

