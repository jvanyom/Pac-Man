; ========================================================================================
; SPEEDY GHOST MANAGEMENT (PINK GHOST)
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

SPEEDY_INIT_ROW EQU     9
SPEEDY_INIT_COL EQU     11

SPEEDY_TARGET_X EQU     0
SPEEDY_TARGET_Y EQU     0

SPEEDY_INIT_MOT EQU     1           ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

SPEEDY_COLOR    EQU     $00CBC0FF   ; PINK


; --- VARIABLES --------------------------------------------------------------------------

SPEEDY_MOTION   DS.B    2

SPEEDY_X        DS.W    1
SPEEDY_Y        DS.W    1

; ----------------------------------------------------------------------------------------
; SPEEDY INIT
; SETS STARTING POSITION AND MOTION
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SPEEDY_INIT
                MOVE.B  #SPEEDY_INIT_MOT,(SPEEDY_MOTION)
                
                AGENT_DROP  SPEEDY_X,SPEEDY_Y,SPEEDY_INIT_ROW,SPEEDY_INIT_COL

                RTS

; ----------------------------------------------------------------------------------------
; SPEEDY UPDATE
; 1. CHECKS IF ALIGNED WITH TILE CENTER
; 2. DETERMINES TARGET:
;    - SCATTER: TOP-LEFT CORNER
;    - CHASE: PACMAN POSITION
; 3. CALLS GHOST_NEXT_MOTION TO DECIDE NEXT MOVE
; 4. EXECUTES AGENT_TRY2MOVE
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SPEEDY_UPDATE
                MOVEM.L D0-D2/D5-D7/A0,-(SP)
                
                MOVE.W  (SPEEDY_X),D1
                MOVE.W  (SPEEDY_Y),D2
                
                ADD.W   #AGENT_RADIUS,D1
                AND.W   #TILE_WIDTH-1,D1
                BNE     .CONTINUE
                
                ADD.W   #AGENT_RADIUS,D2
                AND.W   #TILE_WIDTH-1,D2
                BNE     .CONTINUE                                   ; IF THE GHOST IS NOT IN THE CENTER OF THE TILE, JUST SKIP CHECKS
                
                ; SPEEDY POSITION IS THE CENTER OF A TILE
                
                MOVE.B  #16,D0                                      ; SHIFTER
                
                CMP.B   #CHASE,(GHOST_MODE)
                BEQ     .IS_CHASING
                
                ; SCATTING -> SHOULD FOLLOW FIXED TILE
                
                MOVE.L  #SPEEDY_TARGET_Y<<16|SPEEDY_TARGET_X,D7     ; TARGET  Y | TARGET  X
                BRA     .CHECK_MOTION
.IS_CHASING
                ; CHASING -> SHOULD FOLLOW PACMAN
              
                MOVE.W  (PACMAN_Y),D7                               ; PACMAN Y
                LSL.L   D0,D7
                OR.W    (PACMAN_X),D7                               ; PACMAN X
                
.CHECK_MOTION
                MOVE.B  (SPEEDY_MOTION),D5
                LEA     SPEEDY_X,A0
                JSR     GHOST_NEXT_MOTION
                
                MOVE.B  D5,(SPEEDY_MOTION)

.CONTINUE
                MOVE.B  (SPEEDY_MOTION),D0
                LEA     SPEEDY_X,A0
                JSR     AGENT_TRY2MOVE

                MOVEM.L (SP)+,D0-D2/D5-D7/A0
                RTS

; ----------------------------------------------------------------------------------------
; SPEEDY PLOT
; DRAWS PINK GHOST SPRITE: BODY (ANIM-FRAMED) + EYES (FACING SPEEDY_MOTION).
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SPEEDY_PLOT
                MOVEM.L D0-D3/A0-A1,-(SP)

                ; --- BODY ---
                CLR.W   D1
                BTST.B  #3,(SCREEN_CYC_CTR)
                BEQ     .NO_FRAME
                MOVEQ   #1,D1
.NO_FRAME
                LSL.W   #2,D1
                LEA     GHOST_BODIES,A0
                MOVE.L  (A0,D1.W),A0
                LEA     SPEEDY_PALETTE,A1
                MOVE.W  (SPEEDY_Y),D2
                MOVE.W  (SPEEDY_X),D3
                JSR     SPRITE_DRAW

                ; --- EYES ---
                MOVE.B  (SPEEDY_MOTION),D0
                JSR     MOTION_TO_DIR
                LSL.W   #2,D0
                LEA     GHOST_EYES,A0
                MOVE.L  (A0,D0.W),A0
                LEA     SPEEDY_PALETTE,A1
                MOVE.W  (SPEEDY_Y),D2
                MOVE.W  (SPEEDY_X),D3
                JSR     SPRITE_DRAW

                MOVEM.L (SP)+,D0-D3/A0-A1

                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
