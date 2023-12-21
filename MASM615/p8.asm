TITLE 1st sample program
.8086
.MODEL SMALL
.STACK
.DATA
        word1 WORD 65535
        word2 SWORD -32768
        word3 WORD ?
        word4 WORD "AB"
        myList WORD 1,2,3,4,5
        array WORD 5 DUP(?)


.CODE
MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------
;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

