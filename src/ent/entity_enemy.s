INCLUDE "src/ent/entity_enemy.h.s"

SECTION "ENT_ENEMY_TYPES", ROM0


ent_enemy_index::
    dw ent_enemy_bat_01 ;;00 -> $00


ent_enemy_bat_01:
    db $08  ;;Sprite ID

    db $05  ;;Max HP
    db $00  ;;Max MP
    db $02  ;;Max ATK
    db $01  ;;Max DEF

    db $00  ;;Enemy ID
    db ATTACK_MELEE  ;;Attack Type
    ;db $03  ;;IA State
    ;db $00  ;;Objective X
    ;db $00  ;;Objective Y