INCLUDE "src/sys/system_physics.h.s"

SECTION "SYS_PHYSICS_FUNCS", ROM0


;;==============================================================================================
;;                                    PLAYABLE COLLISIONS
;;----------------------------------------------------------------------------------------------
;; Calcula las colisiones de una entidad dada una direccion
;;
;; INPUT:
;;  HL -> Puntero a la entidad playable
;;  BC -> Direccion X, Y del jugador
;;
;; OUTPUT:
;;  BC -> Direccion actualizada en funcion de las colisiones
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sp_playable_collisions:
    
    push bc
    
    ldi a, [hl] ;;ent_x
    ld d, a
    ld a, [hl]  ;;ent_y
    ld e, a
    
    add c
    ld c, a
    ld a, d
    ld b, a 

    push de
    call _sl_get_map_tile ;;CHECK ENT Y +- 1
    pop de
    pop bc

    ld a, [hl]
    cp $00
    jr z, .continue01
    cp $0E
    jr z, .continue01
    jr .end

.continue01:
    push bc
    ld a, d
    add b
    ld b, a
    ld a, e
    ld c, a

    push de
    call _sl_get_map_tile ;;CHECK ENT X +- 1
    pop de
    pop bc

    ld a, [hl]
    cp $00
    jr z, .continue02
    cp $0E
    jr z, .continue02
    jr .end

.continue02:
    
    push bc
    ld a, d
    add b
    ld b, a
    ld a, e
    add c
    ld c, a

    push de 
    
    call _sl_get_map_tile ;;CHECK ENT X +- 1 && Y +- 1
    pop de
    pop bc

    ld a, [hl]
    cp $00
    jr z, .continue03
    cp $0E
    jr z, .win
    jr .end

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
    jr z, .end
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
    jr .continue03



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
            ld hl, mp_enemy_array
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