INCLUDE "src/functions.h.s"

SECTION "FUNCTION_VARS", WRAM0

rand_seed: ds $01


SECTION "FUNCTION_FUNCS", ROM0


;;==============================================================================================
;;                                    GENERATE RANDOM
;;----------------------------------------------------------------------------------------------
;; Genera un número aleatorio a partir del reloj interno. 
;; Emplea un LFSR para la generación inicial.
;;
;; INPUT:
;;  NONE
;;
;; OUTPUT:
;;  A -> Numero aleatorio generado
;;
;; DESTROYS:
;;  AF, DE
;;
;;==============================================================================================
_generate_random:

    ld a, [$FF05]           ;;Timer Counter. Se incrementa en funcion de la configuración establecida
    ld e, a

.loop:
    ld d, a
    
    rr d
    rr d
    rr d
    rr d
    xor d

    rr d
    xor d

    rr d
    xor d

    rr d
    rr d
    xor d

    ld d, a
    ld a, [$FF04]           ;; Divider Register. Se incrementa 16384 veces por segundo
    xor d

    cp e
    jr z, .loop

    ret


;;Espera hasta estar en VBlank
_wait_Vblank:
    push   af
.loop:
    ld      a,[$FF44]		    ;; |       
	cp      145                 ;; +- Loop hata estar en VBlank (145)   -   FF44 -> Coordenada Y del LCD (De 144 en adelante, estamos en VBlank)    
	jr      c, .loop            ;; |     
    pop    af
    ret


_VRAM_wait:
	push af
    ;di
.loop:
    ld a,[$FF41]  		;STAT - LCD Status (R/W)
		;-LOVHCMM
    and %00000010		;MM=video mode (0/1 =Vram available)  		
    jr nz,.loop
    pop af	
	ret


; HL -> DESTINO
; BC -> CANTIDAD 
_clear_data:
    xor a
    ldi [hl], a
    dec bc
    ld a, b
    xor c
    jr nz, _clear_data
    ret

;; DE -> Origen
;; HL -> Destino
;; BC -> Cantidad
_ldir:
    ld	a, [de]		            
	inc de
	ldi	[hl], a		                    
	dec	bc
	ld  a, b
	or  c
	jr	nz, _ldir
    ret

;; DE -> Origen
;; HL -> Destino
;; BC -> Cantidad
_ldir_tile:
    ld	a, [de]		            
	inc de
    call _VRAM_wait
	ldi	[hl], a		                    
	dec	bc
	ld  a, b
	or  c
	jr	nz, _ldir_tile
    ret

;;  A -> GB palette, not GBC
_define_palette:
    IF DEF(BuildGBC)
        db $AA
    ELSE                
		ld   hl , $FF47
		ldi [hl], a			        ;;FF47 	BGP	BG & Window Palette Data  (R/W)	= &FC
		ldi [hl], a			        ;;FF48  	OBP0	Object Palette 0 Data (R/W)	= &FF
		cpl					        ;;Set sprite Palette 2 to the opposite
		ldi [hl], a			        ;;FF49  	OBP1	Object Palette 1 Data (R/W)	= &FF        
        
    ENDC
    ret


;;infinite Loop
_jri:
    jr _jri
