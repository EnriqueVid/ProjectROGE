INCLUDE "src/sys/system_user.h.s"
INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_hud.h.s"
INCLUDE "src/ent/entity_item.h.s"
INCLUDE "src/ent/entity_player.h.s"

SECTION "SYS_USER_VARS", WRAM0


;;Variables auxiliares
aux_prev_input_x: ds $01    ;;
aux_prev_input_y: ds $01    ;;
aux_prev_input_btn: ds $01  ;;


SECTION "SYS_USER_FUNCS", ROM0



;;==============================================================================================
;;                                     UNEQUIP SHIELD
;;----------------------------------------------------------------------------------------------
;; Desequipa el escudo qeuipado
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
_su_unequip_shield:
    
    ld hl, mp_player
    ld de, ent_player_eq_S 
    add hl, de

    ld a, [hl]
    cp $FF
    ret z

    push hl

    ld hl, mi_player_items
    ld b, $00
    ld c, a
    add hl, bc

    ld a, [hl]
    ld b, a 

    pop hl          ;;HL -> Player Eq_S

    ld a, $FF
    ld [hl], a

    ld a, b         ;; A -> Item_ID

    jp _decrease_stats



;;==============================================================================================
;;                                     UNEQUIP WEAPON
;;----------------------------------------------------------------------------------------------
;; Desequipa el arma qeuipada
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
_su_unequip_weapon:
    
    ld hl, mp_player
    ld de, ent_player_eq_W 
    add hl, de

    ld a, [hl]
    cp $FF
    ret z

    push hl

    ld hl, mi_player_items
    ld b, $00
    ld c, a
    add hl, bc

    ld a, [hl]
    ld b, a 

    pop hl          ;;HL -> Player Eq_W

    ld a, $FF
    ld [hl], a

    ld a, b         ;; A -> Item_ID

    jp _decrease_stats




;;DECREMENTA LOS STATS DEL JUGADOR AL DESEQUIPAR UN ITEM
_decrease_stats:
    ;;Cargamos los datos del Items

    ;db $18, $FE

    ld hl, ent_item_index
    ld d, $00
    ld e, a
    sla e
    add hl, de
    ldi a, [hl]
    ld e, a
    ld d, [hl]
    ld h, d
    ld l, e

.ignore_text_loop_1:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_1

.ignore_text_loop_2:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_2

    inc hl
    ;;HL -> Item_ptr
    push hl

    ld hl, mp_player
    ld bc, ep_mHP
    add hl, bc

    ld d, h
    ld e, l
    ld a, [de]
    ld c, a

    ;;Quitamos HP
    pop hl
    ldi a, [hl]
    ld b, a
    ld a, c
    sub b
    ld [de], a

    push hl

    ld hl, mp_player
    ld bc, ep_cHP
    add hl, bc

    ld b, a
    ld a, [hl]
    cp b
    jr c, .no_corregir_HP
    
        ld a, b
        ld [hl], a
    ;db $18, $FE

.no_corregir_HP:
    pop hl
    

    ;;Quitamos MP
    inc de
    ld a, [de]
    ld c, a
    ldi a, [hl]
    ld b, a
    ld a, c
    sub b
    ld [de], a
    push hl

    ld hl, mp_player
    ld bc, ep_cMP
    add hl, bc

    ld b, a
    ld a, [hl]
    cp b
    jr c, .no_corregir_MP
    
        ld a, b
        ld [hl], a
    ;db $18, $FE

.no_corregir_MP:

    ;;Quitamos Atk
    ld hl, mp_player
    ld bc, ep_cATK
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    ld c, a

    pop hl
    ldi a, [hl]
    ld b, a
    ld a, c
    sub b
    ;db $18,$FE
    ld [de], a

    ;;Quitamos Def
    inc de
    ld a, [de]
    ld c, a
    ld a, [hl]
    ld b, a
    ld a, c
    sub b
    ld [de], a

    call _su_update_all_hud_data
    call _sr_update_draw_player_hud

    ret


;;==============================================================================================
;;                                     UNEQUIP ITEM
;;----------------------------------------------------------------------------------------------
;; Desequipa el objeto seleccionado
;;
;; INPUT:
;;  C -> Item position
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_unequip_item:

    ld hl, mp_player
    ld de, ent_player_eq_W 
    add hl, de

    ldi a, [hl]
    cp c
    jr nz, .check_shield
         
        call _su_unequip_weapon
        ret

.check_shield:
    ld a, [hl]
    cp c
    ret nz
        
        call _su_unequip_shield
        ret





;;==============================================================================================
;;                                     EQUIP ITEM
;;----------------------------------------------------------------------------------------------
;; Equipa el objeto seleccionado, desequipa el objeto equiado anterior
;;
;; INPUT:
;;  C -> Item position
;;  HL-> Item_ptr
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_equip_item:

    ld a, [hl]
    push af


    ld hl, ent_item_index
    ld d, $00
    ld e, a
    sla e
    add hl, de
    ldi a, [hl]
    ld e, a
    ld d, [hl]
    ld h, d
    ld l, e

.ignore_text_loop_1:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_1

.ignore_text_loop_2:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_2

    pop af
    cp $0A
    jr nc, .es_escudo
    ;;EQUIPAR ARMAS----------------------------------------------

        push hl

        ld hl, mp_player
        ld de, ent_player_eq_W 
        add hl, de
        ld a, [hl]
        cp $FF
        jr z, .no_unequip_weapon

            push bc
            push hl
            call _su_unequip_weapon
            pop hl
            pop bc

.no_unequip_weapon:
        ld a, c
        ld [hl], a

        jr .add_stats


.es_escudo:
    ;;EQUIPAR ESCUDOS--------------------------------------------
        push hl

        ld hl, mp_player
        ld de, ent_player_eq_S 
        add hl, de
        ld a, [hl]
        cp $FF
        jr z, .no_unequip_shield

            push bc
            push hl
            call _su_unequip_shield
            pop hl
            pop bc

.no_unequip_shield:
        ld a, c
        ld [hl], a


.add_stats:
    
    ld hl, mp_player
    ld bc, ep_mHP
    add hl, bc

    ld d, h
    ld e, l
    ld a, [de]
    ld c, a

    ;;Anadimos HP
    pop hl
    inc hl
    ldi a, [hl]
    add c
    ld [de], a
    

    ;;Anadimos MP
    inc de
    ld a, [de]
    ld c, a
    ldi a, [hl]
    add c
    ld [de], a
    push hl

    ;;Anadimos Atk
    ld hl, mp_player
    ld bc, ep_cATK
    add hl, bc
    ld d, h
    ld e, l
    ld a, [de]
    ld c, a

    pop hl
    ldi a, [hl]
    add c
    ;db $18,$FE
    ld [de], a

    ;;Anadimos Def
    inc de
    ld a, [de]
    ld c, a
    ld a, [hl]
    add c
    ld [de], a

    call _su_update_all_hud_data
    call _sr_update_draw_player_hud

    ret


;;==============================================================================================
;;                                     USE ITEM
;;----------------------------------------------------------------------------------------------
;; Usa el objeto seleccionado
;;
;; INPUT:
;;   C -> Item position
;;  HL -> Item_ptr
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_use_item:

    push hl
    push bc

    ld a, [hl]
    push af


    ld hl, ent_item_index
    ld b, $00
    ld c, a
    sla c
    add hl, bc
    ldi a, [hl]
    ld c, a
    ld b, [hl]
    ld h, b
    ld l, c

.ignore_text_loop_1:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_1

.ignore_text_loop_2:
    ldi a, [hl]
    cp "/"
    jr nz, .ignore_text_loop_2


    ;;Comprobamos si es magia o consumible
    pop af
    cp $28
    jr nc, .es_consumible
    ;;OBJETOS MAGICOS---------------------------------------------------

        pop bc
        pop hl

        ret

.es_consumible:
    ;;OBJETOS CONSUMIBLES-----------------------------------------------

        push hl

        ;;Añadimos HP__________________________
        ld hl, mp_player
        ld bc, ep_cHP
        add hl, bc

        ld d, h
        ld e, l
        ld a, [de]
        ld b, a

        pop hl
        inc hl
        ldi a, [hl]
        add b
        ld [de], a

        push hl

        ;;Comprobamos el overflow del HP
        ld hl, mp_player
        ld bc, ep_mHP
        add hl, bc

        ld b, a
        ;ld b, $10
        ld a, [hl]
        sub b
        ;db $18, $FE
        jr nc, .no_corregir_HP
            ld  a, [hl]
            ld [de], a

.no_corregir_HP:

        ;;Añadimos MP______________________________
        ld hl, mp_player
        ld bc, ep_cMP
        add hl, bc

        ld d, h
        ld e, l
        ld a, [de]
        ld b, a

        pop hl
        ldi a, [hl]
        add b
        ld [de], a

        push hl

    ;;Comprobamos el overflow del MP
        ld hl, mp_player
        ld bc, ep_mMP
        add hl, bc

        ld b, a
        ;ld b, $10
        ld a, [hl]
        sub b
        ;db $18, $FE
        jr nc, .no_corregir_MP
            ld  a, [hl]
            ld [de], a

.no_corregir_MP:

        ;;Modificamos los STATS______________________________    
        ld hl, mp_player
        ld bc, ep_cSTAT
        add hl, bc

        ld d, h
        ld e, l
        ld a, [de]
        ld b, a

        pop hl

        ld a, [hl]
        and b
        ld [de], a

        pop bc
        ld hl, mp_player
        ld de, ent_player_eq_W 
        add hl, de
        ld a, [hl]
        cp $FF
        jr z, .no_corregir_eq_w
        cp c
        jr c, .no_corregir_eq_w
            dec a
            ld [hl], a
.no_corregir_eq_w:
        inc hl
        ld a, [hl]
        cp $FF
        jr z, .no_corregir_eq_s
        cp c
        jr c, .no_corregir_eq_s
            dec a
            ld [hl], a
.no_corregir_eq_s:

        pop hl

        call _mi_delete_player_item

        call _su_update_all_hud_data
        call _sr_update_draw_player_hud

        ret



;;==============================================================================================
;;                                     DELETE ITEM
;;----------------------------------------------------------------------------------------------
;; Usa el objeto seleccionado
;;
;; INPUT:
;;   C -> Item position
;;  HL -> Item_ptr
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_delete_item:
    push hl

    ld hl, mp_player
    ld de, ent_player_eq_W 
    add hl, de
    ldi a, [hl]
    cp c
    jr z, .esta_equipado
    ld a, [hl]
    cp c
    jr nz, .no_esta_equipado

.esta_equipado:
        push bc
        call _su_unequip_item
        pop bc
        ;jr .no_corregir_eq_s

.no_esta_equipado:
    ld hl, mp_player
    ld de, ent_player_eq_W 
    add hl, de
    ld a, [hl]
    cp $FF
    jr z, .no_corregir_eq_w
    cp c
    jr c, .no_corregir_eq_w
        dec a
        ld [hl], a
.no_corregir_eq_w:
    inc hl
    ld a, [hl]
    cp $FF
    jr z, .no_corregir_eq_s
    cp c
    jr c, .no_corregir_eq_s
        dec a
        ld [hl], a
.no_corregir_eq_s:

    pop hl

    call _mi_delete_player_item

    call _su_update_all_hud_data
    call _sr_update_draw_player_hud

    ret


;;==============================================================================================
;;                                    ITEM ACTION
;;----------------------------------------------------------------------------------------------
;; Gestiona que accion se realiza sobre un objeto
;;
;; INPUT:
;;  A -> Accion a realizar
;;  C -> Posicion del item en el vextor de objetos
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_su_item_action:

    ld hl, mi_player_items
    ld b, $00
    add hl, bc
    ;;HL -> Ptr al Item ID
    ;; A -> Accion a realizar

.check_use:
    cp $00
    jr nz, .check_equip
        call _su_use_item
        ret

.check_equip:
    cp $01
    jr nz, .check_asign
        call _su_equip_item
        ret

.check_delete:
    cp $02
    jr nz, .check_unequip
        call _su_delete_item
        ret

.check_asign:
    cp $03
    jr nz, .check_delete


.check_unequip:
    cp $05
    jr nz, .end
        call _su_unequip_item
        ret

.end:

    db $18, $FE

    ret

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
;;                                    SYSTEM MENU INPUT INIT
;;----------------------------------------------------------------------------------------------
;; Actualiza el valor del input que realiza el jugador
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  A -> Resultado del input
;;
;; DESTROYS:
;;  AF, BC
;;
;;==============================================================================================
_su_menu_input_init:

    ld a, $FF
    ld [aux_prev_input_x],   a
    ld [aux_prev_input_y],   a
    ld [aux_prev_input_btn], a

    ret

;;==============================================================================================
;;                                    SYSTEM MENU INPUT
;;----------------------------------------------------------------------------------------------
;; Actualiza el valor del input que realiza el jugador para los menus
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  A -> Resultado del input
;;
;; DESTROYS:
;;  AF, BC
;;
;;==============================================================================================
_su_menu_input:

    call _su_input

    ;Datos de las pulsaciones de los botones (x, y, btn)
    ;A, B, Select, Start (0,1,2,3)
    ld hl, mg_input_data

    ldi a, [hl]
    cp $00
    jr z, .check_vert

        cp $01              ;;Comprobamos el input en el eje X
        jr nz, .check_left
        ;;PULSA DERECHA
        xor a
        ld [aux_prev_input_btn], a
        ld [aux_prev_input_y], a

        ld a, [aux_prev_input_x]
        cp $01
        jp z, .end_action

        ld a, $01
        ld [aux_prev_input_x], a

        ld a, $01
        ret


.check_left:
        ;;PULSA IZQUIERDA
        xor a
        ld [aux_prev_input_btn], a
        ld [aux_prev_input_y], a

        ld a, [aux_prev_input_x]
        cp $FF
        jp z, .end_action

        ld a, $FF
        ld [aux_prev_input_x], a

        ld a, $02
        ret

.check_vert:
    xor a
    ld [aux_prev_input_x], a
    ldi a, [hl]
    cp $00
    jr z, .check_btn

        cp $01
        jr nz, .check_up
        ;;PULSA ABAJO
        xor a
        ld [aux_prev_input_btn], a

        ld a, [aux_prev_input_y]
        cp $01
        jr z, .end_action

        ld a, $01
        ld [aux_prev_input_y], a

        ld a, $03
        ret

.check_up:
        ;;PULSA ARRIBA
        xor a
        ld [aux_prev_input_btn], a

        ld a, [aux_prev_input_y]
        cp $FF
        jr z, .end_action

        ld a, $FF
        ld [aux_prev_input_y], a

        ld a, $04
        ret

.check_btn:
    xor a
    ld [aux_prev_input_y], a

    ld a, [hl]
    cp $DF
    jr z, .no_input

.check_a:        
        bit 0, a
        jr nz, .check_b
        ;;PULSA A
        ld a, [aux_prev_input_btn] 
        bit 0, a
        jr nz, .end_action          ;Si prev de btn_A, es 0, continua

        ld a, %00000001
        ld [aux_prev_input_btn], a

        ld a, $05
        ret

.check_b:
        bit 1, a
        jr nz, .check_select
        ;;PULSA B
        ld a, [aux_prev_input_btn] 
        bit 1, a
        jr nz, .end_action          ;Si prev de btn_B, es 0, continua
        
        ld a, %00000010
        ld [aux_prev_input_btn], a

        ld a, $06
        ret

.check_select:
        bit 2, a
        jr nz, .check_start
        ;;PULSA START
        ld a, [aux_prev_input_btn] 
        bit 2, a
        jr nz, .end_action          ;Si prev de btn_start, es 0, continua
        
        ld a, %00000100
        ld [aux_prev_input_btn], a

        ld a, $07
        ret

.check_start:
        bit 3, a
        jr nz, .no_input
        ;;PULSA SELECT
        ld a, [aux_prev_input_btn] 
        bit 3, a
        jr nz, .end_action          ;Si prev de btn_select, es 0, continua
        
        ld a, %00001000
        ld [aux_prev_input_btn], a

        ld a, $08
        ret

.no_input:
    xor a
    ld [aux_prev_input_btn], a

.end_action:
    xor a
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
    