TITLE program storing sum and diffrence of two numbers
.8086
.MODEL SMALL
.STACK
.DATA
    SOURCE       WORD 100
    DESTINATION  WORD 200
    SUM          WORD ?
    DIFF         WORD ?
.CODE
MAIN PROC                ;ASSEMBLER DIRECTIVES

    MOV AX, @DATA        ;INITIALIZE DATA SEGMENT
    MOV DS, AX
;---------------------------------------------------
    MOV AX, SOURCE
    MOV BX, DESTINATION
    ADD BX,AX
    MOV SUM,BX

    MOV BX, DESTINATION
    SUB BX,AX
    MOV DIFF,BX

;---------------------------------------------------

    MOV AH, 4Ch          ;RETURN CONTROL TO THE OPERATING SYSTEM
    INT 21h

MAIN ENDP
END MAIN
