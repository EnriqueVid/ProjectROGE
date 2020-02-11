INCLUDE "src/man/manager_game.h.s"
INCLUDE "src/man/manager_playable.h.s"
INCLUDE "src/man/manager_level.h.s"


SECTION "MAN_GAME_VARS", WRAM0

mg_actual_level: ds $01     ;;Nivel de juego actual
mg_input_data: ds $02       ;;Datos de las pulsaciones de los botones




SECTION "MAN_GAME_FUNCS", ROM0

;;==============================================================================================
;;                                    MANAGER PLAYABLE INIT
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_game
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
_mg_init:

    call _mp_init
    call _ml_init

    xor a
    ld [mg_actual_level], a
    ld [mg_input_data], a
    ld [mg_input_data + 1], a

    ret