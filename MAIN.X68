; ========================================================================================
; TITLE    : PAC-MAN
; AUTHOR   : JORDI VANYÓ MESTRE
; CREATION : 08-NOV-2023
; ========================================================================================

                ORG     $1000

; --- INCLUDES -------------------------------------------------------------------

                INCLUDE "LIB/STR.X68"
                INCLUDE "SYSTEM/SYSTEM.X68"
                INCLUDE "STATES/STATES.X68"

; --- INITIALIZE -------------------------------------------------------------------------

START
                ORI.W   #$0700,SR               ; DISABLE ALL INTERRUPTS

                JSR     SYSTEM_INIT
                JSR     STATE_INIT
                
; --- UPDATE -----------------------------------------------------------------------------

.LOOP
                TRAP    #KEYBOARD_TRAP
                JSR     STATE_UPDATE

; --- SYNCH ------------------------------------------------------------------------------

.WAIT_INT
                TST.B   (SCREEN_INT_CTR)        ; WAIT FOR INTERRUPT
                BEQ     .WAIT_INT
                CLR.B   (SCREEN_INT_CTR)

; --- PLOT -------------------------------------------------------------------------------

                JSR     STATE_PLOT
                TRAP    #SCREEN_TRAP

                BRA     .LOOP

                SIMHALT

                END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
