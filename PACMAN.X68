; ========================================================================================
; PAC-MAN MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

PACMAN_INIT_ROW EQU     27

PACMAN_INIT_MOT EQU     1           ; %1000=[DOWN] | %0100=[RIGHT] | %0010=[UP] | %0001=[LEFT] | 0=[NOT MOVING]

PACMAN_COLOR    EQU     $0000FFFF   ; YELLOW

; --- VARIABLES --------------------------------------------------------------------------

PACMAN_MOTION   DS.B    2

PACMAN_X        DS.W    1
PACMAN_Y        DS.W    1

; ----------------------------------------------------------------------------------------
;  INITALIZATION : CALCULATES INITIAL POSITION
; ----------------------------------------------------------------------------------------
PACMAN_INIT
                MOVE.B  #PACMAN_INIT_MOT,(PACMAN_MOTION)
                
                AGENT_DROP  PACMAN_X,PACMAN_Y,PACMAN_INIT_ROW

                RTS

; ----------------------------------------------------------------------------------------
;  UPDATES THE PACMAN : CHECKS IF THERE IS A WALL IN THE FACING DIRECTION
; ----------------------------------------------------------------------------------------
PACMAN_UPDATE
                MOVEM.L D0-D2/A0,-(SP)
                
                MOVE.B  (PACMAN_MOTION),D0
                LEA     PACMAN_X,A0
                JSR     AGENT_TRY2MOVE

.CHECK_KEYBOARD
                MOVE.B  (KEYBOARD_VALUE),D0         ; CHECK IF KEYBOARD IS PRESSED
                BEQ     .END
                
                CMP.B   (PACMAN_MOTION),D0          ; IF PRESSED MOTION IS THE SAME AS CURRENT, SKIP CHECKS
                BEQ     .END

                JSR     AGENT_CAN_MOVE              ; CHECK IF PACMAN CAN GO TO KEYBOARD MOTION
                BNE     .END
                
                MOVE.B  D0,(PACMAN_MOTION)

.END
                MOVEM.L (SP)+,D0-D2/A0

                RTS

; ----------------------------------------------------------------------------------------
;  PLOTS THE PACMAN
; ----------------------------------------------------------------------------------------
PACMAN_PLOT
                MOVEM.L D1-D3,-(SP)

                MOVE.L  #PACMAN_COLOR,D1
                MOVE.W  (PACMAN_Y),D2
                MOVE.W  (PACMAN_X),D3
                
                JSR     AGENT_PLOT
                
                MOVEM.L (SP)+,D1-D3

                RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
