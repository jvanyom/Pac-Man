; ========================================================================================
; TITLE    : PAC-MAN
; AUTHOR   : JORDI VANYO MESTRE
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
                ; 1. INPUT HANDLING
                TRAP    #KEYBOARD_TRAP                  ; READ INPUT STATE

                ; 2. GAME LOGIC
                JSR     STATE_UPDATE                    ; UPDATE CURRENT STATE (INTRO OR GAME)

; --- SYNCH ------------------------------------------------------------------------------

.WAIT_INT
                ; 3. V-SYNC SYNCHRONIZATION
                ; WAIT FOR VERTICAL BLANK INTERRUPT TO ENSURE CONSTANT FRAMERATE (55/60Hz)
                ; THIS PREVENTS SCREEN TEARING AND SPEED ISSUES
                TST.B   (SCREEN_INT_CTR)        ; WAIT FOR INTERRUPT FLAG (SET BY ISR)
                BEQ     .WAIT_INT
                CLR.B   (SCREEN_INT_CTR)        ; ACKNOWLEDGE/RESET FLAG

; --- PLOT -------------------------------------------------------------------------------

                ; 4. RENDER
                JSR     STATE_PLOT                      ; DRAW SCENE TO BACKBUFFER
                TRAP    #SCREEN_TRAP                    ; FLUSH/FLIP BUFFERS (UPDATE VIDEO HARDWARE)

                BRA     .LOOP

                SIMHALT

                END     START
