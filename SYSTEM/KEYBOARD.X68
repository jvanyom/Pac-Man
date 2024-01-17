; ========================================================================================
; KEYBOARD MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

KEYBOARD_TRAP   EQU     0       ; KEYBOARD READ TRAP

KEYBOARD_LF_KEY EQU     $25     ; LEFT  KEY CODE
KEYBOARD_UP_KEY EQU     $26     ; UP    KEY CODE
KEYBOARD_RG_KEY EQU     $27     ; RIGHT KEY CODE
KEYBOARD_DW_KEY EQU     $28     ; DOWN  KEY CODE

; --- VARIABLES --------------------------------------------------------------------------

KEYBOARD_VALUE  DS.B    2       ; KEY STATE

; ----------------------------------------------------------------------------------------
;  INITIALIZES THE KEYBOARD
; ----------------------------------------------------------------------------------------
KEYBOARD_INIT
                MOVE.L  #KEYBOARD_READ,($80+KEYBOARD_TRAP*4)       ; INSTALL TRAP

                CLR.B   (KEYBOARD_VALUE)

                RTS
                
; ----------------------------------------------------------------------------------------
; TRAP SERVICE ROUTINE: UPDATES EDGE AND VALUE VARIABLES ACCORDING TO THE BITFIELD
; 
; KEYBOARD_VALUE HOLDS THE CURRENT VALUES AND KEYBOARD_EDGE HOLDS RISING EDGES FROM
; PREVIOUS CALL TO THE CURRENT ONE.
;
; OUTPUT   - (KEYBOARD_VALUE) AND (KEYBOARD_EDGE)
; ----------------------------------------------------------------------------------------
KEYBOARD_READ
                MOVEM.L D0-D3,-(SP)

                MOVE.B  #19,D0                                                                              ; CHECK FOR KEYPRESS (DOWN, RIGHT, UP, LEFT)
                MOVE.L  #KEYBOARD_DW_KEY<<24+KEYBOARD_RG_KEY<<16+KEYBOARD_UP_KEY<<8+KEYBOARD_LF_KEY,D1     
                TRAP    #15

                MOVE.W  #3,D3                                                                               ; TRANSLATES THE 8-BIT ENCODING
.LOOP       
                LSL.L   #8,D1                                                                               ; OF TRAP #15 TASK 19 INTO A 1-BIT
                ROXL.B  #1,D2                                                                               ; PER KEYPRESS ENCODING
                DBRA.W  D3,.LOOP                

                MOVE.B  (KEYBOARD_VALUE),D0                                                                 ; COMPUTE EDGE.
                NOT.B   D0                                                                                  ; EDGE=NOT(PREVIOUS) AND CURRENT.
                AND.B   D2,D0

                MOVE.B  D2,(KEYBOARD_VALUE)                                                                 ; STORE VALUES (PRESS)

                MOVEM.L (SP)+,D0-D3

                RTE
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
