GLOBAL _sr_load_tiles
GLOBAL _sr_draw_sprite
GLOBAL _sr_draw_tile
GLOBAL _sr_draw_screen
GLOBAL _sr_update_scroll_map
GLOBAL _sr_draw_row
GLOBAL _sr_draw_column
GLOBAL _sr_draw_hud
GLOBAL _sr_attack_animation



ep_x = 0
ep_y = 1
ep_wx = 2
ep_wy = 3
ep_vx = 4
ep_vy = 5
ep_dir_x = 6
ep_dir_y = 7
ep_spr = 8
ep_spr_ptr_L = 9
ep_spr_ptr_H = 10
ep_mHP = 11
ep_mMP = 12
ep_mATK = 13
ep_mDEF = 14
ep_cHP = 15
ep_cMP = 16
ep_cATK = 17
ep_cDEF = 18
ep_cSTAT = 19


MAPw = 50
MAPh = 50

GBSw SET 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh SET  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx SET $FF43          ;; Game Boy Screen X
GBSy SET $FF42          ;; Game Boy Screen Y