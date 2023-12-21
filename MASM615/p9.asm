TITLE 1st sample program
.8086
.MODEL SMALL
.STACK
.DATA
        lw1 word 10,10,10,10
            word 20,20,20,20
            word 30,30,30,30
        lw2 word 4 dup(10)
            word 4 dup(20)
            word 4 dup(30)
            word 2 dup(0),2 dup("A")
         


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

