m_define_entity_item: MACRO

    ds $01              ;; Item ID
    ds $10              ;; Descripcion de 16 Caracteres

    ds $01              ;; Item HP
    ds $01              ;; Item MP
    ds $01              ;; Item ATK
    ds $01              ;; Item DEF

ENDM

ei_id   = 0
ei_desc = 1
ei_HP   = 17
ei_MP   = 18
ei_ATK  = 19
ei_DEF  = 20

entity_item_sie = 21