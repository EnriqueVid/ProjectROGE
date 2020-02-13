INCLUDE "src/man/manager_level.h.s"
INCLUDE "src/ent/entity_camera.h.s"
INCLUDE "src/ent/entity_map.h.s"


SECTION "MAN_LEVEL_VARS", WRAM0

ml_camera:
    m_define_entity_camera

ml_map:
    m_define_entity_map




SECTION "MAN_LEVEL_FUNCS", ROM0

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

    ld hl, ml_map                ;; Destino
    ld de, ent_map_01            ;; Origen
    ld bc, entity_map_size       ;; Cantidad
    call _ldir

    ret