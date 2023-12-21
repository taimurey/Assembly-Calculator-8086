TITLE HEX Output Routine

.8086
.MODEL SMALL
.STACK
.DATA
    N1 WORD ?
    N2 WORD ?
    SUM WORD ?
    M1 BYTE "Enter the 1st Hex Number= ",'$'
    M2 BYTE "Enter the 2nd Hex Number= ",'$'
    M3 BYTE "   ",'$'
.CODE
    DISPLAY PROC FAR
        MOV DX,AX
        MOV AH,9
        INT 21h
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

    MOV CX,16  

    XOR BX,BX  

  INHEX1: CALL GETCHAR  
        CMP AL,0Dh   ; Check for Enter key
        JE INHEX2
        ; Check if character is between '0' and '9'
        CMP AL,'0'
        JB SKIP_PROCESS
        CMP AL,'9'
        JBE PROCESS_DIGIT
        ; Check if character is between 'A' and 'F'
        CMP AL,'A'
        JB SKIP_PROCESS
        CMP AL,'F'
        JA SKIP_PROCESS
        ; Convert characters 'A' to 'F' to numbers 10 to 15
        SUB AL,'A'    
        ADD AL,10
        JMP PROCESS_DIGIT

SKIP_PROCESS:
        MOV AL,0
        JMP PROCESS_DIGIT

PROCESS_DIGIT:
        XOR AH,AH
        MOV CL, 4     ; Shift 4 times
SHIFT_LOOP:
        SHL BX, 1     ; Shift BX left by 1 bit
        DEC CL        ; Decrement CL
        JNZ SHIFT_LOOP; Jump if CL is not zero to continue shifting
        ADD BX, AX    ; Add the new hex digit
        JMP INHEX1

INHEX2: MOV AX,BX    
        
        POP DX       
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
