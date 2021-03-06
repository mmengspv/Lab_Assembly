	TITLE Supavet Amornruksakul
	SUBTTL 6210406734

STACK	SEGMENT
	DW	64 DUP (?)
STACK ENDS

DATA	SEGMENT
	NUM		DB  3,?,3 DUP (?)
	NUM1	DB	?
	KEEP 	DB 	?
	FOOD_NAME	DB 20,?,20 DUP (?),"$"
	COUNT	DB	?
	QUANTITY_INPUT	DB 2,?,2 DUP (?),"$"
	QUANTITY	DB	?

	PRICE_INPUT	DB	4,?,4 DUP (?)
	PRICE	DW	?

	DISTANCE_INPUT	DB	3,?,3 DUP (?)
	DISTANCE	DB	?
	GRAB	DW	?

	PRICE_AND_ENTER	DB 4 DUP (?),13,10,"$"
	FOOD	DW	0
	DELIVERY	DB	0
	TOTAL 	DW	0

	TEXT1	DB	"   Food                 Quantity               Price(Baht)",13,10,"$"
	TEXT2	DB	"			 Food		         ","$"
	TEXT3	DB	"			 Deliverty Fee           ","$"
	TEXT4	DB	"			 Total		         ","$"
	BLANK	DB	27 DUP (?),"$"
	BLANK2	DB	24 DUP (?),"$"
DATA	ENDS

CODE	SEGMENT
	ASSUME	CS:CODE, DS:DATA, SS:STACK
MAIN	PROC
	MOV	AX,DATA
	MOV DS,AX		;initial DS
	
	LEA	DX,NUM
	MOV AH,0AH		;input String
	INT 21H
	MOV CH,0
	MOV CL,[NUM+1]
	LEA DI,NUM+2
	CALL ASCII_TO_BINARY
	MOV NUM1,AL
	MOV CX,AX
	MOV KEEP,AL

INPUT_LOOP: LEA DX,FOOD_NAME	;input name of food
	MOV AH,0AH
	INT 21H

	LEA DX,QUANTITY_INPUT
	MOV AH,0AH
	INT 21H
	MOV CH,0
	MOV CL,[QUANTITY_INPUT+1]
	LEA DI,QUANTITY_INPUT+2
	CALL ASCII_TO_BINARY
	MOV QUANTITY,AL

	LEA DX,PRICE_INPUT
	MOV AH,0AH
	INT 21H
	MOV CH,0
	MOV	CL,[PRICE_INPUT+1]
	LEA DI,PRICE_INPUT+2
	CALL ASCII_TO_BINARY
	MUL QUANTITY
	MOV PRICE,AX
	ADD TOTAL,AX

	MOV AL,NUM1
	CMP AL,KEEP
	JNE LOOP2				; first order
	CALL PRINT_TOP_RECIEVE

LOOP2: CALL PRINT_ORDER
	MOV CX,0
	MOV CL,KEEP
	DEC KEEP
	LOOP INPUT_LOOP
	
	LEA DX,DISTANCE_INPUT
	MOV AH,0AH
	INT 21H
	MOV CH,0
	MOV CL,[DISTANCE_INPUT+1]
	LEA DI,DISTANCE_INPUT+2
	CALL ASCII_TO_BINARY
	MOV DISTANCE,AL

	LEA DX,TEXT2
	CALL PRINT
	LEA BX,PRICE_AND_ENTER
	MOV AX,TOTAL
	CALL SET_PRICE
	LEA DX,PRICE_AND_ENTER
	MOV AH,9
	INT 21H

	LEA DX,TEXT3
	CALL PRINT
	CALL CAL
	LEA BX,PRICE_AND_ENTER
	MOV AX,GRAB
	ADD TOTAL,AX
	CALL SET_PRICE
	LEA DX,PRICE_AND_ENTER
	MOV AH,9
	INT 21H

	LEA DX,TEXT4
	CALL PRINT
	LEA BX,PRICE_AND_ENTER
	MOV AX,TOTAL
	CALL SET_PRICE
	LEA DX,PRICE_AND_ENTER
	MOV AH,9
	INT 21H



	MOV AH,4CH
	INT 21H			; return to DOS
MAIN 	ENDP

ASCII_TO_BINARY	PROC
	MOV AX,0		;set = 0
	MOV SI,10
NEXT: MUL SI
	MOV BX,0
	MOV BL,[DI]
	SUB BX,30H
	ADD AX,BX
	INC DI
	LOOP NEXT
	RET
ASCII_TO_BINARY ENDP

BINARY_TO_ASCII	PROC
	 MOV DI,10                
NEXT2:   CWD
	 DIV DI                       ;divind AX by 10
	 ADD DX,'0'                   ;convert to ASCII code
	 DEC BX 
	 MOV [BX],DL                  ;store character in string
	 CMP AX,0                     ;compare AX and 0
	 JNE NEXT2		      ;if AX != 0 get next digit
	 RET
BINARY_TO_ASCII ENDP

PRINT_TOP_RECIEVE	PROC
	LEA DX,TEXT1
	MOV AH,9
	INT 21H
	RET
PRINT_TOP_RECIEVE	ENDP

PRINT_ORDER	PROC
	MOV BH,0
	MOV BL,FOOD_NAME+1		;BL = number charactor of FOOD_NAME
	ADD BL,2
	LEA DI,FOOD_NAME[BX]	;DI = offset of last character in FOOD
	MOV BYTE PTR[DI],"$"	;put "$" at last charactor
	MOV AH,9
	LEA DX,FOOD_NAME+2           
	INT 21H 
	MOV CX,27
	; MOV COUNT,0
	MOV AX,0
	MOV AL,FOOD_NAME+1
	SUB CX,AX
	LEA BX,BLANK
	CALL FILL_BLANK
	LEA DX,BLANK
	MOV AH,9
	INT 21H

	MOV BH,0
	MOV BL,QUANTITY_INPUT+1
	ADD BX,2
	LEA DI,QUANTITY_INPUT[BX]
	MOV BYTE PTR[DI],"$"
	MOV AH,9
	LEA DX,QUANTITY_INPUT+2
	INT 21H

	MOV AX,0
	MOV AL,QUANTITY_INPUT+1
	MOV CX,24
	SUB CX,AX
	LEA BX,BLANK2
	CALL FILL_BLANK
	LEA DX,BLANK2
	MOV AH,9
	INT 21H

	LEA BX,PRICE_AND_ENTER    ;copy offset of STD_POINT into BX
	MOV AX,PRICE
	CALL SET_PRICE
	LEA DX,PRICE_AND_ENTER
	MOV AH,9
	INT 21H

	RET
PRINT_ORDER ENDP

SET_PRICE   PROC
    MOV CX,4
FILL_SPACE: MOV   BYTE PTR[BX]," "        ;fill 4 space
    INC BX
    LOOP FILL_SPACE
	CALL BINARY_TO_ASCII
    RET
SET_PRICE   ENDP

FILL_BLANK	PROC
FILL: CMP CX,1
	JE SIGN
	MOV BYTE PTR[BX]," "
	INC BX
	LOOP FILL
SIGN: MOV BYTE PTR[BX],"$"
	RET
FILL_BLANK	ENDP

CAL	PROC
	MOV GRAB,0
	CMP DISTANCE,5
	JA DISTANCE_6
	CMP TOTAL,500
	JBE DISTANCE_1
DISTANCE_1: MOV AX,10
	MUL DISTANCE
	JMP FINISH
DISTANCE_6: CMP DISTANCE,20
	JA DISTANCE_21
	SUB DISTANCE,5
	MOV AX,15
	MUL DISTANCE
	CMP TOTAL,500
	JBE PLUS1
	JMP FINISH
PLUS1: ADD AX,50
	JMP FINISH
DISTANCE_21: MOV AX,20
	SUB DISTANCE,20
	MUL DISTANCE
	CMP TOTAL,500
	JBE PLUS2
	ADD AX,225
	JMP FINISH
PLUS2:	ADD AX,275
FINISH: MOV GRAB,AX
	RET
CAL	ENDP

PRINT	PROC
	MOV AH,9
	INT 21H
	RET
PRINT 	ENDP

CODE	ENDS
		END MAIN