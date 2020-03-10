INCLUDE "src/ent/entity_enemy.h.s"

SECTION "ENT_ENEMY_TYPES", ROM0


ent_enemy_index::
    dw ent_enemy_bat_01 ;;01 -> $01


ent_enemy_bat_01:
    db $08  ;;Sprite ID

    db $05  ;;Max HP
    db $00  ;;Max MP
    db $02  ;;Max ATK
    db $01  ;;Max DEF

    db $01  ;;Enemy ID
    db $00  ;;Attack Type
    db $02  ;;IA State
    db $00  ;;Objective X
    db $00  ;;Objective Y