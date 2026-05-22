; ========================================================================================
; BLINKY GHOST MANAGEMENT (RED GHOST)
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

BLINKY_INIT_ROW EQU     5
BLINKY_INIT_COL EQU     35

BLINKY_TARGET_X EQU     TILE_WIDTH*(MAZE_WIDTH-2)
BLINKY_TARGET_Y EQU     0

BLINKY_INIT_MOT EQU     1           ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

BLINKY_COLOR    EQU     $000000FF   ; RED


; --- VARIABLES --------------------------------------------------------------------------

BLINKY_MOTION   DS.B    2

BLINKY_X        DS.W    1
BLINKY_Y        DS.W    1

; ----------------------------------------------------------------------------------------
; BLINKY_INIT
; Initializes Blinky's position and initial motion.
; ----------------------------------------------------------------------------------------
BLINKY_INIT
                MOVE.B  #BLINKY_INIT_MOT,(BLINKY_MOTION)
                
                AGENT_DROP  BLINKY_X,BLINKY_Y,BLINKY_INIT_ROW,BLINKY_INIT_COL

                RTS

; ----------------------------------------------------------------------------------------
; BLINKY UPDATE
; 1. CHECKS IF ALIGNED WITH TILE CENTER
; 2. DETERMINES TARGET:
;    - SCATTER: TOP-RIGHT CORNER
;    - CHASE: PACMAN POSITION
; 3. CALLS GHOST_NEXT_MOTION TO DECIDE NEXT MOVE
; 4. EXECUTES AGENT_TRY2MOVE
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
BLINKY_UPDATE
                MOVEM.L D0-D2/D5-D7/A0,-(SP)
                
                MOVE.W  (BLINKY_X),D1
                MOVE.W  (BLINKY_Y),D2
                
                ADD.W   #AGENT_RADIUS,D1
                AND.W   #TILE_WIDTH-1,D1
                BNE     .CONTINUE
                
                ADD.W   #AGENT_RADIUS,D2
                AND.W   #TILE_WIDTH-1,D2
                BNE     .CONTINUE                                   ; IF THE GHOST IS NOT IN THE CENTER OF THE TILE, JUST SKIP CHECKS
                
                ; BLINKY POSITION IS THE CENTER OF A TILE
                
                MOVE.B  #16,D0                                      ; SHIFTER
                
                CMP.B   #CHASE,(GHOST_MODE)
                BEQ     .IS_CHASING
                
                ; SCATTING -> SHOULD FOLLOW FIXED TILE
                
                MOVE.L  #BLINKY_TARGET_Y<<16|BLINKY_TARGET_X,D7     ; TARGET  Y | TARGET  X
                BRA     .CHECK_MOTION
.IS_CHASING
                ; CHASING -> SHOULD FOLLOW PACMAN
              
                MOVE.W  (PACMAN_Y),D7                               ; PACMAN Y
                LSL.L   D0,D7
                OR.W    (PACMAN_X),D7                               ; PACMAN X
                
.CHECK_MOTION
                MOVE.B  (BLINKY_MOTION),D5
                LEA     BLINKY_X,A0
                JSR     GHOST_NEXT_MOTION
                
                MOVE.B  D5,(BLINKY_MOTION)

.CONTINUE
                MOVE.B  (BLINKY_MOTION),D0
                LEA     BLINKY_X,A0
                JSR     AGENT_TRY2MOVE

                MOVEM.L (SP)+,D0-D2/D5-D7/A0
                RTS

; ----------------------------------------------------------------------------------------
; BLINKY PLOT
; DRAWS RED GHOST SPRITE: BODY (ANIM-FRAMED) + EYES (FACING BLINKY_MOTION).
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
BLINKY_PLOT
                MOVEM.L D0-D3/A0-A1,-(SP)

                ; --- BODY ---
                CLR.W   D1                          ; D1 = ANIM FRAME (0 OR 1)
                BTST.B  #3,(SCREEN_CYC_CTR)
                BEQ     .NO_FRAME
                MOVEQ   #1,D1
.NO_FRAME
                LSL.W   #2,D1
                LEA     GHOST_BODIES,A0
                MOVE.L  (A0,D1.W),A0
                LEA     BLINKY_PALETTE,A1
                MOVE.W  (BLINKY_Y),D2
                MOVE.W  (BLINKY_X),D3
                JSR     SPRITE_DRAW

                ; --- EYES ---
                MOVE.B  (BLINKY_MOTION),D0
                JSR     MOTION_TO_DIR               ; D0 = DIR INDEX (0..3)
                LSL.W   #2,D0
                LEA     GHOST_EYES,A0
                MOVE.L  (A0,D0.W),A0
                LEA     BLINKY_PALETTE,A1
                MOVE.W  (BLINKY_Y),D2
                MOVE.W  (BLINKY_X),D3
                JSR     SPRITE_DRAW

                MOVEM.L (SP)+,D0-D3/A0-A1

                RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
