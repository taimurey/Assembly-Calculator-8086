TITLE    Write a program that inputs a matrix of the order of 3 x 3 and displays the matrix along with its transpose and diagonal elements.
.MODEL SMALL
.STACK
.DATA
    input BYTE "Enter the elements of the matrix(3X3): ","$"
    output BYTE "The matrix is: ","$"
    diagonal BYTE "The diagonal elements are: ","$"
    matrix    WORD 9 DUP(?)
    transpose WORD 9 DUP(?)

    newline     BYTE 13,10,"$"
    space       BYTE " ","$"

    end1 BYTE 13,10,"END OF PROGRAM","$"
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

; Procedure to input a 3x3 matrix
;condition is that offset must be in DI
INPUT_MATRIX PROC
    MOV CX,9
    MOV AX, OFFSET newline
    CALL DISPLAY
    INPUT_LOOP:
        CALL INDEC
        MOV [DI],AX
        ADD DI,2
        LOOP INPUT_LOOP
    RET
INPUT_MATRIX ENDP

; Procedure to display a 3x3 matrix  
;condition is that offset must be in SI
DISPLAY_MATRIX PROC
    MOV CX,9

    DISPLAY_LOOP:
        XOR DX,DX
        MOV AX,CX
        MOV BX, 3
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

; Procedure to calculate and display transpose of a matrix
TRANSPOSE_MATRIX PROC
    MOV CX, 3 ; Loop counter for rows
    MOV DX, 3 ; Loop counter for columns
    MOV SI, OFFSET matrix ; SI points to the original matrix
    MOV DI, OFFSET transpose ; DI points to the transpose matrix

TRANSPOSE_LOOP:
    PUSH DI ; Save DI
    PUSH CX ; Save row counter
    MOV CX, DX ; Set inner loop counter for columns

TRANSPOSE_INNER_LOOP:
    MOV AX, [SI] ; Load a number from the original matrix
    MOV [DI], AX ; Store the number in the transpose matrix
    ADD SI, 2 ; Move to the next element in the original matrix
    ADD DI, 6 ; Move to the next element in the transpose matrix (2 words for each element in a column)
    LOOP TRANSPOSE_INNER_LOOP

    POP CX ; Restore row counter
    ;ADD SI, 6 ; Move to the next row in the original matrix (2 words for each element in a row)
    POP DI ; Restore DI
    ADD DI, 2 ; Move to the next column in the transpose matrix
    LOOP TRANSPOSE_LOOP

    RET
TRANSPOSE_MATRIX ENDP

; Procedure to display diagonal elements of a matrix
DISPLAY_DIAGONAL PROC
    MOV CX, 3 ; Loop counter for diagonal elements
    MOV SI, OFFSET matrix ; SI points to the matrix
DISPLAY_DIAGONAL_LOOP:
    MOV AX, [SI] ; Load a diagonal element
    CALL OUTDEC ; Output the diagonal element
    ADD SI, 8 ; Move to the next diagonal element
    MOV AX, OFFSET space
    CALL DISPLAY
    LOOP DISPLAY_DIAGONAL_LOOP
    RET
DISPLAY_DIAGONAL ENDP

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    MOV AX, OFFSET input ; Display the input message
    CALL DISPLAY
    MOV DI, OFFSET matrix ; Set DI to point to matrix
    CALL INPUT_MATRIX ; Input the 3x3 matrix


    MOV AX, OFFSET output ; Display the output message
    CALL DISPLAY
    MOV SI, OFFSET matrix ; SI points to the original matrix
    CALL DISPLAY_MATRIX ; Display the original matrix

    MOV AX, OFFSET newline
    CALL DISPLAY


    MOV AX, OFFSET diagonal ; Display the diagonal message
    CALL DISPLAY

    MOV AX, OFFSET newline
    CALL DISPLAY
    
    CALL DISPLAY_DIAGONAL

    MOV AX, OFFSET newline
    CALL DISPLAY

    CALL TRANSPOSE_MATRIX ; Calculate and display the transpose matrix
    MOV SI, OFFSET transpose ; SI points to the transpose matrix
    CALL DISPLAY_MATRIX ; Display the transpose matrix

    MOV AX, OFFSET END1 ; Display the end message
    CALL DISPLAY

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

