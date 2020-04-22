INCLUDE "src/functions.h.s"

SECTION "FUNCTION_VARS", WRAM0

rand_seed: ds $01


SECTION "FUNCTION_FUNCS", ROM0




;;==============================================================================================
;;                                    GENERATE RANDOM
;;----------------------------------------------------------------------------------------------
;; Convierte un numero hexadecimal de hasta $FF a decimal y lo devielve en DE
;;
;; INPUT:
;;  A -> Numero en hexadecimal para convertir
;;
;; OUTPUT:
;;  DE -> Numero decimal convertido, Cada nibble representa una unidad/decena/centena
;;
;; DESTROYS:
;;  AF, B, DE
;;
;;==============================================================================================
_hex2dec:

    ld de, $0000

    cp $C8                  ;200 decimal
    jr c, .check_cent
    sub $C8
    ld d, $02
    jr .check_daa

.check_cent:
    cp $64                  ;100 decimal
    jr c, .check_daa
    sub $64
    ld d, $01 

.check_daa
    ld b, a
    xor a

.bit0:
    bit 0, b
    jr z, .bit1
    add a, $01
    daa

.bit1:
    bit 1, b
    jr z, .bit2
    add a, $02
    daa

.bit2:
    bit 2, b
    jr z, .bit3
    add a, $04
    daa

.bit3:
    bit 3, b
    jr z, .bit4
    add a, $08
    daa

.bit4:
    bit 4, b
    jr z, .bit5
    add a, $16
    daa

.bit5:
    bit 5, b
    jr z, .bit6
    add a, $32
    daa

.bit6:
    bit 6, b
    jr z, .bit_end
    add a, $64
    daa
    
.bit_end:

    ld e, a

    ;db $18, $FE

    ret



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
    ;dec	a
    jr nz,.loop
    
    ;db $18,$FE
    pop af	
	ret


; HL -> DESTINO
; BC -> CANTIDAD 
_clear_data:
    xor a
    call _VRAM_wait
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
