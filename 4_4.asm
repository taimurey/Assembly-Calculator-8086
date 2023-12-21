TITLE    Program to input a 3x3 matrix and display the matrix, its transpose and diagonal elements.
.MODEL SMALL
.STACK
.DATA
    inputMsg BYTE "Input the elements of the matrix(3X3): ","$"
    outputMsg BYTE "The matrix is: ","$"
    diagonalMsg BYTE "The diagonal elements are: ","$"
    originalMatrix    WORD 9 DUP(?)
    transposedMatrix WORD 9 DUP(?)

    lineBreak     BYTE 13,10,"$"
    spaceChar       BYTE " ","$"

    endMsg BYTE 13,10,"PROGRAM TERMINATED","$"
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

READ_DEC PROC FAR  ;Procedure to input an unsigned decimal number from the keyboard to AX register
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,10   ;Multiplier

    XOR BX,BX   ;Clear number i.e., initialize to 0

    READ_LOOP: CALL READ_CHAR  ;Get next character
            CMP AL,'0'    ;Less than 0
            JB END_READ     ;Yes
            CMP AL,'9'    ;Greater than 9
            JA END_READ     ;Yes

            SUB AL,'0'    ;Get decimal digits

            XOR AH,AH     ;We want to save the digit in stack, must be of 2 bytes

            PUSH AX       ;Save the digit

            MOV AX,BX     ;Decimal multiplication by 10

            MUL CX
            POP BX       ;Restore the digit
            ADD BX,AX    ;Add the digit to the number (partial result)
            JMP READ_LOOP   ;Get next digit

    END_READ: MOV AX,BX    ;Return number in AX
                            
            POP BX       ;Restore Registers
            POP CX
            POP DX

            RET
READ_DEC ENDP      ;Return to Caller

WRITE_DEC PROC ;Procedure to output an unsigned decimal number to the terminal, the number must be placed in the ax register.
    PUSH AX   ;save registers
    PUSH BX   
    PUSH CX
    PUSH DX

    MOV CX,0   ;Initialize digit count
    MOV BX,10  ;Set up divisor

    WRITE_LOOP:   
        XOR DX,DX ;Make zero high order word of the dividend
        DIV BX        ;Divide by 10
        PUSH DX       ;Save remainder
        INC CL        ;Bump count
        CMP AX,0      ;Anything left?

        JA WRITE_LOOP       ;If yes, get next digit

    OUTPUT_LOOP:  
        POP AX     ;Get a digit from the stack
        ADD AL,'0'    ;Convert a digit to character
        CALL WRITE_CHAR  ;Output the digit
        LOOP OUTPUT_LOOP
        POP DX      ;Restore the registers
        POP CX
        POP BX
        POP AX
        RET

WRITE_DEC   ENDP    ;Return to Caller

; Procedure to input a 3x3 matrix
;condition is that offset must be in DI
INPUT_MATRIX PROC
    MOV CX,9
    MOV AX, OFFSET lineBreak
    CALL SHOW_MSG
    INPUT_LOOP:
        CALL READ_DEC
        MOV [DI],AX
        ADD DI,2
        LOOP INPUT_LOOP
    RET
INPUT_MATRIX ENDP

; Procedure to display a 3x3 matrix  
;condition is that offset must be in SI
SHOW_MATRIX PROC
    MOV CX,9

    DISPLAY_LOOP:
        XOR DX,DX
        MOV AX,CX
        MOV BX, 3
        DIV BX
        CMP DX,0
        JE newline1

        MOV AX, OFFSET spaceChar
        CALL SHOW_MSG

        MOV AX,[SI]
        CALL WRITE_DEC
        ADD SI,2
        CMP CX,1
        JE A
        LOOP DISPLAY_LOOP
        
    newline1:
        MOV AX, OFFSET lineBreak
        CALL SHOW_MSG

        MOV AX,[SI]
        CALL WRITE_DEC
        ADD SI,2

        CMP CX,1
        JE A
        LOOP DISPLAY_LOOP
    A:
    RET
SHOW_MATRIX ENDP

; Procedure to calculate and display transpose of a matrix
TRANSPOSE_MATRIX PROC
    MOV CX, 3 ; Loop counter for rows
    MOV DX, 3 ; Loop counter for columns
    MOV SI, OFFSET originalMatrix ; SI points to the original matrix
    MOV DI, OFFSET transposedMatrix ; DI points to the transposed matrix

TRANSPOSE_LOOP:
    PUSH DI ; Save DI
    PUSH CX ; Save row counter
    MOV CX, DX ; Set inner loop counter for columns

TRANSPOSE_INNER_LOOP:
    MOV AX, [SI] ; Load a number from the original matrix
    MOV [DI], AX ; Store the number in the transposed matrix
    ADD SI, 2 ; Move to the next element in the original matrix
    ADD DI, 6 ; Move to the next element in the transposed matrix (2 words for each element in a column)
    LOOP TRANSPOSE_INNER_LOOP

    POP CX ; Restore row counter
    POP DI ; Restore DI
    ADD DI, 2 ; Move to the next column in the transposed matrix
    LOOP TRANSPOSE_LOOP

    RET
TRANSPOSE_MATRIX ENDP

; Procedure to display diagonal elements of a matrix
SHOW_DIAGONAL PROC
    MOV CX, 3 ; Loop counter for diagonal elements
    MOV SI, OFFSET originalMatrix ; SI points to the matrix
SHOW_DIAGONAL_LOOP:
    MOV AX, [SI] ; Load a diagonal element
    CALL WRITE_DEC ; Output the diagonal element
    ADD SI, 8 ; Move to the next diagonal element
    MOV AX, OFFSET spaceChar
    CALL SHOW_MSG
    LOOP SHOW_DIAGONAL_LOOP
    RET
SHOW_DIAGONAL ENDP

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------

    MOV AX, OFFSET inputMsg ; Display the input message
    CALL SHOW_MSG
    MOV DI, OFFSET originalMatrix ; Set DI to point to matrix
    CALL INPUT_MATRIX ; Input the 3x3 matrix


    MOV AX, OFFSET outputMsg ; Display the output message
    CALL SHOW_MSG
    MOV SI, OFFSET originalMatrix ; SI points to the original matrix
    CALL SHOW_MATRIX ; Display the original matrix

    MOV AX, OFFSET lineBreak
    CALL SHOW_MSG


    MOV AX, OFFSET diagonalMsg ; Display the diagonal message
    CALL SHOW_MSG

    MOV AX, OFFSET lineBreak
    CALL SHOW_MSG
    
    CALL SHOW_DIAGONAL

    MOV AX, OFFSET lineBreak
    CALL SHOW_MSG

    CALL TRANSPOSE_MATRIX ; Calculate and display the transposed matrix
    MOV SI, OFFSET transposedMatrix ; SI points to the transposed matrix
    CALL SHOW_MATRIX ; Display the transposed matrix

    MOV AX, OFFSET endMsg ; Display the end message
    CALL SHOW_MSG

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN