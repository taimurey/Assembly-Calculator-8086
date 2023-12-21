TITLE  Program to input a number and display all even and odd numbers less than the number.
.MODEL SMALL
.STACK
.DATA
    prompt_msg BYTE 13,10,"Enter a number: $"
    num        WORD ?

    space_char BYTE ' $'  ; Space characters for formatting
    new_line   BYTE 13,10,'$' ; Newline characters for formatting

    even_msg   BYTE 13,10,"Even numbers: ", 13,10,'$'
    odd_msg    BYTE 13,10,"Odd numbers: ", 13,10,'$'

    even_nums  WORD 100 DUP(?)
    odd_nums   WORD 100 DUP(?)  

    even_num_count WORD 0
    odd_num_count  WORD 0

.CODE
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

    WRITE_CHAR proc NEAR
        MOV DL,AL
        MOV AH,2
        INT 21h
        RET
    WRITE_CHAR ENDP

    READ_NUM PROC FAR  ;Inputs an unsigned decimal number from the keyboard to AX register
                       ;The number is entered as 1 or more digits, the input is terminated by a char other than 0-9
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,10   ;MULTIPLIER

        XOR BX,BX   ;CLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

        READ_LOOP1: CALL READ_CHAR  ;GET NEXT CHARACTER
                CMP AL,'0'    ;LESS THAN 0
                JB READ_LOOP2     ;YES
                CMP AL,'9'    ;GREATER THAN 9
                JA READ_LOOP2     ;YES

                SUB AL,'0'    ;GET DECIMAL digits

                XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

                PUSH AX       ;SAVE THE DIGIT

                MOV AX,BX     ;MULTIPLY N BY 10

                MUL CX
                POP BX       ;RESTORE THE DIGIT
                ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP READ_LOOP1   ;GET NEXT DIGIT

        READ_LOOP2: MOV AX,BX    ;RETURN N IN AX
                                
                POP BX       ;Restore Registers
                POP CX
                POP DX

                RET
    READ_NUM ENDP      ;Return to Caller

    WRITE_NUM PROC ;Outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
        PUSH AX   ;save registers
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,10  ;SET UP DIVISOR

        WRITE_LOOP1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
            DIV BX        ;DIVIDE BY 10
            PUSH DX       ;SAVE REMAINDER
            INC CL        ;BUMP COUNT
            CMP AX,0      ;ANYTHING LEFT?

            JA WRITE_LOOP1       ;IF YES, GET NEXT DIGIT

        WRITE_LOOP2:  POP AX     ;GET A DIGIT FROM THE STACK
            ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
            CALL WRITE_CHAR  ;OUTPUT THE DIGIT
            LOOP WRITE_LOOP2
            POP DX      ;RESTORE THE REGISTERS
            POP CX
            POP BX
            POP AX
            RET

    WRITE_NUM   ENDP    ;RETURN TO CALLER

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------
    ;Taking input
    MOV AX, OFFSET prompt_msg
    CALL SHOW_MESSAGE
    CALL READ_NUM
    MOV num, AX

    MOV SI, offset even_nums
    MOV DI, offset odd_nums

    ;Finding even and odd numbers
    MOV CX, num
    MAIN_LOOP:
    TEST CX, 1
    JZ IS_EVEN
    JMP IS_ODD

    CMP CX, 0
    JZ END_PROGRAM

        IS_EVEN:
            MOV [SI], CX
            INC SI
            INC SI
            INC even_num_count
            JMP NEXT_ITERATION

        IS_ODD:
            MOV [DI], CX
            INC DI
            INC DI
            INC odd_num_count
    NEXT_ITERATION:  
    LOOP MAIN_LOOP

END_PROGRAM:
    ;Showing even numbers
    MOV AX, OFFSET even_msg
    CALL SHOW_MESSAGE

    MOV CX, even_num_count
    MOV SI, offset even_nums
    DISPLAY_EVEN_LOOP: 
        MOV AX, offset space_char
        CALL SHOW_MESSAGE
        MOV AX, [SI]
        CALL WRITE_NUM
        INC SI
        INC SI
        LOOP DISPLAY_EVEN_LOOP

    ;Showing odd numbers
    MOV AX, OFFSET odd_msg
    CALL SHOW_MESSAGE
    MOV CX, odd_num_count
    MOV SI, offset odd_nums
    DISPLAY_ODD_LOOP: 
        MOV AX, offset space_char
        CALL SHOW_MESSAGE
        MOV AX, [SI]
        CALL WRITE_NUM
        INC SI
        INC SI
        LOOP DISPLAY_ODD_LOOP

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN