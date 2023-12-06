; ========================================================================================
;  MAZE MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

MAZE_WIDTH      EQU     40                          ; TILES PER SCREEN HORIZONTALLY

MAZE_HEIGHT     EQU     36                          ; TILES PER SCREEN VERTICALLY

TILE_WIDTH      EQU     16
TILE_RADIUS     EQU     TILE_WIDTH>>1

; ----------------------------------------------------------------------------------------
;  PLOTS THE MAP
; ----------------------------------------------------------------------------------------
MAZE_PLOT
                MOVEM.L D0-D1/D5-D7/A0-A2,-(SP)
                
                LEA     TEXTURES,A1
                LEA     MAZEDATA,A2

                MOVE.W  #MAZE_HEIGHT-1,D0           ; ROW ITERATOR
                CLR.W   D6                          ; INITIAL Y

.LOOP_Y
                MOVE.W  #MAZE_WIDTH-1,D1            ; COLUMN ITERATOR
                CLR.W   D5                          ; INITIAL X (REINIT AFTER EACH ROW)

.LOOP_X     
                MOVE.B  (A2)+,D7                    ; GET MAP CELL

                ROL.W   #2, D7                      ; TIMES 4 SINCE ADDRESSES ARE LONG
                MOVE.L  (A1,D7.W),A0                ; GET TEXTURE ADDRESS
                
                JSR     (A0)                        ; DRAW TEXTURE

                ADD.W   #TILE_WIDTH,D5              ; ADD WIDTH TO X
                DBRA.W  D1,.LOOP_X                  ; LOOP FOR ALL COLUMNS

                ADD.W   #TILE_WIDTH,D6              ; ADD WIDTH TO Y
                DBRA.W  D0,.LOOP_Y                  ; LOOP FOR ALL ROWS

                MOVEM.L (SP)+,D0-D1/D5-D7/A0-A2

                RTS

; ----------------------------------------------------------------------------------------
;  GET TILE ADDRESS BY X & Y COORDINATES
;
;  INPUT        : D1 - X
;                 D2 - Y
;
;  MODIFILES    : A0 - TILE ADDRESS
; ----------------------------------------------------------------------------------------                
GET_TILE_ADDRESS
                MOVEM.L D1-D2,-(SP)

                DIVU.W  #TILE_WIDTH,D1
                DIVU.W  #TILE_WIDTH,D2
                MULU.W  #MAZE_WIDTH,D2
                ADD.W   D1,D2
                
                LEA     MAZEDATA,A0
                ADDA.L  D2,A0
                
                MOVEM.L (SP)+,D1-D2

                RTS

; ----------------------------------------------------------------------------------------
;  GET TILE ID BY X & Y COORDINATES
;
;  INPUT        : D1 - X
;                 D2 - Y
;
;  MODIFILES    : D3 - TILE ID
; ----------------------------------------------------------------------------------------             
GET_TILE
                MOVE.L  A0,-(SP)

                JSR     GET_TILE_ADDRESS

                MOVE.B  (A0),D3

                MOVE.L  (SP)+,A0

                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
