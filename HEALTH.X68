; ========================================================================================
; HEALTH MANAGEMENT
; ========================================================================================

; --- CONSTANTS --------------------------------------------------------------------------

INITIAL_LIFES   EQU     3

LIFES_X         EQU     TILE_WIDTH*2
LIFES_Y         EQU     TILE_WIDTH*MAZE_HEIGHT-AGENT_WIDTH

MARGIN          EQU     AGENT_WIDTH+(AGENT_RADIUS>>1)

; --- VARIABLES --------------------------------------------------------------------------

LIFES           DS.B    2

; ----------------------------------------------------------------------------------------
; INITIALIZE LIFES
; ----------------------------------------------------------------------------------------
HEALTH_INIT
                MOVE.B  #INITIAL_LIFES,(LIFES)
                RTS
                
; ----------------------------------------------------------------------------------------
; UPDATE HEALTH BASED ON PACMAN AND GHOSTS COLLISSION
; ----------------------------------------------------------------------------------------
HEALTH_UPDATE
                MOVEM.L D0-D3/A1,-(SP)
                
                TST.B   (LIFES)
                BEQ     .GAME_OVER

                MOVE.W  (PACMAN_X),D0
                MOVE.W  (PACMAN_Y),D1
                
                ; --- BLINKY ---------
                
                MOVE.W  (BLINKY_X),D2
                MOVE.W  (BLINKY_Y),D3
                
                CMP.W   D0,D2
                BNE     .SPEEDY
                
                CMP.W   D1,D3
                BEQ     .COLLISSION

.SPEEDY         ; --- SPEEDY ---------
                
                MOVE.W  (SPEEDY_X),D2
                MOVE.W  (SPEEDY_Y),D3
                
                CMP.W   D0,D2
                BNE     .BASHFUL
                
                CMP.W   D1,D3
                BEQ     .COLLISSION
                
.BASHFUL        ; --- BASHFUL --------

                MOVE.W  (BASHFUL_X),D2
                MOVE.W  (BASHFUL_Y),D3
                
                CMP.W   D0,D2
                BNE     .POKEY
                
                CMP.W   D1,D3
                BEQ     .COLLISSION
                
.POKEY          ; --- POKEY ----------

                MOVE.W  (POKEY_X),D2
                MOVE.W  (POKEY_Y),D3
                
                CMP.W   D0,D2
                BNE     .END
                
                CMP.W   D1,D3
                BNE     .END
                
                ; --- COLLISSION -----
.COLLISSION
                MOVE.W  #DEATH1_SND,D7
                TRAP    #SOUND_TRAP
                
                SUBQ.B  #1,(LIFES)
                BEQ     .END
                JSR     RESET_STATE
                BRA     .END
                
.GAME_OVER      
                MOVE.L  #300,D1
                MOVE.B  #23,D0
                TRAP    #15
          
                CLR.W   (STATE_NEXT)

.END
                MOVEM.L (SP)+,D0-D3/A1
                RTS

; ----------------------------------------------------------------------------------------
; PLOT LIFES ACORDING TO PAC-MAN DESIGN
; ----------------------------------------------------------------------------------------
HEALTH_PLOT
                MOVEM.L D0-D3,-(SP)

                MOVE.B  (LIFES),D0
                BEQ     .GAME_OVER
                
                SUBQ.B  #1,D0
                
                MOVE.L  #PACMAN_COLOR,D1
                MOVE.W  #LIFES_X,D3
                MOVE.W  #LIFES_Y,D2              

.LOOP           
                JSR     AGENT_PLOT
                
                ADD.W   #MARGIN,D3
                
                DBRA    D0,.LOOP
                BRA     .END

.GAME_OVER
                MOVE.L  #$000000FF,D1
                MOVE.B  #21,D0
                TRAP    #15                 ; RED AS FOREGROUND COLOR

                LEA     .GAME_OVER_TXT,A1
                MOVE.W  #TILE_WIDTH*18-3,D1
                MOVE.W  #TILE_WIDTH*20+1,D2
                MOVE.B  #95,D0
                TRAP    #15

.END
                MOVEM.L (SP)+,D0-D3
                RTS
.GAME_OVER_TXT  DC.B    'GAME OVER!',0
                DS.W    0
                
RESET_STATE
                MOVE.L  #300,D1
                MOVE.B  #23,D0
                TRAP    #15                 ; SLEEP
                
                JSR     PACMAN_INIT         ; RESET PACMAN
                JSR     BLINKY_INIT         ; RESET BLINKY
                JSR     SPEEDY_INIT
                JSR     BASHFUL_INIT
                BRA     POKEY_INIT

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
