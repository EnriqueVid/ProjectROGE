INCLUDE "src/ent/entity_playable.h.s"

GLOBAL default_entity_player


m_define_entity_player: MACRO

    m_define_entity_playable
    ds $01              ;; Equiped Weapon
    ds $01              ;; Equiped Armor
    ds $01              ;; Equiped Item

    ds $01              ;; Default HP
    ds $01              ;; Default MP
    ds $01              ;; Default ATK
    ds $01              ;; Default DEF

ENDM

ent_player_eq_W    = 17
ent_player_eq_A    = 18
ent_player_aq_I    = 19

ent_player_def_HP  = 20
ent_player_def_MP  = 21
ent_player_def_ATK = 22
ent_player_def_DEF = 23

entity_player_size = 24