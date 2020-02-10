INCLUDE "src/ent/entity_player.h.s"

m_define_entity_enemy: MACRO

    m_define_entity_playable
    ds $01              ;; Enemy ID
    

ENDM

ent_enemy_id    = 18

entity_enemy_size = 19