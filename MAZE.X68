; ========================================================================================
;  MAZE MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

MAZE_WIDTH      EQU     40                          ; TILES PER SCREEN HORIZONTALLY
MAZE_HEIGHT     EQU     36                          ; TILES PER SCREEN VERTICALLY

MAZE_BYTES      EQU     MAZE_WIDTH*MAZE_HEIGHT

TILE_WIDTH      EQU     16
TILE_RADIUS     EQU     TILE_WIDTH>>1

; --- VARIABLES --------------------------------------------------------------------------
MAZE_FILE       DC.B    'DATA/MAZEDATA.bin',0
MAZEDATA        DS.B    MAZE_BYTES
                DS.W    0

; ----------------------------------------------------------------------------------------
; INIT MAZE : LOAD IT FROM BINARY FILE
; ----------------------------------------------------------------------------------------
MAZE_INIT
                MOVEM.L D0-D2/A1,-(SP)

                LEA     MAZE_FILE,A1
                MOVE.B  #51,D0
                TRAP    #15
                
                LEA     MAZEDATA,A1
                MOVE.L  #MAZE_BYTES,D2
                MOVE.B  #53,D0
                TRAP    #15
                
                MOVEM.L (SP)+,D0-D2/A1
                RTS

; ----------------------------------------------------------------------------------------
; PLOTS THE MAZE
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
;  INPUT        : D1.W - X
;                 D2.W - Y
;
;  MODIFILES    : A0 - TILE ADDRESS
; ----------------------------------------------------------------------------------------                
GET_TILE
                MOVEM.L D1-D2,-(SP)

                DIVU.W  #TILE_WIDTH,D1
                DIVU.W  #TILE_WIDTH,D2
                MULU.W  #MAZE_WIDTH,D2
                ADD.W   D1,D2
                
                LEA     MAZEDATA,A0
                ADDA.L  D2,A0
                
                MOVEM.L (SP)+,D1-D2

                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
