INCLUDE "src/ent/entity_camera.h.s"
INCLUDE "src/man/manager_level.h.s"
INCLUDE "src/ent/entity_map.h.s"
INCLUDE "src/ent/entity_room.h.s"
INCLUDE "src/ent/entity_item.h.s"


SECTION "MAN_LEVEL_VARS", WRAM0

ml_camera:
    m_define_entity_camera

ml_room_num: ds $01

ml_room_next_l: ds $01
ml_room_next_h: ds $01

ml_room_array:
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room
    m_define_entity_room

ml_item_num: ds $01

ml_item_next_l: ds $01
ml_item_next_h: ds $01

ml_item_array:
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item
    m_define_entity_item

ml_map:
    m_define_entity_map




SECTION "MAN_LEVEL_FUNCS", ROM0






;;==============================================================================================
;;                                          NEW ITEM
;;----------------------------------------------------------------------------------------------
;; Anade una item al mapa
;;
;; INPUT:
;;  A  -> Item ID
;;  BC -> Item X, Y
;;  DE -> Quantity
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_ml_new_item:

    push af
    ld a, [ml_item_num]
    cp $0A
    jr z, .end


    ld a, [ml_item_next_h]
    ld h, a
    ld a, [ml_item_next_l]
    ld l, a

    ;;HL -> Entity Item ID
    pop af

    ldi [hl], a
    push hl
    push af
    ;;HL -> Entity Item X
    ld [hl], b
    inc hl
    ;;HL -> Entity Item Y
    ld [hl], c
    inc hl

    pop af
.check_money:
    cp $FF  ;;Comprobamos si es Dinero
    jr nz, .check_sword
        ld a, $17
        ldi [hl], a             ;; HL -> Entity Item Sprite
        jr .end_check

.check_sword:
    cp 10  ;;Comprobamos si es una Espada
    jr nc, .check_shield
        ld a, $18
        ldi [hl], a             ;; HL -> Entity Item Sprite
        jr .end_check

.check_shield:
    cp 20  ;;Comprobamos si es un Escudo
    jr nc, .check_magic
        ld a, $19
        ldi [hl], a             ;; HL -> Entity Item Sprite
        jr .end_check

.check_magic:
    cp 40  ;;Comprobamos si es una Magia
    jr nc, .check_HP
        ld a, $1A
        ldi [hl], a             ;; HL -> Entity Item Sprite
        jr .end_check

.check_HP:
    cp 50  ;;Comprobamos si es un objeto de curacion de HP
    jr nc, .end_check
        ld a, $1B
        ldi [hl], a             ;; HL -> Entity Item Sprite
        jr .end_check

.end_check:
    
    ld [hl], d
    inc hl
    ld [hl], e
    inc hl
    
    ld a, [ml_item_num]
    inc a
    ld [ml_item_num], a

    ld a, h
    ld [ml_item_next_h], a
    ld a, l
    ld [ml_item_next_l], a

    pop hl
    ld c, [hl]
    inc hl
    ld e, [hl]
    ld b, $00
    ld d, $00
    inc hl
    ld a, [hl]
    push af

    ld hl, ml_map
    call _sl_get_tilemap_dir
    pop af
    ld [hl], a

    push af
.end:
    pop af
    ret


;;==============================================================================================
;;                                          ADD EXIT
;;----------------------------------------------------------------------------------------------
;; Anade una salida a la habitacion
;;
;; INPUT:
;;   A -> Room ID
;;  BC -> Exit X, Y
;;
;; OUTPUT:
;;  BC -> Exit X, Y final
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_ml_add_exit:
    
    ld hl, ml_room_array
    cp $00
    jr z, .end_loop

    ld de, entity_room_size
.loop:
    add hl, de
    dec a
    jr nz, .loop

.end_loop:

    ;HL -> Puntero a la Habitacion 
    ld de, ent_room_exit_num
    add hl, de
    ld a, [hl]
    cp max_exits
    ret z
    ;;HL -> ent_room_exit_num

    push af
    inc a
    ldi [hl], a
    pop af


    ;;A  -> numero de salidas
    ;;HL -> ent_room_exit_01
    cp $00
    jr z, .loop_2_end
.loop_2:
    push af

        ldi a, [hl]
        ld d, a
        ldi a, [hl]
        ld e, a

        call _sl_check_exit_neighbours

    pop af
    dec a
    jr nz, .loop_2

.loop_2_end:
    
    ;;HL -> Salida[A].x
    ld a, b
    ldi [hl], a
    ld a, c
    ldi [hl], a

    ;db $18, $fe

    ret



;;==============================================================================================
;;                                          NEW ROOM
;;----------------------------------------------------------------------------------------------
;; Guarda el puntero especificado
;;
;; INPUT:
;;  BC -> Room X, Y
;;  DE -> Room W, H 
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF
;;
;;==============================================================================================
_ml_new_room:
    push bc
    ld hl, ml_room_array
    ld bc, entity_room_size
    ld a, [ml_room_num]
    cp $00
    jr z, .continue
.loop:
    add hl, bc
    dec a
    jr nz, .loop
.continue:

    pop bc
    ld a, b
    ldi [hl], a ;;ROOM X
    ld a, c
    ldi [hl], a ;;ROOM Y
    ld a, d 
    ldi [hl], a ;;ROOM W
    ld a, e
    ldi [hl], a ;;ROOM H

    ;;HL -> ROOM ID
    
    ld a, [ml_room_num]
    ldi [hl], a  ;;ROOM ID = ml_room_num
    inc a
    ld [ml_room_num], a

    ld a, h
    ld [ml_room_next_h], a
    ld a, l
    ld [ml_room_next_l], a

    ld a, $09
.loop2:
    push af
    xor a
    ldi [hl], a
    pop af
    dec a
    jr nz, .loop2
    
    ld a, $05
.loop3:
    push af
    ld a, $AA
    ldi [hl], a
    pop af
    dec a
    jr nz, .loop3

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
_ml_save_bgmap_tr:
    ld a, h
    ld [ec_bgmap_prt_TR_H], a
    ld a, l
    ld [ec_bgmap_prt_TR_L], a
    ret

_ml_save_bgmap_tl:
    ld a, h
    ld [ec_bgmap_prt_TL_H], a
    ld a, l
    ld [ec_bgmap_prt_TL_L], a
    ret

_ml_save_bgmap_bl:
    ld a, h
    ld [ec_bgmap_prt_BL_H], a
    ld a, l
    ld [ec_bgmap_prt_BL_L], a
    ret

_ml_save_player_bgmap:
    ld a, h
    ld [ec_player_bgmap_prt_H], a
    ld a, l
    ld [ec_player_bgmap_prt_L], a
    ret


_ml_save_tilemap:
    ld a, h
    ld [ec_tilemap_ptr_H], a
    ld a, l
    ld [ec_tilemap_ptr_L], a
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
_ml_load_bgmap_tr:
    ld a, [ec_bgmap_prt_TR_H]
    ld h, a
    ld a, [ec_bgmap_prt_TR_L]
    ld l, a
    ret

_ml_load_bgmap_tl:
    ld a, [ec_bgmap_prt_TL_H]
    ld h, a
    ld a, [ec_bgmap_prt_TL_L]
    ld l, a
    ret

_ml_load_bgmap_bl:
    ld a, [ec_bgmap_prt_BL_H]
    ld h, a
    ld a, [ec_bgmap_prt_BL_L]
    ld l, a
    ret

_ml_load_player_bgmap:
    ld a, [ec_player_bgmap_prt_H]
    ld h, a
    ld a, [ec_player_bgmap_prt_L]
    ld l, a
    ret

_ml_load_tilemap:
    ld a, [ec_tilemap_ptr_H]
    ld h, a
    ld a, [ec_tilemap_ptr_L]
    ld l, a
    ret






;;==============================================================================================
;;                                    MANAGER LEVEL INIT
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_level
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
_ml_init:

    ld hl, ml_camera             ;; Destino
    ld de, ent_camera_default    ;; Origen
    ld bc, entity_camera_size    ;; Cantidad
    call _ldir

    
    ;ld hl, level_index
    ;ld a, [mg_actual_level]
    ;sla a
    ;ld de, $0000
    ;ld e, a
    ;add hl, de

    ;ldi a, [hl]
    ;ld e, a
    ;ld a, [hl]
    ;ld d, a

    ld de, ent_map_01            ;; Origen
    ;db $18, $FE

    ld hl, ml_map                ;; Destino
    ld bc, entity_map_size       ;; Cantidad
    call _ldir

    xor a
    ld [ml_room_num], a
    ld [ml_item_num], a

    ld hl, ml_room_array
    ld a, h
    ld [ml_room_next_h], a
    ld a, l
    ld [ml_room_next_l], a

    ld hl, ml_item_array
    ld a, h
    ld [ml_item_next_h], a
    ld a, l
    ld [ml_item_next_l], a

    ret