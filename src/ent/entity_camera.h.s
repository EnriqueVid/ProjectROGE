m_define_entity_camera: MACRO

    ds $01          ;; Tilemap X
    ds $01          ;; Tilemap Y
    ds $02          ;; Tilemap ptr
    ds $02          ;; BG map ptr (TL)
    ds $02          ;; BG map ptr (TR)
    ds $02          ;; BG map ptr (BL)
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
