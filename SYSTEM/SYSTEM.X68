; ========================================================================================
;  SYSTEM MANAGEMENT (SYSTEM CODE)
; ========================================================================================

                INCLUDE "SYSTEM/SCREEN.X68"
                INCLUDE "SYSTEM/KEYBOARD.X68"
                INCLUDE "SYSTEM/SOUND.X68"
                INCLUDE "SYSTEM/TIMER.X68"

; ----------------------------------------------------------------------------------------
;  INITIALIZES THE SYSTEM: SCREEN & KEYBOARD
; ----------------------------------------------------------------------------------------
SYSTEM_INIT
                JSR     SCREEN_INIT
                JSR     KEYBOARD_INIT
                JSR     SOUND_INIT
                JSR     TIMER_INIT

                MOVE.W  SR,-(SP)
                ANDI.W  #$D8FF,(SP)                ; SWITCH TO USER & ENABLE INTERRUPTS

                RTE








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
