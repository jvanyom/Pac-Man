; ========================================================================================
; METHODS TO DRAW TEXTURES DEPENDING ON THE TILE TYPE
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

WALL_COLOR      EQU     $00FF0000               ; BLUE
PELLET_COLOR    EQU     $00FFFFFF               ; WHITE
DOOR_COLOR      EQU     $00FFC0CB               ; PINK

PELLET_RADIUS   EQU     2
PELLET_WIDTH    EQU     PELLET_RADIUS<<1

EMPTY_ID        EQU     0
PELLET_ID       EQU     1
TP_ID           EQU     2
WALL_ID         EQU     3
DOOR_ID         EQU     4


; --- LIST OF POINTERS TO PICTURES -------------------------------------------------------

TEXTURES        DC.L    .EMPTY,.PELLET,.TP,.WALL,.DOOR

.TP
.EMPTY          RTS
                
.PELLET
                MOVEM.L D0-D4,-(SP)

                MOVE.L  #PELLET_COLOR,D1
                MOVE.B  #80,D0                              ; CHANGE PEN COLOR
                TRAP    #15

                MOVE.B  #81,D0                              ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.B  #88,D0                              ; PLOT CIRCLE

                MOVEQ.L #TILE_RADIUS-PELLET_RADIUS,D1
                ADD.L   D5,D1                               ; LEFT X

                MOVEQ.L #TILE_RADIUS-PELLET_RADIUS,D2
                ADD.L   D6,D2                               ; UPPER Y

                MOVEQ.L #TILE_RADIUS+PELLET_RADIUS,D3
                ADD.L   D5,D3                               ; RIGHT X

                MOVEQ.L #TILE_RADIUS+PELLET_RADIUS,D4
                ADD.L   D6,D4                               ; LOWER Y

                TRAP    #15

                MOVEM.L (SP)+,D0-D4

                RTS

.WALL
                MOVEM.L D0-D4,-(SP)

                MOVE.L  #WALL_COLOR,D1

                MOVE.B  #80,D0                  ; CHANGE PEN COLOR
                TRAP    #15

                MOVE.B  #81,D0                  ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.B  #87,D0                  ; PLOT RECTANGLE

                MOVE.L  D5,D1                   ; LEFT X
                MOVE.L  D6,D2                   ; UPPER Y

                MOVE.L  #TILE_WIDTH,D3          ; RIGHT X
                ADD.L   D5,D3

                MOVE.L  #TILE_WIDTH,D4          ; LOWER Y
                ADD.L   D6,D4

                TRAP    #15

                MOVEM.L (SP)+,D0-D4

                RTS
                
.DOOR
                MOVEM.L D0-D4,-(SP)

                MOVE.L  #DOOR_COLOR,D1

                MOVE.B  #80,D0                  ; CHANGE PEN COLOR
                TRAP    #15

                MOVE.B  #81,D0                  ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.B  #87,D0                  ; PLOT RECTANGLE

                MOVE.L  D5,D1                   ; LEFT X
                ADDQ.L  #1,D1
                
                MOVE.L  D6,D2                   ; UPPER Y

                MOVE.L  #TILE_WIDTH,D3          ; RIGHT X
                ADD.L   D5,D3

                MOVE.L  #2,D4
                ADD.L   D6,D4                   ; LOWER Y

                TRAP    #15

                MOVEM.L (SP)+,D0-D4
                
                RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
