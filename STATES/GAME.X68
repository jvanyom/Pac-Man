; ==============================================================================
; GAME MANAGEMENT
; ==============================================================================

; --- CODE INCLUDES ------------------------------------------------------------

                INCLUDE "TEXTURES.X68"
                INCLUDE "MAZE.X68"
                INCLUDE "AGENT.X68"
                INCLUDE "PACMAN.X68"
                INCLUDE "GHOST/GHOST.X68"
                INCLUDE "SPRITES.X68"
                INCLUDE "SCORE.X68"
                INCLUDE "HEALTH.X68"

; ------------------------------------------------------------------------------
; INITIALIZES GAME
; CALLS INIT ROUTINES FOR ALL GAME SUB-SYSTEMS (MAZE, PACMAN, GHOSTS, SCORE, HEALTH)
;
; INPUT    : NONE
; OUTPUT   : NONE
; ------------------------------------------------------------------------------
GAME_INIT       
                JSR     MAZE_INIT
                JSR     PACMAN_INIT
                JSR     GHOST_INIT
                JSR     SCORE_INIT
                BRA     HEALTH_INIT

; ------------------------------------------------------------------------------
; UPDATES THE GAME
; EXECUTES LOGIC FOR ALL GAME ENTITIES
;
; INPUT    : NONE
; OUTPUT   : NONE
; ------------------------------------------------------------------------------
GAME_UPDATE
                JSR     PACMAN_UPDATE
                JSR     GHOST_UPDATE
                JSR     SCORE_UPDATE
                BRA     HEALTH_UPDATE

; ------------------------------------------------------------------------------
; PLOTS THE GAME
; RENDERS ALL GAME ENTITIES IN ORDER (MAZE -> STATIC, OTHERS -> DYNAMIC)
;
; INPUT    : NONE
; OUTPUT   : NONE
; ------------------------------------------------------------------------------
GAME_PLOT
                JSR     MAZE_PLOT
                JSR     PACMAN_PLOT
                JSR     GHOST_PLOT
                JSR     SCORE_PLOT
                BRA     HEALTH_PLOT





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
