TITLE  input a list of 10 integers and  sorted list in ascending, descending order, sum and product.
.8086
.MODEL SMALL
.STACK
.DATA
   
    input_msg   BYTE 13,10,"Input a list of 10 integers: $"
    list        WORD 10 DUP(?)

    space     BYTE ' $'  ; space characters for formatting
    newline   BYTE 13,10,'$' ; newline characters for formatting

    ascending   BYTE 13,10,"The sorted list in ascending order: $"

    descending  BYTE 13,10,"The sorted list in descending order: $"

    sum_msg     BYTE 13,10,"Sum of the list = $"
    sum_ans     WORD 0d
    prod_msg    BYTE 13,10,"Product of the list = $"
    prod_ans    WORD 1d

    temp        WORD ?

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
    MOV AX, OFFSET newline
    CALL DISPLAY

    MOV CX, 10
    MOV SI, offset list

    LOOP1: CALL INDEC
        MOV [SI], AX
        INC SI
        INC SI
        LOOP LOOP1


    ;Calculating sum
    MOV CX, 10
    MOV SI, offset list
    LOOP2: MOV AX, [SI]
        ADD sum_ans, AX
        INC SI
        INC SI
        LOOP LOOP2

    ;Calculating product
    MOV CX, 10
    MOV SI, offset list
    LOOP3: MOV AX, [SI]
        MOV BX, prod_ans
        MUL BX
        MOV prod_ans, AX
        INC SI
        INC SI
        LOOP LOOP3

    ;sorting array
    MOV CX, 9
    MOV SI, offset list
    outer_loop:
        MOV AX, [SI]
        MOV temp, AX
        MOV BX, temp
        MOV DI, SI

        PUSH CX
        PUSH SI

       inner_loop: 
            ADD SI, 2
            MOV AX, [SI]
            CMP AX,temp
            JA UPDATE
            JMP A

            UPDATE: 
                    MOV BX, temp
                    MOV [SI], BX
                    MOV temp, AX
                    MOV [DI], AX
            A:
                CMP CX,0
                JE B
                LOOP inner_loop
        B:
        POP SI
        POP CX
        ADD SI,2
        LOOP outer_loop

    ;printing in ascending order
    MOV AX, OFFSET descending
    CALL DISPLAY
    MOV CX, 10
    MOV SI, offset list

    LOOP4: 
        MOV AX, OFFSET space
        CALL DISPLAY

        MOV AX, [SI]
        CALL OUTDEC

        INC SI
        INC SI
        LOOP LOOP4

    MOV AX, OFFSET ascending
    CALL DISPLAY
    MOV CX, 10
    MOV SI, offset list
    ADD SI, SIZEOF list
    SUB SI, 2

    LOOP5: 
        MOV AX, OFFSET space
        CALL DISPLAY

        MOV AX, [SI]
        CALL OUTDEC

        DEC SI
        DEC SI
        LOOP LOOP5

    MOV AX, OFFSET sum_msg
    CALL DISPLAY
    MOV AX, sum_ans
    CALL OUTDEC

    MOV AX, OFFSET prod_msg
    CALL DISPLAY
    MOV AX, prod_ans
    CALL OUTDEC

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

