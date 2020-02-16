INCLUDE "src/ent/entity_enemy.h.s"

SECTION "ENT_ENEMY_TYPES", ROM0


ent_enemy_bat_01::
    db $00  ;;Position X
    db $00  ;;Position Y

    db $40  ;;Window X
    db $40  ;;Window Y

    db $00  ;;Velocity X
    db $00  ;;Velocity Y

    db $00  ;;Direction X
    db $00  ;;Direction Y

    db $08  ;;Sprite ID
    db $08  ;;Sprite ptr L
    db $C0  ;;Sprite ptr H

    db $05  ;;Max HP
    db $00  ;;Max MP
    db $02  ;;Max ATK
    db $01  ;;Max DEF

    db $05  ;;Current HP
    db $00  ;;Current MP
    db $02  ;;Current ATK
    db $01  ;;Current DEF

    db $00  ;;Current Status Effect

    db $01  ;;Enemy ID