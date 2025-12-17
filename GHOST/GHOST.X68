; ========================================================================================
; GHOSTS MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

CHASE           EQU     %001
SCATTER         EQU     %010
FRIGHTENED      EQU     %100

SCATTER_TIME    EQU     7       ; SECONDS
CHASE_TIME      EQU     20      ; SECONDS

; --- VARIABLES --------------------------------------------------------------------------

GHOST_MODE      DS.B    1
                DS.W    0

; --- INCLUDES ---------------------------------------------------------------------------

                INCLUDE "GHOST/AI.X68"
                INCLUDE "GHOST/BLINKY.X68"
                INCLUDE "GHOST/SPEEDY.X68"
                INCLUDE "GHOST/BASHFUL.X68"
                INCLUDE "GHOST/POKEY.X68"

; ----------------------------------------------------------------------------------------
; INITIALIZE ALL GHOSTS
; ----------------------------------------------------------------------------------------
GHOST_INIT
                CLR.W   (TIMER)
                MOVE.B  #CHASE,(GHOST_MODE)
                
                JSR     BLINKY_INIT
                JSR     SPEEDY_INIT
                JSR     BASHFUL_INIT
                BRA     POKEY_INIT

; ----------------------------------------------------------------------------------------
; UPDATES ALL GHOSTS
; MANAGES THE GLOBAL SCATTER/CHASE TIMER:
; - SCATTER: 7 SECONDS
; - CHASE: 20 SECONDS
; SWITCHES GHOST_MODE FLAG WHEN TIMER EXPIRES
;
; INPUT    : NONE
; OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
GHOST_UPDATE
                CMP.B   #CHASE,(GHOST_MODE)
                BEQ     .IS_CHASING
                
                ; SCATTING

                CMP.W   #SCATTER_TIME,(TIMER)
                BNE     .END

                CLR.W   (TIMER)
                MOVE.B  #CHASE,(GHOST_MODE)
                BRA     .END

.IS_CHASING
                CMP.W   #CHASE_TIME,(TIMER)
                BNE     .END

                CLR.W   (TIMER)
                MOVE.B  #SCATTER,(GHOST_MODE)

.END      
                JSR     BLINKY_UPDATE
                JSR     SPEEDY_UPDATE
                JSR     BASHFUL_UPDATE
                BRA     POKEY_UPDATE

; ----------------------------------------------------------------------------------------
; PLOTS ALL GHOSTS
; ----------------------------------------------------------------------------------------
GHOST_PLOT
                JSR     BLINKY_PLOT
                JSR     SPEEDY_PLOT
                JSR     BASHFUL_PLOT
                BRA     POKEY_PLOT






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
