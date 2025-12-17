; ========================================================================================
; SCREEN MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

SCREEN_WIDTH    EQU     640                                     ; SCREEN WIDTH (PX)
SCREEN_HEIGHT   EQU     576                                     ; SCREEN HEIGHT (PX)

SCREEN_TRAP     EQU     1                                       ; SCREEN REFRESH TRAP
SCREEN_IRQ      EQU     1                                       ; SCREEN INTERRUPT NUMBER
SCREEN_TIMER    EQU     20                                      ; SCREEN TIMER (MS)
                                                                ;   20 MS ~ 50 FPS

; --- VARIABLES --------------------------------------------------------------------------

SCREEN_INT_CTR  DS.B    1                                       ; INTERRUPT COUNTER/FLAG
SCREEN_CYC_CTR  DS.B    1                                       ; CYCLE COUNTER

; ----------------------------------------------------------------------------------------
;  INITIALIZES THE SCREEN
;
;  - SETS RESOLUTION TO 640x576
;  - SETS WINDOWED MODE
;  - INITIALIZES DOUBLE BUFFERING (VISIBLE AND HIDDEN PAGE)
;  - ENABLES INTERRUPTS (VBL)
;
;  INPUT    : NONE
;  OUTPUT   : NONE
;  MODIFIES : D0-D3, HARDWARE REGISTERS
; ----------------------------------------------------------------------------------------
SCREEN_INIT
                MOVEM.L D0-D3,-(SP)

                MOVE.L  #SCREEN_UPDATE,($80+SCREEN_TRAP*4)      ; INSTALL TRAP

                MOVE.L  #SCREEN_WIDTH<<16|SCREEN_HEIGHT,D1      ; SET RESOLUTION
                MOVE.B  #33,D0
                TRAP    #15

                MOVE.L  #1,D1                                   ; SET WINDOWED MODE
                TRAP    #15

                MOVE.W  #$FF00,D1                               ; CLEAR VISIBLE BUFFER
                MOVE.B  #11,D0
                TRAP    #15

                MOVE.B  #17,D1                                  ; ENABLE DOUBLE BUFFER
                MOVE.B  #92,D0
                TRAP    #15

                MOVE.W  #$FF00,D1                               ; CLEAR HIDDEN BUFFER
                MOVE.B  #11,D0
                TRAP    #15

                MOVE.L  #SCREEN_ISR,($60+SCREEN_IRQ*4)          ; INSTALL ISR

                MOVE.B  #5,D1                                   ; ENABLE EXCEPTION PROCESSING
                MOVE.B  #32,D0
                TRAP    #15

                MOVE.B  #%10000000|SCREEN_IRQ,D2                ; ENABLE AUTO-IRQ
                MOVE.L  #SCREEN_TIMER,D3
                MOVE.B  #6,D1
                MOVE.B  #32,D0
                TRAP    #15

                CLR.B   (SCREEN_INT_CTR)                        ; PREPARE INTERRUPT FLAG
                CLR.B   (SCREEN_CYC_CTR)

                MOVEM.L (SP)+,D0-D3

                RTS

; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
;  SCREEN TIMED INTERRUPT SERVICE ROUTINE (VBL)
;  EXECUTED AUTOMATICALLY EVERY VERTICAL BLANK (APPROX 55/60Hz)
;  UPDATES COUNTERS FOR MAIN LOOP SYNCHRONIZATION
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SCREEN_ISR
                ADDQ.B  #1,(SCREEN_INT_CTR)                     ; UPDATE INT FLAG/COUNTER
                ADDQ.B  #1,(SCREEN_CYC_CTR)

                RTE

; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
;  TRAP SERVICE ROUTINE : FLIPS BUFFERS
;  CALLED VIA 'TRAP #SCREEN_TRAP'
;
;  1. SWAPS VISIBLE AND HIDDEN SCREEN BUFFERS (DOUBLE BUFFERING)
;  2. CLEARS THE NEW HIDDEN BUFFER FOR THE NEXT FRAME DRAWING
;
;  INPUT    : NONE
;  OUTPUT   : NONE
; ----------------------------------------------------------------------------------------
SCREEN_UPDATE
                MOVEM.W D0/D1,-(SP)

                MOVE.B  #94,D0                                  ; UPDATE DOUBLE BUFFER
                TRAP    #15

                MOVE.W  #$FF00,D1                               ; CLEAR HIDDEN BUFFER
                MOVE.B  #11,D0
                TRAP    #15

                MOVEM.W (SP)+,D0/D1
            
                RTE






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
