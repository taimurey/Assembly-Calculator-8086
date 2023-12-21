TITLE 1st sample program
.8086
.MODEL SMALL
.STACK
.DATA
        list1 BYTE 10,20,30,40
        list2 BYTE 10,20,30,40
              BYTE 50,60,70,80
              BYTE 81,82,83,84
        list3 BYTE ?,32,41h,00100010b
        list4 BYTE 0Ah,20h,'A',22h

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

