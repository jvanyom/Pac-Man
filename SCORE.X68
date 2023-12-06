; ========================================================================================
; SCORE MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

PELLET_POINTS   EQU     50

STARTING_SCORE  EQU     0

SCORE_BG_COLOR  EQU     $00000000

SCORE_POSITION  EQU     $1001

; --- VARIABLES --------------------------------------------------------------------------

SCORE           DS.W    1

; ----------------------------------------------------------------------------------------
;  INITALIZATION : INITIAL SCORE
; ----------------------------------------------------------------------------------------
SCORE_INIT
                MOVE.W  #STARTING_SCORE,(SCORE)
                RTS

; ----------------------------------------------------------------------------------------
;  UPDATES SCORE : SUM POINTS IF PAC-MAN CROSSES PELLET TILES & CHANGE IT TO EMPTY TILES
; ----------------------------------------------------------------------------------------
SCORE_UPDATE
                MOVEM.L D1-D2/A0,-(SP)

                MOVE.W  (PACMAN_X),D1
                MOVE.W  (PACMAN_Y),D2
                
                JSR     GET_TILE_ADDRESS
                CMP.B   #PELLET_ID,(A0)
                BNE     .END
                
                MOVE.B  #EMPTY_ID,(A0)
                ADD.W   #PELLET_POINTS,(SCORE)

.END
                MOVEM.L (SP)+,D1-D2/A0

                RTS

; ----------------------------------------------------------------------------------------
;  PLOTS SCORE
; ----------------------------------------------------------------------------------------
SCORE_PLOT
                MOVE.L  #SCORE_BG_COLOR,D1      ; CHANGE FILL COLOR
                MOVE.B  #81,D0
                TRAP    #15
                
                MOVE.W  #SCORE_POSITION,D1      ; CHANGE TEXT POSITION
                MOVE.B  #11,D0
                TRAP    #15

                MOVE.W  (SCORE),D1              ; PLOT SCORE
                MOVE.B  #2,D2
                MOVE.B  #20,D0
                TRAP    #15

                RTS 


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
