IF DEF (m_define_entity_hud)

ELSE
m_define_entity_hud: MACRO

    ds $01              ;; Max HP C
    ds $01              ;; Max HP D
    ds $01              ;; Max HP U

    ds $01              ;; Max MP D
    ds $01              ;; Max MP U

    ds $01              ;; Current HP C
    ds $01              ;; Current HP D
    ds $01              ;; Current HP U

    ds $01              ;; Current MP D
    ds $01              ;; Current MP U

    ds $01              ;; Attack C
    ds $01              ;; Attack D
    ds $01              ;; Attack U

    ds $01              ;; Defense C
    ds $01              ;; Defense D
    ds $01              ;; Defense U

    ds $01              ;; Current FL D
    ds $01              ;; Current FL U

    ds $01              ;; Level C
    ds $01              ;; Level D
    ds $01              ;; Level U




ENDM

ENDC

eh_m_hp_c   = 0
eh_m_hp_d   = 1
eh_m_hp_u   = 2

eh_m_mp_d   = 3
eh_m_mp_u   = 4

eh_c_hp_c   = 5
eh_c_hp_d   = 6
eh_c_hp_u   = 7

eh_c_mp_d   = 8
eh_c_mp_u   = 9

eh_atk_c    = 10
eh_atk_d    = 11
eh_atk_u    = 12

eh_def_c    = 13
eh_def_d    = 14
eh_def_u    = 15

eh_fl_d   = 16
eh_fl_u   = 17

eh_lvl_c = 18
eh_lvl_d = 19
eh_lvl_u = 20

entity_hud_size = 21