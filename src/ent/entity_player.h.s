GLOBAL default_entity_player

IF DEF(m_define_entity_player)

ELSE
m_define_entity_player: MACRO

    m_define_entity_playable
    ds $01              ;; Equiped Weapon
    ds $01              ;; Equiped Armor
    ds $01              ;; Equiped Item

    ds $01              ;; Default HP
    ds $01              ;; Default MP
    ds $01              ;; Default ATK
    ds $01              ;; Default DEF

    ds $01              ;; Player Lvl

ENDM
ENDC

ent_player_eq_W    = 23
ent_player_eq_A    = 24
ent_player_aq_I    = 25

ent_player_def_HP  = 26
ent_player_def_MP  = 27
ent_player_def_ATK = 28
ent_player_def_DEF = 29

ent_player_Lvl     = 30


entity_player_size = 31