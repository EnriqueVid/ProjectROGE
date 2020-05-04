INCLUDE "src/ent/entity_camera.h.s"

SECTION "ENT_CAMERA_DEFAULT", ROM0


ent_camera_default::
    db $00  ;;Tilemap X
    db $00  ;;Tilemap Y
    db $00  ;;Tilemap ptr L
    db $00  ;;Tilemap ptr H

    db $00  ;;BG map ptr TL L 
    db $00  ;;BG map ptr TL H  

    db $00  ;;BG map ptr TR L 
    db $00  ;;BG map ptr TR H  

    db $00  ;;BG map ptr BL L 
    db $00  ;;BG map ptr BL H  

    db $00  ;;Player BG map ptr L
    db $00  ;;Player BG map ptr H

    db $00  ;;Scroll Active
    db $00  ;;Scroll Counter 
    db $00  ;;Scroll Direction X
    db $00  ;;Scroll Direction Y

    

