m_define_entity_camera: MACRO

                    ds $01          ;; Tilemap X
                    ds $01          ;; Tilemap Y
ec_tilemap_ptr_L:   ds $01          ;; Tilemap ptr L
ec_tilemap_ptr_H:   ds $01          ;; Tilemap ptr H
ec_bgmap_prt_TL_L:  ds $01          ;; BG map ptr (TL) L
ec_bgmap_prt_TL_H:  ds $01          ;; BG map ptr (TL) H
ec_bgmap_prt_TR_L:  ds $01          ;; BG map ptr (TR) L
ec_bgmap_prt_TR_H:  ds $01          ;; BG map ptr (TR) H
ec_bgmap_prt_BL_L:  ds $01          ;; BG map ptr (BL) L
ec_bgmap_prt_BL_H:  ds $01          ;; BG map ptr (BL) H
                    ds $01          ;; Scroll Active
                    ds $01          ;; Scroll Counter
                    ds $01          ;; Scroll Direction X
                    ds $01          ;; Scroll Direction Y

ENDM

ec_tilemap_x = 0
ec_tilemap_y = 1
ec_tilemap_ptr_l = 2
ec_tilemap_ptr_h = 3

ec_bgmap_ptr_tl_l = 4
ec_bgmap_ptr_tl_h = 5
ec_bgmap_ptr_tr_l = 6
ec_bgmap_ptr_tr_h = 7
ec_bgmap_ptr_bl_l = 8
ec_bgmap_ptr_bl_h = 9

ec_scroll_active = 10
ec_scroll_counter = 11
ec_scroll_dir_x = 12
ec_scroll_dir_y = 13

entity_camera_size = 14
