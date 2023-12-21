COMMENT *This program moves a bloco of specified number of bytes from one place to 
        another*

N = 16          ;Define a constt. used in the program


.8086
.MODEL SMALL

.STACK

.DATA
	SOURCE			WORD	100
	DESTINATION		WORD	200
	SUM			WORD	?


.CODE

MAIN     PROC
	 MOV		AX, @DATA		;INTIALIZE DATA SEGMENT
	 MOV		DS, AX			
;----------------------------------------------------------------------

        MOV             SI,SOURCE
        MOV             DI,DESTINATION                  ;SETUP SOUCE & DESTINATION OFFSET ADDRESSES
        MOV             CX,N                            ;SETUP BYTES COUNT TO BE MOVED


AGAIN:  MOV             AH,[SI]                         ;MOVE THE BLOCK
        MOV             [DI],AH 
        INC             SI
        INC             DI
        DEC             CX
        JNZ             AGAIN
;----------------------------------------------------------------------


	 MOV		AH, 4CH	                        ;RETURN CONTROL TO THE OPERTAING SYSTEM
	 INT		21H
MAIN	 ENDP
END	 MAIN