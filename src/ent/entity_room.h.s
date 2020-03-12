IF DEF(m_define_entity_room)

ELSE
m_define_entity_room: MACRO

    ds $01              ;; Room X
    ds $01              ;; Room Y
    ds $01              ;; Room W
    ds $01              ;; Room H
    ds $01              ;; Room ID

    ds $01              ;; Exit Num
    ds $02              ;; Exit 1
    ds $02              ;; Exit 2    
    ds $02              ;; Exit 3
    ds $02              ;; Exit 4

ENDM
ENDC

ent_room_x  = 00
ent_room_y  = 01
ent_room_w  = 02
ent_room_h  = 03
ent_room_id = 04

ent_room_exit_num = 05
ent_room_exit_01  = 06
ent_room_exit_02  = 08
ent_room_exit_03  = 10
ent_room_exit_04  = 12

entity_room_size = 14
