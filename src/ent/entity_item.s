INCLUDE "src/ent/entity_item.h.s"

SECTION "ENT_ITEM_DATA", ROMX

    
ent_item_index::                
    dw item_copper_sword_data   ;;ID = 0
    dw item_copper_sword_data   ;;ID = 1
    dw item_copper_sword_data   ;;ID = 2
    dw item_copper_sword_data   ;;ID = 3
    dw item_copper_sword_data   ;;ID = 4
    dw item_copper_sword_data   ;;ID = 5
    dw item_copper_sword_data   ;;ID = 6
    dw item_copper_sword_data   ;;ID = 7
    dw item_copper_sword_data   ;;ID = 8
    dw item_copper_sword_data   ;;ID = 9

    dw item_copper_shield_data   ;;ID = 10
    dw item_copper_shield_data   ;;ID = 11
    dw item_copper_shield_data   ;;ID = 12
    dw item_copper_shield_data   ;;ID = 13
    dw item_copper_shield_data   ;;ID = 14
    dw item_copper_shield_data   ;;ID = 15
    dw item_copper_shield_data   ;;ID = 16
    dw item_copper_shield_data   ;;ID = 17
    dw item_copper_shield_data   ;;ID = 18
    dw item_copper_shield_data   ;;ID = 19

    dw item_copper_staff_data   ;;ID = 20
    dw item_copper_staff_data   ;;ID = 21
    dw item_copper_staff_data   ;;ID = 22
    dw item_copper_staff_data   ;;ID = 23
    dw item_copper_staff_data   ;;ID = 24
    dw item_copper_staff_data   ;;ID = 25
    dw item_copper_staff_data   ;;ID = 26
    dw item_copper_staff_data   ;;ID = 27
    dw item_copper_staff_data   ;;ID = 28
    dw item_copper_staff_data   ;;ID = 29
    dw item_copper_staff_data   ;;ID = 30
    dw item_copper_staff_data   ;;ID = 31
    dw item_copper_staff_data   ;;ID = 32
    dw item_copper_staff_data   ;;ID = 33
    dw item_copper_staff_data   ;;ID = 34
    dw item_copper_staff_data   ;;ID = 35
    dw item_copper_staff_data   ;;ID = 36
    dw item_copper_staff_data   ;;ID = 37
    dw item_copper_staff_data   ;;ID = 38
    dw item_copper_staff_data   ;;ID = 39


    dw item_lesser_potion_data  ;;ID = 40
    dw item_lesser_potion_data  ;;ID = 41
    dw item_lesser_potion_data  ;;ID = 42
    dw item_lesser_potion_data  ;;ID = 43
    dw item_lesser_potion_data  ;;ID = 44
    dw item_lesser_potion_data  ;;ID = 45
    dw item_lesser_potion_data  ;;ID = 46
    dw item_lesser_potion_data  ;;ID = 47
    dw item_lesser_potion_data  ;;ID = 48
    dw item_lesser_potion_data  ;;ID = 49

    dw item_default ;;ID = 50

    


item_default:     
    db "/"              ;;ITEM NAME (8 chars)
    db "/"      ;;ITEM DESC (16 chars)
    db $03                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE
    db $00                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP

item_copper_sword_data:     
    db "c_sword/"               ;;ITEM NAME (8 chars)
    db "Common sword.ATK:_+1/"       ;;ITEM DESC (16 chars)
    db $01                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $01                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE
    db $00                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP

item_copper_shield_data:     
    db "c_shield/"               ;;ITEM NAME (8 chars)
    db "Common shield.DEF:_+1/"       ;;ITEM DESC (16 chars)
    db $01                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK
    db $01                      ;;ITEM DEFFENSE
    db $00                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP

item_copper_staff_data:     
    db "c_staff/"               ;;ITEM NAME (8 chars)
    db "Common staff.DAMAGE:_10/"       ;;ITEM DESC (16 chars)
    db $02                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE
    db $00                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP

item_lesser_potion_data:     
    db "potion/"               ;;ITEM NAME (8 chars)
    db "Lesser potion.HP:_10/"       ;;ITEM DESC (16 chars)
    db $00                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE
    db $0A                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP