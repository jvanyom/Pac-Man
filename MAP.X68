; ========================================================================================
;  MAP MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

MAP_MAZE_WIDTH  EQU     28                          ; TILES PER SCREEN HORIZONTALLY

MAP_MAZE_HEIGHT EQU     36                          ; TILES PER SCREEN VERTICALLY

MAP_TILE_WIDTH  EQU     8<<1

; ----------------------------------------------------------------------------------------
;  INITALIZATION
;
;  MODIFILES : A1, A2
; ----------------------------------------------------------------------------------------
MAP_INIT
                LEA     TEXTURES,A1
                LEA     MAPDATA,A2

                RTS

; ----------------------------------------------------------------------------------------
;  PLOTS THE MAP
; ----------------------------------------------------------------------------------------
MAP_PLOT
                MOVEM.L D0/D1/D5-D7/A0/A2,-(SP)

                MOVE.W  #MAP_MAZE_HEIGHT-1,D0       ; ROW ITERATOR
                CLR.W   D6                          ; INITIAL Y

.LOOP_Y
                MOVE.W  #MAP_MAZE_WIDTH-1,D1        ; COLUMN ITERATOR
                CLR.W   D5                          ; INITIAL X (REINIT AFTER EACH ROW)

.LOOP_X     
                MOVE.B  (A2)+,D7                    ; GET MAP CELL

                ROL.W   #2, D7                      ; TIMES 4 SINCE ADDRESSES ARE LONG
                MOVE.L  (A1,D7.W),A0                ; GET TEXTURE ADDRESS
                
                JSR     (A0)                        ; DRAW TEXTURE

                ADD.W   #MAP_TILE_WIDTH,D5          ; ADD 8 TO X
                DBRA.W  D1,.LOOP_X                  ; LOOP FOR ALL COLUMNS

                ADD.W   #MAP_TILE_WIDTH,D6          ; ADD 8 TO Y
                DBRA.W  D0,.LOOP_Y                  ; LOOP FOR ALL ROWS

                MOVEM.L (SP)+,D0/D1/D5-D7/A0/A2

                RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
