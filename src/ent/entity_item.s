INCLUDE "src/ent/entity_item.h.s"

SECTION "ENT_ITEM_DATA", ROMX

    
ent_item_index::                
    dw item_copper_sword_data   ;;ID = 0 = $00
    dw item_copper_sword_data   ;;ID = 1 = $01
    dw item_copper_sword_data   ;;ID = 2 = $02
    dw item_copper_sword_data   ;;ID = 3 = $03
    dw item_copper_sword_data   ;;ID = 4 = $04
    dw item_copper_sword_data   ;;ID = 5 = $05
    dw item_copper_sword_data   ;;ID = 6 = $06
    dw item_copper_sword_data   ;;ID = 7 = $07
    dw item_copper_sword_data   ;;ID = 8 = $08
    dw item_copper_sword_data   ;;ID = 9 = $09

    dw item_copper_shield_data   ;;ID = 10 = $0A
    dw item_copper_shield_data   ;;ID = 11 = $0B
    dw item_copper_shield_data   ;;ID = 12 = $0C
    dw item_copper_shield_data   ;;ID = 13 = $0D
    dw item_copper_shield_data   ;;ID = 14 = $0E
    dw item_copper_shield_data   ;;ID = 15 = $0F
    dw item_copper_shield_data   ;;ID = 16 = $10
    dw item_copper_shield_data   ;;ID = 17 = $11
    dw item_copper_shield_data   ;;ID = 18 = $12
    dw item_copper_shield_data   ;;ID = 19 = $13

    dw item_copper_staff_data   ;;ID = 20 = $14
    dw item_copper_staff_data   ;;ID = 21 = $15
    dw item_copper_staff_data   ;;ID = 22 = $16
    dw item_copper_staff_data   ;;ID = 23 = $17
    dw item_copper_staff_data   ;;ID = 24 = $18
    dw item_copper_staff_data   ;;ID = 25 = $19
    dw item_copper_staff_data   ;;ID = 26 = $1A
    dw item_copper_staff_data   ;;ID = 27 = $1B
    dw item_copper_staff_data   ;;ID = 28 = $1C
    dw item_copper_staff_data   ;;ID = 29 = $1D
    dw item_copper_staff_data   ;;ID = 30 = $1E
    dw item_copper_staff_data   ;;ID = 31 = $1F
    dw item_copper_staff_data   ;;ID = 32 = $20
    dw item_copper_staff_data   ;;ID = 33 = $21
    dw item_copper_staff_data   ;;ID = 34 = $22
    dw item_copper_staff_data   ;;ID = 35 = $23
    dw item_copper_staff_data   ;;ID = 36 = $24
    dw item_copper_staff_data   ;;ID = 37 = $25
    dw item_copper_staff_data   ;;ID = 38 = $26
    dw item_copper_staff_data   ;;ID = 39 = $27


    dw item_lesser_potion_data  ;;ID = 40 = $28
    dw item_lesser_potion_data  ;;ID = 41 = $29
    dw item_lesser_potion_data  ;;ID = 42 = $2A
    dw item_lesser_potion_data  ;;ID = 43 = $2B
    dw item_lesser_potion_data  ;;ID = 44 = $2C
    dw item_lesser_potion_data  ;;ID = 45 = $2D
    dw item_lesser_potion_data  ;;ID = 46 = $2E
    dw item_lesser_potion_data  ;;ID = 47 = $2F
    dw item_lesser_potion_data  ;;ID = 48 = $30
    dw item_lesser_potion_data  ;;ID = 49 = $31

    dw item_default ;;ID = 50 = $32


item_default:     
    db "________/"              ;;ITEM NAME (8 chars)
    db "/"      ;;ITEM DESC (16 chars)
    db $03                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE
    db $00                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP
    db $00                      ;;ITEM ATTRIBUTES

item_copper_sword_data:     
    db "c>sword_/"               ;;ITEM NAME (8 chars)
    db "Common_sword.ATK:_1/"       ;;ITEM DESC (16 chars)
    db $01                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $05                      ;;ITEM HEALTH
    db $00                      ;;ITEM MP
    db $05                      ;;ITEM ATTACK
    db $00                      ;;ITEM DEFFENSE

item_copper_shield_data:     
    db "c>shield/"               ;;ITEM NAME (8 chars)
    db "Common_shield.DEF:_1/"       ;;ITEM DESC (16 chars)
    db $01                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM HEALTH
    db $03                      ;;ITEM MP
    db $00                      ;;ITEM ATTACK
    db $01                      ;;ITEM DEFFENSE

item_copper_staff_data:     
    db "c>staff_/"               ;;ITEM NAME (8 chars)
    db "Common_staff.DMG:_10/"       ;;ITEM DESC (16 chars)
    db $02                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $00                      ;;ITEM ATTACK


item_lesser_potion_data:     
    db "potion__/"               ;;ITEM NAME (8 chars)
    db "Lesser_potion.HP:_10/"       ;;ITEM DESC (16 chars)
    db $00                      ;;ITEM TYPE (00 -> consumable, 01 -> equipment, 02 -> Magic)
    db $0A                      ;;ITEM HEALTH
    db $05                      ;;ITEM MP
    db $FF                      ;;ITEM ATTRIBUTES