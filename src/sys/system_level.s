INCLUDE "src/sys/system_level.h.s"

SECTION "SYS_LEVEL_FUNCS", ROM0



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
;;  AF, BC, HL
;;
;;========================================================================================
_sl_update_scroll:
    
    ld hl, ml_camera
    ld bc, ec_scroll_active
    add hl, bc
    ldi a, [hl]             ;; scroll_activr

    cp $00
    ret z
    push af

    ld a, [hl]              ;; scroll_counter
    cp $00
    jr nz, .end_update_scroll
        ld a, scrollCounterConst
        ldi [hl], a          ;; scroll_counter

        
        ld a, [$FF43]
        ld b, a
        ldi a, [hl]         ;; scroll_dir_x
        add b
        call _wait_Vblank
        ld [$FF43], a

        ld a, [$FF42]
        ld b, a
        ld a, [hl]         ;; scroll_dir_y
        add b
        call _wait_Vblank
        ld [$FF42], a

        pop af
        dec a
        ld hl, ml_camera
        ld bc, ec_scroll_active
        add hl, bc
        ld [hl], a

        ret




    

.end_update_scroll:
    dec a
    ld [hl], a              ;; scroll_counter

    pop af
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
_sl_set_scroll_screen:

    push hl
    
    push bc

    ld hl, ml_camera
    ld bc, ec_scroll_active
    add hl, bc

    ld a, scrollConst
    ldi [hl], a                 ;;ec_scroll_active
    inc hl                      ;;ec_scroll_counter
    pop bc
    ld a, b
    ldi [hl], a                 ;;ec_scroll_dir_x
    ld a, c
    ld [hl], a                  ;;ec_scroll_dir_y
    
    pop hl
    ret



;;==============================================================================================
;;                                       INIT LEVEL
;;----------------------------------------------------------------------------------------------
;; Setea el mapa y la camara para ser dibujado mediante scroll
;;
;; INPUT:
;;  BC -> Posicion X inicial en el tilemap (Esquina superior izquierda)
;;  DE -> Posicion Y inicial en el tilemap (Esquina superior izquierda)
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sl_init_level:
    ld hl, mp_player    ;; Obtenemos la posicion inicial del jugador para setear la posicion inicial de la camara en el tilemap
    ldi a, [hl]         ;; Player X
    sub 5
    ld e, a             ;; Restamos 5 a la X como offset del jugador

    ld a, [hl]          ;; Player Y
    sub 4
    ld d, a             ;; Restamos 4 a la Y como offset del jugador

    ld hl, ml_camera
    ld a, e
    ldi [hl], a         ;; Camera Tilemap X
    ld a, d
    ldi [hl], a         ;; Camera Tilemap Y

    ld a, 8             ;; Posicionamos la vista en (8, 0) el 8 es para que el jugador se vea centrado en la pantalla
    ld [GBSx], a
    xor a
    ld [GBSy], a

    inc hl              ;; Camera Tilemap ptr L
    inc hl              ;; Camera Tilemap ptr H
    ld b, h
    ld c, l          
    
    push bc
    call _sl_get_screenmap_dir
    pop bc
    ld a, l
    ld [bc],a           ;; Camera BGmap ptr TL L
    inc bc
    ld a, h
    ld [bc], a          ;; Camera BGmap ptr TL H

    push hl             ;; HL -> screenmap_dir

    ld de, GBSw * 2 - 2
    add hl, de
    ld a, l
    inc bc
    ld [bc], a          ;; BC -> Camera BGmap ptr TR L
    ld a, h
    inc bc
    ld [bc], a          ;; BC -> Camera BGmap ptr TR H

    pop hl
    push hl

    ld a,  GBSh - 1
    ld de, $0040
.bottom_left_loop:
    add hl, de
    dec a
    jr nz, .bottom_left_loop

    ld a, l
    inc bc
    ld [bc], a          ;; BC -> Camera BGmap ptr BL L
    ld a, h
    inc bc
    ld [bc], a          ;; BC -> Camera BGmap ptr BL H


    ld bc, 0
    ld de, 0 
    ld hl, ml_camera    
    ldi a, [hl]         ;; Camera Tilemap X
    ld c, a
    ldi a, [hl]         ;; Camera Tilemap Y
    ld e, a

    ld hl, ml_map
    call _sl_get_tilemap_dir

    ld b, h
    ld c, l

    ld hl, ml_camera    ;; Camera Tilemap X
    inc hl              ;; Camera Tilemap X
    inc hl              ;; Camera Tilemap ptr L

    ld a, c
    ldi [hl], a
    ld a, b
    ld [hl], a

    pop hl
    ; HL -> Puntero a la memoria de video
    ; BC -> Puntero al tilemap

    call _sr_draw_screen

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
_sl_correct_vert:

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
_sl_correct_hor:

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
_sl_get_map_tile:
    nop
    ld hl, _mapa_Prueba_01
    xor a
    ld d, a
    ld e, b 
    add hl, de
    ld a, c
    ld de, MAPw
    cp $0
    ret z
.loop:
    dec a
    ret z
    add hl, de
    jr .loop   



;;==============================================================================================
;;                                       GET SCREENMAP DIR
;;----------------------------------------------------------------------------------------------
;; Obtiene el puntero a las coordenadas de pantalla a partir de la posicion de la camara
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
_sl_get_screenmap_dir:

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
_sl_get_tilemap_dir:

    add hl, bc
    ld c, MAPw
    ld a, e
    cp 0
    ret z
.loop:
    add hl, bc
    dec a
    jr nz, .loop
    ret