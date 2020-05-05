IF DEF (m_define_entity_item)

ELSE
m_define_entity_item: MACRO

    ds $01              ;; Item ID
    ds $01              ;; Item X
    ds $01              ;; Item Y
    ds $01              ;; Sprite ID
    ds $02              ;; Item Quantity

ENDM

ENDC

ei_id    = 0
ei_x     = 1
ei_y     = 2
ei_quant = 3

entity_item_sie = 5