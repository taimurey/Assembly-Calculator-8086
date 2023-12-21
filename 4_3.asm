TITLE   Program to input a number and display its divisors and Fibonacci numbers less than or equal to it.
.MODEL SMALL
.STACK
.DATA
    prompt_msg BYTE 13,10,"Enter a number: $"
    num    WORD ?

    space     BYTE ' $'  ; space characters for formatting
    newline   BYTE 13,10,'$' ; newline characters for formatting

    fibonacci_msg  BYTE 13,10,"Fibonacci numbers: ", 13,10,'$'
    divisor_msg   BYTE 13,10,"Divisors: ", 13,10,'$'

    fibonacci_array WORD 1,1,100 DUP(?)
    divisor_array  WORD 100 DUP(?)  

    fibonacci_count WORD 2
    divisor_count  WORD 0

.CODE
    SHOW_MSG PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h
        RET
    SHOW_MSG ENDP

    READ_CHAR PROC FAR
        MOV AH,1
        INT 21H
        RET
    READ_CHAR ENDP

    WRITE_CHAR proc NEAR
        MOV DL,AL
        MOV AH,2
        INT 21h
        RET
    WRITE_CHAR ENDP

    INPUT_NUM PROC FAR  ;inputs an unsigned decimal number from the keyboard to AX register
                        ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-9
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,10   ;MULTIPLIER

        XOR BX,BX   ;CLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

        INPUT_LOOP: CALL READ_CHAR  ;GET NEXT CHARACTER
                CMP AL,'0'    ;LESS THAN 0
                JB INPUT_END     ;YES
                CMP AL,'9'    ;GREATER THAN 9
                JA INPUT_END     ;YES

                SUB AL,'0'    ;GET DECIMAL digits

                XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

                PUSH AX       ;SAVE THE DIGIT

                MOV AX,BX     ;MULTIPLY N BY 10

                MUL CX
                POP BX       ;RESTORE THE DIGIT
                ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP INPUT_LOOP   ;GET NEXT DIGIT

        INPUT_END: MOV AX,BX    ;RETURN N IN AX
                                
                POP BX       ;Restore Registers
                POP CX
                POP DX

                RET
    INPUT_NUM ENDP      ;Return to Caller

    OUTPUT_NUM PROC ;outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
        PUSH AX   ;save registers
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,10  ;SET UP DIVISOR

        OUT_LOOP1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
            DIV BX        ;DIVIDE BY 10
            PUSH DX       ;SAVE REMAINDER
            INC CL        ;BUMP COUNT
            CMP AX,0      ;ANYTHING LEFT?

            JA OUT_LOOP1       ;IF YES, GET NEXT DIGIT

        OUT_LOOP2:  POP AX     ;GET A DIGIT FROM THE STACK
            ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
            CALL WRITE_CHAR  ;OUTPUT THE DIGIT
            LOOP OUT_LOOP2
            POP DX      ;RESTORE THE REGISTERS
            POP CX
            POP BX
            POP AX
            RET

    OUTPUT_NUM   ENDP    ;RETURN TO CALLER

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------
    ;Taking input
    MOV AX, OFFSET prompt_msg
    CALL SHOW_MSG
    CALL INPUT_NUM
    MOV num, AX

    ;Finding Fibonacci numbers
    MOV SI, offset fibonacci_array
    ADD SI, 4

    FIB_LOOP:
        MOV AX, [SI-2]
        MOV BX, [SI-4]
        ADD AX, BX

        CMP AX, num
        JG NEXT_STEP

        MOV [SI], AX
        ADD SI, 2
        INC fibonacci_count

        JMP FIB_LOOP

    NEXT_STEP:
    ;Showing Fibonacci series
    MOV AX, OFFSET fibonacci_msg
    CALL SHOW_MSG

    MOV CX, fibonacci_count
    MOV SI, offset fibonacci_array
    FIB_DISPLAY_LOOP: 
        MOV AX, offset space
        CALL SHOW_MSG
        MOV AX, [SI]
        CALL OUTPUT_NUM
        INC SI
        INC SI
        LOOP FIB_DISPLAY_LOOP


    ;Finding divisors
    MOV SI, offset divisor_array
    MOV CX, num

    DIV_LOOP:
        XOR DX,DX

        MOV AX, num
        MOV BX, CX
        DIV BX
        CMP DX, 0
        JNE NOT_DIVISOR

        MOV [SI], CX
        ADD SI, 2
        INC divisor_count

        NOT_DIVISOR:
            LOOP DIV_LOOP
   
    EXIT:
    ;Showing divisors
    MOV AX, OFFSET divisor_msg
    CALL SHOW_MSG
    MOV CX, divisor_count
    MOV SI, offset divisor_array
    DIV_DISPLAY_LOOP: 
        MOV AX, offset space
        CALL SHOW_MSG
        MOV AX, [SI]
        CALL OUTPUT_NUM
        ADD SI,2
        LOOP DIV_DISPLAY_LOOP

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN