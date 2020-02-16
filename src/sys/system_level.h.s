GLOBAL _sl_get_tilemap_dir
GLOBAL _sl_get_screenmap_dir
GLOBAL _sl_get_map_tile
GLOBAL _sl_correct_hor
GLOBAL _sl_correct_vert
GLOBAL _sl_init_level
GLOBAL _sl_set_scroll_screen
GLOBAL _sl_update_scroll
GLOBAL _sl_spawn_enemies


entity_enemy_size = 21


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


MAPw = 50
MAPh = 50

scrollConst = 16
scrollCounterConst = $2

GBSw = 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh =  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx = $FF43          ;; Game Boy Screen X
GBSy = $FF42          ;; Game Boy Screen Y