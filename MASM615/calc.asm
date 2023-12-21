TITLE A multi mode calculator
.8086
.MODEL SMALL
.STACK
.DATA

    ;messages for the user
    calculator  BYTE "WELCOME TO CALCULATOR",13,10
                BYTE "Select your Mode",13,10
                BYTE "1. Decimal",13,10
                BYTE "2. Octal",13,10
                BYTE "3. Hexadecimal",13,10
                BYTE "4. Binary",13,10
                BYTE "Enter your choice: $"

    menu        BYTE 13,10,"          MAIN MENU",13,10
                BYTE "Addition...........1", 13, 10
                BYTE "Substraction.......2", 13, 10
                BYTE "Multiplication.....3", 13, 10
                BYTE "Divide(Remainder)..4", 13, 10
                BYTE "Divide(Quotient)...5", 13, 10
                BYTE "Exit...............6", 13, 10
                BYTE "Enter your choice: $"
            
    newline     BYTE 13, 10, '$'  ; Newline characters for formatting

    error       BYTE 13,10,"Invalid choice!",13,10
                BYTE "Re-enter your choice: $"

    goodbye     BYTE 13,10,"Goodbye!$"

    N1          WORD ?
    N2          WORD ?
    TEMP        WORD ?
    MODE        BYTE ?

    M1          BYTE "1st NUMBER= ",'$'
    M2          BYTE "2nd NUMBER= ",'$'

.CODE

DISPLAY PROC FAR
    PUSH DX
    MOV DX,AX
    MOV AH,9
    INT 21h
    POP DX
    RET
DISPLAY ENDP

GETCHAR PROC NEAR
    PUSH DX
    MOV AH,1
    INT 21h
    POP DX
    RET
GETCHAR ENDP

PUTCHAR proc NEAR
    MOV DL,AL
    MOV AH,2
    INT 21h
    RET
PUTCHAR ENDP

;______________________________________________________________________________________________________________________________

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

;__________________________________________________________________________________________________________________________________

    INOCT PROC FAR  ;inputs an unsigned octal number from the keyboard to AX register
                    ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-7
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

                MOV AX,BX     ;DEC_MULTIPLICATION N BY 8

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

        OCT1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
            DIV BX        ;DIVIDE BY 8
            PUSH DX       ;SAVE REMAINDER
            INC CL        ;BUMP COUNT
            CMP AX,0      ;ANYTHING LEFT?

            JA OCT1       ;IF YES, GET NEXT DIGIT

        OCT2:  POP AX     ;GET A DIGIT FROM THE STACK
            ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
            CALL PUTCHAR  ;OUTPUT THE DIGIT
            LOOP OCT2
            POP DX      ;RESTORE THE REGISTERS
            POP CX
            POP BX
            POP AX
            RET

    OUTOCT   ENDP    ;RETURN TO CALLER
;_________________________________________________________________________________________________________________________________________
        INHEX PROC FAR
            PUSH BX
            PUSH CX
            PUSH DX

            MOV CX, 16 ;MULTIPLIER
            XOR BX, BX ;cLEAR NUMBER MEAN INITILIZE TO 0 

            INHEX1:
                CALL GETCHAR
                CMP AL, '0' ;LESS THAN 0
                JB INHEX3   ;YES
                CMP AL, '9' ;GREATER THAN 9
                JA INHEX2   ;YES
                SUB AL, '0' ;GET DECIMAL digits
                JMP CONT
            INHEX2:
                CMP AL, 'A' ;LESS THAN A
                JB INHEX3
                CMP AL, 'F' ;GREATER THAN F
                JA INHEX3  ;YES
                SUB AL, 37h ;GET DECIMAL digits
                JMP CONT
            CONT:
                XOR AH, AH ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE  
                PUSH AX ;SAVE THE DIGIT

                MOV AX, BX ;;DEC_MULTIPLICATION N BY 16

                MUL CX
                POP BX ;RESTORE THE DIGIT
                ADD BX, AX ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP INHEX1 ;GET NEXT DIGIT
            INHEX3:
                MOV AX, BX ;RETURN N IN AX

                POP DX  ;Restore Registers
                POP CX
                POP BX
                RET
        INHEX ENDP ;Return to caller

    OUTHEX PROC FAR
        PUSH AX ;save registers
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,16  ;SET UP DIVISOR

    OUT1:
        XOR DX, DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
        DIV BX ;DIVIDE BY 16
        PUSH DX ;SAVE THE REMAINDER
        INC CL ;BUMP COUNT
        CMP AX, 0 ;ANYTHING LEFT?

        JA OUT1 ;IF YES, GET NEXT DIGIT

    OUT2:
        POP AX ;GET A DIGIT FROM THE STACK
        CMP AX, 9
        JA LETTER
    DIGIT:
        ADD AL, '0'
        JMP CONT
    LETTER:
        ADD AL, 37h
    CONT:
        CALL PUTCHAR
        LOOP OUT2
        POP DX ;RESTORE THE REGISTERS
        POP CX
        POP BX
        POP AX
        RET
    OUTHEX ENDP
  
    ;_________________________________________________________________________________________________________________________________________
    INBIN PROC FAR  ;inputs an unsigned binary number from the keyboard to AX register
                    ;the number is entered as 1 or more digits, the input is terminated by a char other than 0-1
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,2   ;MULTIPLIER

        XOR BX,BX   ;cLEAR NUMBER MEAN INITILIZE TO 0  (MOV BX,0  ADD BX,0   XOR BX,BX)

        INBIN1: CALL GETCHAR  ;GET NEXT CHARACTER
                CMP AL,'0'    ;LESS THAN 0
                JB INBIN2     ;YES
                CMP AL,'1'    ;GREATER THAN 1
                JA INBIN2     ;YES

                SUB AL,'0'    ;GET DECIMAL digits

                XOR AH,AH     ;WE WANT TO SAVE THE DIGIT IN STACK MUST BE OF 2BYTE

                PUSH AX       ;SAVE THE DIGIT

                MOV AX,BX     ;DEC_MULTIPLICATION N BY 2

                MUL CX
                POP BX       ;RESTORE THE DIGIT
                ADD BX,AX    ;ADD THE DIGIT TO THE NUMBER (PARTIAL RESULT)
                JMP INBIN1   ;GET NEXT DIGIT

        INBIN2: MOV AX,BX    ;RETURN N IN AX
                                
                POP BX       ;Restore Registers
                POP CX
                POP DX

                RET
    INBIN ENDP      ;Return to Caller

    OUTBIN PROC ;outputs an unsigned decimal number to the terminal, the number must be placed in the ax register.
        PUSH AX   ;save registers
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   ;INITIALIZE DIGIT COUNT
        MOV BX,2  ;SET UP DIVISOR

        BIN1:   XOR DX,DX ;MAKE ZERO HIGH ORDER WORD OF THE DIVIDEND
            DIV BX        ;DIVIDE BY 10
            PUSH DX       ;SAVE REMAINDER
            INC CL        ;BUMP COUNT
            CMP AX,0      ;ANYTHING LEFT?
            JA BIN1       ;IF YES, GET NEXT DIGIT

        BIN2:  POP AX     ;GET A DIGIT FROM THE STACK
            ADD AL,'0'    ;CONVERT A DIGIT TO CHARACTER
            CALL PUTCHAR  ;OUTPUT THE DIGIT
            LOOP BIN2
            POP DX      ;RESTORE THE REGISTERS
            POP CX
            POP BX
            POP AX
            RET
    OUTBIN   ENDP    ;RETURN TO CALLER
    ;_________________________________________________________________________________________________________________________________________

ADDITION PROC
    MOV AX,N1
    ADD AX,N2
    MOV TEMP,AX
    RET
ADDITION ENDP

SUBSTRACTION PROC
    MOV AX,N1
    SUB AX,N2
    MOV TEMP,AX
    RET
SUBSTRACTION ENDP

MULTIPLICATION PROC
    PUSH DX
    PUSH BX
    XOR DX,DX

    MOV AX,N1
    MOV BX,N2
    MUL BX
    MOV TEMP,AX
    MOV AX,DX
    MOV TEMP+2,AX
    
    POP BX
    POP DX
    RET
MULTIPLICATION ENDP

DIVIDE_REMAINDER PROC
    PUSH DX
    PUSH BX
    XOR DX,DX

    MOV AX,N1
    MOV BX,N2
    DIV BX
    MOV TEMP,DX
 
    POP BX
    POP DX

    RET
DIVIDE_REMAINDER ENDP

DIVIDE_QUOTIENT PROC
    PUSH DX
    PUSH BX
    XOR DX,DX

    MOV AX,N1
    MOV BX,N2
    DIV BX
    MOV TEMP,AX
 
    POP BX
    POP DX

    RET
DIVIDE_QUOTIENT ENDP


MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    ;-------------------------

    MOV AX,OFFSET calculator
    CALL DISPLAY

    START1:
        CALL GETCHAR
        MOV MODE, AL

        CMP MODE, '1'
        JE CAL_DECIMAL
        CMP MODE, '2'
        JE CAL_OCTAL
        CMP MODE, '3'
        JE CAL_HEXADECIMAL
        CMP MODE, '4'
        JE CAL_BINARY

        MOV AX, OFFSET error
        CALL DISPLAY 
        JMP START1


    START_DEC:
    CAL_DECIMAL:

        XOR DX,DX
        XOR CX,CX
        XOR BX,BX
        XOR AX,AX

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INDEC
        MOV N1, AX

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INDEC
        MOV N2, AX

        MOV AX,OFFSET newline
        CALL DISPLAY
        
        MOV AX, OFFSET menu
        CALL DISPLAY

        INPUT:
            CALL GETCHAR

            CMP AL, '1'
            JE DEC_ADDITION
            CMP AL, '2'
            JE DEC_SUBSTRACTION
            CMP AL, '3'
            JE DEC_MULTIPLICATION
            CMP AL, '4'
            JE DEC_DIVIDE_REMAINDER
            CMP AL, '5'
            JE DEC_DIVIDE_QUOTIENT
            CMP AL, '6'
            JE EXIT

            MOV AX, OFFSET error
            CALL DISPLAY 
            JMP INPUT

    START_OCT:
    CAL_OCTAL:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INOCT
        MOV N1, AX

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INOCT
        MOV N2, AX

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX, OFFSET menu
        CALL DISPLAY

        INPUT1:
            CALL GETCHAR

            CMP AL, '1'
            JE OCT_ADDITION
            CMP AL, '2'
            JE OCT_SUBSTRACTION
            CMP AL, '3'
            JE OCT_MULTIPLICATION
            CMP AL, '4'
            JE OCT_DIVIDE_REMAINDER
            CMP AL, '5'
            JE OCT_DIVIDE_QUOTIENT
            CMP AL, '6'
            JE EXIT

            MOV AX, OFFSET error
            CALL DISPLAY
            JMP INPUT1

    START_HEX:
    CAL_HEXADECIMAL:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INHEX
        MOV N1, AX

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INHEX
        MOV N2, AX

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX, OFFSET menu
        CALL DISPLAY

        INPUT2:
            CALL GETCHAR

            CMP AL, '1'
            JE HEX_ADDITION
            CMP AL, '2'
            JE HEX_SUBSTRACTION
            CMP AL, '3'
            JE HEX_MULTIPLICATION
            CMP AL, '4'
            JE HEX_DIVIDE_REMAINDER
            CMP AL, '5'
            JE HEX_DIVIDE_QUOTIENT
            CMP AL, '6'
            JE EXIT

            MOV AX, OFFSET error
            CALL DISPLAY
            JMP INPUT2

    START_BIN:
    CAL_BINARY:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INBIN
        MOV N1, AX

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INBIN
        MOV N2, AX

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX, OFFSET menu
        CALL DISPLAY

        INPUT3:
            CALL GETCHAR

            CMP AL, '1'
            JE BIN_ADDITION
            CMP AL, '2'
            JE BIN_SUBSTRACTION
            CMP AL, '3'
            JE BIN_MULTIPLICATION
            CMP AL, '4'
            JE BIN_DIVIDE_REMAINDER
            CMP AL, '5'
            JE BIN_DIVIDE_QUOTIENT
            CMP AL, '6'
            JE EXIT

            MOV AX, OFFSET error
            CALL DISPLAY
            JMP INPUT3
 

    DEC_ADDITION:
 
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTDEC
  
        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTDEC

        MOV AL,'='
        CALL PUTCHAR

        CALL ADDITION
        MOV AX,TEMP
        CALL OUTDEC
        
        JMP AGAIN_DEC


    DEC_SUBSTRACTION:

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTDEC
  
        MOV AL,'-'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTDEC

        MOV AL,'='
        CALL PUTCHAR

        CALL SUBSTRACTION
        MOV AX,TEMP
        CALL OUTDEC

        JMP AGAIN_DEC

    DEC_MULTIPLICATION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTDEC
  
        MOV AL,'*'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTDEC

        MOV AL,'='
        CALL PUTCHAR

        CALL MULTIPLICATION
        MOV AX,TEMP
        CALL OUTDEC

        JMP AGAIN_DEC

    DEC_DIVIDE_REMAINDER:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTDEC
  
        MOV AL,'%'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTDEC

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_REMAINDER
        MOV AX,TEMP
        CALL OUTDEC
    
        JMP AGAIN_DEC

    DEC_DIVIDE_QUOTIENT:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTDEC
  
        MOV AL,'/'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTDEC

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_QUOTIENT
        MOV AX,TEMP
        CALL OUTDEC
    

        JMP AGAIN_DEC


    OCT_ADDITION:
    
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        CALL ADDITION
        MOV AX,TEMP
        CALL OUTOCT
        
     
        JMP AGAIN_OCT

    OCT_SUBSTRACTION:

        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'-'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        CALL SUBSTRACTION
        MOV AX,TEMP
        CALL OUTOCT

        JMP AGAIN_OCT


    OCT_MULTIPLICATION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'*'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        CALL MULTIPLICATION
        MOV AX,TEMP
        CALL OUTOCT

        JMP AGAIN_OCT

    OCT_DIVIDE_REMAINDER:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'%'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_REMAINDER
        MOV AX,TEMP
        CALL OUTOCT
    
        JMP AGAIN_OCT

    OCT_DIVIDE_QUOTIENT:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTOCT
  
        MOV AL,'/'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTOCT

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_QUOTIENT
        MOV AX,TEMP
        CALL OUTOCT
    

        JMP AGAIN_OCT


    HEX_ADDITION:      
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        CALL ADDITION
        MOV AX,TEMP
        CALL OUTHEX
        
        JMP AGAIN_HEX

    HEX_SUBSTRACTION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AL,'-'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        CALL SUBSTRACTION
        MOV AX,TEMP
        CALL OUTHEX

        JMP AGAIN_HEX


    HEX_MULTIPLICATION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AL,'*'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        CALL MULTIPLICATION
        MOV AX,TEMP
        CALL OUTHEX

        JMP AGAIN_HEX

    HEX_DIVIDE_REMAINDER:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AL,'%'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_REMAINDER
        MOV AX,TEMP
        CALL OUTHEX
    
        JMP AGAIN_HEX

    HEX_DIVIDE_QUOTIENT:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AL,'/'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_QUOTIENT
        MOV AX,TEMP
        CALL OUTHEX
    

        JMP AGAIN_HEX

    BIN_ADDITION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTBIN
  
        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTBIN

        MOV AL,'='
        CALL PUTCHAR

        CALL ADDITION
        MOV AX,TEMP
        CALL OUTBIN
        
        JMP AGAIN_BIN

    BIN_SUBSTRACTION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTBIN
  
        MOV AL,'-'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTBIN

        MOV AL,'='
        CALL PUTCHAR

        CALL SUBSTRACTION
        MOV AX,TEMP
        CALL OUTBIN

        JMP AGAIN_BIN

BIN_MULTIPLICATION:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTBIN
  
        MOV AL,'*'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTBIN

        MOV AL,'='
        CALL PUTCHAR

        CALL MULTIPLICATION
        MOV AX,TEMP
        CALL OUTBIN

        JMP AGAIN_BIN

    BIN_DIVIDE_REMAINDER:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTBIN
  
        MOV AL,'%'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTBIN

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_REMAINDER
        MOV AX,TEMP
        CALL OUTBIN
    
        JMP AGAIN_BIN

    BIN_DIVIDE_QUOTIENT:
        MOV AX,OFFSET newline
        CALL DISPLAY

        MOV AX,N1
        CALL OUTBIN
  
        MOV AL,'/'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTBIN

        MOV AL,'='
        CALL PUTCHAR

        CALL DIVIDE_QUOTIENT
        MOV AX,TEMP
        CALL OUTBIN
    

        JMP AGAIN_BIN

    AGAIN_DEC:
        MOV AX, OFFSET newline
        CALL DISPLAY

        JMP START_DEC

    AGAIN_BIN:
        MOV AX, OFFSET newline
        CALL DISPLAY

        JMP START_BIN

    AGAIN_HEX:
        MOV AX, OFFSET newline
        CALL DISPLAY

        JMP START_HEX

    AGAIN_OCT:
        MOV AX, OFFSET newline
        CALL DISPLAY

        JMP START_OCT   
    
    ;-------------------------
    EXIT:
        MOV AX, OFFSET goodbye
        CALL DISPLAY
        MOV AH, 4Ch
        INT 21h

MAIN ENDP
END MAIN