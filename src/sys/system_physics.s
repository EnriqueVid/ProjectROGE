INCLUDE "src/sys/system_physics.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_camera.h.s"

SECTION "SYS_PHYSICS_VARS", WRAM0
sp_special_tile:    ds $01


SECTION "SYS_PHYSICS_FUNCS", ROM0



;;==============================================================================================
;;                                  CHECK PLAYER DISTANCE
;;----------------------------------------------------------------------------------------------
;; calcula y devuelve la distancia absoluta de un punto al jugador
;;
;; INPUT:
;;  BC -> Corrdenadas X,Y a calcular la distncia
;;
;; OUTPUT:
;;  BC -> Distancia absoluta X, Y
;;
;; DESTROYS:
;;  AF, BC, DE
;;
;;==============================================================================================
_sp_check_distance_player:

    ld de, mp_player
    ld a, [de]
    sub b
    jr nc, .no_corregir_x
        xor $FF
        inc a

.no_corregir_x:
    ld b, a
    
    inc de
    ld a, [de]
    sub c
    jr nc, .no_corregir_y
        xor $FF
        inc a

.no_corregir_y
    ld c, a
    ret

;;==============================================================================================
;;                                    PLAYABLE COLLISIONS
;;----------------------------------------------------------------------------------------------
;; Calcula las colisiones con en mapay con todas la entidades de una entidad dada una direccion
;;
;; INPUT:
;;  HL -> Puntero a la entidad playable
;;  BC -> Direccion X, Y de la entidad
;;
;; OUTPUT:
;;  BC -> Direccion actualizada en funcion de las colisiones
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sp_playable_collisions:
    
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
    jr z, .end              ;;Si B y C valen 0, acabamos (no se puede mover)
 
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

    ld a, [sp_special_tile]
    cp $16
    jr z, .win

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
    ld a, $00
    ld [mg_win_condition], a
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