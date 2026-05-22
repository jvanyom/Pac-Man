; ========================================================================================
; SPRITE RENDERING
; 16x16 palette-indexed sprites for Pac-Man and ghosts.
; ----------------------------------------------------------------------------------------
; SPRITE BYTE FORMAT (raw .bin files in DATA/SPRITES/):
;   0 = TRANSPARENT (pixel skipped)
;   1 = PALETTE INDEX 1 (PRIMARY  : pac body / ghost body)
;   2 = PALETTE INDEX 2 (SECONDARY: eye white)
;   3 = PALETTE INDEX 3 (TERTIARY : pupil)
;
; PALETTE FORMAT:
;   3 CONSECUTIVE LONG WORDS (BGR), MATCHING TRAP #15 TASK 80 PEN COLOR.
;   A LONG OF $00000000 IS TREATED AS "UNUSED" AND THAT PASS IS SKIPPED.
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

SPRITE_W        EQU     16
SPRITE_H        EQU     16
SPRITE_BYTES    EQU     SPRITE_W*SPRITE_H

EYE_WHITE       EQU     $00FFFFFF       ; WHITE
EYE_PUPIL       EQU     $00FF0000       ; DARK BLUE (ARCADE-STYLE PUPILS)

; --- DIRECTION INDEX ---------------------------------------------------------------------
; SPRITE TABLES INDEX DIRECTIONS AS: 0=LEFT, 1=UP, 2=RIGHT, 3=DOWN.
; DIR_TABLE MAPS A 4-BIT MOTION BITMASK (%0001..%1000) TO ITS DIRECTION INDEX.

DIR_TABLE       DC.B    0       ; %0000 (NONE -> DEFAULT LEFT)
                DC.B    0       ; %0001 LEFT
                DC.B    1       ; %0010 UP
                DC.B    0       ; %0011
                DC.B    2       ; %0100 RIGHT
                DC.B    0       ; %0101
                DC.B    0       ; %0110
                DC.B    0       ; %0111
                DC.B    3       ; %1000 DOWN
                DC.B    0       ; %1001
                DC.B    0       ; %1010
                DC.B    0       ; %1011
                DC.B    0       ; %1100
                DC.B    0       ; %1101
                DC.B    0       ; %1110
                DC.B    0       ; %1111
                DS.W    0

; --- SPRITE DATA (RAW 16x16 PALETTE INDICES) ---------------------------------------------

PAC_L0          INCBIN  "DATA/SPRITES/PACMAN_L0.bin"
                DS.W    0
PAC_L1          INCBIN  "DATA/SPRITES/PACMAN_L1.bin"
                DS.W    0
PAC_U0          INCBIN  "DATA/SPRITES/PACMAN_U0.bin"
                DS.W    0
PAC_U1          INCBIN  "DATA/SPRITES/PACMAN_U1.bin"
                DS.W    0
PAC_R0          INCBIN  "DATA/SPRITES/PACMAN_R0.bin"
                DS.W    0
PAC_R1          INCBIN  "DATA/SPRITES/PACMAN_R1.bin"
                DS.W    0
PAC_D0          INCBIN  "DATA/SPRITES/PACMAN_D0.bin"
                DS.W    0
PAC_D1          INCBIN  "DATA/SPRITES/PACMAN_D1.bin"
                DS.W    0

GHOST_B0_DATA   INCBIN  "DATA/SPRITES/GHOST_B0.bin"
                DS.W    0
GHOST_B1_DATA   INCBIN  "DATA/SPRITES/GHOST_B1.bin"
                DS.W    0

EYES_L_DATA     INCBIN  "DATA/SPRITES/EYES_L.bin"
                DS.W    0
EYES_U_DATA     INCBIN  "DATA/SPRITES/EYES_U.bin"
                DS.W    0
EYES_R_DATA     INCBIN  "DATA/SPRITES/EYES_R.bin"
                DS.W    0
EYES_D_DATA     INCBIN  "DATA/SPRITES/EYES_D.bin"
                DS.W    0

; --- LOOKUP TABLES ----------------------------------------------------------------------
; PACMAN_SPRITES : INDEXED BY (DIR*2 + FRAME). 4 DIRS * 2 FRAMES = 8 ENTRIES.

PACMAN_SPRITES  DC.L    PAC_L0,PAC_L1
                DC.L    PAC_U0,PAC_U1
                DC.L    PAC_R0,PAC_R1
                DC.L    PAC_D0,PAC_D1

GHOST_BODIES    DC.L    GHOST_B0_DATA,GHOST_B1_DATA

GHOST_EYES      DC.L    EYES_L_DATA,EYES_U_DATA,EYES_R_DATA,EYES_D_DATA

; --- PALETTES (3 LONGS EACH: PRIMARY, EYE WHITE, PUPIL) ---------------------------------
; PALETTE LONGS WITH VALUE 0 ARE SKIPPED BY SPRITE_DRAW.
; PAC_PALETTE LEAVES SECONDARY/TERTIARY ZERO BECAUSE PAC SPRITES ONLY USE PRIMARY.

PAC_PALETTE     DC.L    PACMAN_COLOR,0,0

BLINKY_PALETTE  DC.L    BLINKY_COLOR,EYE_WHITE,EYE_PUPIL
SPEEDY_PALETTE  DC.L    SPEEDY_COLOR,EYE_WHITE,EYE_PUPIL
BASHFUL_PALETTE DC.L    BASHFUL_COLOR,EYE_WHITE,EYE_PUPIL
POKEY_PALETTE   DC.L    POKEY_COLOR,EYE_WHITE,EYE_PUPIL

; ----------------------------------------------------------------------------------------
; SPRITE_DRAW : BLIT A 16x16 PALETTE-INDEXED SPRITE TO THE BACKBUFFER.
; FOR EACH NON-ZERO PALETTE ENTRY, ITERATES THE SPRITE AND PLOTS EVERY PIXEL WHOSE
; BYTE MATCHES THAT PALETTE INDEX.
;
; INPUT  : A0   - SPRITE DATA POINTER (256 BYTES)
;          A1   - PALETTE POINTER (3 LONGS)
;          D2.W - CENTER Y (AGENT-STYLE PIXEL COORDS)
;          D3.W - CENTER X
; OUTPUT : NONE. ALL REGISTERS PRESERVED VIA MOVEM.
; ----------------------------------------------------------------------------------------
SPRITE_DRAW
                MOVEM.L D0-D7/A0-A2,-(SP)

                AND.L   #$FFFF,D2                   ; CLEAN UPPER 16 BITS FOR TRAP #15
                AND.L   #$FFFF,D3
                SUB.W   #AGENT_RADIUS,D2            ; TOP Y  = CENTER Y - 8
                SUB.W   #AGENT_RADIUS,D3            ; LEFT X = CENTER X - 8

                MOVE.L  A0,A2                       ; A2 = SAVED SPRITE BASE PTR
                MOVE.L  D2,D5                       ; D5 = SAVED TOP Y
                MOVE.L  D3,D6                       ; D6 = SAVED LEFT X

                MOVEQ   #1,D7                       ; D7 = CURRENT PALETTE INDEX (1..3)

.COLOR_LOOP
                MOVE.W  D7,D0
                SUBQ.W  #1,D0
                LSL.W   #2,D0
                MOVE.L  (A1,D0.W),D1                ; D1 = PALETTE[INDEX-1] (PEN COLOR)
                BEQ     .SKIP_COLOR                 ; 0 -> UNUSED, SKIP PASS

                MOVE.B  #80,D0                      ; SET PEN COLOR
                TRAP    #15

                MOVE.L  A2,A0                       ; RESET SPRITE PTR
                MOVE.W  #SPRITE_H-1,D4              ; ROW COUNTER
                MOVE.L  D5,D2                       ; CURRENT Y

.ROW_LOOP
                MOVE.W  #SPRITE_W-1,D3              ; COL COUNTER
                MOVE.L  D6,D1                       ; CURRENT X
                MOVE.B  #82,D0                      ; PLOT PIXEL CMD

.COL_LOOP
                CMP.B   (A0)+,D7                    ; PIXEL MATCHES CURRENT COLOR?
                BNE     .NEXT_PIXEL
                TRAP    #15                         ; PLOT PIXEL (D1=X, D2=Y)
.NEXT_PIXEL
                ADDQ.W  #1,D1
                DBRA    D3,.COL_LOOP

                ADDQ.W  #1,D2
                DBRA    D4,.ROW_LOOP

.SKIP_COLOR
                ADDQ.W  #1,D7
                CMP.W   #4,D7
                BLT     .COLOR_LOOP

                MOVEM.L (SP)+,D0-D7/A0-A2
                RTS

; ----------------------------------------------------------------------------------------
; MOTION_TO_DIR : CONVERT A MOTION BITMASK TO A DIRECTION INDEX (0..3).
;
; INPUT  : D0.B - MOTION BITMASK (LEFT/UP/RIGHT/DOWN)
; OUTPUT : D0.W - DIRECTION INDEX (0=L, 1=U, 2=R, 3=D)
; ----------------------------------------------------------------------------------------
MOTION_TO_DIR
                MOVEM.L A0,-(SP)
                AND.W   #$F,D0
                LEA     DIR_TABLE,A0
                MOVE.B  (A0,D0.W),D0
                AND.W   #$F,D0
                MOVEM.L (SP)+,A0
                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
