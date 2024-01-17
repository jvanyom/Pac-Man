; ========================================================================================
; INTRO SCREEN
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

IMAGE_WIDTH     EQU     411
IMAGE_HEIGHT    EQU     68

INITIAL_Y       EQU     SCREEN_HEIGHT>>2
INITIAL_X       EQU     (SCREEN_WIDTH>>1)-(IMAGE_WIDTH>>1)

; --- VARIABLES --------------------------------------------------------------------------

IMAGE           INCBIN  "DATA/INTRO_IMAGE.bin"
                DS.W    0
          
; ----------------------------------------------------------------------------------------
; INIT INTRO SCREEN
; ----------------------------------------------------------------------------------------
INTRO_INIT
                RTS
      
; ----------------------------------------------------------------------------------------
; UPDATE INTRO SCREEN : CHECK IF ANY KEY IS PRESSED
; ----------------------------------------------------------------------------------------
INTRO_UPDATE
                MOVEM.L D0-D1,-(SP)
                
                TST.B   (KEYBOARD_VALUE)
                BEQ     .END
                
                MOVE.W  #1,(STATE_NEXT)         ; SWAP TO GAME
            
.END
                MOVEM.L (SP)+,D0-D1
                RTS

; ----------------------------------------------------------------------------------------
; PLOT INTRO SCREEN
; ----------------------------------------------------------------------------------------
INTRO_PLOT
                MOVEM.L D1-D2/A0,-(SP)

                BSR     PLOT_TITLE
                
                BTST.B  #4,(SCREEN_CYC_CTR)
                BEQ     .END
                
                MOVE.L  #$00FFFFFF,D1
                LEA     .TXT1,A0
                MOVE.B  #.TXT_ROW,D0
                JSR     STRPRINT

.END
                MOVEM.L (SP)+,D1-D2/A0
                RTS
.TXT_ROW        EQU     30
.TXT1           DC.B    'PRESS ANY ARROW KEY TO START',0
                DS.W    0

; ----------------------------------------------------------------------------------------
; PLOT PAC-MAN TITLE IMAGE IN THE MIDDLE OF THE SCREEN
; ----------------------------------------------------------------------------------------
PLOT_TITLE
                MOVEM.L D0-D4/A0,-(SP)

                MOVE.L  #PACMAN_COLOR,D1
                MOVE.B  #80,D0
                TRAP    #15                         ; SET PEN WITH PACMAN_COLOR
                
                MOVE.B  #82,D0
                LEA     IMAGE,A0

                MOVE.W  #IMAGE_HEIGHT-1,D4          ; ROW ITERATOR
                MOVE.W  #INITIAL_Y,D2               ; Y

.LOOP_Y
                MOVE.W  #IMAGE_WIDTH-1,D3           ; COLUMN ITERATOR
                MOVE.W  #INITIAL_X,D1               ; X

.LOOP_X         
                TST.B   (A0)+
                BEQ     .CONTINUE                   ; IF PIXEL IS BLACK, SKIP DRAWING
                
                TRAP    #15                         ; DRAW YELLOW PIXEL
.CONTINUE
                ADDQ.W  #1,D1
                DBRA.W  D3,.LOOP_X

                ADDQ.W  #1,D2
                DBRA.W  D4,.LOOP_Y
                
                MOVEM.L (SP)+,D0-D4/A0
                RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
