GLOBAL _sr_load_tiles
GLOBAL _sr_draw_sprite
GLOBAL _sr_draw_tile
GLOBAL _sr_draw_screen
GLOBAL _sr_update_scroll_map
GLOBAL _sr_draw_row
GLOBAL _sr_draw_column
GLOBAL _sr_draw_hud



ep_x = 0
ep_y = 1
ep_wx = 2
ep_wy = 3
ep_vx = 4
ep_vy = 5
ep_dir = 6
ep_spr = 7
ep_mHP = 8
ep_mMP = 9
ep_mATK = 10
ep_mDEF = 11
ep_cHP = 12
ep_cMP = 13
ep_cATK = 14
ep_cDEF = 15
ep_cSTAT = 16


MAPw = 50
MAPh = 50

GBSw SET 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh SET  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx SET $FF43          ;; Game Boy Screen X
GBSy SET $FF42          ;; Game Boy Screen Y