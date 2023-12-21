TITLE 1st sample program
.8086
.MODEL SMALL
.STACK
.DATA
        lw1 WORD 10,20,30,40
        lw2 WORD 10,20,30,40
            WORD 50,60,70,80
            WORD 81,82,83,84
        lw3 WORD ?,32,41h,00100010b
        lw4 WORD 0Ah,20h,'A',22h

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

