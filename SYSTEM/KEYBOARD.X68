; ========================================================================================
; KEYBOARD MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

KEYBOARD_TRAP   EQU     0       ; KEYBOARD READ TRAP

KEYBOARD_KEY_LF EQU     $25     ; LEFT  KEY CODE
KEYBOARD_KEY_UP EQU     $26     ; UP    KEY CODE
KEYBOARD_KEY_RG EQU     $27     ; RIGHT KEY CODE
KEYBOARD_KEY_DW EQU     $28     ; DOWN  KEY CODE

; --- KEYBOARD BITFIELD MASKS ------------------------------------------------------------
;
; CONVENIENCE CONSTANTS TO ACCESS THE FOLLOWING BIT-FIELD. THIS BIT-FIELD IS USED BY:
;
;   - KEYBOARD_VALUE
;   - KEYBOARD_EDGE
;
; +------+---+---+---+---+
; | 0000 | 3 | 2 | 1 | 0 |
; +------+---+---+---+---+
;          |   |   |   |
;          |   |   |   +---------- LEFT BUTTON
;          |   |   +-------------- UP BUTTON
;          |   +------------------ RIGHT BUTTON
;          +---------------------- DOWN BUTTON

KEYBOARD_MSK_LF EQU     %00000001
KEYBOARD_MSK_UP EQU     %00000010
KEYBOARD_MSK_RG EQU     %00000100
KEYBOARD_MSK_DW EQU     %00001000

KEYBOARD_BIT_LF EQU     0
KEYBOARD_BIT_UP EQU     1
KEYBOARD_BIT_RG EQU     2
KEYBOARD_BIT_DW EQU     3

; --- VARIABLES --------------------------------------------------------------------------

KEYBOARD_VALUE  DS.B    1       ; KEY STATE
KEYBOARD_EDGE   DS.B    1       ; KEY EDGE

; ----------------------------------------------------------------------------------------
;  INITIALIZES THE KEYBOARD
; ----------------------------------------------------------------------------------------
KEYBOARD_INIT
                MOVE.L  #KEYBOARD_READ,($80+KEYBOARD_TRAP*4)       ; INSTALL TRAP

                CLR.B   (KEYBOARD_VALUE)
                CLR.B   (KEYBOARD_EDGE)

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
                MOVE.L  #KEYBOARD_KEY_DW<<24+KEYBOARD_KEY_RG<<16+KEYBOARD_KEY_UP<<8+KEYBOARD_KEY_LF,D1     
                TRAP    #15

                MOVE.W  #3,D3                                                                               ; TRANSLATES THE 8-BIT ENCODING
.LOOP       
                LSL.L   #8,D1                                                                               ; OF TRAP #15 TASK 19 INTO A 1-BIT
                ROXL.B  #1,D2                                                                               ; PER KEYPRESS ENCODING
                DBRA.W  D3,.LOOP                

                MOVE.B  (KEYBOARD_VALUE),D0                                                                 ; COMPUTE EDGE.
                NOT.B   D0                                                                                  ; EDGE=NOT(PREVIOUS) AND CURRENT.
                AND.B   D2,D0

                MOVE.B  D2,(KEYBOARD_VALUE)                                                                 ; STORE VALUES (PRESS AND EDGE)
                MOVE.B  D0,(KEYBOARD_EDGE)

                MOVEM.L (SP)+,D0-D3

                RTE




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
