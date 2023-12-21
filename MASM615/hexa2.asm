.8086
.MODEL SMALL
.STACK
.DATA
    N1 WORD ?
    N2 WORD ?
    SUM WORD ?
    M1 BYTE "Enter 1st Hex Number= "
    M2 BYTE "Enter 2nd Hex Number= "
    M3 BYTE " ","579E"
    MSG BYTE "Sum of 1234"
    MSG1 BYTE "and 456A"
    

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

        MOV CX,16  

        XOR BX,BX  

                


        INHEX1: CALL GETCHAR  
                ; Check if character is between '0' and '9' or 'A' and 'F'
                CMP AL,'0'    
                JB INHEX2     
                CMP AL,'9'    
                JA CHECKALPHA 
                JMP PROCESS_DIGIT
        CHECKALPHA:
                CMP AL,'A'
                JB INHEX2
                CMP AL,'F'
                JA INHEX2
                
                SUB AL,'A'    
                ADD AL,10     
                JMP PROCESS_DIGIT

        PROCESS_DIGIT:
                XOR AH,AH     
                PUSH AX       
                MOV AX,BX     
                MUL CX
                POP BX       
                ADD BX,AX    
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

        MOV AX,OFFSET MSG
        CALL DISPLAY

        MOV AX,N1
        CALL OUTHEX

        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,OFFSET MSG1
        CALL DISPLAY

        MOV AX,N2
        CALL OUTHEX

        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AL,'='
        CALL PUTCHAR

        MOV AX,OFFSET M3
        CALL DISPLAY

        MOV AX,SUM
        CALL OUTHEX

    ;---------------------------------------------------
        MOV AH, 4Ch          
        INT 21h

    MAIN ENDP
    END MAIN