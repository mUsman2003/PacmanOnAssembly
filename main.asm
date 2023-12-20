include Irvine32.inc
include macros.inc
includelib winmm.lib

TITLE MASM PlaySound                        (PlaySoundExample.asm)

PlaySound PROTO,
pszSound:PTR BYTE, 
hmod:DWORD, 
fdwSound:DWORD

.data

    speed1 Dword 150
    speed2 DWORD 125
    speed3 DWORD 100

    SND_FILENAME DWORD 00020001h
    musicIntro DB "pacman_beginning.wav", 0
    musicChomp DB "pacman_chomp.wav", 0
    musicFruit DB "pacman_eatfruit.wav", 0
    musicDeath DB "pacman_death.wav", 0
    TempM DB " ",0

    levelIndicator DB 1
    livesIndicator DB 3
    score DW 0

    Menu1InputNamePrompt DB 25 Dup(?)
    buffer db 255 Dup(?)
    scoreBuffer DB "   0",0 

    Name1 db 25 Dup(?)
    Name2 db 25 Dup(?)
    Name3 db 25 Dup(?)

    Score1 db 25 Dup(?)
    Score2 db 25 Dup(?)
    Score3 db 25 Dup(?)

    level_1 db 25 Dup(?)
    level_2 db 25 Dup(?)
    level_3 db 25 Dup(?)

    HighscorePrompt DB "Name      Score       Level",0

    filename DB  "score.txt", 0
    filetemp DB  "temp.txt",0
    fileHandle HANDLE ?

    CurrentCoins DW 600


    Menu2OptionHandle DB 1
    Menu2OptionUp_Down DB ?
;------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------
    GameStateHandle DB  1
;--------------------------------------(player Movement Handles)---------------------------   
;-----------------------------------------------------------------------------------------    
    
    PlayerDirectionHandle DB 3
    PlayerMovement1Possibibly DB 1

    Ghost1DirectionHandle DB 1
    Ghost1MovementPossibibly DB 1

    Ghost2DirectionHandle DB 1
    Ghost2MovementPossibibly DB 1
    Ghost3DirectionHandle DB 1
    Ghost3MovementPossibibly DB 1

    Ghost4DirectionHandle DB 1
    Ghost4MovementPossibibly DB 1
    Ghost5DirectionHandle DB 2
    Ghost5MovementPossibibly DB 1
    Ghost6DirectionHandle DB 3
    Ghost6MovementPossibibly DB 1
    Ghost7DirectionHandle DB 1
    Ghost7MovementPossibibly DB 1

    Ghost1Status DB 1
    Ghost2Status DB 1
    Ghost3Status DB 1
    Ghost4Status DB 1
    Ghost5Status DB 1
    Ghost6Status DB 1
    Ghost7Status DB 1

;----------------------------------(Player)-----------------------------------------------   
; 
    xPos DB 8
    yPos DB 7
    inputChar DB ?
;----------------------------------(Wall,Coin,Space,Ghost)--------------------------------    
;-----------------------------------------------------------------------------------------    
    wall DB "X"
    coin DB "."
    space DB " "

    G1 DB "!"    
    G2 DB "!"     
    G3 DB "!"   
    G4 DB "!"    
    G5 DB "!"    
    G6 DB "!"    
    G7 DB "!"   

    ;   level 1 Ghost
    xG1Pos DB 10
    yG1Pos DB 15
    ;   level 2 Ghost
    xG2Pos DB 8
    yG2Pos DB 15
    xG3Pos DB 12
    yG3Pos DB 17
    ;   level 3 ghost
    xG4Pos DB 40
    yG4Pos DB 21
    xG5Pos DB 34
    yG5Pos DB 21
    xG6Pos DB 40
    yG6Pos DB 15
    xG7Pos DB 34
    yG7Pos DB 15
;--------------------------------------Main Screen----------------------------------------    
;----------------------------------------------------------------------------------------- 

    m1_r01 DB "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
    m1_r02 DB "XXXX                                                                   XXXX",0

    pacman_0 DB "   ,------------------------------------------------------------,",0
    pacman_1 DB "   |   ________                                                 |",0
    pacman_2 DB "   |   \____   \ _____      ____     _____   _____      ____    |",0
    pacman_3 DB "   |    |   ___/ \__  \   _/ ___\   /     \  \__  \    /    \   |",0
    pacman_4 DB "   |    |  |      / __ \_ \  \___  |  | |  \  / __ \_ |   |  \  |",0
    pacman_5 DB "   |    |__|     (____  /  \__  /  |__|_|  / (____  / |___|  /  |",0
    pacman_6 DB "   |                  \/      \/         \/       \/       \/   |",0  
    pacman_7 DB "   '------------------------------------------------------------'",0
    
    pinky_01 DB "              PPPPPPPP",0
    pinky_02 DB "          PPPPPPPPPPPPPPPP",0
    pinky_03 DB "        PPPPPPPPPPPPPPPPPPPP",0
    pinky_04 DB "      PPPPPPWWWWPPPPPPPPWWWWPP",0
    pinky_05 DB "      PPPPWWWWWWWWPPPPWWWWWWWW",0
    pinky_06 DB "      PPPPWWWWBBBBPPPPWWWWBBBB",0
    pinky_07 DB "    PPPPPPWWWWBBBBPPPPWWWWBBBBPP",0
    pinky_08 DB "    PPPPPPPPWWWWPPPPPPPPWWWWPPPP",0
    pinky_09 DB "    PPPPPPPPPPPPPPPPPPPPPPPPPPPP",0
    pinky_10 DB "    PPPPPPPPPPPPPPPPPPPPPPPPPPPP",0
    pinky_11 DB "    PPPPPPPPPPPPPPPPPPPPPPPPPPPP",0
    pinky_12 DB "    PPPP  PPPPPP    PPPPPP  PPPP",0
    pinky_13 DB "    PP      PPPP    PPPP      PP",0

;--------------------------------------(Level 1)-----------------------------------------    
;-----------------------------------------------------------------------------------------    

    l1_r01 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
    l1_r02 DB "     XX . . . . . . . . . . . . . . XX",0
    l1_r03 DB "     XX . XXXXXXX . XXX . XXXXXXX . XX",0
    l1_r04 DB "     XX . XXXXXXX . XXX . XXXXXXX . XX",0
    l1_r05 DB "     XX . . . . . . . . . . . . . . XX",0
    l1_r06 DB "     XX . XXXXXXX . XXX . XXX . XXXXXX",0
    l1_r07 DB "     XX . XXXXXXX . XXX . XXX . XXXXXX",0    
    l1_r08 DB "     XX . . . . . . XXX . . . . . . XX",0
    l1_r09 DB "     XXXXXXXXXXXX . XXXXXXXXXXXXX . XX",0
    l1_r10 DB "     XX           . XXX . . . . . . XX",0
    l1_r11 DB "     XX        XX . . . . XXXXXXX . XX",0
    l1_r12 DB "     XX        XX . XXX . . . . . . XX",0
    l1_r13 DB "     XXXXXXXXXXXX . XXX . XXXXXXX . XX",0
    l1_r14 DB "     XX . . . . . . . . . . . . . . XX",0
    l1_r15 DB "     XX . XXXXXXX . XXX . XXXXXXX . XX",0
    l1_r16 DB "     XX . . . XXX . . . . . . . . . XX",0
    l1_r17 DB "     XXXXXX . XXX . XXX . XXXXXXXXXXXX",0
    l1_r18 DB "     XX . . . . . . XXX . . . . . . XX",0
    l1_r19 DB "     XX . XXXXXXXXXXXXXXXXXXXXXXX . XX",0
    l1_r20 DB "     XX . XXXXXXXXXXXXXXXXXXXXXXX . XX",0
    l1_r21 DB "     XX . . . . . . . . . . . . . . XX",0
    l1_r22 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
   
;--------------------------------------(Level 2)-----------------------------------------    
;-----------------------------------------------------------------------------------------    

    l2_r01 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
    l2_r02 DB "     XX . . . . . . . . . . . . . . XXX . . . . XX",0
    l2_r03 DB "     XX * XXXXXXX . XXX . XXXXXXX . XXX . XXX * XX",0
    l2_r04 DB "     XX . XXXXXXX . XXX . XXXXXXX . XXX . XXX . XX",0
    l2_r05 DB "     XX . . . . . . . . . . . . . . . . . XXX . XX",0
    l2_r06 DB "     XX . XXXXXXX . XXX . XXX . XXXXXXX . . . . XX",0
    l2_r07 DB "     XX . XXXXXXX . XXX . XXX . XXXXXXX . XXXXXXXX",0
    l2_r08 DB "     XX . . . . . . XXX . . . . . . . . . . . . XX",0
    l2_r09 DB "     XXXXXXXXXXXX . XXXXXXXXXXXXX . XXX . XXX . XX",0
    l2_r10 DB "     XX           . XXX . . . . . . . . . XXX . XX",0
    l2_r11 DB "     XX        XX . . . . XXXXXXXXXXXXX . . . . XX",0
    l2_r12 DB "     XX           . XXX . . . . . . XXX . XXXXXXXX",0
    l2_r13 DB "     XXXXXXXXXXXX . XXX . XXXXXXX . XXX . XXXXXXXX",0
    l2_r14 DB "     XX . . . . . . . . . . . . . . . . . . . . XX",0
    l2_r15 DB "     XX . XXXXXXX . XXX . XXXXXXX . XXXXXXXXX . XX",0
    l2_r16 DB "     XX . . . XXX . . . . . . . . . . . . . . . XX",0
    l2_r17 DB "     XXXXXX . XXX . XXX . XXXXXXXXXXXXX . XXXXXXXX",0
    l2_r18 DB "     XX . . . . . . XXX . . . . . . . . . . . . XX",0
    l2_r19 DB "     XX * XXXXXXXXXXXXXXXXXXXXXXX . XXX . XXX * XX",0
    l2_r20 DB "     XX . XXXXXXXXXXXXXXXXXXXXXXX . XXX . XXX . XX",0
    l2_r21 DB "     XX . . . . . . . . . . . . . . XXX . . . . XX",0
    l2_r22 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0

;--------------------------------------(Level 3)-----------------------------------------    
;-----------------------------------------------------------------------------------------    

    l3_r01 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0
    l3_r02 DB "     XX . . . . . . . . . . . . . . XXX . . . . . . . . . . . . . * XX",0
    l3_r03 DB "     XX . XXXXXXX . XXXXXXXXXXXXX . XXX . XXXXXXXXXXXXX . XXXXXXX . XX",0
    l3_r04 DB "     XX * XXXXXXX . XXXXXXXXXXXXX . XXX . XXXXXXXXXXXXX . XXXXXXX . XX",0
    l3_r05 DB "     XX . . . . . . . . . XXX . . . . . . . . XXX . . . . . . . . . XX",0
    l3_r06 DB "     XX . XXXXXXX . XXX . XXX . XXXXXXXXXXX . XXX . XXX . XXXXXXX . XX",0
    l3_r07 DB "     XX . XXXXXXX . XXX . . . . . . XXX . . . . . . XXX . XXXXXXX . XX",0    
    l3_r08 DB "     XX . . . . . . XXXXXXXXXXXXX . XXX . XXXXXXXXXXXXX . . . . . . XX",0
    l3_r09 DB "     XXXXXXXXXXXX . XXXXXXXXXXXXX . XXX . XXXXXXXXXXXXX . XXXXXXXXXXXX",0
    l3_r10 DB "     XXXX     XXX . XXX . . . . . . . . . . . . . * XXX . XXX     XXXX",0
    l3_r11 DB "                  . XXX . XXXXXXX . XXX . XXXXXXX . XXX .             ",0
    l3_r12 DB "     XXXX     XXX . XXX . XXXXXXX . XXX . XXXXXXX . XXX . XXX     XXXX",0
    l3_r13 DB "     XXXXXXXXXXXX . XXX . XXXXXXX . XXX . XXXXXXX . XXX . XXXXXXXXXXXX",0
    l3_r14 DB "     XX . . . . . . . . . XXXXXXX . . . . XXXXXXX . . . . . . . . . XX",0
    l3_r15 DB "     XX . XXXXXXX . XXX . XXXXXXXXXXXXXXXXXXXXXXX . XXX . XXXXXXX . XX",0
    l3_r16 DB "     XX . . . XXX . . . . . . . . . . . . . . . . . . . . XXX . . . XX",0
    l3_r17 DB "     XXXXXX . XXX . XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX . XXX . XXXXXX",0
    l3_r18 DB "     XX . . . XXX . . . . . . . . . XXX . . . . . . . . . XXX . . . XX",0
    l3_r19 DB "     XX * XXXXXXXXXXXXXXXXX . XXX . XXX . XXX . XXXXXXXXXXXXXXXXX . XX",0
    l3_r20 DB "     XX . XXXXXXXXXXXXXXXXX . XXX . XXX . XXX . XXXXXXXXXXXXXXXXX . XX",0
    l3_r21 DB "     XX . . . . . . . . . . . XXX . * . . XXX . . . . . . . . . . * XX",0
    l3_r22 DB "     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",0


.code

;------------------------------------------(Start of Main)-------------------------------------------
;------------------------------------------(Main Screen)---------------------------------------------
;------------------------------------------(Main Screen)---------------------------------------------

main PROC
    ;call Level1Maze
    ;call Level2Maze
    ;call Level3Maze
   
;----------------------------------(Introduction screen)----------------------------------    
;-----------------------------------------------------------------------------------------
    call Menu1Name
    call PacmanLogo
    call Menu1EnterName
;--------------------------------------(Menu screen)--------------------------------------    
;-----------------------------------------------------------------------------------------
    Menu:
    ;call clrscr
    call Menu2Screen
    call Readchar
;----------------------------------------(Selection)--------------------------------------
;----------------------------------------(Selection)--------------------------------------
    cmp al,"1"
    je level1
    cmp al,"2"
    jne n2
    call clrscr
    call InstructionPage
    call readchar
    jmp Menu
    n2:
    cmp al,"3"
    jne SkipL
    call HighScoreMenu
    call readchar
    jmp Menu
    SkipL:
    n3:
    cmp al,"4"
    je exitGame
    n4:


    level1:
        call Level1Maze 
    level2:
        call Level2Maze 
    level3:
        call Level3Maze

    exitGame:
    call clrscr
    mov eax, white (black*16)
    call settextcolor
    exit

main ENDP
;------------------------------------------(End of Main)---------------------------------------------
;------------------------------------------(Main Screen)---------------------------------------------


;------------------------------------------(Main Screen)---------------------------------------------
;------------------------------------------(Main Screen)---------------------------------------------
Menu1Name PROC  
    
    ;call playMusic
    ;INVOKE PlaySound, OFFSET musicIntro, NULL, SND_FILENAME

    mov esi,offset [m1_r01]
    mov ecx,lengthof m1_r01
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r01]
    mov ecx,lengthof m1_r01
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay

    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r02]
    mov ecx,lengthof m1_r02
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay

    mov esi,offset [m1_r01]
    mov ecx,lengthof m1_r01
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay
    mov esi,offset [m1_r01]
    mov ecx,lengthof m1_r01
    call Menu1Displayer
    call crlf
    mov eax,1   
    call Delay

    mov eax ,0
    mov eax, black (black*16)
    call settextcolor

    ret
Menu1Name ENDP  
Menu1Displayer PROC

    ld1:
        mov ebx,[esi]  
        cmp bl,' '
        jz C1
        cmp bl,wall
        jz C3
        jmp ld_excape
        C1: call DrawSpace
        jmp ld_excape
        C3: call DrawRedWall
        ld_excape:
        inc esi
        loop ld1    
    ret
Menu1Displayer ENDP 
PacmanLogo PROC  
    mov eax ,0
    mov eax, yellow (black*16)
    call settextcolor

    mov dh,3
    mov dl,4
    call gotoxy
    mov edx,offset pacman_0
    call writestring
    mov  eax,50    
    call Delay
    mov dh,4
    mov dl,4
    call gotoxy
    mov edx,offset pacman_1
    call writestring
    mov  eax,50    
    call Delay
    mov dh,5
    mov dl,4
    call gotoxy
    mov edx,offset pacman_2
    call writestring
    mov  eax,50   
    call Delay
    mov dh,6
    mov dl,4
    call gotoxy
    mov edx,offset pacman_3
    call writestring
    mov  eax,50   
    call Delay
    mov dh,7
    mov dl,4
    call gotoxy
    mov edx,offset pacman_4
    call writestring
    mov  eax,50    
    call Delay
    mov dh,8
    mov dl,4
    call gotoxy
    mov edx,offset pacman_5
    call writestring
    mov  eax,50    
    call Delay
    mov dh,9
    mov dl,4
    call gotoxy
    mov edx,offset pacman_6
    call writestring
    mov  eax,50   
    call Delay
    mov dh,10
    mov dl,4
    call gotoxy
    mov edx,offset pacman_7
    call writestring
    mov  eax,50   
    call Delay

    mov eax ,0
    mov eax, black (black*16)
    call settextcolor

    call PinkyGhost


    ret
PacmanLogo ENDP 
Menu1EnterName PROC 
    
    mov eax ,0
    mov eax, gray (black*16)
    call settextcolor

    mov dh,20
    mov dl,42
    call gotoxy
    mwrite "Press 'ENTER' to Continue",0

    mov eax ,0
    mov eax, white (black*16)
    call settextcolor

    mov dh,15
    mov dl,42
    call gotoxy
    mwrite "Enter UserName : ",0

    INVOKE PlaySound, OFFSET musicIntro, NULL, SND_FILENAME
    
    mov ecx,25
    mov edx,offset Menu1InputNamePrompt
    call readstring

    mov eax ,0
    mov eax, black (black*16)
    call settextcolor

    
    ret
Menu1EnterName ENDP 

PinkyGhost PROC
    mov esi,offset pinky_01
    mov ecx,lengthof pinky_01
    mov dh,13
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_02
    mov ecx,lengthof pinky_02
    mov dh,14
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_03
    mov ecx,lengthof pinky_03
    mov dh,15
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_04
    mov ecx,lengthof pinky_04
    mov dh,16
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_05
    mov ecx,lengthof pinky_05
    mov dh,17
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_06
    mov ecx,lengthof pinky_06
    mov dh,18
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_07
    mov ecx,lengthof pinky_07
    mov dh,19
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_08
    mov ecx,lengthof pinky_08
    mov dh,20
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_09
    mov ecx,lengthof pinky_09
    mov dh,21
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_10
    mov ecx,lengthof pinky_10
    mov dh,22
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_11
    mov ecx,lengthof pinky_11
    mov dh,23
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_12
    mov ecx,lengthof pinky_12
    mov dh,24
    mov dl,6
    call gotoxy
    call GhostMaker
    mov esi,offset pinky_13
    mov ecx,lengthof pinky_13
    mov dh,25
    mov dl,6
    call gotoxy
    call GhostMaker
    mov eax,black (black*16)
    call settextcolor
    ret
PinkyGhost ENDP    
GhostMaker PROC 
    dec ecx
    ld1:
        mov ebx,[esi]
        cmp bl,' '
        jz C1
        cmp bl,"P"
        jz C2
        cmp bl,"W"
        jz C3
        cmp bl,"B"
        jz C4
        call DrawWall
    C1: call DrawSpace
        jmp ld_excape
    C2: call DrawPinkWall
        jmp ld_excape
    C3: call DrawWhiteWall
        jmp ld_excape
    C4: call DrawBlueWall
        jmp ld_excape
    ld_excape:
    inc esi
    loop ld1

    ret
GhostMaker ENDP 

RedyGhost PROC
    mov esi,offset pinky_01
    mov ecx,lengthof pinky_01
    mov dh,13
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_02
    mov ecx,lengthof pinky_02
    mov dh,14
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_03
    mov ecx,lengthof pinky_03
    mov dh,15
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_04
    mov ecx,lengthof pinky_04
    mov dh,16
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_05
    mov ecx,lengthof pinky_05
    mov dh,17
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_06
    mov ecx,lengthof pinky_06
    mov dh,18
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_07
    mov ecx,lengthof pinky_07
    mov dh,19
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_08
    mov ecx,lengthof pinky_08
    mov dh,20
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_09
    mov ecx,lengthof pinky_09
    mov dh,21
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_10
    mov ecx,lengthof pinky_10
    mov dh,22
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_11
    mov ecx,lengthof pinky_11
    mov dh,23
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_12
    mov ecx,lengthof pinky_12
    mov dh,24
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov esi,offset pinky_13
    mov ecx,lengthof pinky_13
    mov dh,25
    mov dl,6
    call gotoxy
    call RedGhostMaker
    mov eax,black (black*16)
    call settextcolor
    ret
RedyGhost ENDP    
RedGhostMaker PROC 
    dec ecx
    ld1:
        mov ebx,[esi]
        cmp bl,' '
        jz C1
        cmp bl,"P"
        jz C2
        cmp bl,"W"
        jz C3
        cmp bl,"B"
        jz C4
        call DrawWall
    C1: call DrawSpace
        jmp ld_excape
    C2: call DrawRedWall
        jmp ld_excape
    C3: call DrawWhiteWall
        jmp ld_excape
    C4: call DrawBlueWall
        jmp ld_excape
    ld_excape:
    inc esi
    loop ld1

    ret
RedGhostMaker ENDP 

;------------------------------------------(Menu Screen)---------------------------------------------
;------------------------------------------(Menu Screen)---------------------------------------------
Menu2Screen PROC
    call clrscr
    call  Menu1Name  
    call PacmanLogo
    call RedyGhost  

    mov eax ,0
    mov eax, gray (black*16)
    call settextcolor

    mov dh,22
    mov dl,45
    call gotoxy
    mwrite "Press '1,2,3 or 4'",0
    mov dh,23
    mov dl,48
    call gotoxy
    mwrite "to Continue",0

    mov eax ,0
    mov eax, white (black*16)
    call settextcolor

    mov dh,15
    mov dl,40
    call gotoxy 
    mwrite "          Play",0

    mov dh,16
    mov dl,40
    call gotoxy
    mwrite "      How to Play?",0

    mov dh,17
    mov dl,40
    call gotoxy
    mwrite "        Highscore",0
    
    mov dh,18
    mov dl,40
    call gotoxy
    mwrite "          Quit",0

    mov eax ,0
    mov eax, white (black*16)
    call settextcolor
    
    ret
Menu2Screen ENDP
;------------------------------------------(Instructions)--------------------------------------------
;------------------------------------------(Menu Screen)---------------------------------------------
InstructionPage PROC    
    mov eax ,0
    mov eax, white (black*16)
    call settextcolor

    mov dh,10
    mov dl,10
    call gotoxy
    mwrite "          Asking for Pac-Man instructions?",0
    mov dh,12
    mov dl,10
    call gotoxy
    mwrite "     do you also need guidance on how to breathe?",0
    mov dh,13
    mov dl,10
    call gotoxy
    mwrite "  Just press the 'Inhale' button, you'll figure it out!",0
    mov dh,16
    mov dl,10
    call gotoxy
    mwrite "        It's like a maze of common sense, really.",0
    
    mov eax ,0
    mov eax, gray (black*16)
    call settextcolor

    mov dh,22
    mov dl,26
    call gotoxy
    mwrite "Press B for going back",0
    ret
InstructionPage ENDP    
;-------------------------------------------(HighScore)----------------------------------------------
;------------------------------------------(Menu Screen)---------------------------------------------
HighScoreMenu PROC
    call clrscr
    call Menu1Name  
    call PacmanLogo 
    mov edx,OFFSET filename
    call OpenInputFile
    mov fileHandle,eax

    letsOpenFile:
        mov edx,offset buffer
        mov ecx,255
        call ReadFromFile
        mov buffer[255],0
    call CloseFile

    mov eax ,0
    mov eax, gray (black*16)
    call settextcolor

    mov dh,23
    mov dl,44
    call gotoxy
    mwrite "Press B for going back",0

    mov eax,white(black*16)
    call settextcolor

    mov dh,16
    mov dl,42
    call gotoxy
    mwrite "Name      Score       Level",0
    call crlf

    mov esi,offset buffer
    mov dh,18
    mov dl,42
    call gotoxy
    mov edi,offset Name1
    call StringMasking 
    mov dh,18
    mov dl,52
    call gotoxy
    mov edi,offset Score1
    call StringMasking 
    mov dh,18
    mov dl,66
    call gotoxy
    mov edi,offset level_1
    call StringMasking 

    mov dh,19
    mov dl,42
    call gotoxy
    mov edi,offset Name2
    call StringMasking 
    mov dh,19
    mov dl,52
    call gotoxy
    mov edi,offset Score2
    call StringMasking 
    mov dh,19
    mov dl,66
    call gotoxy
    mov edi,offset level_2
    call StringMasking 

    mov dh,20
    mov dl,42
    call gotoxy
    mov edi,offset Name3
    call StringMasking 
    mov dh,20
    mov dl,52
    call gotoxy
    mov edi,offset Score3
    call StringMasking 
    mov dh,20
    mov dl,66
    call gotoxy
    mov edi,offset level_3
    call StringMasking 
    ret
HighScoreMenu ENDP  
StringMasking PROC 


    mov ebx," "
    cmp [esi],bl
    jne l1
    inc esi
    l1:
    mov ecx,0
    mov cl,[esi]
    mov eax,[esi]
    call writechar
    mov [edi],cl
    inc esi
    inc edi
    cmp [esi],bl
    jne l1
    ;mov bl,0
    ;mov [edi],bl

ret
StringMasking endp  
;--------------------------------------------(EndScreen)---------------------------------------------
;------------------------------------------(Menu Screen)---------------------------------------------
getValuesofUser PROC
    mov edx,OFFSET filename
    call OpenInputFile
    mov fileHandle,eax

    letsOpenFile:
        mov edx,offset buffer
        mov ecx,255
        call ReadFromFile
        mov buffer[255],0
    call CloseFile

    mov esi,offset buffer

    mov edi,offset Name1
    call FileReadingMasking 
    mov edi,offset Score1
    call FileReadingMasking 
    mov edi,offset level_1
    call FileReadingMasking 

    mov edi,offset Name2
    call FileReadingMasking 
    mov edi,offset Score2
    call FileReadingMasking 
    mov edi,offset level_2
    call FileReadingMasking 

    mov edi,offset Name3
    call FileReadingMasking 
    mov edi,offset Score3
    call FileReadingMasking 
    mov edi,offset level_3
    call FileReadingMasking 
    ret
getValuesofUser ENDP  
FileReadingMasking PROC 

    mov ebx," "
    cmp [esi],bl
    jne l1
    inc esi
    l1:
    mov ecx,0
    mov cl,[esi]
    ;mov eax,[esi]
    ;call writechar
    mov [edi],cl
    inc esi
    inc edi
    cmp [esi],bl
    jne l1

ret
FileReadingMasking endp  
EndScreen PROC
    
    call clrscr
    call Menu1Name  
    call PacmanLogo
    call getValuesofUser   
    
    mov eax, red (black*16)
    call settextcolor
   
    mov eax ,0
    mov eax, gray (black*16)
    call settextcolor

    mov dh,21
    mov dl,46
    call gotoxy
    mwrite "Press 'R' to Restart",0

    mov dh,16
    mov dl,46
    call gotoxy
    mov eax, white (black*16)
    call settextcolor
    mwrite "   Name : ",
    mov edx,offset Menu1InputNamePrompt
    call writestring
    mov dh,17
    mov dl,46
    call gotoxy
    mwrite " Scored : ",
    mov ax,score
    call Writedec
    mov dh,18
    mov dl,46
    call gotoxy
    mwrite "  Level : ",
    mov eax,0
    mov al,levelIndicator
    call Writedec
    call readchar
    call clrscr
    call main   
    ret
EndScreen ENDP  
;--------------------------------------------(Level 1)-----------------------------------------------
;--------------------------------------------(Level 1)-----------------------------------------------
DrawLevel1 PROC 

    mov esi,offset [l1_r01]
    mov ecx,lengthof l1_r01
    mov dl,0
    mov dh,6
    call Gotoxy
    call LevelDisplayer1

    mov esi,offset [l1_r02]
    mov ecx,lengthof l1_r02
    mov dl,0
    mov dh,7
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r03]
    mov ecx,lengthof l1_r03
    mov dl,0
    mov dh,8
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r04]
    mov ecx,lengthof l1_r04
    mov dl,0
    mov dh,9
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r05]
    mov ecx,lengthof l1_r05
    mov dl,0
    mov dh,10
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r06]
    mov ecx,lengthof l1_r06
    mov dl,0
    mov dh,11
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r07]
    mov ecx,lengthof l1_r07
    mov dl,0
    mov dh,12
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r08]
    mov ecx,lengthof l1_r08
    mov dl,0
    mov dh,13
    call Gotoxy
    call LevelDisplayer1

    mov esi,offset [l1_r09]
    mov ecx,lengthof l1_r09
    mov dl,0
    mov dh,14
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r10]
    mov ecx,lengthof l1_r10
    mov dl,0
    mov dh,15
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r11]
    mov ecx,lengthof l1_r11
    mov dl,0
    mov dh,16
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r12]
    mov ecx,lengthof l1_r12
    mov dl,0
    mov dh,17
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r13]
    mov ecx,lengthof l1_r13
    mov dl,0
    mov dh,18
    call Gotoxy
    call LevelDisplayer1

    mov esi,offset [l1_r14]
    mov ecx,lengthof l1_r14
    mov dl,0
    mov dh,19
    call Gotoxy
    call LevelDisplayer1

    mov esi,offset [l1_r15]
    mov ecx,lengthof l1_r15
    mov dl,0
    mov dh,20
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r16]
    mov ecx,lengthof l1_r16
    mov dl,0
    mov dh,21
    call Gotoxy
    call LevelDisplayer1

    mov esi,offset [l1_r17]
    mov ecx,lengthof l1_r17
    mov dl,0
    mov dh,22
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r18]
    mov ecx,lengthof l1_r18
    mov dl,0
    mov dh,23
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r19]
    mov ecx,lengthof l1_r19
    mov dl,0
    mov dh,24
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r20]
    mov ecx,lengthof l1_r20
    mov dl,0
    mov dh,25
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r21]
    mov ecx,lengthof l1_r21
    mov dl,0
    mov dh,26
    call Gotoxy
    call LevelDisplayer1
    
    mov esi,offset [l1_r22]
    mov ecx,lengthof l1_r22
    mov dl,0
    mov dh,27
    call Gotoxy
    call LevelDisplayer1
    ret 
DrawLevel1 ENDP 
LevelDisplayer1 PROC 
    dec ecx
    ld1:
        mov ebx,[esi]
        cmp bl,' '
        jz C1
        cmp bl,coin
        jz C2
        cmp bl,wall
        jz C3
        call DrawWall
    C1: call DrawSpace
        jmp ld_excape
    C2: call DrawCoin
        jmp ld_excape
    C3: call DrawWall
        jmp ld_excape
    ld_excape:
    inc esi
    loop ld1

    ret
LevelDisplayer1 ENDP 
;--------------------------------------------(Level 2)-----------------------------------------------
;--------------------------------------------(Level 1)-----------------------------------------------
DrawLevel2 PROC 

    mov esi,offset [l2_r01]
    mov ecx,lengthof l2_r01
    mov dl,0
    mov dh,6
    call Gotoxy
    call LevelDisplayer2

    mov esi,offset [l2_r02]
    mov ecx,lengthof l2_r02
    mov dl,0
    mov dh,7
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r03]
    mov ecx,lengthof l2_r03
    mov dl,0
    mov dh,8
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r04]
    mov ecx,lengthof l2_r04
    mov dl,0
    mov dh,9
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r05]
    mov ecx,lengthof l2_r05
    mov dl,0
    mov dh,10
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r06]
    mov ecx,lengthof l2_r06
    mov dl,0
    mov dh,11
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r07]
    mov ecx,lengthof l2_r07
    mov dl,0
    mov dh,12
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r08]
    mov ecx,lengthof l2_r08
    mov dl,0
    mov dh,13
    call Gotoxy
    call LevelDisplayer2

    mov esi,offset [l2_r09]
    mov ecx,lengthof l2_r09
    mov dl,0
    mov dh,14
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r10]
    mov ecx,lengthof l2_r10
    mov dl,0
    mov dh,15
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r11]
    mov ecx,lengthof l2_r11
    mov dl,0
    mov dh,16
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r12]
    mov ecx,lengthof l2_r12
    mov dl,0
    mov dh,17
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r13]
    mov ecx,lengthof l2_r13
    mov dl,0
    mov dh,18
    call Gotoxy
    call LevelDisplayer2

    mov esi,offset [l2_r14]
    mov ecx,lengthof l2_r14
    mov dl,0
    mov dh,19
    call Gotoxy
    call LevelDisplayer2

    mov esi,offset [l2_r15]
    mov ecx,lengthof l2_r15
    mov dl,0
    mov dh,20
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r16]
    mov ecx,lengthof l2_r16
    mov dl,0
    mov dh,21
    call Gotoxy
    call LevelDisplayer2

    mov esi,offset [l2_r17]
    mov ecx,lengthof l2_r17
    mov dl,0
    mov dh,22
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r18]
    mov ecx,lengthof l2_r18
    mov dl,0
    mov dh,23
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r19]
    mov ecx,lengthof l2_r19
    mov dl,0
    mov dh,24
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r20]
    mov ecx,lengthof l2_r20
    mov dl,0
    mov dh,25
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r21]
    mov ecx,lengthof l2_r21
    mov dl,0
    mov dh,26
    call Gotoxy
    call LevelDisplayer2
    
    mov esi,offset [l2_r22]
    mov ecx,lengthof l2_r22
    mov dl,0
    mov dh,27
    call Gotoxy
    call LevelDisplayer2
    ret 
DrawLevel2 ENDP 
LevelDisplayer2 PROC 
    dec ecx
    ld1:
        mov ebx,[esi]
        cmp bl,' '
        jz C1
        cmp bl,coin
        jz C2
        cmp bl,wall
        jz C3
        cmp bl,'*'
        jz C4
        call DrawWall
    C1: call DrawSpace
        jmp ld_excape
    C2: call DrawCoin
        jmp ld_excape
    C3: call DrawWall
        jmp ld_excape
    C4: call DrawFruit
        jmp ld_excape
    ld_excape:
    inc esi
    loop ld1

    ret
LevelDisplayer2 ENDP 
;--------------------------------------------(Level 3)-----------------------------------------------
;--------------------------------------------(Level 3)-----------------------------------------------
DrawLevel3 PROC 

    mov esi,offset [l3_r01]
    mov ecx,lengthof l3_r01
    mov dl,0
    mov dh,6
    call Gotoxy
    call LevelDisplayer3

    mov esi,offset [l3_r02]
    mov ecx,lengthof l3_r02
    mov dl,0
    mov dh,7
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r03]
    mov ecx,lengthof l3_r03
    mov dl,0
    mov dh,8
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r04]
    mov ecx,lengthof l3_r04
    mov dl,0
    mov dh,9
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r05]
    mov ecx,lengthof l3_r05
    mov dl,0
    mov dh,10
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r06]
    mov ecx,lengthof l3_r06
    mov dl,0
    mov dh,11
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r07]
    mov ecx,lengthof l3_r07
    mov dl,0
    mov dh,12
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r08]
    mov ecx,lengthof l3_r08
    mov dl,0
    mov dh,13
    call Gotoxy
    call LevelDisplayer3

    mov esi,offset [l3_r09]
    mov ecx,lengthof l3_r09
    mov dl,0
    mov dh,14
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r10]
    mov ecx,lengthof l3_r10
    mov dl,0
    mov dh,15
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r11]
    mov ecx,lengthof l3_r11
    mov dl,0
    mov dh,16
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r12]
    mov ecx,lengthof l3_r12
    mov dl,0
    mov dh,17
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r13]
    mov ecx,lengthof l3_r13
    mov dl,0
    mov dh,18
    call Gotoxy
    call LevelDisplayer3

    mov esi,offset [l3_r14]
    mov ecx,lengthof l3_r14
    mov dl,0
    mov dh,19
    call Gotoxy
    call LevelDisplayer3

    mov esi,offset [l3_r15]
    mov ecx,lengthof l3_r15
    mov dl,0
    mov dh,20
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r16]
    mov ecx,lengthof l3_r16
    mov dl,0
    mov dh,21
    call Gotoxy
    call LevelDisplayer3

    mov esi,offset [l3_r17]
    mov ecx,lengthof l3_r17
    mov dl,0
    mov dh,22
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r18]
    mov ecx,lengthof l3_r18
    mov dl,0
    mov dh,23
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r19]
    mov ecx,lengthof l3_r19
    mov dl,0
    mov dh,24
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r20]
    mov ecx,lengthof l3_r20
    mov dl,0
    mov dh,25
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r21]
    mov ecx,lengthof l3_r21
    mov dl,0
    mov dh,26
    call Gotoxy
    call LevelDisplayer3
    
    mov esi,offset [l3_r22]
    mov ecx,lengthof l3_r22
    mov dl,0
    mov dh,27
    call Gotoxy
    call LevelDisplayer3
    ret 
DrawLevel3 ENDP 
LevelDisplayer3 PROC 
    dec ecx
    ld1:
        mov ebx,[esi]
        cmp bl,' '
        jz C1
        cmp bl,coin
        jz C2
        cmp bl,wall
        jz C3
        cmp bl,'*'
        jz C4
        call DrawWall
    C1: call DrawSpace
        jmp ld_excape
    C2: call DrawCoin
        jmp ld_excape
    C3: call DrawWall
        jmp ld_excape
    C4: call DrawFruit
        jmp ld_excape
    ld_excape:
    inc esi
    loop ld1

    ret
LevelDisplayer3 ENDP 
;-------------------------------------(Wall/Coin/Spcae Printers)-------------------------------------
;-----------------------------------(Wall/Coin/Spcae Printers)---------------------------------------

DrawSpace PROC
    mov eax,0
    mov al,black (black*16)
    call SetTextColor
    mov al,' '
    call Writechar
    ret
DrawSpace ENDP
DrawCoin PROC
   
    mov eax,0
    mov al,white (black*16)
    call SetTextColor
    mov al,'o'
    call WriteChar
    ret
DrawCoin ENDP
DrawWall PROC
    mov eax,0
    mov eax,blue (blue *16)
    call SetTextColor
    mov al,wall
    call WriteChar
    ret
DrawWall ENDP
DrawFruit PROC
    mov eax,0
    mov eax,1101b
    call SetTextColor
    mov al,'*'
    call WriteChar
    ret
DrawFruit ENDP
DrawRedWall PROC 
    mov eax,0
    mov eax,red (red *16)
    call SetTextColor
    mov al,wall
    call WriteChar
    ret
DrawRedWall ENDP    
DrawBlueWall PROC 
    mov eax,0
    mov eax,blue (blue *16)
    call SetTextColor
    mov al,wall
    call WriteChar
    ret
DrawBlueWall ENDP  
DrawPinkWall PROC 
    mov eax,0
    mov eax,1101b (1101b *16)
    call SetTextColor
    mov al,wall
    call WriteChar
    ret
DrawPinkWall ENDP   
DrawWhiteWall PROC 
    mov eax,0
    mov eax,white (white *16)
    call SetTextColor
    mov al,wall
    call WriteChar
    ret
DrawWhiteWall ENDP  

;---------------------------------(Game Status/level/lives Updator)----------------------------------
;--------------------------------------------(Score Updator)-----------------------------------------
DrawScore PROC 
   
    ; draw score:
    mov eax,yellow (black * 16)
    call SetTextColor
    mov dl,7
    mov dh,3
    call Gotoxy
    mwrite "Score : ",0
    mov ax,score
    call Writedec

    mov eax,0
    mov dl,7
    mov dh,4
    call Gotoxy
    mwrite "Lives : ",0
    mov al,livesIndicator
    call Writedec


    mov eax,0
    mov dl,27
    mov dh,4
    call Gotoxy
    mwrite "Level : ",0
    mov al,levelIndicator
    call Writedec

    ret

DrawScore ENDP 
;---------------------------------------(Coordinate Getter)------------------------------------------
;---------------------------------------(Coordinate Getter)------------------------------------------
CoordinaterUpdator PROC 
    mov ebx,0
    mov bh,yPos
    sub bh,6
    mov bl,xPos
    ret
CoordinaterUpdator ENDP 
CoordinaterUpdatorGhost1 PROC 
    mov ebx,0
    mov bh,yG1Pos
    sub bh,6
    mov bl,xG1Pos
    ret
CoordinaterUpdatorGhost1 ENDP 
CoordinaterUpdatorGhost2 PROC 
    mov ebx,0
    mov bh,yG2Pos
    sub bh,6
    mov bl,xG2Pos
    ret
CoordinaterUpdatorGhost2 ENDP 
CoordinaterUpdatorGhost3 PROC 
    mov ebx,0
    mov bh,yG3Pos
    sub bh,6
    mov bl,xG3Pos
    ret
CoordinaterUpdatorGhost3 ENDP 
CoordinaterUpdatorGhost4 PROC 
    mov ebx,0
    mov bh,yG4Pos
    sub bh,6
    mov bl,xG4Pos
    ret
CoordinaterUpdatorGhost4 ENDP 
CoordinaterUpdatorGhost5 PROC 
    mov ebx,0
    mov bh,yG5Pos
    sub bh,6
    mov bl,xG5Pos
    ret
CoordinaterUpdatorGhost5 ENDP 
CoordinaterUpdatorGhost6 PROC 
    mov ebx,0
    mov bh,yG6Pos
    sub bh,6
    mov bl,xG6Pos
    ret
CoordinaterUpdatorGhost6 ENDP 
CoordinaterUpdatorGhost7 PROC 
    mov ebx,0
    mov bh,yG7Pos
    sub bh,6
    mov bl,xG7Pos
    ret
CoordinaterUpdatorGhost7 ENDP 
;----------------------------------------(Ghosts - Level 1)------------------------------------------
;----------------------------------------(Ghosts - Level 1)------------------------------------------
GetGhostRowl1 PROC
        cmp bh,1
        je l1_r02_Handle  
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle
        cmp bh,21
        je l1_r22_Handle
            
        l1_r02_Handle:  mov esi,offset l1_r02
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        jmp MovementChecker

        MovementChecker:
    ret
GetGhostRowl1 ENDP    
DrawGhost1 PROC 
    mov eax,0
    mov al,white (16*1101b)
    call SetTextColor
    mov dl,xG1Pos
    mov dh,yG1Pos
    call Gotoxy
    mov al,G1
    call WriteChar
    mov al,white (16*black)
    call SetTextColor
    ret
DrawGhost1 ENDP  
UpdateGhost1 PROC
    mov dl,xG1Pos
    mov dh,yG1Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG1Pos
    sub bh,6
    mov bl,xG1Pos
    call GetGhostRowl1
    mov cl,bl

    l1: inc esi
    loop l1

    mov edx,0
    mov dh,"."
    cmp [esi],dh
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost1 ENDP   
Ghost1Movement PROC 
        call Level1Intersection 

        mov Ghost1MovementPossibibly,1

        cmp Ghost1DirectionHandle,1
        je L1moveRight
        cmp Ghost1DirectionHandle,2
        je L1moveLeft
        cmp Ghost1DirectionHandle,3
        je L1moveUp
        cmp Ghost1DirectionHandle,4
        je L1MoveDown

        L1moveRight:   
            call UpdateGhost1
            inc xG1Pos
            inc xG1Pos
            mov Ghost1DirectionHandle,1
            call CoordinaterUpdatorGhost1
            call Level1MovementLeftRightGhost1 
            jmp L1SkipLeftRight

        L1moveLeft: 
            call UpdateGhost1
            dec xG1Pos
            dec xG1Pos
            mov Ghost1DirectionHandle,2
            call CoordinaterUpdatorGhost1
            call Level1MovementLeftRightGhost1 
            jmp L1SkipLeftRight

        L1moveUp:
            call UpdateGhost1
            dec yG1Pos
            mov Ghost1DirectionHandle,3
            call CoordinaterUpdatorGhost1
            call Level1MovementUpGhost1
            jmp L1SkipLeftRight

        L1MoveDown:
            call UpdateGhost1
            inc yG1Pos
            mov Ghost1DirectionHandle,4
            call CoordinaterUpdatorGhost1
            call Level1MovementDownGhost1
            jmp L1SkipLeftRight

        L1SkipLeftRight:      

        cmp Ghost1MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost1DirectionHandle,1
        je RightFixer
        cmp Ghost1DirectionHandle,2
        je LeftFixer
        cmp Ghost1DirectionHandle,3
        je UpFixer
        cmp Ghost1DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG1Pos
                    dec xG1Pos
                    jmp NewDirector
        LeftFixer:  inc xG1Pos
                    inc xG1Pos
                    jmp NewDirector
        UpFixer:    inc yG1Pos
                    jmp NewDirector
        DownFixer:  dec yG1Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost1DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost1Movement ENDP 

Level1MovementLeftRightGhost1 PROC 

        cmp bh,1
        je l1_r02_Handle  
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle
        cmp bh,21
        je l1_r22_Handle
            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call Ghost1WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level1MovementLeftRightGhost1 ENDP    
Level1MovementUpGhost1 PROC   

        cmp bh,0
        je l1_r01_Handle  
        cmp bh,1
        je l1_r02_Handle
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle

        l1_r01_Handle:  mov esi,offset l1_r01
                        call Ghost1WallChecker
                        jmp MovementChecker            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call Ghost1WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level1MovementUpGhost1 ENDP  
Level1MovementDownGhost1 PROC   

        cmp bh,0
        je l1_r01_Handle  
        cmp bh,1
        je l1_r02_Handle
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle

        l1_r01_Handle:  mov esi,offset l1_r01
                        call Ghost1WallChecker
                        jmp MovementChecker            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call Ghost1WallChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call Ghost1WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level1MovementDownGhost1 ENDP  
Ghost1WallChecker PROC
    mov ecx,0
    mov cl,bl
    l1loop1:
    inc esi
    loop l1loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost1MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost1WallChecker ENDP
;----------------------------------------(Ghosts - Level 2)------------------------------------------
;----------------------------------------(Ghosts - Level 2)------------------------------------------

GetGhostRowl2 PROC
        cmp bh,1
        je l2_r02_Handle  
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle
        cmp bh,21
        je l2_r22_Handle
            
        l2_r02_Handle:  mov esi,offset l2_r02
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        jmp MovementChecker
        MovementChecker:
    ret
GetGhostRowl2 ENDP    
DrawGhost2 PROC 
    mov eax,0
    mov al,white (16*1101b)
    call SetTextColor
    mov dl,xG2Pos
    mov dh,yG2Pos
    call Gotoxy
    mov al,G2
    call WriteChar
    mov al,white (16*black)
    call SetTextColor
    ret
DrawGhost2 ENDP  
UpdateGhost2 PROC
    mov dl,xG2Pos
    mov dh,yG2Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG2Pos
    sub bh,6
    mov bl,xG2Pos
    call GetGhostRowl2
    mov cl,bl

    l2: inc esi
    loop l2

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost2 ENDP  
Ghost2Movement PROC 
        call Level2Intersection 
    
        mov Ghost2MovementPossibibly,1

        cmp Ghost2DirectionHandle,1
        je l2moveRight
        cmp Ghost2DirectionHandle,2
        je l2moveLeft
        cmp Ghost2DirectionHandle,3
        je l2moveUp
        cmp Ghost2DirectionHandle,4
        je l2MoveDown

        l2moveRight:   
            call UpdateGhost2
            inc xG2Pos
            inc xG2Pos
            mov Ghost2DirectionHandle,1
            call CoordinaterUpdatorGhost2
            call Level2MovementLeftRightGhost2 
            jmp l2SkipLeftRight

        l2moveLeft: 
            call UpdateGhost2
            dec xG2Pos
            dec xG2Pos
            mov Ghost2DirectionHandle,2
            call CoordinaterUpdatorGhost2
            call Level2MovementLeftRightGhost2 
            jmp l2SkipLeftRight

        l2moveUp:
            call UpdateGhost2
            dec yG2Pos
            mov Ghost2DirectionHandle,3
            call CoordinaterUpdatorGhost2
            call Level2MovementUpGhost2
            jmp l2SkipLeftRight

        l2MoveDown:
            call UpdateGhost2
            inc yG2Pos
            mov Ghost2DirectionHandle,4
            call CoordinaterUpdatorGhost2
            call Level2MovementDownGhost2
            jmp l2SkipLeftRight

        l2SkipLeftRight:      

        cmp Ghost2MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost2DirectionHandle,1
        je RightFixer
        cmp Ghost2DirectionHandle,2
        je LeftFixer
        cmp Ghost2DirectionHandle,3
        je UpFixer
        cmp Ghost2DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG2Pos
                    dec xG2Pos
                    jmp NewDirector
        LeftFixer:  inc xG2Pos
                    inc xG2Pos
                    jmp NewDirector
        UpFixer:    inc yG2Pos
                    jmp NewDirector
        DownFixer:  dec yG2Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost2DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost2Movement ENDP 

DrawGhost3 PROC 
    mov eax,0
    mov al,white (16*cyan)
    call SetTextColor
    mov dl,xG3Pos
    mov dh,yG3Pos
    call Gotoxy
    mov al,G3
    call WriteChar
    mov al,white (16*black)
    call SetTextColor
    ret
DrawGhost3 ENDP  
UpdateGhost3 PROC
    mov dl,xG3Pos
    mov dh,yG3Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG3Pos
    sub bh,6
    mov bl,xG3Pos
    call GetGhostRowl2
    mov cl,bl

    l2: inc esi
    loop l2

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost3 ENDP  
Ghost3Movement PROC 
        call Level2Intersection 

        mov Ghost3MovementPossibibly,1

        cmp Ghost3DirectionHandle,1
        je l2moveRight
        cmp Ghost3DirectionHandle,2
        je l2moveLeft
        cmp Ghost3DirectionHandle,3
        je l2moveUp
        cmp Ghost3DirectionHandle,4
        je l2MoveDown

        l2moveRight:   
            call UpdateGhost3
            inc xG3Pos
            inc xG3Pos
            mov Ghost3DirectionHandle,1
            call CoordinaterUpdatorGhost3
            call Level2MovementLeftRightGhost3 
            jmp l2SkipLeftRight

        l2moveLeft: 
            call UpdateGhost3
            dec xG3Pos
            dec xG3Pos
            mov Ghost3DirectionHandle,2
            call CoordinaterUpdatorGhost3
            call Level2MovementLeftRightGhost3 
            jmp l2SkipLeftRight

        l2moveUp:
            call UpdateGhost3
            dec yG3Pos
            mov Ghost3DirectionHandle,3
            call CoordinaterUpdatorGhost3
            call Level2MovementUpGhost3
            jmp l2SkipLeftRight

        l2MoveDown:
            call UpdateGhost3
            inc yG3Pos
            mov Ghost3DirectionHandle,4
            call CoordinaterUpdatorGhost3
            call Level2MovementDownGhost3
            jmp l2SkipLeftRight

        l2SkipLeftRight:      

        cmp Ghost3MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost3DirectionHandle,1
        je RightFixer
        cmp Ghost3DirectionHandle,2
        je LeftFixer
        cmp Ghost3DirectionHandle,3
        je UpFixer
        cmp Ghost3DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG3Pos
                    dec xG3Pos
                    jmp NewDirector
        LeftFixer:  inc xG3Pos
                    inc xG3Pos
                    jmp NewDirector
        UpFixer:    inc yG3Pos
                    jmp NewDirector
        DownFixer:  dec yG3Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost3DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost3Movement ENDP 

Level2MovementLeftRightGhost2 PROC 

        cmp bh,1
        je l2_r02_Handle  
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle
        cmp bh,21
        je l2_r22_Handle
            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost2WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level2MovementLeftRightGhost2 ENDP    
Level2MovementUpGhost2 PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call Ghost2WallChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost2WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementUpGhost2 ENDP  
Level2MovementDownGhost2 PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call Ghost2WallChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost2WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost2WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementDownGhost2 ENDP  
Ghost2WallChecker PROC
    mov ecx,0
    mov cl,bl
    l2loop1:
    inc esi
    loop l2loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost2MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost2WallChecker ENDP

Level2MovementLeftRightGhost3 PROC 

        cmp bh,1
        je l2_r02_Handle  
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle
        cmp bh,21
        je l2_r22_Handle
            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost3WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level2MovementLeftRightGhost3 ENDP    
Level2MovementUpGhost3 PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call Ghost3WallChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost3WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementUpGhost3 ENDP  
Level2MovementDownGhost3 PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call Ghost3WallChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call Ghost3WallChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call Ghost3WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementDownGhost3 ENDP  
Ghost3WallChecker PROC
    mov ecx,0
    mov cl,bl
    l2loop1:
    inc esi
    loop l2loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost3MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost3WallChecker ENDP

;----------------------------------------(Ghosts - Level 3)------------------------------------------
;----------------------------------------(Ghosts - Level 2)------------------------------------------
GetGhostRowl3 PROC
        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        jmp MovementChecker
        MovementChecker:
    ret
GetGhostRowl3 ENDP 

DrawGhost4 PROC 
    mov eax,0
    mov al,white (110b*16)
    call SetTextColor
    mov dl,xG4Pos
    mov dh,yG4Pos
    call Gotoxy
    mov al,G4
    call WriteChar
    mov al,black (black*16)
    call SetTextColor
    ret
DrawGhost4 ENDP  
UpdateGhost4 PROC
    mov dl,xG4Pos
    mov dh,yG4Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG4Pos
    sub bh,6
    mov bl,xG4Pos
    call GetGhostRowl3
    mov cl,bl

    l3: inc esi
    loop l3

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost4 ENDP  
Ghost4Movement PROC 
        call Level3Intersection 

        mov Ghost4MovementPossibibly,1

        cmp Ghost4DirectionHandle,1
        je l3moveRight
        cmp Ghost4DirectionHandle,2
        je l3moveLeft
        cmp Ghost4DirectionHandle,3
        je l3moveUp
        cmp Ghost4DirectionHandle,4
        je l3MoveDown

        l3moveRight:   
            call UpdateGhost4
            inc xG4Pos
            inc xG4Pos
            mov Ghost4DirectionHandle,1
            call CoordinaterUpdatorGhost4
            call Level3MovementLeftRightGhost4 
            jmp l3SkipLeftRight

        l3moveLeft: 
            call UpdateGhost4
            dec xG4Pos
            dec xG4Pos
            mov Ghost4DirectionHandle,2
            call CoordinaterUpdatorGhost4
            call Level3MovementLeftRightGhost4 
            jmp l3SkipLeftRight

        l3moveUp:
            call UpdateGhost4
            dec yG4Pos
            mov Ghost4DirectionHandle,3
            call CoordinaterUpdatorGhost4
            call Level3MovementUpGhost4
            jmp l3SkipLeftRight

        l3MoveDown:
            call UpdateGhost4
            inc yG4Pos
            mov Ghost4DirectionHandle,4
            call CoordinaterUpdatorGhost4
            call Level3MovementDownGhost4
            jmp l3SkipLeftRight

        l3SkipLeftRight:      

        cmp Ghost4MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost4DirectionHandle,1
        je RightFixer
        cmp Ghost4DirectionHandle,2
        je LeftFixer
        cmp Ghost4DirectionHandle,3
        je UpFixer
        cmp Ghost4DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG4Pos
                    dec xG4Pos
                    jmp NewDirector
        LeftFixer:  inc xG4Pos
                    inc xG4Pos
                    jmp NewDirector
        UpFixer:    inc yG4Pos
                    jmp NewDirector
        DownFixer:  dec yG4Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost4DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost4Movement ENDP 

DrawGhost5 PROC 
    mov eax,0
    mov al,white (1011b * 16)
    call SetTextColor
    mov dl,xG5Pos
    mov dh,yG5Pos
    call Gotoxy
    mov al,G5
    call WriteChar
    ret
DrawGhost5 ENDP  
UpdateGhost5 PROC
    mov dl,xG5Pos
    mov dh,yG5Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG5Pos
    sub bh,6
    mov bl,xG5Pos
    call GetGhostRowl3
    mov cl,bl

    l3: inc esi
    loop l3

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost5 ENDP  
Ghost5Movement PROC 
        call Level3Intersection 

        mov Ghost5MovementPossibibly,1

        cmp Ghost5DirectionHandle,1
        je l3moveRight
        cmp Ghost5DirectionHandle,2
        je l3moveLeft
        cmp Ghost5DirectionHandle,3
        je l3moveUp
        cmp Ghost5DirectionHandle,4
        je l3MoveDown

        l3moveRight:   
            call UpdateGhost5
            inc xG5Pos
            inc xG5Pos
            mov Ghost5DirectionHandle,1
            call CoordinaterUpdatorGhost5
            call Level3MovementLeftRightGhost5 
            jmp l3SkipLeftRight

        l3moveLeft: 
            call UpdateGhost5
            dec xG5Pos
            dec xG5Pos
            mov Ghost5DirectionHandle,2
            call CoordinaterUpdatorGhost5
            call Level3MovementLeftRightGhost5 
            jmp l3SkipLeftRight

        l3moveUp:
            call UpdateGhost5
            dec yG5Pos
            mov Ghost5DirectionHandle,3
            call CoordinaterUpdatorGhost5
            call Level3MovementUpGhost5
            jmp l3SkipLeftRight

        l3MoveDown:
            call UpdateGhost5
            inc yG5Pos
            mov Ghost5DirectionHandle,4
            call CoordinaterUpdatorGhost5
            call Level3MovementDownGhost5
            jmp l3SkipLeftRight

        l3SkipLeftRight:      

        cmp Ghost5MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost5DirectionHandle,1
        je RightFixer
        cmp Ghost5DirectionHandle,2
        je LeftFixer
        cmp Ghost5DirectionHandle,3
        je UpFixer
        cmp Ghost5DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG5Pos
                    dec xG5Pos
                    jmp NewDirector
        LeftFixer:  inc xG5Pos
                    inc xG5Pos
                    jmp NewDirector
        UpFixer:    inc yG5Pos
                    jmp NewDirector
        DownFixer:  dec yG5Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost5DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost5Movement ENDP 

DrawGhost6 PROC 
    mov eax,0
    mov al,white (1100b * 16)
    call SetTextColor
    mov dl,xG6Pos
    mov dh,yG6Pos
    call Gotoxy
    mov al,G6
    call WriteChar
    ret
DrawGhost6 ENDP  
UpdateGhost6 PROC
    mov dl,xG6Pos
    mov dh,yG6Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG6Pos
    sub bh,6
    mov bl,xG6Pos
    call GetGhostRowl3
    mov cl,bl

    l3: inc esi
    loop l3

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost6 ENDP  
Ghost6Movement PROC 
        call Level3Intersection 
    
        mov Ghost6MovementPossibibly,1

        cmp Ghost6DirectionHandle,1
        je l3moveRight
        cmp Ghost6DirectionHandle,2
        je l3moveLeft
        cmp Ghost6DirectionHandle,3
        je l3moveUp
        cmp Ghost6DirectionHandle,4
        je l3MoveDown

        l3moveRight:   
            call UpdateGhost6
            inc xG6Pos
            inc xG6Pos
            mov Ghost6DirectionHandle,1
            call CoordinaterUpdatorGhost6
            call Level3MovementLeftRightGhost6 
            jmp l3SkipLeftRight

        l3moveLeft: 
            call UpdateGhost6
            dec xG6Pos
            dec xG6Pos
            mov Ghost6DirectionHandle,2
            call CoordinaterUpdatorGhost6
            call Level3MovementLeftRightGhost6 
            jmp l3SkipLeftRight

        l3moveUp:
            call UpdateGhost6
            dec yG6Pos
            mov Ghost6DirectionHandle,3
            call CoordinaterUpdatorGhost6
            call Level3MovementUpGhost6
            jmp l3SkipLeftRight

        l3MoveDown:
            call UpdateGhost6
            inc yG6Pos
            mov Ghost6DirectionHandle,4
            call CoordinaterUpdatorGhost6
            call Level3MovementDownGhost6
            jmp l3SkipLeftRight

        l3SkipLeftRight:      

        cmp Ghost6MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost6DirectionHandle,1
        je RightFixer
        cmp Ghost6DirectionHandle,2
        je LeftFixer
        cmp Ghost6DirectionHandle,3
        je UpFixer
        cmp Ghost6DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG6Pos
                    dec xG6Pos
                    jmp NewDirector
        LeftFixer:  inc xG6Pos
                    inc xG6Pos
                    jmp NewDirector
        UpFixer:    inc yG6Pos
                    jmp NewDirector
        DownFixer:  dec yG6Pos

        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost6DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost6Movement ENDP 

DrawGhost7 PROC 
    mov eax,0
    mov al,white (1101b*16)
    call SetTextColor
    mov dl,xG7Pos
    mov dh,yG7Pos
    call Gotoxy
    mov al,G7
    call WriteChar
    ret
DrawGhost7 ENDP  
UpdateGhost7 PROC
    mov dl,xG7Pos
    mov dh,yG7Pos    
    call Gotoxy
    mov ebx,0
    mov bh,yG7Pos
    sub bh,6
    mov bl,xG7Pos
    call GetGhostRowl3
    mov cl,bl

    l3: inc esi
    loop l3

    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne next
    mov eax,white (black*16)
    call settextcolor
    mov al,"o"
    call Writechar
    next:
    mov dl,"*"
    cmp [esi],dl
    jne skip
    mov eax,1101b (black*16)
    call settextcolor
    mov al,"*"
    call Writechar
    skip:
    mov al," "
    call WriteChar
    escape:      
    ret
UpdateGhost7 ENDP  
Ghost7Movement PROC 
        call Level3Intersection 
        
        mov Ghost7MovementPossibibly,1

        cmp Ghost7DirectionHandle,1
        je l3moveRight
        cmp Ghost7DirectionHandle,2
        je l3moveLeft
        cmp Ghost7DirectionHandle,3
        je l3moveUp
        cmp Ghost7DirectionHandle,4
        je l3MoveDown

        l3moveRight:   
            call UpdateGhost7
            inc xG7Pos
            inc xG7Pos
            mov Ghost7DirectionHandle,1
            call CoordinaterUpdatorGhost7
            call Level3MovementLeftRightGhost7 
            jmp l3SkipLeftRight

        l3moveLeft: 
            call UpdateGhost7
            dec xG7Pos
            dec xG7Pos
            mov Ghost7DirectionHandle,2
            call CoordinaterUpdatorGhost7
            call Level3MovementLeftRightGhost7 
            jmp l3SkipLeftRight

        l3moveUp:
            call UpdateGhost7
            dec yG7Pos
            mov Ghost7DirectionHandle,3
            call CoordinaterUpdatorGhost7
            call Level3MovementUpGhost7
            jmp l3SkipLeftRight

        l3MoveDown:
            call UpdateGhost7
            inc yG7Pos
            mov Ghost7DirectionHandle,4
            call CoordinaterUpdatorGhost7
            call Level3MovementDownGhost7
            jmp l3SkipLeftRight

        l3SkipLeftRight:      

        cmp Ghost7MovementPossibibly,0
        je GhostMovementFixer
        jmp SkipMovementFixer

        GhostMovementFixer:
        cmp Ghost7DirectionHandle,1
        je RightFixer
        cmp Ghost7DirectionHandle,2
        je LeftFixer
        cmp Ghost7DirectionHandle,3
        je UpFixer
        cmp Ghost7DirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xG7Pos
                    dec xG7Pos
                    jmp NewDirector
        LeftFixer:  inc xG7Pos
                    inc xG7Pos
                    jmp NewDirector
        UpFixer:    inc yG7Pos
                    jmp NewDirector
        DownFixer:  dec yG7Pos
       
        NewDirector:
        mov  eax,4     ;get random 0 to 99
        call RandomRange ;
        inc  eax         ;make range 1 to 100
        mov  Ghost7DirectionHandle,al  ;save random number
        SkipMovementFixer:

    ret
Ghost7Movement ENDP 

Level3MovementLeftRightGhost4 PROC 

        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost4WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level3MovementLeftRightGhost4 ENDP    
Level3MovementUpGhost4 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost4WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost4WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementUpGhost4 ENDP  
Level3MovementDownGhost4 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost4WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost4WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost4WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementDownGhost4 ENDP  
Ghost4WallChecker PROC
    mov ecx,0
    mov cl,bl
    l3loop1:
    inc esi
    loop l3loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost4MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost4WallChecker ENDP

Level3MovementLeftRightGhost5 PROC 

        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost5WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level3MovementLeftRightGhost5 ENDP    
Level3MovementUpGhost5 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost5WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost5WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementUpGhost5 ENDP  
Level3MovementDownGhost5 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost5WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost5WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost5WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementDownGhost5 ENDP  
Ghost5WallChecker PROC
    mov ecx,0
    mov cl,bl
    l3loop1:
    inc esi
    loop l3loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost5MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost5WallChecker ENDP

Level3MovementLeftRightGhost6 PROC 

        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost6WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level3MovementLeftRightGhost6 ENDP    
Level3MovementUpGhost6 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost6WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost6WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementUpGhost6 ENDP  
Level3MovementDownGhost6 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost6WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost6WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost6WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementDownGhost6 ENDP  
Ghost6WallChecker PROC
    mov ecx,0
    mov cl,bl
    l3loop1:
    inc esi
    loop l3loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost6MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost6WallChecker ENDP

Level3MovementLeftRightGhost7 PROC 

        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost7WallChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level3MovementLeftRightGhost7 ENDP    
Level3MovementUpGhost7 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost7WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost7WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementUpGhost7 ENDP  
Level3MovementDownGhost7 PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call Ghost7WallChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call Ghost7WallChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call Ghost7WallChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementDownGhost7 ENDP  
Ghost7WallChecker PROC
    mov ecx,0
    mov cl,bl
    l3loop1:
    inc esi
    loop l3loop1

    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne Replacer 
        mov Ghost7MovementPossibibly,0
    Replacer:
    EscapeReplacer:
    ret
Ghost7WallChecker ENDP

;----------------------------------------------(Player)----------------------------------------------
;------------------------------------------------------------------------------------

DrawPlayer PROC
    ; draw player at (xPos,yPos):
    mov eax,0
    mov al,red (yellow*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al,'@'
    call WriteChar
    ret
DrawPlayer ENDP
UpdatePlayer PROC
    mov al,black (black*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al," "
    call WriteChar
    ret
UpdatePlayer ENDP

Level1Intersection PROC 
	
	mov eax,0
	mov ebx,0
	mov al,xPos
	mov ah,yPos
	mov bl,xG1Pos
	mov bh,yG1Pos
	cmp al,bl
	jne skip
	cmp ah,bh
	jne skip
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen    
    mov eax,200
    call delay
    call Level1Maze 
    mov eax,200
    call delay
	skip:

	ret
Level1Intersection ENDP 
Level2Intersection PROC 
	
	mov eax,0
	mov ebx,0
	mov al,xPos
	mov ah,yPos
	mov bl,xG2Pos
	mov bh,yG2Pos
	cmp al,bl
	jne skip1
	cmp ah,bh
	jne skip1
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level2Maze 

	skip1:
	mov bl,xG3Pos
	mov bh,yG3Pos
	cmp al,bl
	jne skip2
	cmp ah,bh
	jne skip2
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level2Maze 
	skip2:

	ret
Level2Intersection ENDP 
Level3Intersection PROC 
	
	mov eax,0
	mov ebx,0
	mov al,xPos
	mov ah,yPos
	mov bl,xG4Pos
	mov bh,yG4Pos
	cmp al,bl
	jne skip1
	cmp ah,bh
	jne skip1
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level3Maze 

	skip1:
	mov bl,xG5Pos
	mov bh,yG5Pos
	cmp al,bl
	jne skip2
	cmp ah,bh
	jne skip2
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level3Maze 

	skip2:
	mov bl,xG6Pos
	mov bh,yG6Pos
	cmp al,bl
	jne skip3
	cmp ah,bh
	jne skip3
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level3Maze 
	skip3:
	mov bl,xG7Pos
	mov bh,yG7Pos
	cmp al,bl
	jne skip4
	cmp ah,bh
	jne skip4
	dec livesIndicator
    cmp livesIndicator,0
    je EndScreen 
    mov eax,200
    call delay
    call Level3Maze 
	skip4:

	ret
Level3Intersection ENDP 

PlayerMovement1 PROC 
        mov PlayerMovement1Possibibly,1
        call Level1Intersection 
        LookForKey:
            
            mov  eax,speed1    ;   1000=1sec
            call Delay
           ; INVOKE PlaySound, OFFSET musicChomp, NULL, SND_FILENAME
            call ReadKey         ; look for keyboard input
            mov inputChar,al
            jnz MovementcheckerCharacter
        ;call ReadChar
        cmp PlayerDirectionHandle,1
        je L1moveRight
        cmp PlayerDirectionHandle,2
        je L1moveLeft
        cmp PlayerDirectionHandle,3
        je L1moveUp
        cmp PlayerDirectionHandle,4
        je L1MoveDown

        MovementcheckerCharacter:
        cmp inputChar,"d"
        je L1moveRight
        cmp inputChar,"a"
        je L1moveLeft
        cmp inputChar,"w"
        je L1moveUp
        cmp inputChar,"s"
        je L1MoveDown
        cmp inputChar,"p"
        call readchar
        jmp LookForKey

        jmp L1SkipLeftRight

        L1moveRight:
            call UpdatePlayer
            inc xPos
            inc xPos
            mov PlayerDirectionHandle,1
            call CoordinaterUpdator
            call Level1MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveLeft:
            call UpdatePlayer
            dec xPos
            dec xPos
            mov PlayerDirectionHandle,2
            call CoordinaterUpdator
            call Level1MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveUp:
            call UpdatePlayer
            dec yPos
            mov PlayerDirectionHandle,3
            call CoordinaterUpdator
            call Level1MovementUp
            jmp L1SkipLeftRight

        L1MoveDown:
            call UpdatePlayer
            inc yPos
            mov PlayerDirectionHandle,4
            call CoordinaterUpdator
            call Level1MovementDown
            jmp L1SkipLeftRight

        L1SkipLeftRight:

       

        cmp PlayerMovement1Possibibly,0
        je PlayerMovement1Fixer
        jmp SkipMovementFixer

        PlayerMovement1Fixer:
        cmp PlayerDirectionHandle,1
        je RightFixer
        cmp PlayerDirectionHandle,2
        je LeftFixer
        cmp PlayerDirectionHandle,3
        je UpFixer
        cmp PlayerDirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xPos
                    dec xPos
                    jmp SkipMovementFixer
        LeftFixer:  inc xPos
                    inc xPos
                    jmp SkipMovementFixer
        UpFixer:    inc yPos
                    jmp SkipMovementFixer
        DownFixer:  dec yPos

        SkipMovementFixer:
    ret
PlayerMovement1 ENDP 
Level1MovementLeftRight PROC 

        cmp bh,1
        je l1_r02_Handle  
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle
        cmp bh,21
        je l1_r22_Handle
            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call WallCoinChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level1MovementLeftRight ENDP    
Level1MovementUp PROC   

        cmp bh,0
        je l1_r01_Handle  
        cmp bh,1
        je l1_r02_Handle
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle

        l1_r01_Handle:  mov esi,offset l1_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level1MovementUp ENDP  
Level1MovementDown PROC   

        cmp bh,0
        je l1_r01_Handle  
        cmp bh,1
        je l1_r02_Handle
        cmp bh,2
        je l1_r03_Handle
        cmp bh,3
        je l1_r04_Handle
        cmp bh,4
        je l1_r05_Handle
        cmp bh,5
        je l1_r06_Handle
        cmp bh,6
        je l1_r07_Handle
        cmp bh,7
        je l1_r08_Handle
        cmp bh,8
        je l1_r09_Handle
        cmp bh,9
        je l1_r10_Handle
        cmp bh,10
        je l1_r11_Handle
        cmp bh,11
        je l1_r12_Handle
        cmp bh,12
        je l1_r13_Handle
        cmp bh,13
        je l1_r14_Handle
        cmp bh,14
        je l1_r15_Handle
        cmp bh,15
        je l1_r16_Handle
        cmp bh,16
        je l1_r17_Handle
        cmp bh,17
        je l1_r18_Handle
        cmp bh,18
        je l1_r19_Handle
        cmp bh,19
        je l1_r20_Handle
        cmp bh,20
        je l1_r21_Handle

        l1_r01_Handle:  mov esi,offset l1_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l1_r02_Handle:  mov esi,offset l1_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r03_Handle:  mov esi,offset l1_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r04_Handle:  mov esi,offset l1_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r05_Handle:  mov esi,offset l1_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r06_Handle:  mov esi,offset l1_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r07_Handle:  mov esi,offset l1_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r08_Handle:  mov esi,offset l1_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r09_Handle:  mov esi,offset l1_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r10_Handle:  mov esi,offset l1_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r11_Handle:  mov esi,offset l1_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r12_Handle:  mov esi,offset l1_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r13_Handle:  mov esi,offset l1_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r14_Handle:  mov esi,offset l1_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r15_Handle:  mov esi,offset l1_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r16_Handle:  mov esi,offset l1_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r17_Handle:  mov esi,offset l1_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r18_Handle:  mov esi,offset l1_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r19_Handle:  mov esi,offset l1_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r20_Handle:  mov esi,offset l1_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r21_Handle:  mov esi,offset l1_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l1_r22_Handle:  mov esi,offset l1_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level1MovementDown ENDP  
PlayerMovement2 PROC 
        call Level2Intersection 
        mov PlayerMovement1Possibibly,1
        LookForKey:
            mov  eax,speed2    ;   1000=1sec
            call Delay
            call ReadKey         ; look for keyboard input
            mov inputChar,al
            jnz MovementcheckerCharacter
        ;call ReadChar
        cmp PlayerDirectionHandle,1
        je L1moveRight
        cmp PlayerDirectionHandle,2
        je L1moveLeft
        cmp PlayerDirectionHandle,3
        je L1moveUp
        cmp PlayerDirectionHandle,4
        je L1MoveDown

        MovementcheckerCharacter:
        cmp inputChar,"d"
        je L1moveRight
        cmp inputChar,"a"
        je L1moveLeft
        cmp inputChar,"w"
        je L1moveUp
        cmp inputChar,"s"
        je L1MoveDown
        cmp inputChar,"p"
        call readchar
        jmp LookForKey

        jmp L1SkipLeftRight

        L1moveRight:
            call UpdatePlayer
            inc xPos
            inc xPos
            mov PlayerDirectionHandle,1
            call CoordinaterUpdator
            call Level2MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveLeft:
            call UpdatePlayer
            dec xPos
            dec xPos
            mov PlayerDirectionHandle,2
            call CoordinaterUpdator
            call Level2MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveUp:
            call UpdatePlayer
            dec yPos
            mov PlayerDirectionHandle,3
            call CoordinaterUpdator
            call Level2MovementUp
            jmp L1SkipLeftRight

        L1MoveDown:
            call UpdatePlayer
            inc yPos
            mov PlayerDirectionHandle,4
            call CoordinaterUpdator
            call Level2MovementDown
            jmp L1SkipLeftRight

        L1SkipLeftRight:

       

        cmp PlayerMovement1Possibibly,0
        je PlayerMovement1Fixer
        jmp SkipMovementFixer

        PlayerMovement1Fixer:
        cmp PlayerDirectionHandle,1
        je RightFixer
        cmp PlayerDirectionHandle,2
        je LeftFixer
        cmp PlayerDirectionHandle,3
        je UpFixer
        cmp PlayerDirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xPos
                    dec xPos
                    jmp SkipMovementFixer
        LeftFixer:  inc xPos
                    inc xPos
                    jmp SkipMovementFixer
        UpFixer:    inc yPos
                    jmp SkipMovementFixer
        DownFixer:  dec yPos

        SkipMovementFixer:
    ret
PlayerMovement2 ENDP
Level2MovementLeftRight PROC 

        cmp bh,1
        je l2_r02_Handle  
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle
        cmp bh,21
        je l2_r22_Handle
            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call WallCoinChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level2MovementLeftRight ENDP    
Level2MovementUp PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementUp ENDP  
Level2MovementDown PROC   

        cmp bh,0
        je l2_r01_Handle  
        cmp bh,1
        je l2_r02_Handle
        cmp bh,2
        je l2_r03_Handle
        cmp bh,3
        je l2_r04_Handle
        cmp bh,4
        je l2_r05_Handle
        cmp bh,5
        je l2_r06_Handle
        cmp bh,6
        je l2_r07_Handle
        cmp bh,7
        je l2_r08_Handle
        cmp bh,8
        je l2_r09_Handle
        cmp bh,9
        je l2_r10_Handle
        cmp bh,10
        je l2_r11_Handle
        cmp bh,11
        je l2_r12_Handle
        cmp bh,12
        je l2_r13_Handle
        cmp bh,13
        je l2_r14_Handle
        cmp bh,14
        je l2_r15_Handle
        cmp bh,15
        je l2_r16_Handle
        cmp bh,16
        je l2_r17_Handle
        cmp bh,17
        je l2_r18_Handle
        cmp bh,18
        je l2_r19_Handle
        cmp bh,19
        je l2_r20_Handle
        cmp bh,20
        je l2_r21_Handle

        l2_r01_Handle:  mov esi,offset l2_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l2_r02_Handle:  mov esi,offset l2_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r03_Handle:  mov esi,offset l2_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r04_Handle:  mov esi,offset l2_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r05_Handle:  mov esi,offset l2_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r06_Handle:  mov esi,offset l2_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r07_Handle:  mov esi,offset l2_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r08_Handle:  mov esi,offset l2_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r09_Handle:  mov esi,offset l2_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r10_Handle:  mov esi,offset l2_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r11_Handle:  mov esi,offset l2_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r12_Handle:  mov esi,offset l2_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r13_Handle:  mov esi,offset l2_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r14_Handle:  mov esi,offset l2_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r15_Handle:  mov esi,offset l2_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r16_Handle:  mov esi,offset l2_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r17_Handle:  mov esi,offset l2_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r18_Handle:  mov esi,offset l2_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r19_Handle:  mov esi,offset l2_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r20_Handle:  mov esi,offset l2_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r21_Handle:  mov esi,offset l2_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l2_r22_Handle:  mov esi,offset l2_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level2MovementDown ENDP  
PlayerMovement3 PROC 
    
        call Level3Intersection 
        cmp xPos,6
        jne SkipA
        cmp yPos,16
        jne SkipA
        
        mov xPos,66
        call DrawLevel3

        SkipA:
        cmp xPos,68
        jne SkipB
        cmp yPos,16
        jne SkipB
        mov xPos,8
        call DrawLevel3
        SkipB:

        
        mov PlayerMovement1Possibibly,1
        LookForKey:
            mov  eax,speed3    ;   1000=1sec
            call Delay
            call Readkey       ; look for keyboard input
            mov inputChar,al
            jnz MovementcheckerCharacter
        ;call ReadChar
        cmp PlayerDirectionHandle,1
        je L1moveRight
        cmp PlayerDirectionHandle,2
        je L1moveLeft
        cmp PlayerDirectionHandle,3
        je L1moveUp
        cmp PlayerDirectionHandle,4
        je L1MoveDown

        MovementcheckerCharacter:
        cmp inputChar,"d"
        je L1moveRight
        cmp inputChar,"a"
        je L1moveLeft
        cmp inputChar,"w"
        je L1moveUp
        cmp inputChar,"s"
        je L1MoveDown
        cmp inputChar,"p"
        call readchar
        jmp LookForKey

        jmp L1SkipLeftRight

        L1moveRight:
            call UpdatePlayer
            inc xPos
            inc xPos
            mov PlayerDirectionHandle,1
            call CoordinaterUpdator
            call Level3MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveLeft:
            call UpdatePlayer
            dec xPos
            dec xPos
            mov PlayerDirectionHandle,2
            call CoordinaterUpdator
            call Level3MovementLeftRight 
            jmp L1SkipLeftRight

        L1moveUp:
            call UpdatePlayer
            dec yPos
            mov PlayerDirectionHandle,3
            call CoordinaterUpdator
            call Level3MovementUp
            jmp L1SkipLeftRight

        L1MoveDown:
            call UpdatePlayer
            inc yPos
            mov PlayerDirectionHandle,4
            call CoordinaterUpdator
            call Level3MovementDown
            jmp L1SkipLeftRight

        L1SkipLeftRight:

       

        cmp PlayerMovement1Possibibly,0
        je PlayerMovement1Fixer
        jmp SkipMovementFixer

        PlayerMovement1Fixer:
        cmp PlayerDirectionHandle,1
        je RightFixer
        cmp PlayerDirectionHandle,2
        je LeftFixer
        cmp PlayerDirectionHandle,3
        je UpFixer
        cmp PlayerDirectionHandle,4
        je DownFixer
        jmp SkipMovementFixer

        RightFixer: dec xPos
                    dec xPos
                    jmp SkipMovementFixer
        LeftFixer:  inc xPos
                    inc xPos
                    jmp SkipMovementFixer
        UpFixer:    inc yPos
                    jmp SkipMovementFixer
        DownFixer:  dec yPos

        SkipMovementFixer:
    ret
PlayerMovement3 ENDP
Level3MovementLeftRight PROC 

        cmp bh,1
        je l3_r02_Handle  
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle
        cmp bh,21
        je l3_r22_Handle
            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call WallCoinChecker
                        jmp MovementChecker

        MovementChecker:
    ret
Level3MovementLeftRight ENDP    
Level3MovementUp PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementUp ENDP  
Level3MovementDown PROC   

        cmp bh,0
        je l3_r01_Handle  
        cmp bh,1
        je l3_r02_Handle
        cmp bh,2
        je l3_r03_Handle
        cmp bh,3
        je l3_r04_Handle
        cmp bh,4
        je l3_r05_Handle
        cmp bh,5
        je l3_r06_Handle
        cmp bh,6
        je l3_r07_Handle
        cmp bh,7
        je l3_r08_Handle
        cmp bh,8
        je l3_r09_Handle
        cmp bh,9
        je l3_r10_Handle
        cmp bh,10
        je l3_r11_Handle
        cmp bh,11
        je l3_r12_Handle
        cmp bh,12
        je l3_r13_Handle
        cmp bh,13
        je l3_r14_Handle
        cmp bh,14
        je l3_r15_Handle
        cmp bh,15
        je l3_r16_Handle
        cmp bh,16
        je l3_r17_Handle
        cmp bh,17
        je l3_r18_Handle
        cmp bh,18
        je l3_r19_Handle
        cmp bh,19
        je l3_r20_Handle
        cmp bh,20
        je l3_r21_Handle

        l3_r01_Handle:  mov esi,offset l3_r01
                        call WallCoinChecker
                        jmp MovementChecker            
        l3_r02_Handle:  mov esi,offset l3_r02
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r03_Handle:  mov esi,offset l3_r03
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r04_Handle:  mov esi,offset l3_r04
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r05_Handle:  mov esi,offset l3_r05
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r06_Handle:  mov esi,offset l3_r06
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r07_Handle:  mov esi,offset l3_r07
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r08_Handle:  mov esi,offset l3_r08
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r09_Handle:  mov esi,offset l3_r09
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r10_Handle:  mov esi,offset l3_r10
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r11_Handle:  mov esi,offset l3_r11
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r12_Handle:  mov esi,offset l3_r12
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r13_Handle:  mov esi,offset l3_r13
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r14_Handle:  mov esi,offset l3_r14
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r15_Handle:  mov esi,offset l3_r15
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r16_Handle:  mov esi,offset l3_r16
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r17_Handle:  mov esi,offset l3_r17
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r18_Handle:  mov esi,offset l3_r18
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r19_Handle:  mov esi,offset l3_r19
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r20_Handle:  mov esi,offset l3_r20
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r21_Handle:  mov esi,offset l3_r21
                        call WallCoinChecker
                        jmp MovementChecker
        l3_r22_Handle:  mov esi,offset l3_r22
                        call WallCoinChecker
                        jmp MovementChecker
        MovementChecker:
    ret
Level3MovementDown ENDP  
WallCoinChecker PROC
    mov ecx,0
    mov cl,bl
    l1loop1:
    inc esi
    loop l1loop1
    mov edx,0
    mov dl,wall
    cmp [esi],dl
    jne replacewithspace 
        mov PlayerMovement1Possibibly,0
        jmp EscapeReplacer
    replacewithspace:
    mov ecx,20h
    mov edx,0
    mov dl,"."
    cmp [esi],dl
    jne SkipScreIncrease
    add score,10
    dec CurrentCoins

    SkipScreIncrease:
    mov edx,0
    mov dl,"*"
    cmp [esi],dl
    jne Skip
    add score,100
    
    ;INVOKE PlaySound, OFFSET musicFruit, NULL, SND_FILENAME
   

    jmp Skip
    Skip:
    mov [esi],cl
    EscapeReplacer:
    ret
WallCoinChecker ENDP

;----------------------------------------------(Levels)----------------------------------------------
;----------------------------------------------(Player)----------------------------------------------
;------------------------------------------------------------------------------------

Level1Maze PROC
        mov xPos,8
        mov yPos,7
        mov xG1Pos,10
        mov yG1Pos,15

        call clrscr
        call DrawLevel1
    gameLoop1:

        call DrawScore    
        call Ghost1Movement
        call DrawGhost1

        ;call Level1Intersection 
        
        call PlayerMovement1
        call DrawPlayer

        cmp CurrentCoins,457
        ja skip
        call Level2Maze 
        skip:
        cmp livesIndicator,0  
        jne gameLoop1
    ret
Level1Maze ENDP 
Level2Maze PROC 
        mov levelIndicator,2
        mov xPos,8
        mov yPos,7
        mov xG3Pos,12
        mov yG3Pos,17
        mov xG2Pos,8
        mov yG2Pos,15

        mov eax,black (black*16)
        call settextcolor
        mov eax,1500
        call delay
        call clrscr
        call DrawLevel2
    gameLoop2:

        call DrawScore
        call Ghost3Movement
        call Ghost2Movement
        call DrawGhost3
        call DrawGhost2
        call PlayerMovement2
        call DrawPlayer
        cmp CurrentCoins,256
        ja skip
        call Level3Maze 
        skip:
        cmp livesIndicator,0  
        jne gameLoop2
ret
Level2Maze ENDP 
Level3Maze PROC  
        mov levelIndicator,3
        mov xPos,8
        mov yPos,7
        mov xG4Pos,40
        mov yG4Pos,21
        mov xG5Pos,34
        mov yG5Pos,21
        mov xG6Pos,40
        mov yG6Pos,15
        mov xG7Pos,34
        mov yG7Pos,15

        mov eax,black (black*16)
        call settextcolor
        mov eax,1500
        call delay
        call clrscr
        call DrawLevel3

    gameLoop3:
        call DrawScore
        call Ghost7Movement
        call Ghost6Movement
        call Ghost5Movement
        call Ghost4Movement
        call DrawGhost7
        call DrawGhost6
        call DrawGhost5
        call DrawGhost4
        call PlayerMovement3
        call DrawPlayer
        cmp livesIndicator,0  
        cmp CurrentCoins,0
        jne skip
        call EndScreen  
       ; call Level3Maze
        skip:
        jne gameLoop3
ret
Level3Maze ENDP 

ExitGame PROC
    call clrscr
    mov eax, white (black*16)
    call settextcolor
    exit
ExitGame ENDP   

end main