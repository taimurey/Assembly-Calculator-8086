TITLE Matrix Operations Program
.MODEL SMALL
.STACK
.DATA
    mainMenu        BYTE 13,10,"Choose the operation",13,10
                    BYTE "+:Add",13,10,
                         "-:Subtract",13,10,
                         "*:Multiply",13,10,
                         "Q:Exit",13,10,
                         "Your choice: $"

    invalidChoice   BYTE 13,10,"Invalid option!",13,10
                    BYTE "Try again: $"

    lineBreak       BYTE 13,10,"$"
    spaceChar       BYTE " $"

    firstMatrixPrompt  BYTE 13,10,"Enter the elements of the first matrix(4x4): $"
    secondMatrixPrompt BYTE 13,10,"Enter the elements of the second matrix(4x4): $"
    resultMatrixPrompt BYTE 13,10,"Result matrix: $"

    firstMatrix    WORD 16 DUP(?)
    secondMatrix   WORD 16 DUP(?)
    resultMatrix   WORD 16 DUP(?)

.CODE

    ; Procedure to input a 4x4 matrix
    ; DI register must contain the offset
    MATRIX_INPUT PROC
        MOV CX,16
        MOV AX, OFFSET lineBreak
        CALL SHOW_MESSAGE
        INPUT_LOOP:
            CALL GET_DECIMAL
            MOV [DI],AX
            ADD DI,2
            LOOP INPUT_LOOP
        RET
    MATRIX_INPUT ENDP

    ; Procedure to display a 4x4 matrix  
    ; SI register must contain the offset
    MATRIX_DISPLAY PROC
        MOV CX,16

        DISPLAY_LOOP:
            XOR DX,DX
            MOV AX,CX
            MOV BX, 4
            DIV BX
            CMP DX,0
            JE newline1
            MOV AX, OFFSET spaceChar
            CALL SHOW_MESSAGE

            MOV AX,[SI]
            CALL PRINT_DECIMAL
            ADD SI,2
            CMP CX,1
            JE A
            LOOP DISPLAY_LOOP      
        newline1:
            MOV AX, OFFSET lineBreak
            CALL SHOW_MESSAGE

            MOV AX,[SI]
            CALL PRINT_DECIMAL
            ADD SI,2

            CMP CX,1
            JE A
            LOOP DISPLAY_LOOP
        A:
        RET
    MATRIX_DISPLAY ENDP

    SHOW_MESSAGE PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h
        RET
    SHOW_MESSAGE ENDP

    READ_CHAR PROC FAR
        MOV AH,1
        INT 21H
        RET
    READ_CHAR ENDP

    PRINT_CHAR proc NEAR
        MOV DL,AL
        MOV AH,2
        INT 21h
        RET
    PRINT_CHAR ENDP

GET_DECIMAL PROC FAR  ;inputs an unsigned decimal number from the keyboard to AX register
                ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-9
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,10   ;MULTIPLIER

    XOR BX,BX   ;cLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

    GET_DECIMAL_LOOP: CALL READ_CHAR  ;GET NEXT CHARACTER
            CMP AL,'0'    ;LESS THAN 0
            JB GET_DECIMAL_END     ;YES
            CMP AL,'9'    ;GREATER THAN 9
            JA GET_DECIMAL_END     ;YES

            SUB AL,'0'    ;GET DECIMAL digits

            XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

            PUSH AX       ;SAVE THE DIGIT

            MOV AX,BX     ;DEC_MULTIPLICATION N BY 10

            MUL CX
            POP BX       ;RESTORE THE DIGIT
            ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
            JMP GET_DECIMAL_LOOP   ;GET NEXT DIGIT

    GET_DECIMAL_END: MOV AX,BX    ;RETURN N IN AX
                            
            POP BX       ;Restore Registers
            POP CX
            POP DX

            RET
GET_DECIMAL ENDP      ;Return to Caller

PRINT_DECIMAL PROC ;outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
    PUSH AX   ;save registers
    PUSH BX   
    PUSH CX
    PUSH DX

    MOV CX,0   ;INITIALIZE DIGIT COUNT
    MOV BX,10  ;SET UP DIVISOR

    PRINT_DECIMAL_LOOP:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
        DIV BX        ;DIVIDE BY 10
        PUSH DX       ;SAVE REMAINDER
        INC CL        ;BUMP COUNT
        CMP AX,0      ;ANYTHING LEFT?

        JA PRINT_DECIMAL_LOOP       ;IF YES, GET NEXT DIGIT

    PRINT_DECIMAL_END:  POP AX     ;GET A DIGIT FROM THE STACK
        ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
        CALL PRINT_CHAR  ;OUTPUT THE DIGIT
        LOOP PRINT_DECIMAL_END
        POP DX      ;RESTORE THE REGISTERS
        POP CX
        POP BX
        POP AX
        RET
PRINT_DECIMAL   ENDP    ;RETURN TO CALLER

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    MOV AX, OFFSET firstMatrixPrompt ; Display the input message
    CALL SHOW_MESSAGE
    MOV DI, OFFSET firstMatrix ; Set DI to point to firstMatrix
    CALL MATRIX_INPUT ; Input the 4x4 matrix

    MOV AX, OFFSET secondMatrixPrompt ; Display the input message
    CALL SHOW_MESSAGE
    MOV DI, OFFSET secondMatrix ; Set DI to point to secondMatrix
    CALL MATRIX_INPUT ; Input the 4x4 matrix

    MAIN_LOOP:
        MOV AX, OFFSET mainMenu
        CALL SHOW_MESSAGE

        INPUT:
            CALL READ_CHAR

            CMP AL, '+'
            JE ADD_MATRICES
            CMP AL, '-'
            JE SUBTRACT_MATRICES
            CMP AL, '*'
            JE MULTIPLY_MATRICES
            CMP AL, 'Q'
            JE EXIT_PROGRAM

            MOV AX, OFFSET invalidChoice
            CALL SHOW_MESSAGE 
            JMP INPUT
            
    ADD_MATRICES:
        MOV SI, offset firstMatrix
        MOV BX, offset secondMatrix
        MOV DI, offset resultMatrix
        MOV CX, 16
        ADD_LOOP:
            MOV AX, [SI]
            ADD AX, [BX]
            MOV [DI], AX
            
            ADD SI, 2
            ADD BX, 2
            ADD DI, 2

            LOOP ADD_LOOP
            JMP SHOW_RESULT
    SUBTRACT_MATRICES:
        MOV SI, offset firstMatrix
        MOV BX, offset secondMatrix
        MOV DI, offset resultMatrix
        MOV CX, 16
        SUB_LOOP:
            MOV AX, [SI]
            SUB AX, [BX]
            MOV [DI], AX
            
            ADD SI, 2
            ADD BX, 2
            ADD DI, 2

            LOOP SUB_LOOP
            JMP SHOW_RESULT

    MULTIPLY_MATRICES:
        MOV SI, offset firstMatrix
        MOV BX, offset secondMatrix
        MOV DI, offset resultMatrix
        MOV CX, 16
        MUL_LOOP:
            MOV AX, [SI]
            PUSH BX
            MOV DX, [BX]
            MOV BX, DX
            MUL BX
            MOV [DI], AX
            
            ADD SI, 2
            POP BX
            ADD BX, 2
            ADD DI, 2

            LOOP MUL_LOOP

    SHOW_RESULT:
    MOV AX, OFFSET resultMatrixPrompt
    CALL SHOW_MESSAGE
    MOV SI, OFFSET resultMatrix
    CALL MATRIX_DISPLAY

    JMP MAIN_LOOP

;---------------------------------------------------
    EXIT_PROGRAM:
        MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
        INT 21h

MAIN ENDP
END MAIN