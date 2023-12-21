
TITLE HEX Output Routine

.8086
.MODEL SMALL
.STACK
.DATA
    N1 WORD ?
    N2 WORD ?
    SUM WORD ?
    M1 BYTE "Enter 1st Hex Number= ",'$'
    M2 BYTE "Enter 2nd Hex Number= ",'$'
    M3 BYTE "   ",'$'
.CODE
    DISPLAY PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h     ;Interrupt 21h, Function 9h
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

INHEX PROC FAR  
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,16  ; Set the base for hexadecimal

    XOR BX,BX  ; Initialize the sum to 0

INHEX1: 
    CALL GETCHAR  
    
    ; Check for carriage return to end input
    CMP AL, 0Dh
    JE END_INPUT
    
    ; Check if character is between '0' and '9'
    CMP AL,'0'    
    JB INVALID_INPUT   
    CMP AL,'9'    
    JBE PROCESS_DIGIT

    ; Check if character is between 'A' and 'F'
    CMP AL,'A'
    JB INVALID_INPUT
    CMP AL,'F'
    JBE PROCESS_DIGIT
    
    ; If it's not a valid hex character, go back to input
    JMP INVALID_INPUT

PROCESS_DIGIT:
    ; Convert character to number
    CMP AL, '9'
    JBE CONVERT_0_9
    SUB AL, 'A'
    SUB AL, 10

    JMP DIGIT_PROCESSED

CONVERT_0_9:
    SUB AL, '0'

DIGIT_PROCESSED:
    SHL BX, 4           ; Shift BX left by 4 (multiply by 16)
    OR BL, AL           ; Add the new number to BL
           ; Add the new number to BX
    JMP INHEX1          ; Get next character
    

INVALID_INPUT:
    ; Handle invalid input here if necessary, or just loop back to get the next character
    JMP INHEX1

END_INPUT:
    MOV AX, BX          ; Move the final number to AX
    POP DX              ; Restore registers
    POP CX
    POP BX
    RET

INHEX ENDP

  

    OUTHEX PROC 
        PUSH AX   
        PUSH BX   
        PUSH CX
        PUSH DX

        MOV CX,0   
        MOV BX,16  

        OUT1:   
            XOR DX,DX 
            DIV BX        
            PUSH DX       
            INC CL        
            CMP AX,0      

            JA OUT1       

        OUT2:  
            POP AX     
            CMP AL,10
            JL CONVERT_DIGIT
            SUB AL,10
            ADD AL,'A'
            JMP PRINT_DIGIT

        CONVERT_DIGIT:
            ADD AL,'0'    

        PRINT_DIGIT:
            CALL PUTCHAR  
            LOOP OUT2
            POP DX      
            POP CX
            POP BX
            POP AX
            RET

    OUTHEX   ENDP    

    MAIN PROC                

        MOV AX, @DATA        
        MOV DS, AX
    ;---------------------------------------------------
        MOV AX,OFFSET M1
        CALL DISPLAY
        CALL INHEX
        MOV N1, AX
        
        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,OFFSET M2
        CALL DISPLAY
        CALL INHEX
        MOV N2, AX

        MOV AX,N1
        ADD AX,N2
        MOV SUM,AX  

        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX
  
        MOV AL,'+'
        CALL PUTCHAR

        MOV AX,N2
        CALL OUTHEX

        MOV AL,'='
        CALL PUTCHAR

        MOV AX,SUM
        CALL OUTHEX

    ;---------------------------------------------------
        MOV AH, 4Ch          
        INT 21h

    MAIN ENDP
    END MAIN
