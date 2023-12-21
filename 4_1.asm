TITLE  Process a list of 10 integers: sort, sum and multiply.
.8086
.MODEL SMALL
.STACK
.DATA
   
    prompt_msg   BYTE 13,10,"Enter a list of 10 integers: $"
    num_list     WORD 10 DUP(?)

    space_char  BYTE ' $'  ; space for formatting
    new_line    BYTE 13,10,'$' ; newline for formatting

    asc_order   BYTE 13,10,"The sorted list in ascending order: $"

    desc_order  BYTE 13,10,"The sorted list in descending order: $"

    sum_prompt  BYTE 13,10,"Sum of the list = $"
    sum_result  WORD 0d
    prod_prompt BYTE 13,10,"Product of the list = $"
    prod_result WORD 1d

    temp_var    WORD ?

.CODE
    SHOWMSG PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h
        RET
    SHOWMSG ENDP

    READCHAR PROC FAR
        MOV AH,1
        INT 21H
        RET
    READCHAR ENDP

    WRITECHAR proc NEAR
        MOV DL,AL
        MOV AH,2
        INT 21h
        RET
    WRITECHAR ENDP

    READNUM PROC FAR  ;Reads an unsigned decimal number from the keyboard to AX register
                      ;The number is entered as 1 or more digits, the input is terminated by a char other than 0-9
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,10   ;MULTIPLIER

        XOR BX,BX   ;CLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

        READNUM1: CALL READCHAR  ;GET NEXT CHARACTER
                CMP AL,'0'    ;LESS THAN 0
                JB READNUM2   ;YES
                CMP AL,'9'    ;GREATER THAN 9
                JA READNUM2   ;YES

                SUB AL,'0'    ;GET DECIMAL digits

                XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

                PUSH AX       ;SAVE THE DIGIT

                MOV AX,BX     ;MULTIPLY N BY 10

                MUL CX
                POP BX       ;RESTORE THE DIGIT
                ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP READNUM1  ;GET NEXT DIGIT

        READNUM2: MOV AX,BX    ;RETURN N IN AX
                                
                POP BX       ;Restore Registers
                POP CX
                POP DX

                RET
    READNUM ENDP      ;Return to Caller

    WRITENUM PROC ;Outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
        PUSH AX   ;save registers
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,10  ;SET UP DIVISOR

        WRITE1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
            DIV BX        ;DIVIDE BY 10
            PUSH DX       ;SAVE REMAINDER
            INC CL        ;BUMP COUNT
            CMP AX,0      ;ANYTHING LEFT?

            JA WRITE1     ;IF YES, GET NEXT DIGIT

        WRITE2:  POP AX     ;GET A DIGIT FROM THE STACK
            ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
            CALL WRITECHAR  ;OUTPUT THE DIGIT
            LOOP WRITE2
            POP DX      ;RESTORE THE REGISTERS
            POP CX
            POP BX
            POP AX
            RET

    WRITENUM   ENDP    ;RETURN TO CALLER


MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    ;Taking input
    MOV AX, OFFSET prompt_msg
    CALL SHOWMSG
    MOV AX, OFFSET new_line
    CALL SHOWMSG

    MOV CX, 10
    MOV SI, offset num_list

    INPUT_LOOP: CALL READNUM
        MOV [SI], AX
        INC SI
        INC SI
        LOOP INPUT_LOOP


    ;Calculating sum
    MOV CX, 10
    MOV SI, offset num_list
    SUM_LOOP: MOV AX, [SI]
        ADD sum_result, AX
        INC SI
        INC SI
        LOOP SUM_LOOP

    ;Calculating product
    MOV CX, 10
    MOV SI, offset num_list
    PROD_LOOP: MOV AX, [SI]
        MOV BX, prod_result
        MUL BX
        MOV prod_result, AX
        INC SI
        INC SI
        LOOP PROD_LOOP

    ;sorting array
    MOV CX, 9
    MOV SI, offset num_list
    OUTER_LOOP:
        MOV AX, [SI]
        MOV temp_var, AX
        MOV BX, temp_var
        MOV DI, SI

        PUSH CX
        PUSH SI

       INNER_LOOP: 
            ADD SI, 2
            MOV AX, [SI]
            CMP AX,temp_var
            JA UPDATE
            JMP SKIP

            UPDATE: 
                    MOV BX, temp_var
                    MOV [SI], BX
                    MOV temp_var, AX
                    MOV [DI], AX
            SKIP:
                CMP CX,0
                JE END_LOOP
                LOOP INNER_LOOP
        END_LOOP:
        POP SI
        POP CX
        ADD SI,2
        LOOP OUTER_LOOP

    ;printing in ascending order
    MOV AX, OFFSET desc_order
    CALL SHOWMSG
    MOV CX, 10
    MOV SI, offset num_list

    ASC_LOOP: 
        MOV AX, OFFSET space_char
        CALL SHOWMSG

        MOV AX, [SI]
        CALL WRITENUM

        INC SI
        INC SI
        LOOP ASC_LOOP

    MOV AX, OFFSET asc_order
    CALL SHOWMSG
    MOV CX, 10
    MOV SI, offset num_list
    ADD SI, SIZEOF num_list
    SUB SI, 2

    DESC_LOOP: 
        MOV AX, OFFSET space_char
        CALL SHOWMSG

        MOV AX, [SI]
        CALL WRITENUM

        DEC SI
        DEC SI
        LOOP DESC_LOOP

    MOV AX, OFFSET sum_prompt
    CALL SHOWMSG
    MOV AX, sum_result
    CALL WRITENUM

    MOV AX, OFFSET prod_prompt
    CALL SHOWMSG
    MOV AX, prod_result
    CALL WRITENUM

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN