; ========================================================================================
; BASHFUL GHOST MANAGEMENT (CYAN GHOST)
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

BASHFUL_INIT_ROW EQU     33
BASHFUL_INIT_COL EQU     35

BASHFUL_TARGET_X EQU     0
BASHFUL_TARGET_Y EQU     TILE_WIDTH*(MAZE_HEIGHT-1)

BASHFUL_INIT_MOT EQU     1           ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

BASHFUL_COLOR    EQU     $00FFFF00   ; CYAN


; --- VARIABLES --------------------------------------------------------------------------

BASHFUL_MOTION   DS.B    2

BASHFUL_X        DS.W    1
BASHFUL_Y        DS.W    1

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
BASHFUL_INIT
                MOVE.B  #BASHFUL_INIT_MOT,(BASHFUL_MOTION)
                
                AGENT_DROP  BASHFUL_X,BASHFUL_Y,BASHFUL_INIT_ROW,BASHFUL_INIT_COL

                RTS

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
BASHFUL_UPDATE
                MOVEM.L D0-D2/D5-D7/A0,-(SP)
                
                MOVE.W  (BASHFUL_X),D1
                MOVE.W  (BASHFUL_Y),D2
                
                ADD.W   #AGENT_RADIUS,D1
                AND.W   #TILE_WIDTH-1,D1
                BNE     .CONTINUE
                
                ADD.W   #AGENT_RADIUS,D2
                AND.W   #TILE_WIDTH-1,D2
                BNE     .CONTINUE                                   ; IF THE GHOST IS NOT IN THE CENTER OF THE TILE, JUST SKIP CHECKS
                
                ; BASHFUL POSITION IS THE CENTER OF A TILE
                
                MOVE.B  #16,D0                                      ; SHIFTER
                
                CMP.B   #CHASE,(GHOST_MODE)
                BEQ     .IS_CHASING
                
                ; SCATTING -> SHOULD FOLLOW FIXED TILE
                
                MOVE.L  #BASHFUL_TARGET_Y<<16|BASHFUL_TARGET_X,D7     ; TARGET  Y | TARGET  X
                BRA     .CHECK_MOTION
.IS_CHASING
                ; CHASING -> SHOULD FOLLOW PACMAN
              
                MOVE.W  (PACMAN_Y),D7                               ; PACMAN Y
                LSL.L   D0,D7
                OR.W    (PACMAN_X),D7                               ; PACMAN X
                
.CHECK_MOTION
                MOVE.B  (BASHFUL_MOTION),D5
                LEA     BASHFUL_X,A0
                JSR     GHOST_NEXT_MOTION
                
                MOVE.B  D5,(BASHFUL_MOTION)

.CONTINUE
                MOVE.B  (BASHFUL_MOTION),D0
                LEA     BASHFUL_X,A0
                JSR     AGENT_TRY2MOVE

                MOVEM.L (SP)+,D0-D2/D5-D7/A0
                RTS

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
BASHFUL_PLOT
                MOVEM.L D1-D3,-(SP)

                MOVE.L  #BASHFUL_COLOR,D1
                MOVE.W  (BASHFUL_Y),D2
                MOVE.W  (BASHFUL_X),D3
                JSR     AGENT_PLOT
                
                MOVEM.L (SP)+,D1-D3

                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
