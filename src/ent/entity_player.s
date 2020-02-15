SECTION "ENT_PLAYER_DEFAULT", ROM0

default_entity_player::
ent_player_default_x: db $05
ent_player_default_y: db $04

ent_player_default_window_x: db $48+8
ent_player_default_window_y: db $40+16

ent_player_default_vx: db $00
ent_player_default_vy: db $00

ent_player_default_dir_X: db $00
ent_player_default_dir_Y: db $01

ent_player_default_sprite_id: db $07
ent_player_default_sprite_ptr_L: db $00
ent_player_default_sprite_ptr_H: db $C0

ent_player_default_max_HP: db $0F
ent_player_default_max_MP: db $0A
ent_player_default_max_ATK: db $0A
ent_player_default_max_DEF: db $0A

ent_player_default_current_HP: db $0F
ent_player_default_current_MP: db $0A
ent_player_default_current_ATK: db $0A
ent_player_default_current_DEF: db $0A

ent_player_default_current_status_effect: db $00

ent_player_default_eq_weapon: db $00
ent_player_default_eq_armor: db $00
ent_player_default_eq_item: db $00

ent_player_default_def_HP  db $00
ent_player_default_def_MP  db $00
ent_player_default_def_ATK db $00
ent_player_default_def_DEF db $00