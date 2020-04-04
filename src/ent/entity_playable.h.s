IF DEF (m_define_entity_playable)

ELSE
m_define_entity_playable: MACRO

    ds $01              ;; Position X
    ds $01              ;; Position Y

    ds $01              ;; Position Window X
    ds $01              ;; Position Window Y

    ds $01              ;; Velocity X
    ds $01              ;; Velocity Y
    ds $01              ;; Direction X
    ds $01              ;; Direction Y

    ds $01              ;; Sprite ID
    ds $02              ;; Sprite Memory ptr

    ds $01              ;; Max. HP
    ds $01              ;; Max. MP
    ds $01              ;; Max. ATK
    ds $01              ;; Max. DEF

    ds $01              ;; Current HP
    ds $01              ;; Current MP
    ds $01              ;; Current ATK
    ds $01              ;; Current DEF

    ds $01              ;; Current Status Effect

    ds $01              ;; Current Room
    ds $01              ;; Aux Coord X
    ds $01              ;; Aux Coord Y

ENDM
ENDC

ep_x = 0
ep_y = 1
ep_wx = 2
ep_wy = 3
ep_vx = 4
ep_vy = 5
ep_dir_x = 6
ep_dir_y = 7
ep_spr = 8
ep_spr_ptr_L = 9
ep_spr_ptr_H = 10
ep_mHP = 11
ep_mMP = 12
ep_mATK = 13
ep_mDEF = 14
ep_cHP = 15
ep_cMP = 16
ep_cATK = 17
ep_cDEF = 18
ep_cSTAT = 19
ep_room = 20
ep_aux_x = 21     ;; En enemigos sirve para guardar su posicion anterior 
ep_aux_y = 22     ;; En el jugador sirve para guardar la posicion por la que salio de una sala

ent_playable_size = 23


STATUS_PARAL = 1