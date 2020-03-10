IF DEF(m_define_entity_enemy)

ELSE
m_define_entity_enemy: MACRO

    m_define_entity_playable
    ds $01              ;; Enemy ID
    ds $01              ;; Attack Type
    ds $01              ;; IA State
    ds $01              ;; Objective X
    ds $01              ;; Objective Y
    

ENDM

ENDC

IA_STATE_IDLE   = 00
IA_STATE_CHASE  = 01
IA_STATE_WANDER = 02

ATTACK_MELEE    = 00
ATTACK_DISTANCE = 01

ent_enemy_id            = 20
ent_enemy_atk_type      = 21
ent_enemy_ia_state      = 22
ent_enemy_objective_x   = 23
ent_enemy_objective_y   = 24



entity_enemy_size = 25