
;INCLUDE "src/ent/entity_playable.h.s"
INCLUDE "src/ent/entity_enemy.h.s"
INCLUDE "src/ent/entity_item.h.s"


SECTION "ENT_PLAYABLE_VARS", WRAM0
entity_playable: m_define_entity_playable

SECTION "ENT_ITEM_VARS", WRAM0
entity_item: m_define_entity_item

SECTION "ENT_PLAYER_VARS", WRAM0
entity_player: m_define_entity_player

