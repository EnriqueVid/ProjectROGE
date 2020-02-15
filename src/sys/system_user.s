INCLUDE "src/sys/system_user.h.s"


SECTION "SYS_USER_FUNCS", ROM0

;;==============================================================================================
;;                                    SYSTEM USER INPUT
;;----------------------------------------------------------------------------------------------
;; Actualiza el valor del input que realiza el jugador
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC
;;
;;==============================================================================================
_su_input:

    xor a
	ld b, $0
	ld c, $0

    ld a, %11101111         ;; Comprobar D-Pad
    ld [$FF00], a

    ld a, [$FF00]           ;; Obtenemos el dpad
    ld a, [$FF00]           ;; Obtenemos el dpad

	bit 0, a
	jr nz, .check_move_left
		inc b

.check_move_left:
	bit 1, a
	jr nz, .check_move_up
		dec b

.check_move_up:
	bit 2, a
	jr nz, .check_move_down
		dec c

.check_move_down:
	bit 3, a
	jr nz, .end_check_move
		inc c

.end_check_move:

    ld hl, mg_input_data
    ld a, b
    ldi [hl], a
    ld a, c
    ldi [hl], a



    ld a, %11011111
    ld [$FF00], a

    ld a, [$FF00]           ;; Obtenemos los botones pulsados
    ld a, [$FF00]           ;; Obtenemos los botones pulsados
    ld [hl], a              ;; Bit 0 = A
                            ;; Bit 1 = B
                            ;; Bit 2 = Select
                            ;; Bit 3 = Start
    ret
    