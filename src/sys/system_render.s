INCLUDE "src/sys/system_render.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_hud.h.s"


SECTION "SYS_RENDER_VARS", WRAM0
sr_actual_x: ds $01
sr_actual_y: ds $01




SECTION "SYS_RENDER_FUNCS", ROM0


;               /       -8       \  /           +18            \  /    -10    \
attack_anim: db $FE, $FE, $04, $04, $03, $03, $02, $FC, $FC, $FC, $80

;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con los datos del jugador
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_main_menu_info:

    ld hl, mg_hud
    ld bc, eh_atk_c
    add hl, bc

    ldi a, [hl]
    ld b, $00            ;Indica si las centenas han sido 0
    
    add $30             ;;Comprobamos las centenas
    cp $31
    jr nc, .atk_no_cent
        ld a, $90
        ld b, $01
.atk_no_cent:
    call _VRAM_wait
    ld[$98F0], a

    ldi a, [hl]
    add $30
    ld c, a
    cp $31
    jr nc, .atk_no_dec
        ld a, b
        cp $00
        jr z, .atk_no_dec
            ld c, $90
.atk_no_dec:

    ld a, c
    call _VRAM_wait
    ld[$98F1], a
    
    ldi a, [hl]
    add $30
    call _VRAM_wait
    ld[$98F2], a




    ldi a, [hl]
    ld b, $00            ;Indica si las centenas han sido 0
    
    add $30             ;;Comprobamos las centenas
    cp $31
    jr nc, .atk_no_cent
        ld a, $90
        ld b, $01
.def_no_cent:
    call _VRAM_wait
    ld[$9930], a

    ldi a, [hl]
    add $30
    ld c, a
    cp $31
    jr nc, .def_no_dec
        ld a, b
        cp $00
        jr z, .def_no_dec
            ld c, $90
.def_no_dec:

    ld a, c
    call _VRAM_wait
    ld[$9931], a
    
    ldi a, [hl]
    add $30
    call _VRAM_wait
    ld[$9932], a

    ret



;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con los datos del jugador
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_update_draw_player_hud:

    ;Dibujar, Max health

    ld hl, mg_hud
    ldi a, [hl]
    ld b, $00            ;Indica si las centenas han sido 0
    
    add $81             ;;Comprobamos las centenas
    cp $82
    jr nc, .mhp_no_cent
        dec a
        ld b, $01
.mhp_no_cent:
    call _VRAM_wait
    ld[$9C05], a

    ldi a, [hl]
    add $81
    ld c, a
    cp $82
    jr nc, .mhp_no_dec
        ld a, b
        cp $00
        jr z, .mhp_no_dec
            ld c, $80
.mhp_no_dec:

    ld a, c
    call _VRAM_wait
    ld[$9C06], a
    
    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C07], a



    ;Dibujar, Max MP
    ldi a, [hl]
    add $81
    cp $82
    jr nc, .mmp_no_dec
        dec a
.mmp_no_dec:
    call _VRAM_wait
    ld[$9C0E], a

    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C0F], a



    ;Dibujar, Current health
    ldi a, [hl]
    ld b, $00
    
    add $81             ;;Comprobamos las centenas
    cp $82
    jr nc, .chp_no_cent
        dec a
        ld b, $01
.chp_no_cent:
    call _VRAM_wait
    ld[$9C01], a

    ldi a, [hl]
    add $81
    ld c, a
    cp $82
    jr nc, .chp_no_dec
        ld a, b
        cp $00
        jr z, .chp_no_dec
            ld c, $80
.chp_no_dec:

    ld a, c
    call _VRAM_wait
    ld[$9C02], a
    
    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C03], a


    ;Dibujar, Current MP
    ldi a, [hl]
    add $81
    cp $82
    jr nc, .cmp_no_dec
        dec a
.cmp_no_dec:
    call _VRAM_wait
    ld[$9C0B], a

    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C0C], a


    ;Dibujar, Floor
    ld hl, mg_hud
    ld bc, eh_fl_d
    add hl, bc
    
    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C12], a

    ldi a, [hl]
    add $81
    call _VRAM_wait
    ld[$9C13], a


    ret






;;==============================================================================================
;;                                    ENEMIES INITIAL DRAW
;;----------------------------------------------------------------------------------------------
;; Realiza el dibujado inicial del enemigo seleccionado
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_enemies_initial_draw:

    
    ldi a, [hl]
    ld d, a
    ldi a, [hl]
    ld e, a
    ;;DE -> Enemy X, Y

    ld bc, mp_player
    ld a, [bc]
    sub d

    jr c, .derecha
;izquierda
        cp $06
        jr c, .end_derecha
            ld a, $F0
            ldi [hl], a
            inc bc
            jr .end_x
.derecha:
        cp $FB
        jr nc, .end_derecha
            ld a, $B0
            ldi [hl], a
            inc bc
            jr .end_x
.end_derecha:

    sla a
    sla a
    sla a
    sla a
    ld d, a
    inc bc
    inc bc
    ld a, [bc]
    sub d
    ldi [hl], a
    dec bc


.end_x:
    ld a, [bc]
    sub e


    jr c, .abajo
;arriba
        
        cp $05
        jr c, .end_abajo
            ld a, $00
            ldi [hl], a
            jr .end_y
.abajo:
        
        cp $FC
        jr nc, .end_abajo
            ld a, $A0
            ldi [hl], a
            jr .end_y
.end_abajo:


    sla a
    sla a
    sla a
    sla a
    ld e, a
    inc bc
    inc bc
    ld a, [bc]
    sub e
    ldi [hl], a

.end_y:

    ;db $18, $FE

    ret


;;==============================================================================================
;;                                       DRAW ENEMIES
;;----------------------------------------------------------------------------------------------
;; Actualiza el sprite de los enemigos
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_enemies:
    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .continue
.loop:
    push af
    push hl

    ld bc, ep_spr_ptr_L
    add hl, bc
    ldi a, [hl]
    ld c, a
    ld a, [hl]
    ld b, a

    pop hl
    push hl

    call _sr_draw_sprite    

    pop hl
    ld bc, entity_enemy_size
    add hl, bc
    pop af
    dec a
    jr nz, .loop

.continue:
    ret




;;==============================================================================================
;;                                       ATTACK ANIMATION
;;----------------------------------------------------------------------------------------------
;; Anima al entity playable para atacar
;;
;; INPUT:
;;  HL -> entity_playable a animar
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;  AF, BC, DE, HL
;;==============================================================================================
_sr_attack_animation:

    push hl
    
    ld bc, ep_dir_x
    add hl, bc
    ldi a, [hl]
    ld [sr_actual_x], a
    ld a, [hl]
    ld [sr_actual_y], a

    pop hl
    ld bc, ep_spr_ptr_L
    add hl, bc
    ldi a, [hl]
    ld c, a
    ld a, [hl]
    
    ld h, a
    ld l, c

    ld a, $40
    ;ld [sr_anim_counter], a
    ld bc, attack_anim
    ;BC -> Puntero a la animacion

    
.loop:
    dec a
    call _wait_Vblank
    jr nz, .loop

    push hl

    ldi a, [hl]                 ;;C000
    ld e, a
    ld a, [bc]

    push af
    ld a, [sr_actual_y]
    cp $00
    jr z, .check_X

        cp $01
        jr nz, .check_up
            pop af
            push af
            add e
            dec hl
            ld [hl], a
            ld de, 0004
            add hl, de
            ld [hl], a

            dec hl
            dec hl
            dec hl
            jr .check_X

.check_up:
            pop af
            push af
            ld d, a
            ld a, e
            sub d
            dec hl
            ld [hl], a
            ld de, 0004
            add hl, de
            ld [hl], a

            dec hl
            dec hl
            dec hl

.check_X:

    ld a, [hl]
    ld e, a
    ld a, [sr_actual_x]
    cp $00
    jr z, .end
    
        cp $01
        jr nz, .check_left
            pop af
            push af
            add e
            ld [hl], a
            ld de, 0004
            add hl, de
            add a, 8
            ld [hl], a
            jr .end

.check_left:
            pop af
            push af
            ld d, a
            ld a, e
            sub d
            ld [hl], a
            ld de, 0004
            add hl, de
            add a, 8
            ld [hl], a

   
.end:


    pop af
    pop hl

    inc bc
    ld a,[bc]
    cp $80
    ret z
    
    ld a, $40
    jr .loop



;;==============================================================================================
;;                                       DRAW HUD
;;----------------------------------------------------------------------------------------------
;; Dibuja el HUD
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
_sr_draw_hud:
;     ld a, 10
;     ld hl, $9C00
    
; _window_loop:
;     push af
;     ld a, $0F
;     call _sr_draw_tile
;     ld bc, 02
;     add hl, bc
;     pop af
;     dec a
;     jr nz, _window_loop

    
    ld hl, $9C00
    ld bc, base_hud_end - base_hud 
    ld de, base_hud
    call _ldir_tile
    ;; DE -> Origen
    ;; HL -> Destino
    ;; BC -> Cantidad
    ld hl, $9C20
    ld bc, hud_text_separation_end - hud_text_separation
    ld de, hud_text_separation
    call _ldir_tile
    ;; DE -> Origen
    ;; HL -> Destino
    ;; BC -> Cantidad
    ld a, $03
    ld hl, $9C40
.loop:
    push af
    ld bc, hud_text_area_end - hud_text_area
    ld de, hud_text_area
    push hl
    call _ldir_tile
    ; DE -> Origen
    ;; HL -> Destino
    ;; BC -> Cantidad
    pop hl
    ld bc, $0020
    add hl, bc
    pop af
    dec a
    jr nz, .loop

    ld hl, $9C92
    ld a, $92
    call _VRAM_wait
    ld [hl], a

    ld hl, $FF4A      
    ld a, $88         ;; Window Y
    ;ld a, $68

    ldi [hl], a    ;; Seteamos la window 
    ld a, $07
    ld [hl], a
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
_sr_update_scroll_map:

    ld a, b             
    cp 0                ;;Comprobamos si se mueve horizontalmente
    jp z, .check_row    ;;Si el movimiento en X es 0, pasamos al movimiento en Y

    cp 1                ;;Comprobamos si se mueve hacia la derecha
    jr nz, .move_left   ;;Si no es 1 nos movemos a la izquierda

    call _ml_load_bgmap_tr
    ld a, 1
    call _sl_correct_hor
    call _ml_save_bgmap_tr
    ld a, -1
    call _sl_correct_vert

    push bc
    push hl
    call _ml_load_tilemap

    ld bc, $0001
    add hl, bc
    call _ml_save_tilemap
    ld bc, GBSw - 1
    add hl, bc
    ld bc, MAPw * -1  ;;$FFCE -> -50 | MAPw = 50
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _sr_draw_column
    pop bc

    call _ml_load_bgmap_tl  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, 1
    call _sl_correct_hor
    call _ml_save_bgmap_tl

    call _ml_load_bgmap_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, 1
    call _sl_correct_hor
    call _ml_save_bgmap_bl

    call _ml_load_player_bgmap  ;;Actualizamos la posicion del jugador
    ld a, 1
    call _sl_correct_hor
    call _ml_save_player_bgmap

    jr .check_row

.move_left:

    call _ml_load_bgmap_tl

    ld a, -1
    call _sl_correct_hor
    call _ml_save_bgmap_tl
    ld a, -1
    call _sl_correct_vert

    push bc
    push hl
    call _ml_load_tilemap

    ld bc, $FFFF
    add hl, bc
    call _ml_save_tilemap
    ld bc, MAPw * -1  ;;$FFCE -> -50 | MAPw = 50
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _sr_draw_column
    pop bc

    call _ml_load_bgmap_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, -1
    call _sl_correct_hor
    call _ml_save_bgmap_tr

    call _ml_load_bgmap_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, -1
    call _sl_correct_hor
    call _ml_save_bgmap_bl

    call _ml_load_player_bgmap  ;;Actualizamos la posicion del jugador
    ld a, -1
    call _sl_correct_hor
    call _ml_save_player_bgmap

.check_row:
    ld a, c
    cp 0
    ret z
    cp -1
    jr nz, .move_down  

    call _ml_load_bgmap_tl
    ld a, -1
    call _sl_correct_vert
    call _ml_save_bgmap_tl
    ld a, -1
    call _sl_correct_hor

    push hl
    call _ml_load_tilemap

    ld bc, MAPw * -1 ;;$FFCE -> -50 | MAPw = 50
    add hl, bc
    call _ml_save_tilemap
    ld bc, $FFFF
    add hl, bc

    ld b, h
    ld c, l
    pop hl 
    call _sr_draw_row

    call _ml_load_bgmap_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, -1
    call _sl_correct_vert
    call _ml_save_bgmap_tr

    call _ml_load_bgmap_bl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, -1
    call _sl_correct_vert
    call _ml_save_bgmap_bl

    call _ml_load_player_bgmap  ;;Actualizamos la posicion del jugador
    ld a, -1
    call _sl_correct_vert
    call _ml_save_player_bgmap

    ret

.move_down:

    call _ml_load_bgmap_bl
    ld a, 1
    call _sl_correct_vert
    call _ml_save_bgmap_bl
    ld a, -1
    call _sl_correct_hor

    push hl
    call _ml_load_tilemap

    ld bc, MAPw
    add hl, bc
    call _ml_save_tilemap

    ld a, GBSh - 1
    ld bc, MAPw
.md_loop:
    
    add hl, bc
    dec a
    jr nz, .md_loop

    ld bc, $FFFF       
    add hl, bc
    
    ld b, h
    ld c, l
    pop hl 

    call _sr_draw_row

    call _ml_load_bgmap_tr  ;;Actualizamos la posicion de la esquina superior izquierda
    ld a, 1
    call _sl_correct_vert
    call _ml_save_bgmap_tr

    call _ml_load_bgmap_tl  ;;Actualizamos la posicion de la esquina inferior izquierda
    ld a, 1
    call _sl_correct_vert
    call _ml_save_bgmap_tl

    call _ml_load_player_bgmap  ;;Actualizamos la posicion del jugador
    ld a, 1
    call _sl_correct_vert
    call _ml_save_player_bgmap

    ret


;;==============================================================================================
;;                                          DRAW COLUMN
;;----------------------------------------------------------------------------------------------
;; Dibuja una columna de (GBSh+2) tiles.
;;
;; INPUT:
;;  HL -> Direccion de memoria de video en la que dibujar el tile
;;  BC -> Puntero a la direccion del tilemap
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_draw_column:
    ld a, GBSh + 2

.loop:
    push af
    ld a, [bc]  ;; Obtenemos el tile a dibujar

    call _sr_draw_tile

    ld a, 1
    call _sl_correct_vert
    
    ;;ld de, $0040
    ;;add hl, de
    push hl

    ld h, b
    ld l, c

    ld de, MAPw
    add hl, de
    
    ld b, h
    ld c, l

    pop hl
    pop af
    dec a
    jr nz, .loop
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
_sr_draw_row:

    ld a, GBSw + 2

.loop:
    push af
    ld a, [bc]  ;; Obtenemos el tile a dibujar

    call _sr_draw_tile

    ld a, 1
    call _sl_correct_hor
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
;;                                      DRAW SCREEN 8x8
;;----------------------------------------------------------------------------------------------
;; Dibuja los tiles de 8x8 px de un tilemap para cubrir la pantalla
;;
;; INPUT:
;;  HL -> Puntero a la memoria de video donde quieres empezar a dibujar
;;  BC -> Puntero al tilemap donde quieres empezar a dibujar
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_draw_screen_8x8:

    ;db $18, $FE

    xor a
    ld [sr_actual_x], a
    ld [sr_actual_y], a

.loop:    

    ld a, [sr_actual_x]
    cp 20
    jr z, .change_y
    inc a
    ld [sr_actual_x], a

    ld a, [bc]
    call _VRAM_wait
    ldi [hl], a

    inc bc

    jr .loop

.change_y:

    ld a, [sr_actual_y]
    cp 17
    ret z

    inc a
    ld [sr_actual_y], a
    ld de, $000C
    add hl, de

    xor a
    ld [sr_actual_x], a

    jr .loop

    ret


;;==============================================================================================
;;                                      DRAW SCREEN
;;----------------------------------------------------------------------------------------------
;; Dibuja los tiles de un tilemap para cubrir la pantalla
;;
;; INPUT:
;;  HL -> Puntero a la memoria de video donde quieres empezar a dibujar
;;  BC -> Puntero al tilemap donde quieres empezar a dibujar
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_draw_screen:

    xor a
    ld [sr_actual_x], a
    ld [sr_actual_y], a

.loop:

    push hl
    ld h, b     ;; cargamos en hl el puntero al tilemap para realizar calculos
    ld l, c     ;; HL -> TILEMAP  

    ld de, 0    
    ld a, [sr_actual_x]
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
    ld a, [sr_actual_y]
    cp 0
    jr z, .continue
.inc_y:
    add hl, de
    dec a
    jr nz, .inc_y

.continue:
    pop de      ;; E -> Tile a dibujar
    ld a, e
    call _sr_draw_tile

    pop af
    inc a
    ld [sr_actual_x], a
    pop hl
    jr .loop


.change_y:      ;;Bajamos a la siguiente fila del tilemap      
    ;;HL -> TILEMAP
    xor a
    ld[sr_actual_x], a
    ld a, [sr_actual_y]
    inc a
    cp GBSh
    jr z, .end
    ld [sr_actual_y], a
    ld de, MAPw
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
_sr_draw_tile:
    
    push bc
    push hl
    
    ld hl, tile_index
    sla a
    ld d, $00
    ld e, a
    add hl, de

    ldi a, [hl]
    ld e, a
    ld a, [hl]
    ld b, a
    ld c, e

    pop hl
    push hl

    ld a, [bc]
    inc bc
    call _VRAM_wait
    ldi [hl], a

    ld a, [bc]
    inc bc
    call _VRAM_wait
    ld  [hl], a
    pop  hl

    push hl
    ld   de , $0020
    add  hl , de 

    ld a, [bc]
    inc bc
    call _VRAM_wait
    ldi [hl], a

    ld a, [bc]
    call _VRAM_wait
    ld  [hl], a
    pop hl

    pop bc

    ret



;;==============================================================================================
;;                                SYSTEM RENDER DRAW SPRITE
;;----------------------------------------------------------------------------------------------
;; Dibuja el sprite de la entidad especificada en una posicion de memoria dada
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

    ;call _VRAM_wait
    call _ldir              ;; HL -> Destino | DE -> Origen | BC -> Cantidad

    ret


;;==============================================================================================
;;                                          FADE IN
;;----------------------------------------------------------------------------------------------
;; Realiza un efecto de Fade In
;;
;; INPUT:
;;  A -> Velocidad del Fade In
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_fade_in:
    push af
.wait_loop_01:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_01

    ld a, %01000000
    call _define_palette

    pop af
    push af
.wait_loop_02:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_02

    ld a, %10010000
    call _define_palette

    pop af
.wait_loop_03:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_03

    ld a, %11100100
    call _define_palette

    ret




;;==============================================================================================
;;                                          FADE OUT
;;----------------------------------------------------------------------------------------------
;; realiza un efecto de Fade Out
;;
;; INPUT:
;;  A -> Velocidad del Fade Out
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sr_fade_out:
    push af
.wait_loop_01:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_01

    ld a, %10010000
    call _define_palette

    pop af
    push af
.wait_loop_02:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_02

    ld a, %01000000
    call _define_palette

    pop af
.wait_loop_03:
    call _wait_Vblank
    dec a
    jr nz, .wait_loop_03

    ld a, %00000000
    call _define_palette

    ret

