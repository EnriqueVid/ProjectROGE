IF DEF(m_define_entity_room)

ELSE
m_define_entity_room: MACRO

    ds $01              ;; Room X
    ds $01              ;; Room Y
    ds $01              ;; Room W
    ds $01              ;; Room H
    ds $01              ;; Room ID

ENDM
ENDC

ent_room_x  = 00
ent_room_y  = 01
ent_room_w  = 02
ent_room_h  = 03
ent_room_id = 04

entity_room_size = 5
