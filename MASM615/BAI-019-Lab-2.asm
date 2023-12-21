N = 80 

.8086 

.MODEL SMALL 

.STACK 

.DATA 
newLine db 0Dh, 0AH, "$" 
promptStr BYTE "Enter a string (end with '.'): $"
inputStr BYTE "Input: $" 
smallCounter WORD 0 
smallStr BYTE "Small letters: $" 
capitalCounter WORD 0 
capitalStr BYTE "Capital letters: $" 
numberCounter WORD 0 
numberStr BYTE "Numbers: $" 
specialCounter WORD 0 
specialStr BYTE "Special chars: $" 
mystr BYTE ? 


.CODE 

OUTDEC PROC FAR
    PUSH AX 
    PUSH BX 
    PUSH CX 
    PUSH DX 
    MOV CX,0 
    MOV BX,10 
OUT1:
    XOR DX,DX 
    DIV BX 
    PUSH DX 
    INC CL 
    CMP AX,0 
    JA OUT1 
OUT2:
    POP AX 
    ADD AL,'0' 
    CALL PUTCHAR 
    LOOP OUT2 
    POP DX 
    POP CX 
    POP BX 
    POP AX 
    RET 
OUTDEC ENDP 

PUTCHAR PROC FAR
    MOV DL,AL 
    MOV AH,02 
    INT 21h 
    RET 
PUTCHAR ENDP 

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

        ; Display the prompt
    MOV AH, 09
    MOV DX, OFFSET promptStr
    INT 21h

    MOV DI, OFFSET mystr
    MOV CX, N
    MOV BX, 0
STRING_INPUT:
    MOV AH, 01
    INT 21h
    MOV [DI], AL
    INC DI
    INC BX
    CMP AL, '.'
    JE END_INPUT
    LOOP STRING_INPUT
    JMP END_STRING
END_INPUT:
    DEC DI
    DEC BX
    MOV AL, '$'
    MOV [DI], AL
    JMP FINISH
END_STRING:
    INC DI
    MOV AL, '$'
    MOV [DI], AL
FINISH:
    MOV AH, 09
    MOV DX, OFFSET newLine
    INT 21h
    MOV DX, OFFSET inputStr
    INT 21h
    MOV DX, OFFSET mystr
    INT 21h

    MOV DI, OFFSET mystr
    MOV CX, BX
CHECK_CHARS:
    MOV AL, [DI]
    CMP AL, 'A'
    JB CHECK_SMALL
    CMP AL, 'Z'
    JA CHECK_SMALL
    INC capitalCounter
    INC DI
    JMP CONTINUE
CHECK_SMALL:
    CMP AL, 'a'
    JB CHECK_DIGIT
    CMP AL, 'z'
    JA CHECK_DIGIT
    INC smallCounter
    INC DI
    JMP CONTINUE
CHECK_DIGIT:
    CMP AL, '0'
    JB CHECK_SPECIAL
    CMP AL, '9'
    JA CHECK_SPECIAL
    INC numberCounter
    INC DI
    JMP CONTINUE
CHECK_SPECIAL:
    INC specialCounter
    INC DI
CONTINUE:
    LOOP CHECK_CHARS

    ; Display counts
    MOV AH, 09
    MOV DX, OFFSET newLine
    INT 21H
    MOV DX, OFFSET smallStr
    INT 21H
    MOV AX, [smallCounter]
    CALL OUTDEC

    MOV AH, 09
    MOV DX, OFFSET newLine
    INT 21H
    MOV DX, OFFSET capitalStr
    INT 21H
    MOV AX, [capitalCounter]
    CALL OUTDEC

    MOV AH, 09
    MOV DX, OFFSET newLine
    INT 21H
    MOV DX, OFFSET numberStr
    INT 21H
    MOV AX, [numberCounter]
    CALL OUTDEC

    MOV AH, 09
    MOV DX, OFFSET newLine
    INT 21H
    MOV DX, OFFSET specialStr
    INT 21H
    MOV AX, [specialCounter]
    CALL OUTDEC

    MOV AH, 4Ch
    INT 21h 
MAIN ENDP 
END MAIN
