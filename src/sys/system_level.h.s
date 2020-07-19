GLOBAL _sl_get_tilemap_dir
GLOBAL _sl_get_screenmap_dir
GLOBAL _sl_get_map_tile
GLOBAL _sl_correct_hor
GLOBAL _sl_correct_vert
GLOBAL _sl_init_level
GLOBAL _sl_set_scroll_screen
GLOBAL _sl_update_scroll
GLOBAL _sl_spawn_enemies
GLOBAL _sl_check_room
GLOBAL _sl_get_random_exit
GLOBAL _sl_generate_map
GLOBAL _sl_check_exit_neighbours
GLOBAL _sl_get_tile_neighbours




MAPw = 40
MAPh = 34

scrollConst = 16
scrollCounterConst = $2

GBSw = 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh =  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx = $FF43          ;; Game Boy Screen X
GBSy = $FF42          ;; Game Boy Screen Y