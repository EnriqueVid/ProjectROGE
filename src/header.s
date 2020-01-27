INCLUDE "src/header.h.s"


SECTION "RSTS", ROM0[$0000]
    ds $40

SECTION "I_VBLANK", ROM0[$0040]
    jp VblankInterruptHandler
    ds $05

SECTION "I_LCDSTAT", ROM0[$0048]
    reti
    ds $07

SECTION "I_TIMER", ROM0[$0050]
    reti
    ds $07

SECTION "I_SERIAL", ROM0[$0058]
    reti
    ds $07

SECTION "I_JOYPAD", ROM0[$0060]
    reti
    ds $07

SECTION "UNUSED", ROM0[$0068]
    ds $98

SECTION "ENTRY_POINT", ROM0[$0100]          ;; ---------  ENTRY POINT  ---------
    di
    jp _main                                 ;; Cambiar el nombre para que coincida con el de main.s

SECTION "N_LOGO", ROM0[$0104] 
    db $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

SECTION "GAME_NAME", ROM0[$0134]
    db "PROJECT-ROGE",                     0, 0, 0    ;; 0134 - 0142  -->  15 bytes
;;  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;;     P  R  O  J  E  C  T  -  R  O  G  E 

SECTION "METADATA", ROM0[$0143]
    IF DEF(BuildGBC)
        db $80          ;; |
    ELSE                ;; +- (&0143) Flag que indica si es GB(00), GBC(C0) o GB+GBC(80)
        db $00          ;; |
    ENDC

    db 0, 0             ;; (&0144 - &0145) Game Manifacturer Code

    db 0                ;; (&0146)	Super GameBoy flag (&00=normal, &03=SGB)

	db 2     	        ;; (&0147) Cartridge type (special upgrade hardware) 
                        ;; (0=normal ROM , 1/2=MBC1(max 2MByte ROM and/or 32KByte RAM)

                        ;; 0  - ROM ONLY                12 - ROM+MBC3+RAM
                        ;; 1  - ROM+MBC1                13 - ROM+MBC3+RAM+BATT
                        ;; 2  - ROM+MBC1+RAM            19 - ROM+MBC5 (max 8MByte ROM and/or 128KByte RAM)
                        ;; 3  - ROM+MBC1+RAM+BATT       1A - ROM+MBC5+RAM
                        ;; 5  - ROM+MBC2                1B - ROM+MBC5+RAM+BATT
                        ;; 6  - ROM+MBC2+BATTERY        1C - ROM+MBC5+RUMBLE
                        ;; 8  - ROM+RAM                 1D - ROM+MBC5+RUMBLE+SRAM
                        ;; 9  - ROM+RAM+BATTERY         1E - ROM+MBC5+RUMBLE+SRAM+BATT
                        ;; B  - ROM+MMM01               1F - Pocket Camera
                        ;; C  - ROM+MMM01+SRAM          FD - Bandai TAMA5
                        ;; D  - ROM+MMM01+SRAM+BATT     FE - Hudson HuC-3
                        ;; F  - ROM+MBC3+TIMER+BATT     FF - Hudson HuC-1
                        ;; 10 - ROM+MBC3+TIMER+RAM+BATT
                        ;; 11 - ROM+MBC3

    db $02              ;; (&0148) Tamaño de la ROM (0=32k, 1=64k, 2=128k, etc)

    db $03              ;; (&0149) Tamaño de la RAM (0=0k, 1=2k, 2=8k, 3=32k)

    db $01              ;; (&014A) Codigo de Region (0=JPN, 1=EU/US)

    db $33              ;; (&014B) "Old License Code". Debe ser $33 para la SGB

    db $00              ;; (&014C) Version de la rom

    db $00              ;; (&014D) Header Checksum - No es necesario para emuladores

    dw $0000            ;; (&014E - &014F) Global Checksum - No lo usa la GameBoy