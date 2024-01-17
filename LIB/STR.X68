; ========================================================================================
; STRINGS UTIL CODE
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

CHAR_WIDTH      EQU     8                                       ; STANDARD (PX)

; ----------------------------------------------------------------------------------------
;  GET STRING LENGTH
;
;  INPUT    : A0 - ADDRESS TO A NULL TERMINATED STRING
;  OUTPUT   : D7 - STRING LENGTH
; ----------------------------------------------------------------------------------------
STRLEN
                MOVE.L  A0,-(SP)
                CLR.L   D7
                
.LOOP
                TST.B   (A0)+
                BEQ     .END
                ADDQ.B  #1,D7
                BRA     .LOOP
.END
                MOVE.L (SP)+,A0
                
                RTS

; ----------------------------------------------------------------------------------------
;  PRINT SCREEN CENTERED STRING
;
;  INPUT    :   A0      - ADDRESS TO A NULL TERMINADTED STRING
;               D0.B    - ROW
;               D1.L    - FOREGROUND COLOR
; ----------------------------------------------------------------------------------------       
STRPRINT
                MOVEM.L D0-D3/A0-A1,-(SP)
                
                MOVE.B  D0,D3
                
                CLR.L   D2
                MOVE.B  #21,D0
                TRAP    #15

                CLR.L   D1
                MOVE.B  #81,D0
                TRAP    #15
                
                MOVE.L  A0,A1
                
.LOOP           
                TST.B   (A0)+
                BEQ     .ENDLOOP
                
                ADDQ.B  #1,D1
                BRA     .LOOP

.ENDLOOP    
                LSR.B   #1,D1
                SUB.B   #(SCREEN_WIDTH/CHAR_WIDTH)/2,D1
                NEG.B   D1
                ASL.W   #8,D1
                OR.W    D3,D1
                MOVE.B  #11,D0
                TRAP    #15

                MOVE.B  #13,D0
                TRAP    #15

                MOVEM.L (SP)+,D0-D3/A0-A1
                RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
