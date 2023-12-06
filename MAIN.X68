; ========================================================================================
; TITLE    : PAC-MAN
; AUTHOR   : PERE ANTONI PRATS i JORDI VANYÓ
; CREATION : 08-NOV-2023
; ========================================================================================

                ORG     $1000

; --- SYSTEM INCLUDES ----------------------------------------------------------------------

                INCLUDE "SYSTEM/SYSTEM.X68"     ; SYSTEM CODE
                
; --- DATA INCLUDES ----------------------------------------------------------------------

                INCLUDE "DATA/TEXTURES.X68"     ; TEXTURES DATA
                INCLUDE "DATA/MAZEDATA.X68"     ; MAZE DATA
                
; --- CODE INCLUDES ----------------------------------------------------------------------
                
                INCLUDE "MAZE.X68"              ; MAZE MANAGEMENT
                INCLUDE "PACMAN.X68"            ; PACMAN MANAGEMENT
                INCLUDE "SCORE.X68"             ; SCORE MANAGEMENT                

; --- INITIALIZE -------------------------------------------------------------------------

START
                ORI.W   #$0700, SR              ; DISABLE ALL INTERRUPTS

                JSR     SYSTEM_INIT

                JSR     PACMAN_INIT
                JSR     SCORE_INIT
                
; --- UPDATE -----------------------------------------------------------------------------

.LOOP
                TRAP    #KEYBOARD_TRAP
                JSR     PACMAN_UPDATE
                JSR     SCORE_UPDATE

; --- SYNCH ------------------------------------------------------------------------------

.WAIT_INT
                TST.B   (SCREEN_INT_CTR)        ; WAIT FOR INTERRUPT
                BEQ     .WAIT_INT
                CLR.B   (SCREEN_INT_CTR)

; --- PLOT -------------------------------------------------------------------------------

                JSR     MAZE_PLOT
                JSR     PACMAN_PLOT
                JSR     SCORE_PLOT

                TRAP    #SCREEN_TRAP

                BRA     .LOOP

                SIMHALT

                END     START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
