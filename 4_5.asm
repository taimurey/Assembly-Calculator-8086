TITLE Write a menu driven program to add, subtract, and multiply two matrices of order 4 x 4 and displays them along with the result
.MODEL SMALL
.STACK
.DATA
    menu        BYTE 13,10,"Enter the operator",13,10
                BYTE "+:Addition",13,10,
                     "-:Substraction",13,10,
                     "*:Multiplication",13,10,
                     "Q:Quit",13,10,
                     "Enter your choice: $"

    error       BYTE 13,10,"Invalid choice!",13,10
                BYTE "Re-enter your choice: $"

    newline     BYTE 13,10,"$"
    space       BYTE " $"

    matrix1_input     BYTE 13,10,"Enter the elements of the first matrix(4x4): $"
    matrix2_input     BYTE 13,10,"Enter the elements of the second matrix(4x4): $"
    result            BYTE 13,10,"Resultant matrix: $"

    matrix1    WORD 16 DUP(?)
    matrix2    WORD 16 DUP(?)
    matrix3    WORD 16 DUP(?)

.CODE

    ; Procedure to input a 4x4 matrix
    ;condition is that offset must be in DI
    INPUT_MATRIX PROC
        MOV CX,16
        MOV AX, OFFSET newline
        CALL DISPLAY
        INPUT_LOOP:
            CALL INDEC
            MOV [DI],AX
            ADD DI,2
            LOOP INPUT_LOOP
        RET
    INPUT_MATRIX ENDP

    ; Procedure to display a 4x4 matrix  
    ;condition is that offset must be in SI
    DISPLAY_MATRIX PROC
        MOV CX,16

        DISPLAY_LOOP:
            XOR DX,DX
            MOV AX,CX
            MOV BX, 4
            DIV BX
            CMP DX,0
            JE newline1
            MOV AX, OFFSET space
            CALL DISPLAY

            MOV AX,[SI]
            CALL OUTDEC
            ADD SI,2
            CMP CX,1
            JE A
            LOOP DISPLAY_LOOP      
        newline1:
            MOV AX, OFFSET newline
            CALL DISPLAY

            MOV AX,[SI]
            CALL OUTDEC
            ADD SI,2

            CMP CX,1
            JE A
            LOOP DISPLAY_LOOP
        A:
        RET
    DISPLAY_MATRIX ENDP

    DISPLAY PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h
        RET
    DISPLAY ENDP

    GETCHAR PROC FAR
        MOV AH,1
        INT 21H
        RET
    GETCHAR ENDP

    PUTCHAR proc NEAR
        MOV DL,AL
        MOV AH,2
        INT 21h
        RET
    PUTCHAR ENDP

INDEC PROC FAR  ;inputs an unsigned decimal number from the keyboard to AX register
                ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-9
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,10   ;MULTIPLIER

    XOR BX,BX   ;cLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

    INDEC1: CALL GETCHAR  ;GET NEXT CHARACTER
            CMP AL,'0'    ;LESS THAN 0
            JB INDEC2     ;YES
            CMP AL,'9'    ;GREATER THAN 9
            JA INDEC2     ;YES

            SUB AL,'0'    ;GET DECIMAL digits

            XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

            PUSH AX       ;SAVE THE DIGIT

            MOV AX,BX     ;DEC_MULTIPLICATION N BY 10

            MUL CX
            POP BX       ;RESTORE THE DIGIT
            ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
            JMP INDEC1   ;GET NEXT DIGIT

    INDEC2: MOV AX,BX    ;RETURN N IN AX
                            
            POP BX       ;Restore Registers
            POP CX
            POP DX

            RET
INDEC ENDP      ;Return to Caller

OUTDEC PROC ;outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
    PUSH AX   ;save registers
    PUSH BX   
    PUSH CX
    PUSH DX

    MOV CX,0   ;INITIALIZE DIGIT COUNT
    MOV BX,10  ;SET UP DIVISOR

    OUT1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
        DIV BX        ;DIVIDE BY 10
        PUSH DX       ;SAVE REMAINDER
        INC CL        ;BUMP COUNT
        CMP AX,0      ;ANYTHING LEFT?

        JA OUT1       ;IF YES, GET NEXT DIGIT

    OUT2:  POP AX     ;GET A DIGIT FROM THE STACK
        ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
        CALL PUTCHAR  ;OUTPUT THE DIGIT
        LOOP OUT2
        POP DX      ;RESTORE THE REGISTERS
        POP CX
        POP BX
        POP AX
        RET
OUTDEC   ENDP    ;RETURN TO CALLER

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    MOV AX, OFFSET matrix1_input ; Display the input message
    CALL DISPLAY
    MOV DI, OFFSET matrix1 ; Set DI to point to matrix1
    CALL INPUT_MATRIX ; Input the 4x4 matrix

    MOV AX, OFFSET matrix2_input ; Display the input message
    CALL DISPLAY
    MOV DI, OFFSET matrix2 ; Set DI to point to matrix2
    CALL INPUT_MATRIX ; Input the 4x4 matrix

    AGAIN:
        MOV AX, OFFSET menu
        CALL DISPLAY

        INPUT:
            CALL GETCHAR

            CMP AL, '+'
            JE ADDITION
            CMP AL, '-'
            JE SUBSTRACTION
            CMP AL, '*'
            JE MULTIPLICATION
            CMP AL, 'Q'
            JE EXIT

            MOV AX, OFFSET error
            CALL DISPLAY 
            JMP INPUT
            
    ADDITION:
        MOV SI, offset matrix1
        MOV BX, offset matrix2
        MOV DI, offset matrix3
        MOV CX, 16
        ADD_LOOP:
            MOV AX, [SI]
            ADD AX, [BX]
            MOV [DI], AX
            
            ADD SI, 2
            ADD BX, 2
            ADD DI, 2

            LOOP ADD_LOOP
            JMP ANS
    SUBSTRACTION:
        MOV SI, offset matrix1
        MOV BX, offset matrix2
        MOV DI, offset matrix3
        MOV CX, 16
        SUB_LOOP:
            MOV AX, [SI]
            SUB AX, [BX]
            MOV [DI], AX
            
            ADD SI, 2
            ADD BX, 2
            ADD DI, 2

            LOOP SUB_LOOP
            JMP ANS

    MULTIPLICATION:
        MOV SI, offset matrix1
        MOV BX, offset matrix2
        MOV DI, offset matrix3
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

    ANS:
    MOV AX, OFFSET result
    CALL DISPLAY
    MOV SI, OFFSET matrix3
    CALL DISPLAY_MATRIX

    JMP AGAIN

;---------------------------------------------------
    EXIT:
        MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
        INT 21h

MAIN ENDP
END MAIN

