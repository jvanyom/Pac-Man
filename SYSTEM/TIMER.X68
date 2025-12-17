; ========================================================================================
; TIMER MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

FREQUENCY       EQU     1000    ; EVERY SECOND
TIMER_IRQ       EQU     2

; --- VARIABLES --------------------------------------------------------------------------

TIMER           DS.W    1

; ----------------------------------------------------------------------------------------   
;  INITIALIZES THE MFP TIMER
;  SETS UP A 1-SECOND INTERVAL INTERRUPT FOR GAME TIMING
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
TIMER_INIT
                MOVEM.L D0-D3,-(SP)

                MOVE.L  #TIMER_ISR,($60+TIMER_IRQ*4)        ; INSTALL ISR

                MOVE.B  #%10000000|TIMER_IRQ,D2             ; ENABLE AUTO-IRQ
                MOVE.L  #FREQUENCY,D3
                MOVE.B  #6,D1
                MOVE.B  #32,D0
                TRAP    #15
                
                CLR.W   (TIMER)
                
                MOVEM.L (SP)+,D0-D3

                RTS

; ----------------------------------------------------------------------------------------   
;  TIMER INTERRUPT SERVICE ROUTINE
;  INCREMENTS THE GLOBAL TIMER EVERY SECOND
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
TIMER_ISR       
                ADDQ.W  #1,(TIMER)
                RTE


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
