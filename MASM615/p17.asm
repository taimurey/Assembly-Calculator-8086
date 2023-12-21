TITLE OCTAL Output Routine   ;multipler 8, range 0-7

.8086
.MODEL SMALL
.STACK
.DATA
    N1 WORD ?
    N2 WORD ?
    SUM WORD ?
    M1 BYTE "Enter the First Number= ",'$'
    M2 BYTE "Enter the Second Number= ",'$'
    M3 BYTE "   ",'$'
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

    INOCT PROC FAR  ;inputs an unsigned decimal number from the keyboard to AX register
                    ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-9
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,8   ;MULTIPLIER

        XOR BX,BX   ;cLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

        INOCT1: CALL GETCHAR  ;GET NEXT CHARACTER
                CMP AL,'0'    ;LESS THAN 0
                JB INOCT2     ;YES
                CMP AL,'7'    ;GREATER THAN 7
                JA INOCT2     ;YES

                SUB AL,'0'    ;GET DECIMAL digits

                XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

                PUSH AX       ;SAVE THE DIGIT

                MOV AX,BX     ;MULTIPLY N BY 8

                MUL CX
                POP BX       ;RESTORE THE DIGIT
                ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP INOCT1   ;GET NEXT DIGIT

        INOCT2: MOV AX,BX    ;RETURN N IN AX
                                
                POP BX       ;Restore Registers
                POP CX
                POP DX

                RET
    INOCT ENDP      ;Return to Caller

    OUTOCT PROC ;outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
        PUSH AX   ;save registers
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,8  ;SET UP DIVISOR

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

    OUTOCT   ENDP    ;RETURN TO CALLER

    MAIN PROC                ;ASSEMBLER DIRECTIVES

        MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
        MOV DS, AX
    ;---------------------------------------------------
        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INOCT
        MOV N1, AX
        
        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INOCT
        MOV N2, AX

        MOV AX,N1
        ADD AX,N2
        MOV SUM,AX  

        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        MOV AX,SUM
        CALL OUTOCT

    ;---------------------------------------------------
        MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
        INT 21h

    MAIN ENDP
    END MAIN