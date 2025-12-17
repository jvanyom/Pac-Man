; ========================================================================================
; SCORE MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

PELLET_POINTS   EQU     10

MAX_POINTS      EQU     376*PELLET_POINTS

STARTING_SCORE  EQU     0

SCORE_BG_COLOR  EQU     $00000000
SCORE_COLOR     EQU     $00FFFFFF

SCORE_POSITION  EQU     $0F01

; --- VARIABLES --------------------------------------------------------------------------

SCORE           DS.W    1
PELLET_SOUND    DS.L    1

; ----------------------------------------------------------------------------------------
;  INITALIZATION : INITIAL SCORE
; ----------------------------------------------------------------------------------------
SCORE_INIT
                MOVE.W  #STARTING_SCORE,(SCORE)
                MOVE.L  #MUNCH1_SND<<16|MUNCH2_SND,(PELLET_SOUND)
                RTS

; ----------------------------------------------------------------------------------------
;  UPDATES SCORE : SUM POINTS IF PAC-MAN CROSSES PELLET TILES & CHANGE IT TO EMPTY TILES
;  1. CHECKS MAX SCORE (WIN CONDITION)
;  2. GETS CURRENT PACMAN TILE
;  3. IF TILE IS PELLET -> PLAY SOUND, CLEAR TILE, ADD SCORE
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SCORE_UPDATE
                MOVEM.L D1-D2/A0,-(SP)
                
                CMP.W   #MAX_POINTS,(SCORE)
                BEQ     .WIN

                MOVE.W  (PACMAN_X),D1
                MOVE.W  (PACMAN_Y),D2
                
                JSR     GET_TILE
                CMP.B   #PELLET_ID,(A0)
                BNE     .END
                
                JSR     PLAY_MUNCH
                
                MOVE.B  #EMPTY_ID,(A0)
                ADD.W   #PELLET_POINTS,(SCORE)
                BRA     .END
                
.WIN
                MOVE.L  #300,D1
                MOVE.B  #23,D0
                TRAP    #15

                MOVE.W  #0,(STATE_NEXT)

.END
                MOVEM.L (SP)+,D1-D2/A0

                RTS

; ----------------------------------------------------------------------------------------
;  PLOTS SCORE
;  DRAWS THE HUD AND THE NUMERIC SCORE VALUE
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SCORE_PLOT      
                MOVEM.L D0-D2/A1,-(SP)
                
                CMP.W   #MAX_POINTS,(SCORE)
                BEQ     .WIN

                MOVE.L  #SCORE_COLOR,D1         ; CHANGE TEXT COLOR
                MOVE.B  #21,D0
                TRAP    #15
                
                MOVE.L  #SCORE_BG_COLOR,D1      ; CHANGE BG COLOR
                MOVE.B  #81,D0
                TRAP    #15
                
                CLR.L   D1
                
                MOVE.W  #SCORE_POSITION,D1      ; CHANGE TEXT POSITION
                MOVE.B  #11,D0
                TRAP    #15

                MOVE.W  (SCORE),D1              ; PLOT SCORE
                MOVE.B  #3,D0
                TRAP    #15
                BRA     .END

.WIN
                MOVE.L  #PACMAN_COLOR,D1
                MOVE.B  #21,D0
                TRAP    #15                 ; RED AS FOREGROUND COLOR
                
                CLR.L   D1
                MOVE.B  #81,D0
                TRAP    #15

                LEA     .WIN_TXT,A1
                MOVE.W  #TILE_WIDTH*18+4,D1
                MOVE.W  #TILE_WIDTH*20+1,D2
                MOVE.B  #95,D0
                TRAP    #15
            
.END
                MOVEM.L (SP)+,D0-D2/A1
                RTS
.WIN_TXT        DC.B    'YOU WON!',0
                DS.W    0
                
PLAY_MUNCH
                MOVE.L  D7,-(SP)

                MOVE.L  (PELLET_SOUND),D7
                TRAP    #SOUND_TRAP
                
                SWAP.W  D7
                
                MOVE.L  D7,(PELLET_SOUND)
                
                MOVE.L  (SP)+,D7

                RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
