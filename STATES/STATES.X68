; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; --- INCLUDES ----------------------------------------------------------------

                INCLUDE "STATES/INTRO.X68"
                INCLUDE "STATES/GAME.X68"

; --- CONSTATNS ---------------------------------------------------------------

STATE_NONE      EQU     -1                              ; NON-EXISTENT STATE

; --- VARIABLES ---------------------------------------------------------------

STATE_CURRENT   DS.W    1
STATE_NEXT      DS.W    1

STARTED         DS.B    2

; -----------------------------------------------------------------------------
; INITALIZES THE STATE MANAGER
; RESETS STATE VARIABLES AND FLAGS
;
; INPUT    : NONE
; OUTPUT   : NONE
; -----------------------------------------------------------------------------
STATE_INIT
                MOVE.W  #STATE_NONE,(STATE_CURRENT)
                CLR.W   (STATE_NEXT)
                CLR.B   (STARTED)

                RTS

; -----------------------------------------------------------------------------
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; HANDLES:
; 1. STARTUP SEQUENCE (MUSIC + DELAY)
; 2. STATE TRANSITIONS (DETECT CHANGE -> RUN OLD STATE INIT)
; 3. CURRENT STATE UPDATE (RUN UPDATE FUNCTION POINTER)
;
; INPUT    : NONE
; OUTPUT   : NONE
; -----------------------------------------------------------------------------
STATE_UPDATE
                MOVEM.L D0/D7/A0/A6,-(SP)
                
                TST.B   (STARTED)
                BEQ     .CONTINUE
                
                MOVE.B  #START_SND,D7
                TRAP    #SOUND_TRAP             ; PLAY INTRO MUSIC
                
                MOVE.L  #420,D1
                MOVE.B  #23,D0
                TRAP    #15                     ; DELAY
                
                CLR.B   (STARTED)
                
.CONTINUE
                CLR.L   D0
                MOVE.W  (STATE_NEXT),D0
                CMP.W   (STATE_CURRENT),D0
                BEQ     .DO_UPDATE

                MOVE.W  D0,(STATE_CURRENT)             ; IF STATE CHANGED, DO INIT
                LSL.L   #2,D0
                MOVE.L  D0,A0
                LEA     .INIT_TABLE,A6
                MOVE.L  (A0,A6.L),A0
                JSR     (A0)
                
                CMP.W   #1,(STATE_CURRENT)
                BNE     .DO_UPDATE
                
                MOVE.B  #1,(STARTED)

.DO_UPDATE      
                CLR.L   D0                              ; IN ANY CASE, DO UPDATE
                MOVE.W  (STATE_CURRENT),D0
                LSL.L   #2,D0
                MOVE.L  D0,A0
                LEA     .UPDATE_TABLE,A6
                MOVE.L  (A0,A6.L),A0
                JSR     (A0)

                MOVEM.L (SP)+,D0/D7/A0/A6
                RTS
.INIT_TABLE     DC.L    INTRO_INIT,GAME_INIT
.UPDATE_TABLE   DC.L    INTRO_UPDATE,GAME_UPDATE

; -----------------------------------------------------------------------------
; PERFORMS STATE PLOT
; EXECUTES THE DRAWING ROUTINE FOR THE CURRENT ACTIVE STATE
;
; INPUT    : NONE
; OUTPUT   : NONE
; -----------------------------------------------------------------------------
STATE_PLOT
                MOVEM.L D0/A0/A6,-(SP)
                
                CLR.L   D0
                MOVE.W  (STATE_CURRENT),D0
                LSL.L   #2,D0
                MOVE.L  D0,A0
                LEA     .PLOT_TABLE,A6
                MOVE.L  (A0,A6.L),A0
                
                JSR     (A0)

.END
                MOVEM.L (SP)+,D0/A0/A6
                RTS
.PLOT_TABLE     DC.L    INTRO_PLOT,GAME_PLOT

; -----------------------------------------------------------------------------
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; -----------------------------------------------------------------------------
EMPTY_STATE
                RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
