INCLUDE "src/sys/system_IA.h.s"


SECTION "SYS_IA_VARS", WRAM0




SECTION "SYS_IA_FUNCS", ROM0


;;==============================================================================================
;;                                    RESPAWN ENEMY
;;----------------------------------------------------------------------------------------------
;; Genera un enemigo en el nivel en una posicion valida a una distancia del jugador
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
_si_respawn_enemy:

    

    ret