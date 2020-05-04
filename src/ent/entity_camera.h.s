IF DEF(m_define_entity_camera)

ELSE
m_define_entity_camera: MACRO

                        ds $01          ;; Tilemap X
                        ds $01          ;; Tilemap Y
ec_tilemap_ptr_L:       ds $01          ;; Tilemap ptr L
ec_tilemap_ptr_H:       ds $01          ;; Tilemap ptr H
ec_bgmap_prt_TL_L:      ds $01          ;; BG map ptr (TL) L
ec_bgmap_prt_TL_H:      ds $01          ;; BG map ptr (TL) H
ec_bgmap_prt_TR_L:      ds $01          ;; BG map ptr (TR) L
ec_bgmap_prt_TR_H:      ds $01          ;; BG map ptr (TR) H
ec_bgmap_prt_BL_L:      ds $01          ;; BG map ptr (BL) L
ec_bgmap_prt_BL_H:      ds $01          ;; BG map ptr (BL) H
                        ds $01          ;; Scroll Active
                        ds $01          ;; Scroll Counter
                        ds $01          ;; Scroll Direction X
                        ds $01          ;; Scroll Direction Y
ec_player_bgmap_prt_L:  ds $01          ;; player BG map ptr L
ec_player_bgmap_prt_H:  ds $01          ;; player BG map ptr H

ENDM

ENDC

ec_tilemap_x EQUS "00"
ec_tilemap_y EQUS "01"
ec_tilemap_ptr_l EQUS "02"
ec_tilemap_ptr_h EQUS "03"

ec_bgmap_ptr_tl_l EQUS "04"
ec_bgmap_ptr_tl_h EQUS "05"
ec_bgmap_ptr_tr_l EQUS "06"
ec_bgmap_ptr_tr_h EQUS "07"
ec_bgmap_ptr_bl_l EQUS "08"
ec_bgmap_ptr_bl_h EQUS "09"

ec_scroll_active EQUS "10"
ec_scroll_counter EQUS "11"
ec_scroll_dir_x EQUS "12"
ec_scroll_dir_y EQUS "13"

ec_player_bgmap_ptr_l EQUS "14"
ec_player_bgmap_ptr_h EQUS "15"

entity_camera_size EQUS "14"

