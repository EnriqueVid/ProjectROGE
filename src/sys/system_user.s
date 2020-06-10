INCLUDE "src/sys/system_user.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_hud.h.s"
INCLUDE "src/ent/entity_item.h.s"


SECTION "SYS_USER_FUNCS", ROM0

;;==============================================================================================
;;                                    GRAB ITEM
;;----------------------------------------------------------------------------------------------
;; Recoge un objeto del suelo
;;
;; INPUT:
;;  DE -> Player X, Y
;;
;; OUTPUT:
;;  A -> Indica si se puede coger el objeto o no (0=no, 1=si)
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_grab_item:

    ld hl, ml_item_array
    ld a, [ml_item_num]

.loop:
    push af
    push hl

    inc hl
    ldi a, [hl]
    xor d
    ld b, a

    ld a, [hl]
    xor e
    or b

    cp $00
    jr z, .loop_end

    pop hl
    ld bc, entity_item_size
    add hl, bc

    pop af
    dec a
    jr nz, .loop
    ld a, $00
    ret

.loop_end:
    pop hl
    pop af

    ld a, [hl]
    cp $FF
    jr z, .add_money

    call _mi_add_item
    ret

    db $18, $FE

.add_money:

    ld bc, ei_quant
    add hl, bc
    ld b, $00
    ldi a, [hl]
    ld c, a
    ld d, [hl]

    call _mi_add_money

    ld a, $01

    ret


;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con todos los datos necesarios
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
_su_update_all_hud_data:

    ld bc, mg_hud

    ld hl, mp_player
    ld de, ep_mHP
    add hl, de

    ldi a, [hl]     ;A -> Player Max Health

    push bc         ; Sacamos el Max HP en decimal
    call _hex2dec
    pop bc

    ld a, d                 ;; Guardamos las centenas del Max HP
    ld [bc], a

    ld a, e                 ;; Guardamos las decenas del Max HP
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del Max HP
    and %00001111
    inc bc
    ld [bc], a


    ldi a, [hl]     ;A -> Player Max ManaPoints

    push bc         ; Sacamos el Max HP en decimal
    call _hex2dec
    pop bc

    ld a, e                 ;; Guardamos las decenas del Max MP
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del Max MP
    and %00001111
    inc bc
    ld [bc], a


    ;ahora cargamos el ataque del jugador
    ld hl, mg_hud
    ld bc, eh_atk_c
    add hl, bc
    ld b, h
    ld c, l

    ld hl, mp_player
    ld de, ep_cATK
    add hl, de

    ldi a, [hl]     ;A -> Player Attack

    push bc         ; Sacamos el Atk en decimal
    call _hex2dec
    pop bc

    ld a, d                 ;; Guardamos las centenas del Atk
    ld [bc], a

    ld a, e                 ;; Guardamos las decenas del Atk
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del Atk
    and %00001111
    inc bc
    ld [bc], a

    inc bc
    ldi a, [hl]

    push bc         ; Sacamos el Def en decimal
    call _hex2dec
    pop bc

    ld a, d                 ;; Guardamos las centenas del Def
    ld [bc], a

    ld a, e                 ;; Guardamos las decenas del Def
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del Def
    and %00001111
    inc bc
    ld [bc], a


    ld a, [mg_actual_level] ;; Sacamos el piso actual 

    push bc
    call _hex2dec
    pop bc

    ld a, e                 ;; Guardamos las decenas del Piso
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del Piso
    and %00001111
    inc bc
    ld [bc], a


    inc bc
    xor a
    ld [bc], a
    inc bc
    ld [bc], a
    inc bc
    ld a, 01
    ld [bc], a
    ;ld hl, [mp_player]
    ;ld de, ent_player_Lvl
    ;continua en la funcion de abajo


;;==============================================================================================
;;                                    UPDATE PLAYER HUD
;;----------------------------------------------------------------------------------------------
;; Actualiza el hud con los datos del jugador
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
_su_update_player_hud_data:

    ld hl, mg_hud
    ld bc, eh_c_hp_c
    add hl, bc
    ld b, h
    ld c, l


    ld hl, mp_player
    ld de, ep_cHP
    add hl, de
    
    ;db $18, $FE

    ldi a, [hl]

    push bc                 ;; Sacamos el HP en decimal
    call _hex2dec
    pop bc

    ld a, d                 ;; Guardamos las centenas del  HP
    ld [bc], a

    ld a, e                 ;; Guardamos las decenas del HP
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del HP
    and %00001111
    inc bc
    ld [bc], a


    ldi a, [hl]             ;; Sacamos el MP en decimal
    push bc
    call _hex2dec
    pop bc

    ld a, e                 ;; Guardamos las decenas del MP
    srl a
    srl a
    srl a
    srl a
    inc bc
    ld [bc], a

    ld a, e                 ;; Guardamos las unidades del MP
    and %00001111
    inc bc
    ld [bc], a


    



    ;db $18, $FE

    ret



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

    ld a, %11011111
    ld [$FF00], a

    ld a, [$FF00]           ;; Obtenemos los botones pulsados
    ld a, [$FF00]           ;; Obtenemos los botones pulsados
    ld [hl], a              ;; Bit 0 = A
                            ;; Bit 1 = B
                            ;; Bit 2 = Select
                            ;; Bit 3 = Start
    ret
    