INCLUDE "src/sys/system_level.h.s"
INCLUDE "src/ent/entity_camera.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_room.h.s"
INCLUDE "src/ent/entity_map.h.s"


SECTION "SYS_LEVEL_VARS", WRAM0
aux_max_rooms: ds $01
aux_room_counter: ds $01    ;DEBUG

aux_rx: ds $01
aux_ry: ds $01
aux_rw: ds $01
aux_rh: ds $01

aux_rx2: ds $01
aux_ry2: ds $01
aux_rw2: ds $01
aux_rh2: ds $01

aux_close_room:  ds $01
aux_close_dist:  ds $01
aux_orientation: ds $01

aux_room_id_01: ds $01
aux_room_id_02: ds $01

aux_dist: ds $01
;aux_dist_y: ds $01
aux_close_dist_x: ds $01
aux_close_dist_y: ds $01
aux_orient_x: ds $01
aux_orient_y: ds $01

aux_generic_1: ds $01
aux_generic_2: ds $01

aux_debug_01: ds $01
aux_debug_02: ds $01
aux_debug_03: ds $01

aux_debug_04: ds $01
aux_debug_05: ds $01
aux_debug_06: ds $01


SECTION "SYS_LEVEL_FUNCS", ROM0

enemy_positions: db $12, $0B, $06, $13, $0E, $16, $0D, $1F, $07, $29, $1F, $1C, $00, $00, $00, $00
;enemy_positions: db $06, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00



;;========================================================================================
;;                                     GENERATE MAP
;;----------------------------------------------------------------------------------------
;; Devuelve las coordenadas de una salida dado el ID de una habitacion
;;
;; INPUT:
;;  
;;
;; OUTPUT:
;;  BC -> Coordenadas de la salida
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_generate_map:
    xor a
    ld [aux_room_counter], a

    ;;Generamos el numero de salas que va a tener el mapa, de 3 a 6 salas
.generate_room_num:
    call _generate_random
    ld b, %00000111             ;Fuerza el valor de la salida al rango de 0 a 7
    and b
    cp $07                      ;Asegura que el maximo es 6
    jr z, .generate_room_num
    cp $03                      ;Asegura que el minimo es 3
    jr c, .generate_room_num


    ld a, $02                   ;DELETE THIS
    ld [aux_max_rooms], a       ;Guardamos el valor del numero maximo de habitaciones



    ;;Generamos las habitaciones en posiciones validas
.generate_rooms_loop:
    push af                     ;Guardamos el maximo de habitaciones para mas adelante

        call _sl_generate_room_data

        call _sl_generate_room
        cp $00
        jr nz, .generated_room 

            pop af
            jr .generate_rooms_loop

.generated_room:
        ld a, [aux_room_counter]    ;DEBUG
        inc a                       ;DEBUG
        ld [aux_room_counter], a    ;DEBUG

    pop af
    dec a
    jr nz, .generate_rooms_loop

    call _sl_connect_rooms


    ret


;;========================================================================================
;;                                     CONNECT ROOMS
;;----------------------------------------------------------------------------------------
;; Genera las salidas y conecta todas las habitaciones con pasillos
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_connect_rooms:

    xor a
    ld [aux_room_id_01], a              ;; Guardamos Room_1 id
    

    ld a, [ml_room_num]
    cp $00
    ret z
    ld hl, ml_room_array
    
.loop_room_1:
        push af        
        ld a, $FF
        ld [aux_close_dist], a          ;; Seteamos la distancia mas cercana
        ld [aux_close_room], a          ;; Seteamos la room mas cercana
        ld [aux_orientation], a         ;; Seteamos la orienacion de la salida
        
        push hl                         ;; Guardamos los datos de la Room_1 en variables
        ldi a, [hl]
        ld [aux_rx], a
        ldi a, [hl]
        ld [aux_ry], a
        ldi a, [hl]
        ld [aux_rw], a
        ldi a, [hl]
        ld [aux_rh], a

        xor a
        ld [aux_room_id_02], a              ;; Guardamos Room_2 id
        ld a, [ml_room_num]
        ld hl, ml_room_array
.loop_room_2:
            push af
            push hl

            ld a, [aux_room_id_02]
            ld b, a
            ld a, [aux_room_id_01]
            cp b                        ;;Comprobamos si Room_1 != Room_2
            jp z, .loop_room_2_end

            xor a
            ld [aux_dist], a            ;;Seteamos la distancia 
            ld [aux_close_dist_y], a    ;;Seteamos la distncia mas cercana en Y
            ;ld [aux_dist_y], a          ;;Seteamos la distancia en Y
            ld a, $FF   
            ld [aux_close_dist_x], a    ;;Seteamos la distncia mas cercana en X
            ld [aux_orient_x], a        ;;Seteamos la orientacion en X
            ld [aux_orient_y], a        ;;Seteamos la orientacion en Y


            ldi a, [hl]
            ld b, a
            inc hl
            ld a, [hl]
            ld c, a
            dec hl
            ;;BC -> Room_2 X, W

            ;;COMROBAMOS LA DISTANCIA EN X
.check_dist_x_1:
            ;;Si (Room_2.x + Room_2.w) < Room_1.x
            ld a, [aux_rx]
            ld d, a                     ;;D -> Room_1.x
            ld a, b
            add c                       ;;A -> Room_2.x + Room_2.w
            
            cp d
            jr nc, .check_dist_x_2

                ld e, a                 ;;E -> Room_2.x + Room_2.w
                ld a, d                 ;;A -> Room_1.x
                sub e                   ;;A -> Room_1.x - (Room_2.x + Room_2.w)
                ld [aux_dist], a
                ld [aux_close_dist_x], a;;Guardamos la distancia en X
                ld a, $02
                ld [aux_orient_x], a    ;;Orientacion de la salida = 2 = Izquierda
                jr .end_check_dist_x


.check_dist_x_2:
            ;;Si (Room_1.x + Room_1.w) < Room_2.x
            ld a, b
            ld d, a                     ;;D -> Room_2.x
            ld a, [aux_rx]
            ld e, a
            ld a, [aux_rw]
            add e                       ;;A -> Room_1.x + Room_1.w

            cp d
            jr nc, .check_dist_x_3

                ld e, a                 ;;E -> Room_1.x + Room_1.w
                ld a, d                 ;;A -> Room_2.x
                sub e                   ;;A -> Room_2.x - (Room_1.x + Room_1.w)
                ld [aux_dist], a
                ld [aux_close_dist_x], a;;Guardamos la distancia en X
                ld a, $03
                ld [aux_orient_x], a    ;;Orientacion de la salida = 3 = Derecha
                jr .end_check_dist_x

.check_dist_x_3:
            xor a
            ld [aux_dist], a            ;;Distncia = 0
            ld [aux_close_dist_x], a    ;;Guardamos la distancia en X

.end_check_dist_x:


            ldi a, [hl]
            ld b, a
            inc hl
            ld a, [hl]
            ld c, a
            ;;BC -> Room_2 Y, H

            ;;COMROBAMOS LA DISTANCIA EN Y
.check_dist_y_1:
            ;;Si (Room_2.y + Room_2.h) < Room_1.y
            ld a, [aux_ry]
            ld d, a                     ;;D -> Room_1.y
            ld a, b
            add c                       ;;A -> Room_2.y + Room_2.h
            
            cp d
            jr nc, .check_dist_y_2
                ld e, a                 ;;E -> Room_2.y + Room_2.h
                ld a, d                 ;;A -> Room_1.y
                sub e                   ;;A -> Room_1.y - (Room_2.y + Room_2.h)
                ld [aux_close_dist_y], a
                ld d, a
                ld a, [aux_dist]
                add d                   ;;A -> aux_dist + aux_close_dist_y
                ld [aux_dist], a
                xor a
                ld [aux_orient_y], a    ;;Orientacion de la salida = 0 = Arriba
                jr .end_check_dist_y    

.check_dist_y_2:
            ;;Si (Room_1.y + Room_1.h) < Room_2.y
            ld a, b
            ld d, a                     ;;D -> Room_2.y
            ld a, [aux_ry]
            ld e, a
            ld a, [aux_rh]
            add e                       ;;A -> Room_1.y + Room_1.h

            cp d
            jr nc, .end_check_dist_y
                ld e, a                 ;;E -> Room_1.y + Room_1.h
                ld a, d                 ;;A -> Room_2.y
                sub e                   ;;A -> Room_2.y - (Room_1.y + Room_1.h)
                ld [aux_close_dist_y], a
                ld d, a
                ld a, [aux_dist]
                add d                   ;;A -> aux_dist + aux_close_dist_y
                ld [aux_dist], a
                ld a, $01
                ld [aux_orient_y], a    ;;Orientacion de la salida = 1 = Abajo

.end_check_dist_y:

            
            ;;COMPROBAMOS RESULTADOS
            ld a, [aux_close_dist]
            ld d, a
            ld a, [aux_dist]
            cp d                        ;;Comprobamos si (aux_dist < aux_close_dist)
            jr nc, .loop_room_2_end

                ;;COMPROBAR SI YA SE HA UNIDO A LA SALA
                call _sl_check_connection
                cp $01
                jr z, .loop_room_2_end

                ;jr .loop_room_2_end

                ld a, [aux_dist]
                ld [aux_close_dist], a
                ld a, [aux_room_id_02]
                ld [aux_close_room], a

                ld a, [aux_close_dist_x]
                ld d, a
                ld a, [aux_close_dist_y]
                cp d
                jr nc, .orientation_y
                    ld a, [aux_orient_x]
                    ld [aux_orientation], a
                    jr .loop_room_2_end
.orientation_y:
                ld a, [aux_orient_y]
                ld [aux_orientation], a

.loop_room_2_end:
            ld a, [aux_room_id_02]
            inc a
            ld [aux_room_id_02], a

            pop hl
            ld bc, entity_room_size
            add hl, bc

            pop af
            dec a
            jp nz, .loop_room_2
;;_________________________________________
    ;;COMPROBAMOS LA HABITACION MAS CERCANA
        ld a, [aux_close_room]
        cp $FF
        jr z, .loop_room_1_end

        call _sl_set_connection

        call _sl_add_exit_pair

        call _sl_create_corridor

.loop_room_1_end:       
        ld a, [aux_room_id_01]
        inc a
        ld [aux_room_id_01], a

        pop hl
        ld bc, entity_room_size
        add hl, bc

        pop af
        dec a
        jp nz, .loop_room_1

    ret


;;========================================================================================
;;                                     CORRIDOR VERT
;;----------------------------------------------------------------------------------------
;; Genera pasillo hasta que las x de los dos puntos de inicio coincidan
;;
;; INPUT:
;;  [aux_rx] [aux_ry]  -> Exit_1 X,Y. Se mueve hacia abajo
;;  [aux_rx2][aux_ry2] -> Exit_2 X,Y. Se mueve hacia arriba
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_corridor_vert:


;;========================================================================================
;;                                     CORRIDOR HOR
;;----------------------------------------------------------------------------------------
;; Genera pasillo hasta que las x de los dos puntos de inicio coincidan
;;
;; INPUT:
;;  [aux_rx] [aux_ry]  -> Exit_1 X,Y. Se mueve hacia la derecha
;;  [aux_rx2][aux_ry2] -> Exit_2 X,Y. Se mueve hacia la izquierda
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_corridor_hor:

    ;;Sacamos el puntero de Exit_1 del mapa
    ld a, [aux_rx]
    ld c, a
    ld a, [aux_ry]
    ld e, a
    ld b, $00
    ld d, $00
    ld hl, ml_map
    call _sl_get_tilemap_dir

    ld a, $14
    ld [hl], a

    ld b, h
    ld c, l
    ;BC -> Exit_1_map_ptr

    push bc
    ;;Sacamos el puntero de Exit_1 del mapa
    
    ld a, [aux_rx2]
    ld c, a
    ld a, [aux_ry2]
    ld e, a
    ld b, $00
    ld d, $00
    ld hl, ml_map
    call _sl_get_tilemap_dir

    ld a, $14
    ld [hl], a

    ld d, h
    ld e, l
    ;DE -> Exit_2_map_ptr
    pop bc
    
    push bc
    push de
    
    ;;Generamos el numero que indicará el camino elternativo de movimiento
    call _generate_random

    ld b, a
    ld a, %00000001
    and b
    ld [aux_generic_1], a

    pop de
    pop bc

.loop:

.check_bc:
    ;Commprobamos si RX y RX2 coinciden
    push bc
        ld a, [aux_rx]
        ld b, a
        ld a, [aux_rx2]
        xor b
        jr z, .loop_end
    pop bc

    ;Movemos RX
    ld h, b
    ld l, c
    inc hl
    ld a, [hl]
    cp $0C
    jr nz, .alt_rx

        ld a, [aux_rx]
        inc a
        ld [aux_rx], a

        ld a, $14
        ld [hl], a
        ld b, h
        ld c, l

    

.check_de: 
    ;Commprobamos si RX y RX2 coinciden
    push bc
        ld a, [aux_rx]
        ld b, a
        ld a, [aux_rx2]
        xor b
        jr z, .loop_end
    pop bc

    ;Movemos RX2
    ld h, d
    ld l, e
    dec hl
    ld a, [hl]
    cp $0C
    jr nz, .alt_rx2

        ld a, [aux_rx2]
        dec a
        ld [aux_rx2], a

        ld a, $14
        ld [hl], a
        ld d, h
        ld e, l

;Vuelta a empezar
    jr .loop

.loop_end:
    pop bc
    ret


.alt_rx:
    ld h, b
    ld l, c
    ret
    jr .check_de

.alt_rx2:
    ret
    jr .check_bc

;;========================================================================================
;;                                     CREATE CORRIDOR
;;----------------------------------------------------------------------------------------
;; Crea un pasillo para unir dos salas por sus salidas
;;
;; INPUT:
;;  [aux_rx]            -> Exit_1 X
;;  [aux_ry]            -> Exit_1 Y
;;  [aux_rx2]           -> Exit_2 X
;;  [aux_ry2]           -> Exit_2 Y
;;  [aux_orientation]   -> Orientacion inicial del pasillo
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_create_corridor:

    ld a, [aux_orientation]

;;TOP----------------------------------------------
.top:
    cp $00
    jr nz, .bottom
        ret

;;BOTTOM-------------------------------------------
.bottom:
    cp $01
    jr nz, .left
        ret
;;LEFT---------------------------------------------
.left:
    cp $02
    jr nz, .right

        ;;ALMACENAMOS RX, RY, RX2, RY2
        ld a, [aux_rx2]
        ld b, a
        ld a, [aux_ry2]
        ld c, a

        ld a, [aux_rx]
        ld d, a
        ld a, [aux_ry]
        ld e, a
        

        ;;REORGANIZAMOS RX, RY, RX2, RY2
        ld a, b
        ld [aux_rx], a
        ld a, c
        ld [aux_ry], a

        ld a, d
        ld [aux_rx2], a
        ld a, e
        ld [aux_ry2], a


        call _sl_corridor_hor
        ret

;;RIGHT--------------------------------------------
.right:
    cp $03
    jr nz, .none

        call _sl_corridor_hor
        ret

.none:

    ret


;;========================================================================================
;;                                     ADD EXIT PAIR
;;----------------------------------------------------------------------------------------
;; Comprueba si una habitacion ya se ha unido con otra
;;
;; INPUT:
;;  [aux_room_id_01]  -> Id de la habitacion origen 
;;  [aux_close_room]  -> Id de la habitacion destino
;;  [aux_orientation] -> Orientacion de la salida para la habitacion origen
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_add_exit_pair:

    ld hl, ml_room_array
    ld a, [aux_close_room]
    cp $00
    jr z, .loop_search_close_room_end
    ld bc, entity_room_size
.loop_search_close_room:
    add hl, bc
    dec a
    jr nz, .loop_search_close_room
.loop_search_close_room_end:

    ;;Guardamos los valores de Close_Room
    ldi a, [hl]
    ld [aux_rx2], a
    ldi a, [hl]
    ld [aux_ry2], a
    ldi a, [hl]
    ld [aux_rw2], a
    ldi a, [hl]
    ld [aux_rh2], a


    ld a, [aux_orientation]
;;TOP----------------------------------------------
.exit_top:
    cp $00
    jp nz, .exit_bottom

        ;;ROOM_01 exit
        xor a
        ld b, a
        ld a, [aux_rw]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld b, a
        ld a, [aux_rx]
        inc a
        add b
        ld [aux_debug_05], a
        ld b, a
        ld a, [aux_ry]
        ld c, a
        ld [aux_debug_06], a
        ;;BC -> exit X, Y
        ld a, [aux_room_id_01]
        call _ml_add_exit


        ld a, b
        ld [aux_rx], a
        ld a, c
        ld [aux_ry], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        
        ;;ROOM_02 exit
        xor a
        ld b, a
        ld a, [aux_rw2]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_01], a
        ld b, a
        ld a, [aux_rx2]
        inc a
        add b
        ld b, a
        ld [aux_debug_02], a
        ld a, [aux_ry2]
        ld c, a
        ld a, [aux_rh2]
        add c
        ld c, a
        ld [aux_debug_03], a
        
        ;;BC -> exit X, Y+H
        ld a, [aux_close_room]
        call _ml_add_exit

        ld a, b
        ld [aux_rx2], a
        ld a, c
        ld [aux_ry2], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        ret

;;BOTTOM--------------------------------------------
.exit_bottom:
    cp $01
    jp nz, .exit_left
        ;;ROOM_01 exit
        xor a
        ld b, a
        ld a, [aux_rw]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld b, a
        ld a, [aux_rx]
        inc a
        add b
        ld [aux_debug_05], a
        ld b, a
        ld a, [aux_ry]
        ld c, a
        ld a, [aux_rh]
        add c
        ld c, a 
        ld [aux_debug_06], a
        ;;BC -> exit X, Y
        ld a, [aux_room_id_01]
        call _ml_add_exit

        ld a, b
        ld [aux_rx], a
        ld a, c
        ld [aux_ry], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        ;;ROOM_02 exit
        xor a
        ld b, a
        ld a, [aux_rw2]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_01], a
        ld b, a
        ld a, [aux_rx2]
        inc a
        add b
        ld [aux_debug_02], a
        ld b, a
        ld a, [aux_ry2]
        ld c, a
        ld [aux_debug_03], a
        
        ;;BC -> exit X, Y+H
        ld a, [aux_close_room]
        call _ml_add_exit

        ld a, b
        ld [aux_rx2], a
        ld a, c
        ld [aux_ry2], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        ret


;;LEFT----------------------------------------------
.exit_left:
    cp $02
    jr nz, .exit_right

        ;;ROOM_01 exit
        xor a
        ld b, a
        ld a, [aux_rh]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld c, a
        ld a, [aux_ry]
        inc a
        add c
        ld c, a
        ld a, [aux_rx]
        ld b, a
        ;;BC -> exit X, Y
        ld a, [aux_room_id_01]
        call _ml_add_exit

        ld a, b
        ld [aux_rx], a
        ld a, c
        ld [aux_ry], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a


        ;;ROOM_02 exit
        xor a
        ld b, a
        ld a, [aux_rh2]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld c, a
        ld a, [aux_ry2]
        inc a
        add c
        ld c, a
        ld a, [aux_rx2]
        ld b, a
        ld a, [aux_rw2]
        add b
        ld b, a
        ;;BC -> exit X, Y
        ld a, [aux_close_room]
        call _ml_add_exit

        ld a, b
        ld [aux_rx2], a
        ld a, c
        ld [aux_ry2], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        ret

;;RIGHT---------------------------------------------
.exit_right:
    cp $03
    jr nz, .no_exit

        ;;ROOM_01 exit
        xor a
        ld b, a
        ld a, [aux_rh]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld c, a
        ld a, [aux_ry]
        inc a
        add c
        ld c, a
        ld a, [aux_rx]
        ld b, a
        ld a, [aux_rw]
        add b
        ld b, a 
        ;;BC -> exit X, Y
        ld a, [aux_room_id_01]
        call _ml_add_exit

        ld a, b
        ld [aux_rx], a
        ld a, c
        ld [aux_ry], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a


        ;;ROOM_02 exit
        xor a
        ld b, a
        ld a, [aux_rh2]
        sub $02
        ld c, a
        ld a, %00001111
        call _generate_random_min_max
        ld [aux_debug_04], a
        ld c, a
        ld a, [aux_ry2]
        inc a
        add c
        ld c, a
        ld a, [aux_rx2]
        ld b, a
        ;;BC -> exit X, Y
        ld a, [aux_close_room]
        call _ml_add_exit

        ld a, b
        ld [aux_rx2], a
        ld a, c
        ld [aux_ry2], a

        ld d, $00
        ld e, c
        ld c, b
        ld b, $00
        ld hl, ml_map
        call _sl_get_tilemap_dir

        ld a, $16
        ld [hl], a

        ret

.no_exit:


    ret


;;========================================================================================
;;                               CHECK EXIT NEIGHBOURS
;;----------------------------------------------------------------------------------------
;; Comprueba si una salida tiene un vecino adyacente, de tenerlo modifica la salida
;;
;; INPUT:
;;  BC -> Exit X,Y
;;  DE -> Neighbour X, Y
;;
;; OUTPUT:
;;  BC -> Exit X, Y modificado 
;;
;; DELETES: 
;;  AF, BC
;;
;;========================================================================================
_sl_check_exit_neighbours:

    ld a, b
    ld [aux_generic_1], a
    ld a, c
    ld [aux_generic_2], a

    ;;comprobar si D,E = (B-1),C
    ld a, b
    dec a

    xor d               ;;Da 0 si B-1 = D
    ld b, a                 
    ld a, c
    xor e               ;;Da 0 si C = E
    or b                ;;Da 0 si C = E && B-1 = D
    jr z, .exit_modify

    
    ;;comprobar si D,E = (B+1),C
    ld a, [aux_generic_2]
    ld c, a
    ld a, [aux_generic_1]
    inc a

    xor d               ;;Da 0 si B+1 = D
    ld b, a                 
    ld a, c
    xor e               ;;Da 0 si C = E
    or b                ;;Da 0 si C = E && B+1 = D
    jr z, .exit_modify


    ;;comprobar si D,E = B,(C-1)
    ld a, [aux_generic_1]
    ld b, a
    ld a, [aux_generic_2]
    dec a

    xor e               ;;Da 0 si C-1 = E
    ld c, a
    ld a, b
    xor d               ;;Da 0 si B = D
    or c                ;;Da 0 si C-1 = E && B = D
    jr z, .exit_modify


    ;;comprobar si D,E = B,(C+1)
    ld a, [aux_generic_1]
    ld b, a
    ld a, [aux_generic_2]
    inc a

    xor e               ;;Da 0 si C+1 = E
    ld c, a
    ld a, b
    xor d               ;;Da 0 si B = D
    or c                ;;Da 0 si C+1 = E && B = D
    jr z, .exit_modify


    ;;NO SE MODIFICA BC
    ld a, [aux_generic_1]
    ld b, a
    ld a, [aux_generic_2]
    ld c, a
    ret

.exit_modify:
    ld b, d
    ld c, e
    ret


;;========================================================================================
;;                                     SET_CONNECTION
;;----------------------------------------------------------------------------------------
;; Comprueba si una habitacion ya se ha unido con otra
;;
;; INPUT:
;;  [aux_room_id_01] -> Id de la habitacion origen 
;;  [aux_close_room] -> Id de la habitacion que se quiere conectar
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_set_connection:

    ld hl, ml_room_array
    ld a, [aux_room_id_01]
    cp $00
    jr z, .end_search_1
    ld de, entity_room_size
.search_room_1:
        add hl, de
        dec a
        jr nz, .search_room_1
.end_search_1:
    ;;HL -> Room_1 ptr
    ld de, ent_room_connections
    add hl, de
    ;;HL -> Room_1.connections ptr

    ld a, connection_num
.loop_01:
    push af

    ld a, [hl]
    cp $AA    
    jr z, .loop_01_end
    inc hl

    pop af
    dec a
    jr nz, .loop_01
    push af

.loop_01_end:

    pop af
    ld a, [aux_close_room]
    ld [hl], a


;;AHORA CON LA ROOM 2
    ld hl, ml_room_array
    ld a, [aux_close_room]
    cp $00
    jr z, .end_search_2
    ld de, entity_room_size
.search_room_2:
        add hl, de
        dec a
        jr nz, .search_room_2
.end_search_2:
    ;;HL -> Room_2 ptr
    ld de, ent_room_connections
    add hl, de
    ;;HL -> Room_2.connections ptr

    ld a, connection_num
.loop_02:
    push af

    ld a, [hl]
    cp $AA    
    jr z, .loop_02_end
    inc hl

    pop af
    dec a
    jr nz, .loop_02
    push af

.loop_02_end:

    pop af
    ld a, [aux_room_id_01]
    ld [hl], a

ret

;;========================================================================================
;;                                     CHECK_CONNECTION
;;----------------------------------------------------------------------------------------
;; Comprueba si una habitacion ya se ha unido con otra
;;
;; INPUT:
;;  [aux_room_id_01] -> Id de la habitacion origen 
;;  [aux_room_id_02] -> Id de la habitacion que se quiere unir
;;
;; OUTPUT:
;;  A  -> Indica si habia una conexion previa (0=no, 1=si)
;;
;; DELETES: 
;;  AF, DE, HL
;;
;;========================================================================================
_sl_check_connection:

    ld hl, ml_room_array
    ld a, [aux_room_id_01]
    cp $00
    jr z, .end_search_1
    ld de, entity_room_size
.search_room_1:
        add hl, de
        dec a
        jr nz, .search_room_1
.end_search_1:
    ;;HL -> Room_1 ptr
    
    ld de, ent_room_connections
    add hl, de
    ;;HL -> Room_1.connections ptr

    ld a, connection_num
.loop
    push af

    ld a, [aux_room_id_02]
    ld d, a

    ldi a, [hl]
    cp $AA
    jr z, .exit_good
    cp d
    jr z, .exit_bad

    pop af
    dec a
    jr nz, .loop
    push af

.exit_bad:
    pop af
    ld a, $01
    ret

.exit_good:
    pop af
    xor a
    ret




;;========================================================================================
;;                                     GENERATE ROOM
;;----------------------------------------------------------------------------------------
;; Genera una habitacion leyendo los valores de aux_(rx,ry,rw,rh)
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  A  -> Indica si ha podido generar la Habitacion (0=no, 1=si)
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_generate_room:

    ld a, [aux_rx]
    ld b, a
    ld a, [aux_ry]
    ld c, a
    ld a, [aux_rw]
    dec a
    ld d, a
    ld a, [aux_rh]
    dec a
    ld e, a

    push bc
    push de

    call _sp_check_room_collision

    ;db $18, $FE
    pop de
    pop bc


    cp $00  ;Comprueba si se puede generar la habitacion
    ret z


    push bc

    ;BC -> Room X, Y
    ;DE -> Room W, H 
    call _ml_new_room

    
    pop bc
    ld a, [aux_rw]
    ld d, a
    ld a, [aux_rh]
    ld e, a

    ld a, [aux_room_counter]    ;Debug
    call _sr_draw_room

    ld a, $01
    ret

;;========================================================================================
;;                                 GENERATE ROOM DATA
;;----------------------------------------------------------------------------------------
;; Genera una habitacion leyendo los valores de aux_(rx,ry,rw,rh)
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DELETES: 
;;  AF, DE
;;
;;========================================================================================
_sl_generate_room_data:

    ;;GENERAMOS ANCHO
.generate_width_num:            ;Min 5, max 8
    call _generate_random
    ld d, %00001111             ;Fuerza el valor de la salida al rango de 0 a 15
    and d
    cp $09                      ;Asegura que el maximo es 8
    jr nc, .generate_width_num
    cp $05                      ;Asegura que el minimo es 5
    jr c, .generate_width_num
    ld [aux_rw], a              ;Guardamos el valor del ancho de la habitacion

    ;;GENERAMOS ALTO
.generate_height_num:           ;Min 5, max 8
    call _generate_random
    ld d, %00001111             ;Fuerza el valor de la salida al rango de 0 a 15
    and d
    cp $09                      ;Asegura que el maximo es 8
    jr nc, .generate_height_num
    cp $05                      ;Asegura que el minimo es 5
    jr c, .generate_height_num
    ld [aux_rh], a              ;Guardamos el valor del alto de la habitacion

    

    ;;GENERAMOS COORD X
.generate_x_num:                ;Min 5, max (MAPW-rw-5) || MAPW = 40 = $28
    call _generate_random
    ld d, %00111111             ;Fuerza el valor de la salida al rango de 0 a 63
    and d
    cp $05                      ;Asegura que el minimo es 5
    jr c, .generate_x_num

    push af
    ld a, [aux_rw]
    ld d, a
    ld a, MAPW - $05
    sub d
    ld d, a 
    pop af

    cp d                        ;Asegura que el maximo es (MAPW-rw-5)
    jr nc, .generate_x_num

    ld [aux_rx], a              ;Guardamos el valor de coord_x de la habitacion



    ;;GENERAMOS COORD Y
.generate_y_num:                ;Min 4, max (MAPH-rh-4) || MAPH = 34 = $22
    call _generate_random
    ld d, %00111111             ;Fuerza el valor de la salida al rango de 0 a 63
    and d
    cp $04                      ;Asegura que el minimo es 4
    jr c, .generate_y_num

    push af
    ld a, [aux_rh]
    ld d, a
    ld a, MAPH - $04
    sub d
    ld d, a 
    pop af

    cp d                        ;Asegura que el maximo es (MAPH-rh-4)
    jr nc, .generate_y_num

    ld [aux_ry], a              ;Guardamos el valor de coord_y de la habitacion


    ; ld c, a
    ; ld a, [aux_rx]
    ; ld b, a
    ; ld a, [aux_rw]
    ; ld d, a
    ; ld a, [aux_rh]
    ; ld e, a

    ret



;;========================================================================================
;;                                     GET RANDOM EXIT
;;----------------------------------------------------------------------------------------
;; Devuelve las coordenadas de una salida dado el ID de una habitacion
;;
;; INPUT:
;;  A -> ID de la habitacion
;;
;; OUTPUT:
;;  BC -> Coordenadas de la salida
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_get_random_exit:

    ld hl, ml_room_array
    cp $00
    jr z, .end_loop

.loop:
    ld de, entity_room_size
    add hl, de
    dec a
    jr nz, .loop

.end_loop:
    ;;HL -> Room Pointer
    
    ld bc, ent_room_exit_num
    add hl, bc
    ldi a, [hl]
    ld b, a

    push hl

    call _generate_random

    pop hl                      ;HL -> Exit01 X 
    and %00000011
    cp b
    jr c, .no_correct_exit

        ld a, b
        dec a

.no_correct_exit:

    sla a
    ld b, $00
    ld c, a
    add hl, bc
    
    ldi a, [hl]
    ld b, a
    ld a, [hl]
    ld c, a

    ret



;;========================================================================================
;;                                     CHECK ROOM
;;----------------------------------------------------------------------------------------
;; Devuelve en que sala se encuentra una posicion dada. 
;; $80 significa que no esta en ninguna.
;;
;; INPUT:
;;  BC -> Posicion X,Y a comprobar
;;
;; OUTPUT:
;;  A -> ID de la habitación
;;
;; DELETES: 
;;  AF, BC, DE, HL
;;
;;========================================================================================
_sl_check_room:

    ld hl, ml_room_array
    ld a, [ml_room_num]
    cp $00
    jr z, .continue

.loop:
    push hl
    push af

    ldi a, [hl]
    ld d, a
    ld a, b
    cp d
    jr c, .no_inside
    ldi a, [hl]
    ld e, a
    ld a, c
    cp e
    jr c, .no_inside
    ldi a, [hl]
    add d
    cp b
    jr c, .no_inside
    ldi a, [hl]
    add e
    cp c
    jr c, .no_inside

    pop af
    ld a, [hl]
    pop hl
    ret

.no_inside:
    pop af
    pop hl
    ld de, entity_room_size 
    add hl, de
    dec a
    jr nz, .loop

.continue:

    ld a, $80
    ret



;;========================================================================================
;;                                     SPAWN ENEMIES
;;----------------------------------------------------------------------------------------
;; Crea a los enemigos en diferentes posiciones del mapa
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
_sl_spawn_enemies:


    ld hl, mp_enemy_array
    ld bc, enemy_positions

    ld a, [mp_enemy_num]
    cp $00
    jr z, .continue

.loop:
    push af
    push hl

    ld a, [bc]
    ld d, a
    ldi [hl], a
    inc bc
    ld a, [bc]
    ld e, a
    ldi [hl], a
    
    push bc

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

    ;call _jri

.end_y:

    pop bc

    pop hl
    ld de, entity_enemy_size
    add hl, de

    inc bc

    pop af
    dec a
    jr nz, .loop


.continue:


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

        call _sp_scroll_enemies ;; Realizamos el scroll del resto de playable_entity

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


    ;Guardamos la posicion inicial del jugador en el BGmap
    ld de, $010A
    add hl, de
    ld d, h
    ld e, l
    
    push de
    ld hl, ml_camera
    ld de, ec_player_bgmap_ptr_l
    add hl, de
    pop de

    ld a, e
    ldi [hl], a
    ld [hl], d


    pop hl
    push hl

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
;;  AF, DE, HL
;;
;;==============================================================================================
_sl_get_map_tile:
    ld hl, ml_map
    xor a
    ld d, a
    ld e, b 
    add hl, de
    ld a, c
    inc a
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