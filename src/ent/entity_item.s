INCLUDE "src/ent/entity_item.h.s"

SECTION "ENT_ITEM_DATA", ROMX

    
ent_item_index::                
    dw item_copper_sword_data   ;;ID = 0

item_copper_sword_data:     
    db "c.sword_"               ;;ITEM NAME (8 chars)
    db "----------------"       ;;ITEM DESC (16 chars)
    db $01                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $01                      ;;ITEM ATTACK
    db $01                      ;;ITEM DEFFENSE
    db $01                      ;;ITEM HEALTH
    db $01                      ;;ITEM MP