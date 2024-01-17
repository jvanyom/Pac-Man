; ========================================================================================
; POKEY GHOST MANAGEMENT (ORANGE GHOST)
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

POKEY_INIT_ROW EQU     28
POKEY_INIT_COL EQU     7

POKEY_TARGET_X EQU     TILE_WIDTH*(MAZE_WIDTH-2)
POKEY_TARGET_Y EQU     TILE_WIDTH*(MAZE_HEIGHT-1)

POKEY_INIT_MOT EQU     1           ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

POKEY_COLOR    EQU     $0000C3FF   ; ORANGE

; --- VARIABLES --------------------------------------------------------------------------

POKEY_MOTION   DS.B    2

POKEY_X        DS.W    1
POKEY_Y        DS.W    1

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
POKEY_INIT
                MOVE.B  #POKEY_INIT_MOT,(POKEY_MOTION)
                
                AGENT_DROP  POKEY_X,POKEY_Y,POKEY_INIT_ROW,POKEY_INIT_COL

                RTS

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
POKEY_UPDATE
                MOVEM.L D0-D2/D5-D7/A0,-(SP)
                
                MOVE.W  (POKEY_X),D1
                MOVE.W  (POKEY_Y),D2
                
                ADD.W   #AGENT_RADIUS,D1
                AND.W   #TILE_WIDTH-1,D1
                BNE     .CONTINUE
                
                ADD.W   #AGENT_RADIUS,D2
                AND.W   #TILE_WIDTH-1,D2
                BNE     .CONTINUE                                   ; IF THE GHOST IS NOT IN THE CENTER OF THE TILE, JUST SKIP CHECKS
                
                ; POKEY POSITION IS THE CENTER OF A TILE
                
                MOVE.B  #16,D0                                      ; SHIFTER
                
                CMP.B   #CHASE,(GHOST_MODE)
                BEQ     .IS_CHASING
                
                ; SCATTING -> SHOULD FOLLOW FIXED TILE
                
                MOVE.L  #POKEY_TARGET_Y<<16|POKEY_TARGET_X,D7     ; TARGET  Y | TARGET  X
                BRA     .CHECK_MOTION
.IS_CHASING
                ; CHASING -> SHOULD FOLLOW PACMAN
              
                MOVE.W  (PACMAN_Y),D7                               ; PACMAN Y
                LSL.L   D0,D7
                OR.W    (PACMAN_X),D7                               ; PACMAN X
                
.CHECK_MOTION
                MOVE.B  (POKEY_MOTION),D5
                LEA     POKEY_X,A0
                JSR     GHOST_NEXT_MOTION
                
                MOVE.B  D5,(POKEY_MOTION)

.CONTINUE
                MOVE.B  (POKEY_MOTION),D0
                LEA     POKEY_X,A0
                JSR     AGENT_TRY2MOVE

                MOVEM.L (SP)+,D0-D2/D5-D7/A0
                RTS

; ----------------------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------------------
POKEY_PLOT
                MOVEM.L D1-D3,-(SP)

                MOVE.L  #POKEY_COLOR,D1
                MOVE.W  (POKEY_Y),D2
                MOVE.W  (POKEY_X),D3
                JSR     AGENT_PLOT
                
                MOVEM.L (SP)+,D1-D3

                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
