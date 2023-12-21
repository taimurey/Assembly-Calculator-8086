TITLE program storing sum of two numbers
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
    MOV AX, SOURCE
    MOV BX, DESTINATION
    ADD BX,AX
    MOV SUM,BX

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN

