TITLE program storing sum of two numbers
.8086
.MODEL SMALL
.STACK
.DATA
    N1 WORD ?
    N2 WORD ?
    SUM WORD ?
.CODE

GETCHAR PROC FAR
    MOV AH,1
    INT 21H
    RET
GETCHAR ENDP


INDEC PROC FAR  ;inputs an unsigned decimal number from the keyboard to AX register
;the number is entered as 1 or more digits, the input is terminated by a char other than 0-9
PUSH BX
PUSH CX
PUSH DX

MOV CX,10   ;MULTIPLIER

XOR BX,BX   ;cLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

INDEC1: CALL GETCHAR  ;GET NEXT CHARACTER
    CMP AL,'0'      ;LESS THAN 0
    JB INDEC2       ;YES
    CMP AL,'9'      ;GREATER THAN 9
    JA INDEC2       ;YES

    SUB AL,'0'      ;GET DECIMAL digits

    XOR AH,AH       ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

    PUSH AX         ;SAVE THE DIGIT

    MOV AX,BX       ;MULTIPLY N BY 10

    MUL CX
    POP BX          ;RESTORE THE DIGIT
    ADD BX,AX       ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
    JMP INDEC1      ;GET NEXT DIGIT


INDEC2: MOV AX,BX   ;RETURN N IN AX
                    ;Restore Registers
POP BX 
POP CX
POP DX

RET
INDEC ENDP      ;Return to Caller

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    CALL INDEC
    MOV N1,AX
    CALL INDEC
    MOV N2,AX

    MOV AX,N1
    ADD AX,N2
    MOV SUM,AX

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN
