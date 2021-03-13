TITLE Supavet Amornruksakul
SUBTTL 6210406734

STACK   SEGMENT STACK
    DB  64 DUP(?)
STACK   ENDS

DATA    SEGMENT
    S1  DB  75,80,95,80
    S2  DB  5,20,0,15
    S3  DB  90,85,100,95
    S4  DB  65,55,70,45
    S5  DB  75,70,60,75
    SCORE   DW  ?
    ;MIN     DB  100
    MBYTE   DB  3
    TEXT1   DB  "STUDENT "
    STD_NO  DB  ?
    TEXT2   DB  " gets"
    STD_POINT   DB  3 DUP(?)
    TEXT3   DB  " points so grade is "
    STD_GRADE   DB  ?,13,10,"$"
DATA    ENDS

CODE    SEGMENT
    ASSUME  SS:STACK,DS:DATA,CS:CODE
MAIN    PROC
    MOV AX,DATA
    MOV DS,AX       ;initial DS
;student 1
    MOV AX,1        ;student 1
    CALL SET_NO
    LEA BX,S1           ;copy offset of S1 to BX
    CALL SUM_SCORE
    CALL SET_POINT
    CALL SET_GRADE
    CALL PRINT

;student 2
    MOV AX,2        ;student 2
    CALL SET_NO
    LEA BX,S2           ;copy offset of S2 to BX
    CALL SUM_SCORE
    CALL SET_POINT
    CALL SET_GRADE
    CALL PRINT

;student 3
    MOV AX,3        ;student 3
    CALL SET_NO
    LEA BX,S3           ;copy offset of S3 to BX
    CALL SUM_SCORE
    CALL SET_POINT
    CALL SET_GRADE
    CALL PRINT

;student 4
    MOV AX,4        ;student 4
    CALL SET_NO
    LEA BX,S4           ;copy offset of S4 to BX
    CALL SUM_SCORE
    CALL SET_POINT
    CALL SET_GRADE
    CALL PRINT

;student 5
    MOV AX,5        ;student 5
    CALL SET_NO
    LEA BX,S5           ;copy offset of S5 to BX
    CALL SUM_SCORE
    CALL SET_POINT
    CALL SET_GRADE
    CALL PRINT

    MOV AH,4CH
    INT 21H         ;end program
MAIN    ENDP

SET_NO  PROC        ;set STD_NO in DS
    LEA BX,STD_NO   ;copy offset of STD_NO into BX
    CWD             
    MOV DI,10       ;copy 10 into DI for Divide
    DIV DI          ;(DX,AX)/DI and integer is saved in AX
    ADD DX,"0"
    MOV [BX],DL
    RET
SET_NO  ENDP

SUM_SCORE   PROC    ;cal highest score 3 times
    MOV SCORE,0     ;set score = 0
    MOV CX,4        ;loop 4 round because have a 4 scores
    MOV DL,100      ;assume DL is Minimum score
FIND_MIN:  CMP BYTE PTR[BX],DL
    JAE ADD_SCORE   
    MOV DL,[BX]     ;[Bx] < DL -> DL = [BX]
ADD_SCORE: MOV AL,BYTE PTR[BX]
    CBW
    ADD SCORE,AX    ;add score
    INC BX          ;change [BX] = [BX+1]
    LOOP    FIND_MIN
    MOV AL,DL       
    CBW
    SUB SCORE,AX    ;score-min
    MOV AX,SCORE
    DIV MBYTE       ;AX/MBYTE and integer saved in AL
    CBW
    MOV SCORE,AX
    RET
SUM_SCORE   ENDP

SET_POINT   PROC
    LEA BX,STD_POINT    ;copy offset of STD_POINT into BX
    MOV CX,3
FILL: MOV   BYTE PTR[BX]," "        ;fill 3 space
    INC BX
    LOOP FILL
    MOV AX,SCORE
NEXT: CWD
    MOV DI,10
    DIV DI          ;(DX,AX)/DI and integer is saved in AX
    ADD DX,"0"
    DEC BX
    MOV [BX],DL
    CMP AX,0
    JNE NEXT
    RET
SET_POINT   ENDP

SET_GRADE   PROC
    LEA BX,STD_GRADE
    CMP SCORE,90
    JAE GRADE_A
    CMP SCORE,80
    JAE GRADE_B
    CMP SCORE,65
    JAE GRADE_C
    CMP SCORE,50
    JAE GRADE_D
    JMP GRADE_F
GRADE_A: MOV    BYTE PTR[BX],'A'
    JMP RETURN
GRADE_B: MOV    BYTE PTR[BX],'B'
    JMP RETURN
GRADE_C: MOV    BYTE PTR[BX],'C'
    JMP RETURN
GRADE_D: MOV    BYTE PTR[BX],'D'
    JMP RETURN
GRADE_F: MOV    BYTE PTR[BX],'F'
RETURN: RET
SET_GRADE   ENDP

PRINT   PROC
    MOV AH,9        ;display string
    LEA DX,TEXT1    ;start of string offset
    INT 21H
    RET
PRINT   ENDP
CODE    ENDS
        END MAIN 