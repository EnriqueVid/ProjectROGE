GLOBAL _sr_load_tiles
GLOBAL _sr_draw_sprite
GLOBAL _sr_draw_tile
GLOBAL _sr_draw_screen
GLOBAL _sr_draw_screen_8x8
GLOBAL _sr_update_scroll_map
GLOBAL _sr_draw_row
GLOBAL _sr_draw_column
GLOBAL _sr_draw_hud
GLOBAL _sr_attack_animation
GLOBAL _sr_draw_enemies
GLOBAL _sr_enemies_initial_draw
GLOBAL _sr_update_draw_player_hud
GLOBAL _sr_fade_out
GLOBAL _sr_fade_in
GLOBAL _sr_draw_main_menu_info
GLOBAL _sr_draw_number_tile
GLOBAL _sr_draw_number_6
GLOBAL _sr_draw_number_3
GLOBAL _sr_draw_text
GLOBAL _sr_draw_item_name



Tile_size = 16

MAPw = 40
MAPh = 34

GBSw SET 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh SET  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx SET $FF43          ;; Game Boy Screen X
GBSy SET $FF42          ;; Game Boy Screen Y