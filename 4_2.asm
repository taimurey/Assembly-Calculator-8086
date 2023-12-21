TITLE  Write a program to input a number and display all even and odd numbers less than the number.
.MODEL SMALL
.STACK
.DATA
    input_msg BYTE 13,10,"Input a number: $"
    number    WORD ?

    space     BYTE ' $'  ; space characters for formatting
    newline   BYTE 13,10,'$' ; newline characters for formatting

    even_msg  BYTE 13,10,"Even numbers: ", 13,10,'$'
    odd_msg   BYTE 13,10,"Odd numbers: ", 13,10,'$'

    even_array WORD 100 DUP(?)
    odd_array  WORD 100 DUP(?)  

    even_count WORD 0
    odd_count  WORD 0

.CODE
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

                MOV AX,BX     ;MULTIPLY N BY 10

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
    ;Taking input
    MOV AX, OFFSET input_msg
    CALL DISPLAY
    CALL INDEC
    MOV number, AX

    MOV SI, offset even_array
    MOV DI, offset odd_array

    ;Finding even and odd numbers
    MOV CX, number
    LABEL1:
    TEST CX, 1
    JZ EVEN1
    JMP ODD

    CMP CX, 0
    JZ EXIT

        EVEN1:
            MOV [SI], CX
            INC SI
            INC SI
            INC even_count
            JMP A

        ODD:
            MOV [DI], CX
            INC DI
            INC DI
            INC odd_count
    A:  
    LOOP LABEL1

EXIT:
    ;Showing even numbers
    MOV AX, OFFSET even_msg
    CALL DISPLAY

    MOV CX, even_count
    MOV SI, offset even_array
    LOOP1: 
        MOV AX, offset space
        CALL DISPLAY
        MOV AX, [SI]
        CALL OUTDEC
        INC SI
        INC SI
        LOOP LOOP1

    ;Showing odd numbers
    MOV AX, OFFSET odd_msg
    CALL DISPLAY
    MOV CX, odd_count
    MOV SI, offset odd_array
    LOOP2: 
        MOV AX, offset space
        CALL DISPLAY
        MOV AX, [SI]
        CALL OUTDEC
        INC SI
        INC SI
        LOOP LOOP2

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

