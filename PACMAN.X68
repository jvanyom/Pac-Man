; ========================================================================================
; PAC-MAN MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

PACMAN_WIDTH    EQU     MAP_TILE_WIDTH                          ; SAME OF TILE WIDTH
PACMAN_RADIUS   EQU     PACMAN_WIDTH>>1

PACMAN_INIT_X   EQU     14*MAP_TILE_WIDTH                       ; HORIZONTAL TILES
PACMAN_INIT_Y   EQU     27*MAP_TILE_WIDTH-PACMAN_RADIUS         ; VERTICAL TILES

PACMAN_INIT_SPD EQU     4                                       ; PIXELS

PACMAN_INIT_MOT EQU     1                                       ; START MOVING TO LEFT (1000=DOWN | 0100=RIGHT | 0010=UP | 0001=LEFT)

PACMAN_COLOR    EQU     $0000FFFF                               ; YELLOW

; --- VARIABLES --------------------------------------------------------------------------

PACMAN_X        DC.W    1
PACMAN_Y        DC.W    1

PACMAN_MOTION   DC.B    1
                
PACMAN_SPEED    DC.B    1

; ----------------------------------------------------------------------------------------
;  INITALIZATION : CALCULATES INITIAL POSITION
; ----------------------------------------------------------------------------------------
PACMAN_INIT
                MOVE.B  #PACMAN_INIT_SPD,(PACMAN_SPEED)
                MOVE.B  #PACMAN_INIT_MOT,(PACMAN_MOTION)

                MOVE.W  #PACMAN_INIT_X,(PACMAN_X)
                MOVE.W  #PACMAN_INIT_Y,(PACMAN_Y)
                
                RTS

; ----------------------------------------------------------------------------------------
;  UPDATES THE PACMAN : CHECKS IF THERE IS A WALL IN THE FACING DIRECTION
; ----------------------------------------------------------------------------------------
PACMAN_UPDATE
                MOVEM.L D0-D4/A0,-(SP)
                
                LEA     MAPDATA,A0
                
                MOVE.B  (PACMAN_SPEED),D7
                MOVE.B  (PACMAN_MOTION),D0
                
                MOVE.W  (PACMAN_X),D1
                MOVE.W  (PACMAN_Y),D2

                LSR.B   #1,D0
                BCS     .LEFT
                LSR.B   #1,D0
                BCS     .UP
                LSR.B   #1,D0
                BCS     .RIGHT
                LSR.B   #1,D0
                BCS     .DOWN
                BRA     .END

.LEFT
                SUB.W   #PACMAN_RADIUS+1,D1

                JSR     CAN_MOVE
                BNE     .END

                SUB.W   D7,(PACMAN_X)
                BRA     .END

.UP
                SUB.W   #PACMAN_RADIUS+1,D2

                JSR     CAN_MOVE
                BNE     .END
                
                SUB.W   D7,(PACMAN_Y)
                BRA     .END

.RIGHT
                ADD.W   #PACMAN_RADIUS+1,D1

                JSR     CAN_MOVE
                BNE     .END

                ADD.W   D7,(PACMAN_X)
                BRA     .END

.DOWN
                ADD.W   #PACMAN_RADIUS+1,D2

                JSR     CAN_MOVE
                BNE     .END

                ADD.W   D7,(PACMAN_Y)
                BRA     .END
                
.END
                MOVE.B  (KEYBOARD_VALUE),D0
                BEQ     .NOT_PRESSED
                
                MOVE.B  D0,D4
                
                LSR.B   #1,D0
                BCS     .HORIZONTAL
                LSR.B   #1,D0
                BCS     .VERTICAL
                LSR.B   #1,D0
                BCS     .HORIZONTAL
                LSR.B   #1,D0
                BCS     .VERTICAL
                BRA     .NOT_PRESSED
                
.HORIZONTAL
                MOVE.W  (PACMAN_Y),D1
                ADD.W   #PACMAN_RADIUS,D1
                
                MOVE.W  #MAP_TILE_WIDTH-1,D2
                AND.W   D2,D1
                
                BNE     .NOT_PRESSED
                
                MOVE.B  D4,(PACMAN_MOTION)
                
                BRA     .NOT_PRESSED
                
.VERTICAL
                MOVE.W  (PACMAN_X),D1
                ADD.W   #PACMAN_RADIUS,D1
                
                MOVE.W  #MAP_TILE_WIDTH-1,D2
                AND.W   D2,D1
                
                BNE     .NOT_PRESSED
                
                MOVE.B  D4,(PACMAN_MOTION)
                
.NOT_PRESSED          
                MOVEM.L (SP)+,D0-D4/A0

                RTS

; ----------------------------------------------------------------------------------------
;  PLOTS THE PACMAN
; ----------------------------------------------------------------------------------------
PACMAN_PLOT
                MOVEM.W D0-D4,-(SP)

                MOVE.W  #PACMAN_COLOR,D1

                MOVE.B  #80,D0                  ; CHANGE BORDER COLOR
                TRAP    #15

                MOVE.B  #81,D0                  ; CHANGE FILL COLOR
                TRAP    #15

                MOVE.W  (PACMAN_X),D1           ; LEFT X
                MOVE.W  (PACMAN_Y),D2           ; UPPER Y
                
                SUBQ.W  #PACMAN_RADIUS,D1
                SUBQ.W  #PACMAN_RADIUS,D2

                MOVE.W  D1,D3                   ; RIGHT X (CURRENT X POSITION + WIDTH)
                ADD.W   #PACMAN_WIDTH,D3

                MOVE.W  D2,D4                   ; LOWER Y (CURRENT Y POSITION + WIDTH)
                ADD.W   #PACMAN_WIDTH,D4

                MOVE.B  #88,D0                  ; DRAW ELLIPSE BOUNDED BY PREVIOUS RECTANGLE PARAMS
                TRAP    #15

                MOVEM.W (SP)+,D0-D4

                RTS
                
CAN_MOVE
                MOVEM.W D1-D2,-(SP)

                DIVU.W  #MAP_TILE_WIDTH,D1
                DIVU.W  #MAP_TILE_WIDTH,D2

                MULU.W  #MAP_MAZE_WIDTH,D2

                ADD.W   D1,D2

                MOVE.B  (A0,D2.W),D2
                
                MOVEM.W (SP)+,D1-D2

                RTS











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
