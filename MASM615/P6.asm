COMMENT *This program moves a block of specified number of bytes from one place to another*

N equ 16     ;Define a constt. used in the program

.8086

.MODEL SMALL

.STACK

.DATA
    SOURCE       WORD 100
    DESTINATION  WORD 200
    SUM          WORD ?

.CODE

MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------
        MOV SI, SOURCE
        MOV DI, DESTINATION  ;SETUP SOURCE & DESTINATION OFFSET ADDRESSES
        MOV CX,N             ;SETUP BYTES COUNT TO BE MOVED

AGAIN:  MOV AH,[SI]          ;MOVE THE BLOCK
        MOV [DI],AH
        INC SI
        INC DI
        
        LOOP AGAIN
;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN
