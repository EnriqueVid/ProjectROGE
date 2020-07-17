IF DEF(m_define_entity_map)

ELSE
m_define_entity_map: MACRO

    ds $09c4            ;; Map Tiles

ENDM
ENDC

em_tiles = 0

entity_map_size = $0550  ;$09c4  ;; In Bytes
entity_map_w = 40        ;; In tiles
entity_map_h = 34        ;; In tiles

