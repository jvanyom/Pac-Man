; ========================================================================================
; AGENT MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

AGENT_WIDTH     EQU     TILE_WIDTH                              ; SAME OF TILE WIDTH
AGENT_RADIUS    EQU     AGENT_WIDTH>>1

AGENT_SPEED     EQU     4

LEFT            EQU     %0001
UP              EQU     %0010
RIGHT           EQU     %0100
DOWN            EQU     %1000

; ----------------------------------------------------------------------------------------
; 'MOVES' CONSTANT REFERS TO HOW AND WHAT VARIABLE IT HAVE TO MODIFY TO MOVE IN THE FACING 
; DIRECTION.
;
; LEFT  -> NEAGTIVE X
; UP    -> NEGATIVE Y
; RIGHT -> POSITIVE X
; DOWN  -> POSITIVE Y
;
; WE HAVE 'NEG', 'POS', 'X' AND 'Y' AS AUXILIARY CONSTANTS TO HELP UNDERSTAND THE MOTIONS.
; ----------------------------------------------------------------------------------------
NEG             EQU     %10
POS             EQU     %00
X               EQU     %0
Y               EQU     %1


MOVES           EQU     ((NEG+X)<<4|LEFT)<<24|((NEG+Y)<<4|UP)<<16|((POS+X)<<4|RIGHT)<<8|((POS+Y)<<4|DOWN)

; --- MACROS -----------------------------------------------------------------------------

AGENT_DROP      MACRO
                MOVE.W  #\3*TILE_WIDTH-AGENT_RADIUS,(\2)

                IFNE NARG-4
                    MOVE.W  #(MAZE_WIDTH>>1)*TILE_WIDTH+AGENT_SPEED,(\1)
                    MEXIT
                ENDC
                
                MOVE.W  #\4*TILE_WIDTH-AGENT_RADIUS,(\1)
                ENDM

; ----------------------------------------------------------------------------------------
; TRY TO MOVE AN AGENT TO DESIRED MOTION
;
; INPUT  : D0.B : MOTION
;          A0   : X AND Y IN THE CONSECUTIVE WORD
;
; ----------------------------------------------------------------------------------------
AGENT_TRY2MOVE
                MOVEM.L D1-D2/A0-A1,-(SP)
                
                MOVE.W  (A0),D1
                MOVE.W  2(A0),D2
                
                ADD.W   #AGENT_RADIUS,D1
                AND.W   #TILE_WIDTH-1,D1
                BNE     .MOVE
                
                ADD.W   #AGENT_RADIUS,D2
                AND.W   #TILE_WIDTH-1,D2
                BNE     .MOVE                          ; IF AGENT IS NOT IN THE CENTER OF THE TILE, SKIPS CHECKS AND JUST MOVE
                
                ; PACMAN POSITION IS THE CENTER OF A TILE
                
                JSR     AGENT_CAN_MOVE
                BNE     .CHECK_IF_TP
                
.MOVE
                JSR     AGENT_MOVE
                BRA     .END
                
.CHECK_IF_TP
                MOVE.L  A0,A1
                MOVE.W  (A0),D1
                MOVE.W  2(A0),D2
                JSR     GET_TILE
                
                CMP.B   #TP_ID,(A0)
                BNE     .END
                
                SUB.W   #SCREEN_WIDTH,D1
                BPL     .TELEPORT
                NEG.W   D1
.TELEPORT
                MOVE.W  D1,(A1)

.END
                MOVEM.L (SP)+,D1-D2/A0-A1
                RTS

; ----------------------------------------------------------------------------------------
; PLOT AGENT AS A CIRCLE
;
; INPUT : D1.L : COLOR
;         D2.W : Y
;         D3.W : X
;
; ----------------------------------------------------------------------------------------
AGENT_PLOT
                MOVEM.L D0-D4,-(SP)

                MOVE.B  #80,D0                  ; CHANGE BORDER COLOR
                TRAP    #15

                MOVE.B  #81,D0                  ; CHANGE FILL COLOR
                TRAP    #15
                
                CLR.L   D1
                MOVE.W  D3,D1                   ; LEFT X
                
                SUBQ.W  #AGENT_RADIUS,D1
                SUBQ.W  #AGENT_RADIUS,D2

                MOVE.W  D1,D3                   ; RIGHT X (CURRENT X POSITION + WIDTH)
                ADD.W   #AGENT_WIDTH,D3

                MOVE.W  D2,D4                   ; LOWER Y (CURRENT Y POSITION + WIDTH)
                ADD.W   #AGENT_WIDTH,D4

                MOVE.B  #88,D0                  ; DRAW ELLIPSE BOUNDED BY PREVIOUS RECTANGLE PARAMS
                TRAP    #15

                MOVEM.L (SP)+,D0-D4

                RTS

; ----------------------------------------------------------------------------------------
; CHECK IF AGENT CAN MOVE IN THE DESIRED MOTION
;
; INPUT  : D0.B  : MOTION
;          A0    : CURRENT X AND Y IN THE CONSECUTIVE WORD
;
; OUTPUT : FLAGS : Z=0 IF CANNOT MOVE
;        : D1.W  : NEXT POSSIBLE X
;        : D2.W  : NEXT POSSIBLE Y
;         
; ----------------------------------------------------------------------------------------
                
AGENT_CAN_MOVE
.NEXT           EQU     AGENT_RADIUS+1

                MOVEM.L D0/D3-D7/A0,-(SP)

                MOVE.L  #MOVES,D7
                CLR.W   D6                  ; X=%00 & Y=%10

.LOOP
                MOVE.B  D7,D4

                AND.B   D0,D4
                BEQ     .CONTINUE

                LSR.B   #5,D7
                ROXL.W  #2,D6               ; X OR Y
                
                MOVE.W  (A0,D6.W),D5        ; AXIS TO CHECK
                
                LSR.B   #1,D7               ; NEGATIVE OR POSITIVE
                BCS     .NEGATIVE
                
                ADD.W   #.NEXT,D5
                BRA     .CHECK_IF_MOVE
                
.NEGATIVE
                SUB.W   #.NEXT,D5
                BRA     .CHECK_IF_MOVE
                
.CONTINUE
                LSR.L   #8,D7
                BRA     .LOOP
                
.CHECK_IF_MOVE
                TST.W   D6
                BEQ     .X_MODIFIED
                
                ; Y MODIFIED
                
                MOVE.W  (A0),D1
                MOVE.W  D1,D3
                MOVE.W  D5,D2

                BRA     .GET_TILE
                
.X_MODIFIED
                MOVE.W  D5,D1
                MOVE.W  2(A0),D2
                MOVE.W  D2,D3
                
.GET_TILE
                JSR     GET_TILE

                MOVE.B  (A0),D0
                BLT.S   .END

                CMP.B   #TP_ID,D0
                BGT.S   .END
                
                ADD.W   #AGENT_RADIUS,D3
                AND.W   #TILE_WIDTH-1,D3

.END
                MOVEM.L (SP)+,D0/D3-D7/A0
                RTS

; ----------------------------------------------------------------------------------------
; MOVE AGENT IN THE DESIRED MOTION
;
; INPUT  : D0.B : MOTION
;          A0   : CURRENT X AND Y IN THE CONSECUTIVE WORD
; ----------------------------------------------------------------------------------------
AGENT_MOVE
                MOVEM.L D1-D4,-(SP)

                MOVE.L  #MOVES,D1           ; MOVES
                CLR.W   D3                  ; 0=X & 1=Y

.LOOP
                MOVE.B  D1,D2

                AND.B   D0,D2
                BEQ     .CONTINUE

                LSR.B   #5,D1
                ROXL.W  #2,D3               ; X OR Y
                
                LSR.B   #1,D1               ; NEGATIVE OR POSITIVE
                BCS     .NEGATIVE
                
                ADD.W   #AGENT_SPEED,(A0, D3.W)
                BRA     .END
                
.NEGATIVE
                SUB.W   #AGENT_SPEED,(A0,D3.W)
                BRA     .END
                
.CONTINUE
                LSR.L   #8,D1
                BRA     .LOOP
                
.END
                MOVEM.L (SP)+,D1-D4
                RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
