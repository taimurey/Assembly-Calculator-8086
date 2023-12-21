TITLE   Write a program that inputs a number and displays all its divisors along with list of Fibnocii numbers less than or equal to it.
.MODEL SMALL
.STACK
.DATA
    input_msg BYTE 13,10,"Input a number: $"
    number    WORD ?

    space     BYTE ' $'  ; space characters for formatting
    newline   BYTE 13,10,'$' ; newline characters for formatting

    fibnocii_msg  BYTE 13,10,"Fibnocii numbers: ", 13,10,'$'
    divisors_msg   BYTE 13,10,"Divisiors: ", 13,10,'$'

    fibnocii_array WORD 1,1,100 DUP(?)
    divisors_array  WORD 100 DUP(?)  

    fibnocii_count WORD 2
    divisors_count  WORD 0

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

    ;Finding fibnocii numbers
    MOV SI, offset fibnocii_array
    ADD SI, 4

    L1:
        MOV AX, [SI-2]
        MOV BX, [SI-4]
        ADD AX, BX

        CMP AX, number
        JG NEXT

        MOV [SI], AX
        ADD SI, 2
        INC fibnocii_count

        JMP L1

    NEXT:
    ;Showing fibnocii series
    MOV AX, OFFSET fibnocii_msg
    CALL DISPLAY

    MOV CX, fibnocii_count
    MOV SI, offset fibnocii_array
    LOOP1: 
        MOV AX, offset space
        CALL DISPLAY
        MOV AX, [SI]
        CALL OUTDEC
        INC SI
        INC SI
        LOOP LOOP1


    ;Finding divisors
    MOV SI, offset divisors_array
    MOV CX, number

    L2:
        XOR DX,DX

        MOV AX, number
        MOV BX, CX
        DIV BX
        CMP DX, 0
        JNE NOT_DIVISOR

        MOV [SI], CX
        ADD SI, 2
        INC divisors_count

        NOT_DIVISOR:
            LOOP L2
   
    EXIT:
    ;Showing divisors
    MOV AX, OFFSET divisors_msg
    CALL DISPLAY
    MOV CX, divisors_count
    MOV SI, offset divisors_array
    LOOP2: 
        MOV AX, offset space
        CALL DISPLAY
        MOV AX, [SI]
        CALL OUTDEC
        ADD SI,2
        LOOP LOOP2

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

