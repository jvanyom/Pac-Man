
; ========================================================================================
; SOUND MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

SOUND_TRAP      EQU     2

START_SND       EQU     0
MUNCH1_SND      EQU     1
MUNCH2_SND      EQU     2
EAT_GHOST_SND   EQU     3
DEATH1_SND      EQU     4
DEATH2_SND      EQU     5

; ----------------------------------------------------------------------------------------
;  LOADS ALL FOREGROUND SOUNDS INTO SOUND PERIPHERAL MEMORY
;  ITERATES THROUGH THE .SOUNDS LIST AND UPLOADS THEM VIA IOCS TRAP
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SOUND_INIT
                MOVEM.L D0-D1/A0-A1,-(SP)

                MOVE.L  #SOUND_PLAY,($80+SOUND_TRAP*4)      ; INSTALL TRAP
                
                CLR.B   D1
                LEA     .SOUNDS,A0
.LOOP                
                MOVE.L  (A0)+,D0
                BEQ     .DONE
                
                MOVE.L  D0,A1
                MOVE.B  #71,D0
                TRAP    #15                                 ; LOAD SOUND
                
                ADDQ.B  #1,D1
                BRA     .LOOP
.DONE
                MOVEM.L (SP)+,D0-D1/A0-A1
                RTS
                
.START_SND      DC.B    'SOUND/START.wav',0
.MUNCH1_SND     DC.B    'SOUND/MUNCH1.wav',0
.MUNCH2_SND     DC.B    'SOUND/MUNCH2.wav',0
.EAT_GHOST_SND  DC.B    'SOUND/EAT_GHOST.wav',0
.DEATH1_SND     DC.B    'SOUND/DEATH1.wav',0
.DEATH2_SND     DC.B    'SOUND/DEATH2.wav',0
                DS.W    0

.SOUNDS         DC.L    .START_SND,.MUNCH1_SND,.MUNCH2_SND,.EAT_GHOST_SND,.DEATH1_SND,.DEATH2_SND,0

; ----------------------------------------------------------------------------------------
;  PLAY FOREGROUND
;  STOPS CURRENTLY PLAYING SOUNDS AND TRIGGERS A NEW ONE
;
;  INPUT    : D7.B : SOUND ID ( SEE CONSTANTS )
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SOUND_PLAY
                MOVEM.W D0-D2,-(SP)
                
                MOVE.L  #3,D2
                MOVE.B  #76,D0
                TRAP    #15                 ; STOP ALL SOUNDS

                MOVE.B  D7,D1
                MOVE.B  #72,D0
                TRAP    #15                 ; PLAY DESIRED SOUND

                MOVEM.W (SP)+,D0-D2

                RTE


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
