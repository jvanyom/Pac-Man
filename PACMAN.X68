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
;  UPDATES THE PACMAN : CHECK IF THERE IS A WALL IN THE FACING DIRECTION
;  ALSO POLLS KEYBOARD FOR NEW DIRECTION REQUESTS
;
;  INPUT    : NONE
;  OUTPUT   : NONE
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
;  PICKS A 16x16 SPRITE BY FACING (DIR FROM PACMAN_MOTION) AND ANIMATION FRAME
;  (SCREEN_CYC_CTR BIT 3 -> ~8-FRAME PERIOD MOUTH OPEN/CLOSED).
; ----------------------------------------------------------------------------------------
PACMAN_PLOT
                MOVEM.L D0-D3/A0-A1,-(SP)

                MOVE.B  (PACMAN_MOTION),D0          ; D0 = MOTION BITMASK
                JSR     MOTION_TO_DIR               ; D0 = DIR INDEX (0..3)

                CLR.W   D1                          ; D1 = ANIM FRAME (0 OR 1)
                BTST.B  #3,(SCREEN_CYC_CTR)
                BEQ     .NO_FRAME
                MOVEQ   #1,D1
.NO_FRAME
                LSL.W   #1,D0                       ; DIR * 2
                ADD.W   D1,D0                       ; + FRAME
                LSL.W   #2,D0                       ; * 4 (LONG OFFSET)
                LEA     PACMAN_SPRITES,A0
                MOVE.L  (A0,D0.W),A0                ; A0 = SPRITE DATA PTR

                LEA     PAC_PALETTE,A1
                MOVE.W  (PACMAN_Y),D2
                MOVE.W  (PACMAN_X),D3
                JSR     SPRITE_DRAW

                MOVEM.L (SP)+,D0-D3/A0-A1

                RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
