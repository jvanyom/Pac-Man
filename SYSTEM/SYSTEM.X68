; ========================================================================================
;  SYSTEM MANAGEMENT (SYSTEM CODE)
; ========================================================================================

                INCLUDE "SYSTEM/SCREEN.X68"         ; SCREEN MANAGEMENT
                INCLUDE "SYSTEM/KEYBOARD.X68"       ; KEYBOARD MANAGEMENT

; ----------------------------------------------------------------------------------------
;  INITIALIZES THE SYSTEM: SCREEN & KEYBOARD
; ----------------------------------------------------------------------------------------
SYSTEM_INIT
                JSR     SCREEN_INIT                 ; INIT SCREEN
                JSR     KEYBOARD_INIT               ; INIT KEYBOARD

                MOVE.W  SR, -(SP)
                ANDI.W  #$D8FF, (SP)                ; SWITCH TO USER & ENABLE INTERRUPTS

                RTE

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
