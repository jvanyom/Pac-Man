; ========================================================================================
; PAC-MAN MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

STARTING_ROW    EQU     27

PACMAN_WIDTH    EQU     TILE_WIDTH                              ; SAME OF TILE WIDTH
PACMAN_RADIUS   EQU     PACMAN_WIDTH>>1

PACMAN_INIT_X   EQU     (MAZE_WIDTH>>1)*TILE_WIDTH              ; HORIZONTAL TILES
PACMAN_INIT_Y   EQU     STARTING_ROW*TILE_WIDTH-PACMAN_RADIUS   ; VERTICAL TILES

PACMAN_SPEED    EQU     4                                       ; PIXELS

PACMAN_INIT_MOT EQU     0                                       ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

PACMAN_COLOR    EQU     $0000FFFF                               ; YELLOW

; --- VARIABLES --------------------------------------------------------------------------

PACMAN_X        DS.W    1
PACMAN_Y        DS.W    1

PACMAN_MOTION   DS.B    2

; ----------------------------------------------------------------------------------------
;  INITALIZATION : CALCULATES INITIAL POSITION
; ----------------------------------------------------------------------------------------
PACMAN_INIT
                MOVE.B  #PACMAN_INIT_MOT,(PACMAN_MOTION)

                MOVE.W  #PACMAN_INIT_X,(PACMAN_X)
                MOVE.W  #PACMAN_INIT_Y,(PACMAN_Y)
                
                RTS

; ----------------------------------------------------------------------------------------
;  UPDATES THE PACMAN : CHECKS IF THERE IS A WALL IN THE FACING DIRECTION
; ----------------------------------------------------------------------------------------
PACMAN_UPDATE
                MOVEM.L D0-D5/D7/A0,-(SP)

                LEA     MAZEDATA,A0

                MOVE.B  (PACMAN_MOTION),D0
                
.PRESSED        
                MOVE.B  D0,D4

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
                BRA     .CHECK_KEYBOARD

.NEXT           EQU     PACMAN_RADIUS+1

.LEFT
                SUB.W   #.NEXT,D1

                MOVE.W  D2,D5
                JSR     CAN_MOVE
                BNE     .CHECK_IS_TP
                
                BTST.L  #31,D0
                BNE     .MOVED
                
                SUB.W   #PACMAN_SPEED,(PACMAN_X)
                BRA     .MOVED

.UP
                SUB.W   #.NEXT,D2

                MOVE.W  D1,D5                
                JSR     CAN_MOVE
                BNE     .CHECK_IS_TP
                
                BTST.L  #31,D0
                BNE     .MOVED

                SUB.W   #PACMAN_SPEED,(PACMAN_Y)
                BRA     .MOVED

.RIGHT          
                ADD.W   #.NEXT,D1

                MOVE.W  D2,D5
                JSR     CAN_MOVE
                BNE     .CHECK_IS_TP
                
                BTST.L  #31,D0
                BNE     .MOVED

                ADD.W   #PACMAN_SPEED,(PACMAN_X)
                BRA     .MOVED

.DOWN                
                ADD.W   #.NEXT,D2

                MOVE.W  D1,D5
                JSR     CAN_MOVE
                BNE     .CHECK_IS_TP

                BTST.L  #31,D0
                BNE     .MOVED

                ADD.W   #PACMAN_SPEED,(PACMAN_Y)
                BRA     .MOVED
                
.CHECK_IS_TP
                MOVE.W  (PACMAN_X),D1
                MOVE.W  (PACMAN_Y),D2
                
                JSR     GET_TILE
                CMP.B   #TP_ID,D3
                BNE     .CHECK_KEYBOARD
                
                SUB.W   #SCREEN_WIDTH,D1
                BPL     .TELEPORT
                NEG.W   D1

.TELEPORT
                MOVE.W  D1,(PACMAN_X)
                
.MOVED
                MOVE.B  D4,(PACMAN_MOTION)
                
.CHECK_KEYBOARD
                LSL.L   #1,D0
                BCS     .END

                MOVE.B  (KEYBOARD_VALUE),D0
                BEQ     .END
                
                OR.L    #$80000000,D0
                BRA     .PRESSED

.END
                MOVEM.L (SP)+,D0-D5/D7/A0

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

; ----------------------------------------------------------------------------------------
;  CHECK IF PACMAN CAN MOVE IN THE SPECIFIED X & Y COORDINATES:
;
;       PAC-MAN CAN MOVE IF THE TILE ID IS 0 (EMPTY),1 (PELLET) OR 2 (TP) AND IF THE 
;       POSITION IS MULTIPLE OF 16 (TILE_WIDTH)
;
; FLAGS:
;       - Z=1 IF CAN MOVE
;       - Z=0 IF CAN NOT MOVE
; ----------------------------------------------------------------------------------------        
CAN_MOVE
                MOVEM.W D3/D5,-(SP)

                JSR     GET_TILE
                BLT.S   .END

                CMP.B   #TP_ID,D3
                BGT.S   .END

                ADD.W   #PACMAN_RADIUS,D5
                AND.W   #TILE_WIDTH-1,D5

.END
                MOVEM.W (SP)+,D3/D5

                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
