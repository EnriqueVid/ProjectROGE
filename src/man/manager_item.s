INCLUDE "src/man/manager_item.h.s"

SECTION "MAN_ITEM_VARS", WRAM0
mi_gold:         ds 3

mi_player_item_num: ds $01
mi_player_next_item_h: ds $01
mi_player_next_item_l: ds $01
mi_player_items: ds 21

mi_stored_item_num: ds $01
mi_stored_next_item_h: ds $01
mi_stored_next_item_l: ds $01
mi_stored_items: ds 201

MAX_PLAYER_ITEMS = 20
MAX_STORED_ITEMS = 200


SECTION "MAN_ITEM_FUNCS", ROM0

;;==============================================================================================
;;                                    MANAGER ITEM DELETE PLAYER ITEM
;;----------------------------------------------------------------------------------------------
;; Elimina un Item del inventario del jugador
;;
;; INPUT:
;;  HL -> Puntero al Item
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mi_delete_player_item:

    ld b, h
    ld c, l
    
    inc hl

.loop:

    ldi a, [hl]

    ld [bc], a
    inc bc

    cp $32 ;;32h = 50d -> Item Default
    jr nz, .loop

    ld a, [mi_player_next_item_h]
    ld h, a
    ld a, [mi_player_next_item_l]
    ld l, a
    dec hl
    ld a, h
    ld [mi_player_next_item_h], a
    ld a, l
    ld [mi_player_next_item_l], a

    ret 



;;==============================================================================================
;;                                    MANAGER ITEM ADD ITEM
;;----------------------------------------------------------------------------------------------
;; Anade un Item al inventario del jugador
;;
;; INPUT:
;;  A -> ID del item
;;
;; OUTPUT:
;;  A -> Indica si se ha podido guardar el item (0=no, 1=si)
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mi_add_item:
    push af
    ld a, [mi_player_item_num]
    cp MAX_PLAYER_ITEMS
    jr z, .full

    inc a
    ld [mi_player_item_num], a

    ld a, [mi_player_next_item_h]
    ld h, a
    ld a, [mi_player_next_item_l]
    ld l, a

    pop af
    ldi [hl], a

    ld a, h
    ld [mi_player_next_item_h], a
    ld a, l
    ld [mi_player_next_item_l], a

    ld a, $01
    ret
    
.full:
    pop af
    xor a
    ret
    
    


;;==============================================================================================
;;                                    MANAGER ITEM ADD MONEY
;;----------------------------------------------------------------------------------------------
;; Anade dinero mediante daa. Si no se usa un formato daa puede no funcionar correctamente.
;; Cada Nibble del input hace referencia a una unidad diferente
;; Por ejemplo 980 532 (base decimal) seria: 
;;  B -> 98
;;  C -> 05
;;  D -> 32
;;
;; INPUT:
;;  B -> Centenas de Millar, Decenas de Millar (Cm, Dm)
;;  C -> Unidades de Millar, Centenas (Um, C)
;;  D -> Decenas, Unidades (D,U)
;;
;; OUTPUT:
;;  NONE
;;
;; DESTROYS:
;;  AF, BC, DE, HL
;;
;;==============================================================================================
_mi_add_money:

    ld hl, mi_gold
    inc hl
    inc hl
    
    ld a, [hl]
    add d
    daa
    ld [hl], a
    ld e, $00
    jr nc, .continue_c1
    ld e, $01

.continue_c1:
    ;db $18, $FE
    dec hl
    ld a, [hl]
    add e
    daa
    ld e, $00
    jr nc, .continue_c2
    ld e, $01
.continue_c2:
    add c
    daa
    ld [hl], a
    jr nc, .continue_b
    ld e, $01

.continue_b:
    dec hl
    ld a, [hl]
    add e
    daa
    jr c, .its_over_999999
    add b
    daa
    ld [hl], a
    ret nc

.its_over_999999:
    ld a, $99
    ldi [hl], a 
    ldi [hl], a 
    ld [hl], a 
    ret


    



;;==============================================================================================
;;                                    MANAGER ITEM INIT
;;----------------------------------------------------------------------------------------------
;; Inicializa el valor de las variables contenidas en manager_item
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
_mi_init:

    xor a
    ld hl, mi_gold
    ldi [hl], a
    ldi [hl], a
    ld  [hl], a

    ld [mi_player_item_num], a
    ld [mi_stored_item_num], a

    ld hl, mi_player_items
    ld a, h
    ld [mi_player_next_item_h], a
    ld a, l
    ld [mi_player_next_item_l], a

    ; HL -> DESTINO
    ; BC -> CANTIDAD
    ld bc, 21 
    ld  a, 50
    call _clear_data_custom

    ld hl, mi_stored_items
    ld a, h
    ld [mi_stored_next_item_h], a
    ld a, l
    ld [mi_stored_next_item_l], a

    ; HL -> DESTINO
    ; BC -> CANTIDAD
    ld bc, 200
    ld  a, 50
    call _clear_data_custom

    
    

    ret