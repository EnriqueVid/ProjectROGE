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