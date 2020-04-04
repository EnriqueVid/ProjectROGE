IF DEF(m_define_entity_enemy)

ELSE
m_define_entity_enemy: MACRO

    m_define_entity_playable
    ds $01              ;; Enemy ID
    ds $01              ;; Attack Type
    ds $01              ;; IA State
    ds $01              ;; Objective X
    ds $01              ;; Objective Y
    ds $01              ;; Last Player Room


ENDM

ENDC

IA_STATE_IDLE   = 00
IA_STATE_CHASE  = 01
IA_STATE_WANDER = 02
IA_STATE_SLEEP  = 03
IA_STATE_ATTACK = 04
IA_STATE_NO_IA  = $80

ATTACK_MELEE    = 00
ATTACK_DISTANCE = 01

ent_enemy_id                = 23
ent_enemy_atk_type          = 24
ent_enemy_ia_state          = 25
ent_enemy_objective_x       = 26
ent_enemy_objective_y       = 27
ent_enemy_last_player_room  = 28



entity_enemy_size = 29