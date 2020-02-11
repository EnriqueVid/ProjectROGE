m_define_entity_playable: MACRO

    ds $01              ;; Position X
    ds $01              ;; Position Y

    ds $01              ;; Position Window X
    ds $01              ;; Position Window Y

    ds $01              ;; Velocity X
    ds $01              ;; Velocity Y
    ds $01              ;; Direction

    ds $01              ;; Sprite ID

    ds $01              ;; Max. HP
    ds $01              ;; Max. MP
    ds $01              ;; Max. ATK
    ds $01              ;; Max. DEF

    ds $01              ;; Current HP
    ds $01              ;; Current MP
    ds $01              ;; Current ATK
    ds $01              ;; Current DEF

    ds $01              ;; Current Status Effect

ENDM

ep_x = 0
ep_y = 1
ep_wx = 2
ep_wy = 3
ep_vx = 4
ep_vy = 5
ep_dir = 6
ep_spr = 7
ep_mHP = 8
ep_mMP = 9
ep_mATK = 10
ep_mDEF = 11
ep_cHP = 12
ep_cMP = 13
ep_cATK = 14
ep_cDEF = 15
ep_cSTAT = 16

ent_playable_size = 17