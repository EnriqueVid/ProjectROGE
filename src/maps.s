INCLUDE "src/maps.h.s"

SECTION "Maps_Variables", WRAM0

_win:             ds $01

_mActual_X:       ds $01
_mActual_Y:       ds $01
scroll:           ds $01
scrollCounter:    ds $01
scrollDirectionX: ds $01
scrollDirectionY: ds $01

;scrollPositionX:  ds $01
;scrollPositionY:  ds $01

;;SCROLL MAP VARIABLES
GBS_tilemap_x:      ds $01  ;;posicion X de la panralla en el tilemap
GBS_tilemap_y:      ds $01  ;;posicion Y de la pantalla en el tilemap

GBS_tilemap_pl:     ds $01  ;;puntero a la posicion en el tilemap (low)
GBS_tilemap_ph:     ds $01  ;;puntero a la posicion en el tilemap (high)

GBS_map_tl_pl:         ds $01  ;;puntero a la posicion en el screen_map (low)
GBS_map_tl_ph:         ds $01  ;;puntero a la posicion en el screen_map (high)

GBS_map_tr_pl:         ds $01  ;;puntero a la posicion en el screen_map (low)
GBS_map_tr_ph:         ds $01  ;;puntero a la posicion en el screen_map (high)

GBS_map_bl_pl:         ds $01  ;;puntero a la posicion en el screen_map (low)
GBS_map_bl_ph:         ds $01  ;;puntero a la posicion en el screen_map (high)

;mapLoadIncrement: ds $01


SECTION "Maps", ROM0

_mapa_Prueba_01:
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $02, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $00, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $00, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $01, $00, $01, $01, $00, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $01, $00, $01, $01, $00, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $00, $00, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $00, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
_mapa_Prueba_01_end:


_mapa_Prueba_02:
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
_mapa_Prueba_02_end:




;;==============================================================================================
;;                                        GET MAP TILE
;;----------------------------------------------------------------------------------------------
;; A aprtir de unas coordenadas X e Y obtiene la direccion del tile que se busca
;;
;; INPUT:
;;  B -> X del tilemap
;;  C -> Y del tilemap
;;
;; OUTPUT:
;;  HL -> Puntero al tile
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_get_map_tile:
    nop
    ld hl, _mapa_Prueba_01
    xor a
    ld d, a
    ld e, b 
    add hl, de
    ld a, c
    ld de, MAPW
    cp $0
    ret z
.loop:
    dec a
    ret z
    add hl, de
    jr .loop    



;;==============================================================================================
;;                                          DRAW TILE
;;----------------------------------------------------------------------------------------------
;; Dibuja 4 tiles de 8x8 px en al direccion de memoria indicada para formar un tile de 16x16 px
;;
;; INPUT:
;;  HL -> Direccion de memoria en la que dibujar el tile
;;  A  -> Numero del tile (ID)
;;
;; OUTPUT:
;;
;; DESTROYS:
;;  AF, DE
;;
;;==============================================================================================
_draw_tile:
    nop

    push hl
    call _VRAM_wait
    ldi [hl], a
    call _VRAM_wait
    ld  [hl], a
    pop  hl

    push hl
    ld   de , $0020
    add  hl , de 
    call _VRAM_wait
    ldi [hl], a
    call _VRAM_wait
    ld  [hl], a
    pop hl

    ret

;;==============================================================================================
;;                                           DRAW ROW
;;----------------------------------------------------------------------------------------------
;; Dibuja una columna de (GBSh+2) tiles.
;;
;; INPUT:
;;  HL -> Direccion de memoria en la que dibujar el tile
;;  BC -> Puntero a la direccion del tilemap
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_draw_row:
    ;ld hl, $9A40
    ;ld bc, $035E
    ld a, GBSw + 2

.loop:
    push af
    ld a, [bc]  ;; Obtenemos el tile a dibujar

    call _draw_tile

    ld a, 1
    call _correct_hor
    ;ld de, $0002
    ;add hl, de
    push hl

    ld h, b
    ld l, c

    ld de, $0001
    add hl, de
    
    ld b, h
    ld c, l

    pop hl
    pop af
    dec a
    jr nz, .loop
    ret


;;==============================================================================================
;;                                          DRAW COLUMN
;;----------------------------------------------------------------------------------------------
;; Dibuja una columna de (GBSh+2) tiles.
;;
;; INPUT:
;;  HL -> Direccion de memoria en la que dibujar el tile
;;  BC -> Puntero a la direccion del tilemap
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_draw_column:

    ;ld hl, $9816
    ;ld bc, $025E
    ld a, GBSh + 2

.loop:
    push af
    ld a, [bc]  ;; Obtenemos el tile a dibujar

    call _draw_tile

    ld a, 1
    call _correct_vert
    
    ;;ld de, $0040
    ;;add hl, de
    push hl

    ld h, b
    ld l, c

    ld de, MAPW
    add hl, de
    
    ld b, h
    ld c, l

    pop hl
    pop af
    dec a
    jr nz, .loop
    ret



;;==============================================================================================
;;                                       GET TILEMAP DIR
;;----------------------------------------------------------------------------------------------
;; Obtiene el puntero a las coordenadas especificadas
;;
;; INPUT:
;;  BC -> Posicion X del tilemap
;;  DE -> Posicion Y del tilemap
;;  HL -> Posicion inicial del tilemap
;;
;; OUTPUT:
;;  HL -> Puntero a la posicion del tilemap
;;
;; DESTROYS:
;;  AF, BC, HL
;;
;;==============================================================================================
_get_tilemap_dir:

    add hl, bc
    ld c, MAPW
    ld a, e
    cp 0
    ret z
.loop:
    add hl, bc
    dec a
    jr nz, .loop
    ret



;;==============================================================================================
;;                                       GET SCREENMAP DIR
;;----------------------------------------------------------------------------------------------
;; Obtiene el puntero a las coordenadas especificadas
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  HL -> Puntero de la posicion del screenmap
;;
;; DESTROYS:
;;  AF, BC, HL
;;
;;==============================================================================================
_get_screenmap_dir:

    ld hl, $9800
    ld a, [GBSx]
    sub $08
    srl a
    srl a
    srl a
    ld b, $0
    ld c, a
    add hl, bc

    ld a, [GBSy]
    srl a
    srl a
    srl a
    srl a
    cp $0
    ret z
    ld bc, $40
.loop:
    add hl, bc
    dec a
    jr nz, .loop
    ret



;;==============================================================================================
;;                                       SET SCROLL MAP
;;----------------------------------------------------------------------------------------------
;; Setea el mapa para ser dibujado mediante scroll
;;
;; INPUT:
;;  BC -> Posicion X inicial en el tilemap (Esquina superior izquierda)
;;  DE -> Posicion Y inicial en el tilemap (Esquina superior izquierda)
;;
;; OUTPUT:
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_set_scroll_map:

    ld a, c
    ld [GBS_tilemap_x], a   
    ld a, e
    ld [GBS_tilemap_y], a
    
    ld a, 8
    ld [GBSx], a            ;; Setea la pantalla a la posicion 0,0 del GBmap
    xor a
    ld [GBSy], a            

    call _get_screenmap_dir
    ld a, h
    ld [GBS_map_tl_ph], a
    ld a, l
    ld [GBS_map_tl_pl], a

    push hl

    ld bc, GBSw * 2 - 2
    add hl, bc
    ld a, h
    ld [GBS_map_tr_ph], a
    ld a, l
    ld [GBS_map_tr_pl], a

    pop hl
    push hl

    ld a, GBSh -1
    ld bc, $0040
.loop_bl:
    add hl, bc
    dec a
    jr nz, .loop_bl

    ld a, h
    ld [GBS_map_bl_ph], a
    ld a, l
    ld [GBS_map_bl_pl], a


    ld bc, 0
    ld de, 0 
    ld a, [GBS_tilemap_x]
    ld c, a
    ld a, [GBS_tilemap_y]
    ld e, a


    ld hl, _mapa_Prueba_02
    call _get_tilemap_dir

    ld a, h
    ld [GBS_tilemap_ph], a
    ld b, a 
    ld a, l
    ld [GBS_tilemap_pl], a
    ld c, a

    pop hl
    ; HL -> Puntero a la memoria de video
    ; BC -> Puntero al tilemap

    di
    xor a
    ld [_mActual_X], a
    ld [_mActual_Y], a

.loop:
    
    push hl
    ld h, b     ;; cargamos en hl el puntero al tilemap para realizar calculos
    ld l, c     ;; HL -> TILEMAP  

    ld de, 0    
    ld a, [_mActual_X]
    cp GBSw
    jr z, .change_y
    ld e, a
    add hl, de

    
    ld e, [hl]      ;; E -> Tile a dibujar

    pop hl          ;; HL -> VMEM
    push hl

    push af
    push de

    
    add a, a        ;; Multiplicamos _mActual_X por 2 (los tiles son de 16x16)
    ld  e, a
    add hl, de
    ld de, $0040
    ld a, [_mActual_Y]
    cp 0
    jr z, .continue
.inc_y:
    add hl, de
    dec a
    jr nz, .inc_y


.continue:
    pop de      ;; E -> Tile a dibujar
    ld a, e
    call _draw_tile

    pop af
    inc a
    ld [_mActual_X], a
    pop hl
    jr .loop


.change_y:      ;;Bajamos a la siguiente fila del tilemap      
    ;;HL -> TILEMAP
    xor a
    ld[_mActual_X], a
    ld a, [_mActual_Y]
    inc a
    cp GBSh
    jr z, .end
    ld [_mActual_Y], a
    ld de, MAPW
    add hl, de
    ld b, h
    ld c, l

    pop hl      ;; HL -> VMEM
    ;ld de, GBSw
    ;add hl, de

    jr .loop

.end:
    pop hl
    ret





;;==============================================================================================
;;                                       UPDATE SCROLL MAP
;;----------------------------------------------------------------------------------------------
;; Va cargando tiles de forma dinamica para representar un mapa mayor a la capacidad de memoria.
;;
;; INPUT:
;;  B  -> incremento del mapa en X
;;  C  -> incremento del mapa en Y
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_update_scroll_map:

    

    ld a, b             
    cp 0                ;;Comprobamos si se mueve horizontalmente
    jp z, .check_row    ;;Si el movimiento en X es 0, pasamos al movimiento en Y

    cp 1                ;;Comprobamos si se mueve hacia la derecha
    jr nz, .move_left   ;;Si no es 1 nos movemos a la izquierda

    
    call load_GBS_map_tr
    ld a, 1
    call _correct_hor
    call save_GBS_map_tr
    ld a, -1
    call _correct_vert
    
    push bc
    push hl
    call load_GBS_tilemap

    ld bc, $0001
    add hl, bc
    call save_GBS_tilemap
    ld bc, GBSw - 1
    add hl, bc
    ld bc, $FFE2            ;; -30 -> MAPw = 30
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _draw_column
    pop bc

    call load_GBS_map_tl  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, 1
    call _correct_hor
    call save_GBS_map_tl

    call load_GBS_map_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, 1
    call _correct_hor
    call save_GBS_map_bl
    

    ;;call _jri

    jr .check_row

.move_left:
    
    call load_GBS_map_tl

    ld a, -1
    call _correct_hor
    call save_GBS_map_tl
    ld a, -1
    call _correct_vert
    
    push bc
    push hl
    call load_GBS_tilemap

    ld bc, $FFFF
    add hl, bc
    call save_GBS_tilemap
    ld bc, $FFE2                ;; -30 -> MAPw = 30
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _draw_column
    pop bc

    call load_GBS_map_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, -1
    call _correct_hor
    call save_GBS_map_tr

    call load_GBS_map_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, -1
    call _correct_hor
    call save_GBS_map_bl


.check_row:
    ld a, c
    cp 0
    ret z
    cp -1
    jr nz, .move_down  


    call load_GBS_map_tl

    ld a, -1
    call _correct_vert
    call save_GBS_map_tl
    ld a, -1
    call _correct_hor

    push hl
    call load_GBS_tilemap

    ld bc, $FFE2            ;;-30 MAPW = 30
    add hl, bc
    call save_GBS_tilemap
    ld bc, $FFFF
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _draw_row

    call load_GBS_map_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, -1
    call _correct_vert
    call save_GBS_map_tr

    call load_GBS_map_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, -1
    call _correct_vert
    call save_GBS_map_bl

    ret

.move_down:

    call load_GBS_map_bl
    ld a, 1
    call _correct_vert
    call save_GBS_map_bl
    ld a, -1
    call _correct_hor

    push hl
    call load_GBS_tilemap

    ld bc, MAPW
    add hl, bc
    call save_GBS_tilemap

    ld a, GBSh - 1
    ld bc, MAPW
.md_loop:
    
    add hl, bc
    dec a
    jr nz, .md_loop

    ld bc, $FFFF       
    add hl, bc
    
    ld b, h
    ld c, l
    pop hl 

    call _draw_row

    call load_GBS_map_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, 1
    call _correct_vert
    call save_GBS_map_tr

    call load_GBS_map_tl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, 1
    call _correct_vert
    call save_GBS_map_tl
    
    ret
    

;;==============================================================================================
;;                                       CORRECT HORIZONTAL
;;----------------------------------------------------------------------------------------------
;; Corrige la posicion de inicio horizontalemnte para dibujar filas o columnas
;;
;; INPUT:
;;  HL  -> Direccion a corregir (si se corrige)
;;  A   -> Direccion de la correccion (1 derecha | -1 izquierda)
;;
;; OUTPUT:
;;  HL -> Direccion Corregida
;;
;; DESTROYS:
;;  AF, DE
;;
;;==============================================================================================
_correct_hor:

    cp 0
    ret z
    cp 1
    jr nz, .check_left  ;; comprobamos si va a la izquierda o a la derecha


    ld de, $0002
    ld a, l
    or $E1              ;; Aplicamos esta operacion para comprobar en que borde esta
    cp $FF              ;; Si el resultado es FF, esta en el borde derecho
    jr nz, .no_correction

    ld de, $FFE2
    add hl, de

    ret

.check_left:

    ld de, $FFFE
    ld a, l
    or $E1              ;; Aplicamos esta operacion para comprobar en que borde esta
    cp $E1              ;; Si el resultado es E1, está en el borde izquierdo
    jr nz, .no_correction

    ld de, $001E
    add hl, de

    ret
    
.no_correction:

    add hl, de

    ret



;;==============================================================================================
;;                                       CORRECT VERTICAL
;;----------------------------------------------------------------------------------------------
;; Corrige la posicion de inicio verticalmente para dibujar filas o columnas
;;
;; INPUT:
;;  HL  -> Direccion a corregir (si se corrige)
;;  A   -> Direccion de la correccion (1 abajo | -1 arriba)
;;
;; OUTPUT:
;;  HL -> Direccion Corregida
;;
;; DESTROYS:
;;  AF, DE
;;
;;==============================================================================================
_correct_vert:

    cp 0
    ret z
    cp -1                  
    jr nz, .check_down
    ld de, $FFC0  ;; -64 = -$40
    ld a, h
    cp $98
    jr nz, .no_correction

    ld a, l
    sub $1F
    jr nc, .no_correction 

    ld h, $9B
    ld a, l
    add $C0
    ld l, a 

    ;call _jri

    ret

.check_down:

    ld de, $0040   ;;$40
    ld a, h
    cp $9B
    jr nz, .no_correction

    ld a, l
    sub $C0
    jr c, .no_correction        ;; Si es menor a 9BC0 no puede estar en la ultima fila

    ld h, $98
    ld l, a

    ;call _jri

    ret
    
.no_correction:
    add hl, de
    ret



;;==============================================================================================
;;                                            SAVE POINTERS
;;----------------------------------------------------------------------------------------------
;; Guarda el puntero especificado
;;
;; INPUT:
;;  HL -> Pointer to save
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
save_GBS_map_tr:
    ld a, h
    ld [GBS_map_tr_ph], a
    ld a, l
    ld [GBS_map_tr_pl], a
    ret

save_GBS_map_tl:
    ld a, h
    ld [GBS_map_tl_ph], a
    ld a, l
    ld [GBS_map_tl_pl], a
    ret

save_GBS_map_bl:
    ld a, h
    ld [GBS_map_bl_ph], a
    ld a, l
    ld [GBS_map_bl_pl], a
    ret

save_GBS_tilemap:
    ld a, h
    ld [GBS_tilemap_ph], a
    ld a, l
    ld [GBS_tilemap_pl], a
    ret

;;==============================================================================================
;;                                            LOAD POINTERS
;;----------------------------------------------------------------------------------------------
;; Guarda el puntero especificado
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  HL -> Pointer loaded
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
load_GBS_map_tr:
    ld a, [GBS_map_tr_ph]
    ld h, a
    ld a, [GBS_map_tr_pl]
    ld l, a
    ret

load_GBS_map_tl:
    ld a, [GBS_map_tl_ph]
    ld h, a
    ld a, [GBS_map_tl_pl]
    ld l, a
    ret

load_GBS_map_bl:
    ld a, [GBS_map_bl_ph]
    ld h, a
    ld a, [GBS_map_bl_pl]
    ld l, a
    ret

load_GBS_tilemap:
    ld a, [GBS_tilemap_ph]
    ld h, a
    ld a, [GBS_tilemap_pl]
    ld l, a
    ret



;;==============================================================================================
;;                                            DRAW MAP
;;----------------------------------------------------------------------------------------------
;; Dibuja un mapa del tamaño de la pantalla
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
_draw_map:
    di
    xor a
    ld [_mActual_X], a
    ld [_mActual_Y], a
    ld hl, _mapa_Prueba_01

.loop:
    push hl
    ld bc, 0
    ld a, [_mActual_X]
    cp 16
    jr z, .change_y
    ld  c, a
    add hl, bc
    push af

    ld d, [hl]

    ld hl, $9800
    add a, a
    ld  c, a
    add hl, bc
    ld bc, $0040
    ld a,[_mActual_Y]    
    cp 0
    jr z, .continue
.inc_y:
    add hl, bc
    dec a
    jr nz, .inc_y

.continue:
    ld  a, d
    call _draw_tile

    pop af
    inc a
    ld [_mActual_X], a
    pop hl
    jr .loop

.change_y:
    pop hl 
    xor a
    ld[_mActual_X], a
    ld a, [_mActual_Y]
    inc a
    cp MAPH
    ret z
    ld [_mActual_Y], a
    ld bc, MAPW    
    add hl, bc

    jr .loop



;;==============================================================================================
;;                                      SET SCREEN DATA
;;----------------------------------------------------------------------------------------------
;; Aplica la configuracion inicial de la pantalla
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
_set_screen_data:

    xor a
    ld [scroll], a               ;; Scroll = 0
    ld [scrollDirectionX], a     ;; Scroll direction = 0
    ld [scrollDirectionY], a     ;; Scroll direction = 0

    ld a, scrollCounterConst     ;; |
    ld [scrollCounter], a        ;; +->Scroll Counter = scrollCounterConst

    ret



;;========================================================================================
;;                                  SET SCROLL SCREEN
;;----------------------------------------------------------------------------------------
;; Setea la pantalla para realizar el scroll
;;
;; INPUT: 
;;  B -> Direccion en X (+1 / -1)
;;  C -> Direccion en Y (+1 / -1)
;;
;; OUTPUT: 
;;  NONE
;;
;; DELETES: 
;;  AF
;;
;;========================================================================================
_set_scroll_screen:

    ld a, scrollConst
    ld [scroll], a
    ld a, b
    ld [scrollDirectionX], a
    ld a, c
    ld [scrollDirectionY], a

    ret



;;========================================================================================
;;                                     UPDATE SCROLL
;;----------------------------------------------------------------------------------------
;; Mueve la pantalla en la direccion establecida en _set_scroll_screen
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, HL
;;
;;========================================================================================
_update_scroll:

    ld a, [scroll]
    cp $0
    ret z
    push af

    ld a, [scrollCounter]
    cp $0
    jr nz, .end_update_scroll
        ld a, scrollCounterConst
        ld [scrollCounter], a

        call _wait_Vblank
        ld hl,$FF42				;; FF42 - FF43  -->  Tile scroll X, Y
		ld a, [hl]
		ld b, a
        ld a, [scrollDirectionY]
        add b
		ldi	[hl], a				;; FF42: SCY --> Tile Scroll Y  |
    	ld a, [hl]
        ld b, a
        ld a, [scrollDirectionX]
        add b
		ld	[hl], a				;; FF43: SCX --> Tile Scroll X  +- Setea el scroll de la pantalla a [0, 0]

        ld a, [_enemy_dead]
        cp $00
        jr nz, .continue
        call _move_view_enemy
        call _update_enemy_view_position
.continue:
        pop af
        dec a
        ld [scroll], a

        ret

    
.end_update_scroll:
    dec a
    ld [scrollCounter], a

    pop af
    ret