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

ent_player_eq_W    = 20
ent_player_eq_A    = 21
ent_player_aq_I    = 22

ent_player_def_HP  = 23
ent_player_def_MP  = 24
ent_player_def_ATK = 25
ent_player_def_DEF = 26

entity_player_size = 27