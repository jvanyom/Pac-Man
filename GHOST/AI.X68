; ========================================================================================
; ARTIFICIAL INTELLIGENCE
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

NEXT        EQU     AGENT_RADIUS+1

MAX_CHECKS  EQU     3

; --- VARIABLES --------------------------------------------------------------------------

MOTIONS     DC.W    LEFT<<8|RIGHT,UP<<8|DOWN,RIGHT<<8|LEFT,DOWN<<8|UP

; ----------------------------------------------------------------------------------------
; GET NEXT GHOST MOTION BASED ON DISTANCE TO TARGET TILE COORDINATES
;
; INPUT  : D5.B : MOTION
;          A0   : GHOST X AND Y IN THE CONSECUTIVE WORD
;
;
;          D7.L : 31-16 : TARGET Y
;                 15-0  : TARGET X
;
; OUTPUT : D5.B : NEXT MOTION
; ----------------------------------------------------------------------------------------
GHOST_NEXT_MOTION
                MOVEM.L D0-D4/D6-D7/A0-A1,-(SP)

                LEA     MOTIONS,A1

                MOVE.W  #MAX_CHECKS-1,D1

                MOVE.B  D5,D3               ; MOTION WITH MIN DISTANCE
                MOVE.W  #$7FFF,D4           ; MIN DISTANCE INTIALIZED WITH MAX POSITVE VALUE

.LOOP
                MOVE.W  (A1)+,D0            ; MOTION

                CMP.B   D5,D0
                BEQ     .LOOP               ; CHECK IF DISCARTED DIRECTION IS THE CURRENT ITERATION
                
                LSR.W   #8,D0
                
                MOVE.W  D1,-(SP)
                
                JSR     AGENT_CAN_MOVE
                BNE     .RESTORE_D1         ; CHECK IF GHOST CAN MOVE IN DESIRED DIRECTION
                
                MOVEM.L  D6-D7,-(SP)
                
                MOVE.W  D2,D6               ; NEXT POSSIBLE Y
                SWAP    D6
                MOVE.W  D1,D6               ; NEXT POSSIBLE X
                
                JSR     CHEBYSHOV           ; CALCULATE CHEBYSHOV DISTANCE TO TARGET
                
                CMP.W   D7,D4
                BLT     .RESTORE_D6D7       ; CHECK IF CURRENT DISTANCE IS LESS THAN THE RECENTLY CALCULATED
                
                MOVE.W  D7,D4               ; IF CALCULATED DISTANCE IS LOWER, OVERRIDE IT
                MOVE.B  D0,D3               ; SAVE NEXT MOTION

.RESTORE_D6D7   MOVEM.L (SP)+,D6-D7
.RESTORE_D1     MOVE.W  (SP)+,D1   
.CONTINUE       DBRA    D1,.LOOP
                
                MOVE.B  D3,D5

                MOVEM.L (SP)+,D0-D4/D6-D7/A0-A1

                RTS

; ----------------------------------------------------------------------------------------
; GET CHEBYSHOV DISTANCE BETWEEN TWO POINTS
;
; INPUT  : D6.L : 31-16 : CURRENT Y
;                 15-0  : CURRENT X
;
;          D7.L : 31-16 : TARGET Y
;                 15-0  : TARGET X
;
; OUTPUT : D7.W : DISTANCE
; ----------------------------------------------------------------------------------------
CHEBYSHOV
                MOVEM.L D1-D4/D6,-(SP)

                MOVE.W  D6,D1
                MOVE.W  D7,D2

                SUB.W   D1,D2
                BPL     .POSITIVE_X
                NEG.W   D2

.POSITIVE_X
                SWAP    D6
                MOVE.W  D6,D3

                SWAP    D7
                MOVE.W  D7,D4

                SUB.W   D3,D4
                BPL     .POSITIVE_Y
                NEG.W   D4

.POSITIVE_Y
                CLR.L   D7

                CMP.W   D2,D4
                BGT     .GREATER_Y

                MOVE.W  D2,D7
                BRA     .END
.GREATER_Y
                MOVE.W  D4,D7

.END
                MOVEM.L (SP)+,D1-D4/D6
                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
