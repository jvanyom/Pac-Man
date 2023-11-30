; ========================================================================================
; METHODS TO DRAW TEXTURES DEPENDING ON THE TILE TYPE
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

EMPTY_COLOR     EQU     $00000000               ; BLACK
WALL_COLOR      EQU     $00FF0000               ; BLUE

; --- LIST OF POINTERS TO PICTURES -------------------------------------------------------

TEXTURES        DC.L    .EMPTY,.WALL

.EMPTY
                MOVEM.L D0-D4,-(SP)

                MOVE.L  #EMPTY_COLOR,D1

                MOVE.B  #80,D0                 ; CHANGE PEN COLOR
                TRAP    #15

                MOVE.B  #81,D0                 ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.B  #87,D0                 ; PLOT RECTANGLE

                MOVE.L  D5,D1
                MOVE.L  D6,D2

                MOVE.W  #MAP_TILE_WIDTH,D3
                ADD.W   D5,D3

                MOVE.W  #MAP_TILE_WIDTH,D4
                ADD.W   D6,D4

                TRAP    #15

                MOVEM.L (SP)+,D0-D4

                RTS

.WALL
                MOVEM.L D0-D4,-(SP)

                MOVE.L  #WALL_COLOR,D1

                MOVE.B  #80,D0                 ; CHANGE PEN COLOR
                TRAP    #15

                MOVE.B  #81,D0                 ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.B  #87,D0                 ; PLOT RECTANGLE

                MOVE.L  D5,D1                  ; LEFT X
                MOVE.L  D6,D2                  ; UPPER Y

                MOVE.W  #MAP_TILE_WIDTH,D3     ; RIGHT X
                ADD.W   D5,D3

                MOVE.W  #MAP_TILE_WIDTH,D4     ; LOWER Y
                ADD.W   D6,D4

                TRAP    #15

                MOVEM.L (SP)+,D0-D4

                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
