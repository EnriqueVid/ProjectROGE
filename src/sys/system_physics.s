INCLUDE "src/sys/system_physics.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_camera.h.s"
INCLUDE "src/ent/entity_room.h.s"

SECTION "SYS_PHYSICS_VARS", WRAM0
sp_special_tile:    ds $01
aux_is_player: ds $01

aux_rx: ds $01
aux_ry: ds $01
aux_rw: ds $01
aux_rh: ds $01


SECTION "SYS_PHYSICS_FUNCS", ROM0



;;==============================================================================================
;;                                  CHECK ROOM COLLISION
;;----------------------------------------------------------------------------------------------
;; calcula y devuelve la distancia absoluta de un punto al jugador
;;
;; INPUT:
;;  BC -> X, Y de la room origen
;;  DE -> W, H de la room origen
;;
;; OUTPUT:
;;   A -> Indica si hau colision (0=si, 1=no)
;;
;; DESTROYS:
;;  AF, BC, DE
;;
;;==============================================================================================
_sp_check_room_collision:

    ld a, b
    ld [aux_rx], a
    ld a, c
    ld [aux_ry], a
    ld a, d
    ld [aux_rw], a
    ld a, e
    ld [aux_rh], a

    ld hl, ml_room_array
    ld a, [ml_room_num]
    cp $00
    jr nz, .loop

        ld a, $01
        ret

.loop:
        push af
        push hl

        ldi a, [hl]
        ld b, a
        inc hl
        ld a, [hl]
        ld c, a
        dec hl
        ;;BC -> R2 X, W

        ld a, [aux_rx]
        ld d, a
        ld a, [aux_rw]
        add d
        push af
        ;;A -> R1 X+W

        ld a, b
        ;dec a
        sub $03
        ld d, a
        ;;D -> R2 X-3   (default: X-1)

        pop af
        cp d                    ;;Si (X1+W1 < X2-1) no hay colision
        jr c, .no_collision

        ld a, [aux_rx]
        ld d, a
        ;;D -> R1 X

        ld a, b
        add c
        ;inc a
        add $03
        ;;A -> R2 X+W+3 (default: X+W+2)
        cp d                    ;;Si (X2+W2+1 > X1) no hay colision
        jr c, .no_collision


        ldi a, [hl]
        ld b, a
        inc hl
        ld a, [hl]
        ld c, a
        ;;BC -> R2 Y, H

        ld a, b
        ;dec a
        sub $03
        ld d, a
        ;;D -> R2 Y-3   (default: Y-1)

        ld a, [aux_ry]
        ld e, a
        ld a, [aux_rh]
        add e
        ;;A -> R1 Y+H

        cp d                    ;;Si (Y1 + H1 < Y2) no hay colision
        jr c, .no_collision

        ld a, [aux_ry]
        ld d, a
        ;;D -> R1 Y

        ld a, b
        add c
        ;inc a
        add $03
        ;;A -> R2 Y+H+3 (default: Y+H+1)
        cp d                    ;;Si (Y2+H2+1 > Y1) no hay colision
        jr c, .no_collision

        ;;HAY COLISION
        pop hl
        pop af
        xor a
        ret

        ;;NO HAY COLISION
.no_collision:
        pop hl
        ld de, entity_room_size
        add hl, de

        pop af
        dec a
        jr nz, .loop

    ld a, $01
    ret



;;==============================================================================================
;;                                  CHECK PLAYER DISTANCE
;;----------------------------------------------------------------------------------------------
;; calcula y devuelve la distancia absoluta de un punto al jugador
;;
;; INPUT:
;;  BC -> Coordenadas X,Y a calcular la distncia
;;  DE -> Direccion X,Y hacia el jugador
;;
;; OUTPUT:
;;  BC -> Distancia absoluta X, Y
;;
;; DESTROYS:
;;  AF, BC, DE
;;
;;==============================================================================================
_sp_check_distance_player:

    push hl

    ld de, $0101

    ld hl, mp_player
    ldi a, [hl]
    sub b
    jr nc, .no_corregir_x
        xor $FF
        inc a
        ld d, $FF

.no_corregir_x:
    ld b, a
    cp $00
    jr nz, .no_cambiar_dir_x

        ld d, $00

.no_cambiar_dir_x:
    
    ld a, [hl]
    sub c
    jr nc, .no_corregir_y
        xor $FF
        inc a
        ld e, $FF

.no_corregir_y
    ld c, a
    cp $00
    jr nz, .no_cambiar_dir_y

        ld e, $00

.no_cambiar_dir_y:

    pop hl
    ret

;;==============================================================================================
;;                                    PLAYABLE COLLISIONS
;;----------------------------------------------------------------------------------------------
;; Calcula las colisiones con en mapay con todas la entidades de una entidad dada una direccion
;;
;; INPUT:
;;  HL -> Puntero a la entidad playable
;;  BC -> Direccion X, Y de la entidad
;;   A -> Tipo de Entidad (0=NPC, 1=Player)
;;
;; OUTPUT:
;;  BC -> Direccion actualizada en funcion de las colisiones
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sp_playable_collisions:

    ld [aux_is_player], a
    xor a
    ld [sp_special_tile], a
    
    push bc                 ;;Guardamos la direccion inicial del jugador
    
    ldi a, [hl] ;;ent_x     ;;Obtenemos en DE la posicion x,y de la entidad
    ld d, a
    ld a, [hl]  ;;ent_y
    ld e, a
    
    add c                   ;;Añadimos a direccion en y para obtener la posicion final en Y de la entidad
    ld c, a
    ld a, d
    ld b, a                 ;;BC = Posicion actualizada de la entidad en Y

    push de                 ;;Guardamos la posicion inicial de la entidad
    call _sl_get_map_tile   ;;CHECK ENT Y +- 1
    pop de                  ;;Recuperamos la posicion inicial de la entidad
    pop bc                  ;;Recuperamos la direccion inicial de la entidad

    ld a, [hl]              
    

    cp $14                  ;;Comprobamos si colisiona con algun tile del escenario (<14 = Tiles solidos)
    jr nc, .continue01
    ld c, $00               ;;Si colisiona en Y con algún tile sólido, la ponemos a 0

.continue01:
    push bc                 ;;Guardamos en BC la direccion inicial (Modificada si colisiona en Y)
    ld a, d                 
    add b
    ld b, a
    ld a, e
    ld c, a                 ;; Guardamos en BC la posicion actualizada en X de la entidad

    push de                 ;;Guardamos la posicion inicial de la entidad
    call _sl_get_map_tile   ;;CHECK ENT X +- 1
    pop de                  ;;Recuperamos la posicion inicial de la entidad
    pop bc                  ;;Recuperamos la direccion inicial de la entidad

    ld a, [hl]
    cp $14
    jr nc, .continue02
    ld b, $00               ;;Si colisiona en X, la ponemos a 0
    ld a, c
    or b
    jp z, .end              ;;Si B y C valen 0, acabamos (no se puede mover)
 
.continue02:
    
    push bc                 ;;Guardamos en BC la direccion inicial (Modificada si colisiona en Y o en X)
    ld a, d                 
    add b
    ld b, a
    ld a, e
    add c
    ld c, a                 ;; Guardamos en BC la posicion actualizada en X y en Y de la entidad

    push de                 ;;Guardamos la posicion inicial de la entidad 
    call _sl_get_map_tile   ;;CHECK ENT X +- 1 && Y +- 1
    pop de                  ;;Recuperamos la posicion inicial de la entidad
    pop bc                  ;;Recuperamos la direccion inicial de la entidad

    ld a, [hl]              ;;Comprobamos el tile al que se mueve
    cp $14
    jr c, .end              ;;Si colisiona con un tile solido, acabamos
    
    ;;NO HAY NUNGUN TILE SOLIDO
    ld [sp_special_tile], a
    ;; A = Tile NO solido, se comprueba al final por si hay alguna entidad encima.
.continue03:

    push bc
    push de
    ld a, d
    add b
    ld b, a
    ld a, e
    add c
    ld c, a

    ld hl, mp_player
    ldi a, [hl]
    xor b
    ld d, a
    
    ld a, [hl]
    xor c
    or d
    jr z, .pre_pre_end
    
    pop de
    pop bc

    push bc
    ld a, d
    add b
    ld b, a
    ld a, e
    add c
    ld c, a

    ld hl, mp_enemy_array
    ld a, [mp_enemy_num]
    cp $00
    jr z, .loop_end
    

.loop:
    push af
    
    ldi a, [hl]
    xor b
    ld d, a
    
    ld a, [hl]
    xor c
    or d
    jr z, .pre_end
    pop af

    dec hl
    ld de, entity_enemy_size
    add hl, de

    dec a
    jr nz, .loop

.loop_end:
    pop bc

    ld a, [aux_is_player]
    cp $00
    ret z

    ld a, [sp_special_tile]
    cp $16
    ret c

    cp $16
    jr z, .win

    push bc

    ld a, $01
    ld [mg_grab_item], a

    ; ld hl, mp_player
    ; ldi a, [hl]
    ; add b
    ; ld d, a
    ; ld a, [hl]
    ; add c
    ; ld e, a
    ; ;push de

    ; ld hl, ml_map
    ; ld b, $00
    ; ld c, d
    ; ld d, $00

    ; call _sl_get_tilemap_dir

    ; ld a, $14
    ; ld [hl], a

    ; pop bc
    ; push bc

    ; call _ml_load_player_bgmap
    ; ld a, b
    ; call _sl_correct_hor

    ; ld a, c
    ; call _sl_correct_vert
    
    ; ;HL -> BGmap ptr del tile del objeto
    ; ld a, $14
    ; call _sr_draw_tile
    
    ;call _sr_get_player_BGmap
    ;pop de

    pop bc                  ;BC -> Dir_x, Dir_y
    

    ;ld a, h
    ;cp $9B

    ;[WIP]

    ;db $18, $FE
    

    ret

 
.pre_pre_end:
    pop de
    pop bc
    jr .end
.pre_end:
    pop af
    pop bc
.end:
    ld bc, $0000
    ;ld a, $00
    ;ld [mg_win_condition], a
    ret



.win:
    ld a, $01
    ld [mg_win_condition], a
    ret



;;==============================================================================================
;;                                    SCROLL ENEMIES
;;----------------------------------------------------------------------------------------------
;; Mueve por la pantalla a los enemigos en funcion de su direccion y la del jugador
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
_sp_scroll_enemies:

    ld a, [mp_enemy_num]
    cp $00
    ret z

    ld hl, ml_camera
    ld bc, ec_scroll_dir_x
    add hl, bc
    ldi a, [hl]
    ld d, a
    ld a, [hl]
    ld e, a
    ;DE -> Scroll dir. X, Y 

    ld hl, mp_enemy_array

;dir_x:
    ld a, d
    cp $00
    jr z, .dir_y
        cp $01
        jr nz, .izquierda
;derecha:
            ld a, [mp_enemy_num]
.derecha_loop:
            push af
            push de
            push hl

            inc hl
            inc hl

            ld a, [hl]
            cp $F0
            jr z, .derecha_loop_end

            dec a
            ld [hl], a

            dec hl
            dec hl
            ld a, [hl]
            ld d, a
            
            ld a, [mp_player]
            sub d
            jr nc, .derecha_loop_end
            cp $FB
            jr nc, .derecha_loop_end

            inc hl
            inc hl
            ld a, [hl]
            inc a
            ld [hl], a

.derecha_loop_end:
            pop hl
            ld bc, entity_enemy_size
            add hl, bc
            pop de
            pop af
            dec a
            jr nz, .derecha_loop
            jr .dir_y
;;-----------------------------------------
.izquierda:
            ld a, [mp_enemy_num]
.izquierda_loop:
            push af
            push de
            push hl

            inc hl
            inc hl

            ld a, [hl]
            cp $B0
            jr z, .izquierda_loop_end

            inc a
            ld [hl], a

            dec hl
            dec hl
            ld a, [hl]
            ld d, a
            
            ld a, [mp_player]
            sub d
            jr c, .izquierda_loop_end
            cp $06
            jr c, .izquierda_loop_end

            inc hl
            inc hl
            ld a, [hl]
            dec a
            ld [hl], a

            
.izquierda_loop_end:
            pop hl
            ld bc, entity_enemy_size
            add hl, bc
            pop de
            pop af
            dec a
            jr nz, .izquierda_loop
;;-----------------------------------------
.dir_y:
    ld hl, mp_enemy_array
    ld a, e
    cp $00
    ret z
        cp $01
        jr nz, .arriba
;abajo:
            ld a, [mp_enemy_num]
.abajo_loop:
            push af
            push de
            push hl

            inc hl
            inc hl
            inc hl

            ld a, [hl]
            cp $00
            jr z, .abajo_loop_end

            dec a
            ld [hl], a

            dec hl
            dec hl
            ld a, [hl]
            ld d, a
            
            ld a, [mp_player + 1]
            sub d
            jr nc, .abajo_loop_end
            cp $FC
            jr nc, .abajo_loop_end

            inc hl
            inc hl
            ld a, [hl]
            inc a
            ld [hl], a


.abajo_loop_end:        
            pop hl
            ld bc, entity_enemy_size
            add hl, bc
            pop de
            pop af
            dec a
            jr nz, .abajo_loop
            ret
;------------------------------------------

.arriba:
            ld a, [mp_enemy_num]
.arriba_loop:
            push af
            push de
            push hl

            inc hl
            inc hl
            inc hl

            ld a, [hl]
            cp $A0
            jr z, .arriba_loop_end

            inc a
            ld [hl], a

            dec hl
            dec hl
            ld a, [hl]
            ld d, a
            
            ld a, [mp_player + 1]
            sub d
            jr c, .arriba_loop_end
            cp $05
            jr c, .arriba_loop_end

            inc hl
            inc hl
            ld a, [hl]
            dec a
            ld [hl], a

.arriba_loop_end:
            pop hl
            ld bc, entity_enemy_size
            add hl, bc
            pop de
            pop af
            dec a
            jr nz, .arriba_loop
            ret
    ret




;;==============================================================================================
;;                                    PLAYER DISTANCE X
;;----------------------------------------------------------------------------------------------
;; Devuelve la distancia al jugador en el eje X
;;
;; INPUT:
;;  D -> Posicion de la entidad
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sp_player_distance_x:

    ld a, [mp_player]
    sub d

    jr c, .derecha
;izquierda:

.derecha:

    ret