INCLUDE "src/sys/system_combat.h.s"

SECTION "SYS_COMBAT_FUNCS", ROM0

;;==============================================================================================
;;                                    MANAGER PLAYABLE GAME LOOP
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_game
;;
;; INPUT:
;;  HL -> Entidad que realiza el ataque
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_sc_physical_attack:

    ret