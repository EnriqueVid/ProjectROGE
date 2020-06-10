INCLUDE "src/sys/system_render.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_hud.h.s"
INCLUDE "src/data.h.s"


SECTION "SYS_RENDER_VARS", WRAM0
sr_actual_x: ds $01
sr_actual_y: ds $01

aux_01: ds $01
aux_02: ds $01



SECTION "SYS_RENDER_FUNCS", ROM0

test_text: db "Hello/"

;               /       -8       \  /           +18            \  /    -10    \
attack_anim: db $FE, $FE, $04, $04, $03, $03, $02, $FC, $FC, $FC, $80



;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con los datos del jugador
;;
;; INPUT:
;;  A  -> Posicion del primer item a mostrar
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_item_name:

    ld b, $00
    ld a, c
    ld a, [mi_player_item_num]
    cp $00
    ret z
    
    ld hl, mi_player_items
    add bc

    ;;PRIMER ITEM
    ldi a, [hl]
    push hl
    
    ld hl, ent_item_index
    sla a
    ld b, a
    add hl, bc
    ldi a, [hl]
    ld e, a
    ld d, [hl]

    ld bc, $9882
    ld hl, $8A00

    call _sr_draw_text

    pop hl

    ;;SEGUNDO ITEM
    ldi a, [hl]
    push hl
    
    ld b, $00
    ld hl, ent_item_index
    sla a
    ld c, a
    add hl, bc
    ldi a, [hl]
    ld e, a
    ld d, [hl]

    ld bc, $98C2
    ld hl, $8A80

    call _sr_draw_text

    pop hl

    ;;TERCER ITEM
    ldi a, [hl]
    push hl
    
    ld b, $00
    ld hl, ent_item_index
    sla a
    ld c, a
    add hl, bc
    ldi a, [hl]
    ld e, a
    ld d, [hl]

    ld bc, $9902
    ld hl, $8B00

    call _sr_draw_text

    pop hl

    ;;CUARTO ITEM
    ldi a, [hl]
    push hl
    
    ld b, $00
    ld hl, ent_item_index
    sla a
    ld c, a
    add hl, bc
    ldi a, [hl]
    ld e, a
    ld d, [hl]

    ld bc, $9942
    ld hl, $8B80

    call _sr_draw_text

    pop hl

    ;;QUINTO ITEM
    ldi a, [hl]
    push hl
    
    ld b, $00
    ld hl, ent_item_index
    sla a
    ld c, a
    add hl, bc
    ldi a, [hl]
    ld e, a
    ld d, [hl]

    ld bc, $9982
    ld hl, $8C00

    call _sr_draw_text

    pop hl

    
    
    

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
_sr_draw_main_menu_info:

    ld hl, mg_hud
    ld bc, eh_atk_c
    add hl, bc

    ;Dibujar Atk
    ldi a, [hl]
    ld b ,a
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    push hl
    ld hl, $98EF
    ld d,  $00
    ld e,  $01
    call _sr_draw_number_3
    pop hl

    ;Dibujar Def
    ldi a, [hl]
    ld b ,a
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    ld hl, $992F
    ld d,  $00
    ld e,  $01
    call _sr_draw_number_3

    ;Dibujar Lvl
    ld hl, mg_hud
    ld bc, eh_lvl_c
    add hl, bc
    ldi a, [hl]
    ld b ,a
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a


    ld hl, $98AF
    ld d,  $00
    ld e,  $01
    call _sr_draw_number_3


    ;Dibujar Gold
    ld hl, mi_gold
    ldi a, [hl]
    ld b, a
    ldi a, [hl]
    ld c, a
    ld d, [hl]

    ld hl, $9A04
    ld e,  $01
    call _sr_draw_number_6

    ret



;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con los datos del jugador
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
_sr_update_draw_player_hud:

    ;Dibujar Max HP
    ld hl, mg_hud
    ldi a, [hl]
    ld b ,a
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    push hl
    ld hl, $9C04
    ld d,  $00
    ld e,  $81
    call _sr_draw_number_3
    pop hl

    ;Dibujar Max MP
    ld b, $00
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    push hl
    ld hl, $9C0C
    ld d,  $01
    ld e,  $81
    call _sr_draw_number_3
    pop hl


    ;Dibujar Current HP
    ldi a, [hl]
    ld b ,a
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    push hl
    ld hl, $9C00
    ld d,  $00
    ld e,  $81
    call _sr_draw_number_3
    pop hl


    ;Dibujar Current MP
    ld b, $00
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ldi a, [hl]
    or c
    ld c, a

    push hl
    ld hl, $9C09
    ld d,  $01
    ld e,  $81
    call _sr_draw_number_3
    pop hl


    ;Dibujar Current Floor
    ld hl, mg_hud
    ld bc, eh_fl_d
    add hl, bc

    ld b, $00
    ldi a, [hl]
    ld c, a
    sla c    
    sla c    
    sla c    
    sla c    
    ld a, [hl]
    or c
    ld c, a

    ld hl, $9C10
    ld d,  $01
    ld e,  $81
    call _sr_draw_number_3

    ret

;;==============================================================================================
;;                                    DRAW TEXT
;;----------------------------------------------------------------------------------------------
;; Realiza el dibujado de un string de texto 
;;
;; INPUT:
;;  HL -> Puntero a la VRAM
;;  BC -> Puntero al BGmap
;;  DE -> Puntero al String
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, HL,   
;;
;;==============================================================================================
_sr_draw_text:
    ld a, b
    ld [aux_01], a
    ld a, c
    ld [aux_02], a

.main_loop:

    ld a, [de]
    sub ALPHABET_OFFSET
    cp $FF
    ret z
    cp $FE
    jr nz, .continue

        inc de
        ld a, [de]
        sub ALPHABET_OFFSET
        push af
        push hl
        ld a, [aux_01]
        ld h, a
        ld a, [aux_02]
        ld l, a
        ld bc, $0020
        add hl, bc
        ld b, h
        ld a, h
        ld [aux_01], a
        ld c, l
        ld a, l
        ld [aux_02], a
        pop hl
        pop af

.continue:
    push de
    push hl
    ld hl, tileset_08
    ld de, Tile_size
    cp $00
    jr z, .end_loop_search

.loop_search:

    add hl, de
    dec a
    jr nz, .loop_search

.end_loop_search:
    ;HL -> Puntero al tile en ROM

    ld d, h
    ld e, l
    pop hl
    
    push bc
    ld bc, Tile_size
    call _ldir_tile
    pop bc
    
    ;;Obtenemos el identificador del tile a dibujar
    ld d, h
    ld a, l
    sla d
    sla d
    sla d
    sla d
    srl a
    srl a
    srl a
    srl a
    or d
    dec a

    call _VRAM_wait
    ld [bc], a

    inc bc

    pop de
    inc de
    
    jr .main_loop




;;==============================================================================================
;;                                    DRAW NUMBER 3
;;----------------------------------------------------------------------------------------------
;; Realiza el dibujado de un numero de 3 digitos. 
;; Cada nibble de los bytes debe simbolizar un numero decimal del 0 al 9.
;;
;; INPUT:
;;  B  -> NADA, Centenas (-, C)
;;  C  -> Decenas, Unidades (D, U)
;;  HL -> Puntero a VRAM inicial
;;  D  -> indica como se dibujan los dos primeros digitos cuando valen 0 (0 -> Normal, 1 -> no hacer nada)
;;  E  -> Offset del numero respecto al tile
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_number_3:
    xor a
    ld [aux_01], a

    ld a, b
    cp $00
    jr z, .b_00
        push hl
        ld b, $02
        call _sr_draw_number_tile
        pop hl
        inc hl
        jr .continue_c

.b_00: 

        ld a, $01
        ld [aux_01], a
        inc hl
        ld a, d
        cp $00
        jr nz, .continue_c

        ld a, e
        dec a
        call _VRAM_wait
        ld [hl], a


.continue_c:
    inc hl
    ld a, [aux_01]
    ld b, a
    ld a, c
    call _sr_draw_number_tile

    ret




;;==============================================================================================
;;                                    DRAW NUMBER 6
;;----------------------------------------------------------------------------------------------
;; Realiza el dibujado de un numero de 6 digitos. 
;;
;; INPUT:
;;  B  -> Centenas de Millar, Decenas de Millar (Cm, Dm)
;;  C  -> Unidades de Millar, Centenas (Um, C)
;;  D  -> Decenas, Unidades (D,U)
;;  HL -> Puntero a VRAM inicial
;;  E  -> Offset del numero respecto al tile
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_number_6:
    
    xor a
    ld [aux_01], a

    ld a, b
    cp $00
    jr z, .b_00
        push hl
        ld b, $01
        call _sr_draw_number_tile
        pop hl
        inc hl
        inc hl
        jr .continue_c

.b_00:
        ld a, $01
        ld [aux_01], a
        ld a, e
        dec a
        call _VRAM_wait
        ldi [hl], a
        call _VRAM_wait
        ldi [hl], a

.continue_c:
    
    ld a, [aux_01]
    ld b, a
    xor a
    ld [aux_01], a
    
    ld a, c
    cp $00
    jr z, .c_00
        push hl
        call _sr_draw_number_tile
        pop hl
        inc hl
        inc hl
        jr .continue_d

.c_00:
        ld a, b
        ld [aux_01], a
        cp $00
        jr z, .c_draw_00

        ld a, e
        dec a
        call _VRAM_wait
        ldi [hl], a
        call _VRAM_wait
        ldi [hl], a
        jr .continue_d


.c_draw_00:        
        push hl
        call _sr_draw_number_tile
        pop hl
        inc hl
        inc hl

.continue_d:

    ld a, [aux_01]
    ld b, a
    ld a, d
    call _sr_draw_number_tile
 
    ret



;;==============================================================================================
;;                                    DRAW NUMBER TILE
;;----------------------------------------------------------------------------------------------
;; Realiza el dibujado del tile de un numero establecido
;;
;; INPUT:
;;  HL -> Puntero al enemigo
;;  A  -> 2 Digitos a dibujar
;;  B  -> Indica que se hace con el primer dijito en caso de ser 0 (0 = dibujar numero, 1 = rellenar con vacio, 2 = no hacer nada)
;;  E  -> Offset del numero respecto al tile
;;
;; OUTPUT:
;;
;; DESTROYS:
;;  
;;
;;==============================================================================================
_sr_draw_number_tile:

    push af
    srl a
    srl a
    srl a
    srl a
    push af

    cp $00
    jr nz, .first_draw
        
    ld a, b
    cp $00
    jr z, .first_draw
    cp $02
    jr z, .continue
        pop af
        push af
        dec a

.first_draw:
    add e
    call _VRAM_wait
    ld [hl], a

.continue:
    inc hl
    pop af
    pop af
    and %00001111
    add e
    call _VRAM_wait
    ld [hl], a

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

