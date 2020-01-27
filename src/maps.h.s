GLOBAL _draw_tile
GLOBAL _draw_map
GLOBAL _draw_map_scroll
GLOBAL _set_screen_data
GLOBAL _set_scroll_screen
GLOBAL _update_scroll
GLOBAL LCDWait
GLOBAL _get_map_tile

GLOBAL _set_scroll_map
GLOBAL _draw_column
GLOBAL _draw_row
GLOBAL _update_scroll_map

GLOBAL _win

GLOBAL _mActual_X
GLOBAL _mActual_Y
GLOBAL scroll
GLOBAL scrollCounter   
GLOBAL scrollDirectionX
GLOBAL scrollDirectionY
GLOBAL scrollPositionX
GLOBAL scrollPositionY


MAPW SET 30
MAPH SET 30
scrollConst SET 16
scrollCounterConst SET 255

GBSw SET 11             ;; Game Boy Screen Width (en tiles de 16x16 px). Es 11 por el offset
GBSh SET  9             ;; Game Boy Screen Height (en tiles de 16x16 px)
GBSx SET $FF43          ;; Game Boy Screen X
GBSy SET $FF42          ;; Game Boy Screen Y