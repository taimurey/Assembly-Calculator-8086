; Develop routines (procedures) to input and output decimal numbers in the range 0 to 65535 
; and verify their correctness by writing a menu driven calculator program that inputs two 
; operands (unsigned numbers) and an operator (+, -, *, /, %), performs the operation on 
; operands and displays the result.

.8086

.model small

.stack 100h

.DATA
    
    msg1   db 10, 13, "Enter First Number: $"
    msg2   db 10, 13, "Enter Second Number: $"
    msg3   db 10, 13, "Enter Operator (+, -, *, /, %): $"
    msg4   db 10, 13, "Result: $"
    msg5   db 10, 13, "Invalid Operator: $"
    msg6   db 10, 13, "Division by Zero Error: $"
    num1   dw ?
    num2   dw ?
    opr    db ?
    result dw ?

.CODE

main proc
                       mov  ax, @data
                       mov  ds, ax

    ; Display menu and handle user input
                       call DisplayMenu

    ; Perform calculation based on input
                       call PerformCalculation

    ; Handle output
                       call HandleOutput

    ; Terminate program
                       mov  ah, 4Ch
                       int  21h
main endp

ReadDecimalNumber proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  cx, 0
                       mov  dx, 0
                       mov  bx, 10

    ; Read number
    read:              
                       mov  ah, 1
                       int  21h
                       cmp  al, 13
                       je   exit
                       cmp  al, 8
                       je   backspace
                       sub  al, 48
                       mul  bx
                       add  dx, ax
                       jmp  read

    ; Handle backspace
    backspace:         
                       mov  ah, 2
                       mov  dl, 8
                       int  21h
                       mov  ah, 2
                       mov  dl, ' '
                       int  21h
                       mov  ah, 2
                       mov  dl, 8
                       int  21h
                       jmp  read

    ; Exit

    exit:              
                       mov  [si], dx
                       mov  [di], cx

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

ReadDecimalNumber endp

WriteDecimalNumber proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, 10
                       mov  cx, 0

    ; Write number
    write:             
                       mov  dx, 0
                       div  bx
                       push dx
                       inc  cx
                       cmp  ax, 0
                       jne  write

    ; Display number
    display:           
                       pop  dx
                       add  dl, 48
                       mov  ah, 2
                       int  21h
                       loop display

    ; Exit

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

WriteDecimalNumber endp

AddNumbers proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       add  ax, bx
                       mov  [si], ax

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

AddNumbers endp

SubtractNumbers proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       sub  ax, bx
                       mov  [si], ax

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

SubtractNumbers endp

MultiplyNumbers proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       mul  bx
                       mov  [si], ax

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

MultiplyNumbers endp

DivideNumbers proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       mov  dx, 0
                       div  bx
                       mov  [si], ax

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

DivideNumbers endp

ModulusNumbers proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       mov  dx, 0
                       div  bx
                       mov  [si], dx

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

ModulusNumbers endp

DisplayMenu proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]

    ; Display message

                       mov  ah, 9
                       mov  dx, offset msg1
                       int  21h

    ; Read first number

                       mov  dx, offset num1
                       mov  cx, offset num2
                       call ReadDecimalNumber

    ; Display message

                       mov  ah, 9
                       mov  dx, offset msg2
                       int  21h

    ; Read second number

                       mov  dx, offset num2
                       mov  cx, offset opr
                       call ReadDecimalNumber

    ; Display message

                       mov  ah, 9
                       mov  dx, offset msg3
                       int  21h

    ; Read operator

                       mov  dx, offset opr
                       mov  cx, offset result
                       call ReadDecimalNumber

    ; Exit

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

DisplayMenu endp

HandleInput proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       cmp  bx, 43
                       je   add
                       cmp  bx, 45
                       je   subtract
                       cmp  bx, 42
                       je   multiply
                       cmp  bx, 47
                       je   divide
                       cmp  bx, 37
                       je   modulus
                       jmp  error

    ; Exit

    add:               
                       call AddNumbers
                       jmp  exit

    subtract:          
                       call SubtractNumbers
                       jmp  exit

    multiply:          


                       call MultiplyNumbers
                       jmp  exit

    divide:            


                       call DivideNumbers
                       jmp  exit

    modulus:           

                       call ModulusNumbers
                       jmp  exit

    error:             
                       mov  dx, offset msg5
                       mov  ah, 9
                       int  21h
                       jmp  exit

    exit:              

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

HandleInput endp

HandleOutput proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]

    ; Display message

                       mov  ah, 9
                       mov  dx, offset msg4
                       int  21h

    ; Write result

                       mov  dx, offset result
                       mov  cx, offset num1
                       call WriteDecimalNumber

    ; Exit

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

HandleOutput endp

PerformCalculation proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]

    ; Validate input

                       mov  dx, offset opr
                       mov  cx, offset result
                       call ValidateInput

    ; Handle input

                       mov  dx, offset num1
                       mov  cx, offset opr
                       call HandleInput

    ; Exit

                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

PerformCalculation endp

ValidateInput proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       cmp  bx, 43
                       je   exit
                       cmp  bx, 45
                       je   exit
                       cmp  bx, 42
                       je   exit
                       cmp  bx, 47
                       je   exit
                       cmp  bx, 37
                       je   exit
                       jmp  error

    ; Exit

    exit:              
                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

    ; Error

    error:             
                       mov  dx, offset msg5
                       mov  ah, 9
                       int  21h
                       jmp  exit

ValidateInput endp

ErrorHandling proc
                       push ax
                       push bx
                       push cx
                       push dx
                       push si
                       push di
                       push bp

                       mov  bp, sp
                       mov  si, [bp+4]
                       mov  di, [bp+6]
                       mov  ax, [si]
                       mov  bx, [di]
                       cmp  bx, 43
                       je   exit
                       cmp  bx, 45
                       je   exit
                       cmp  bx, 42
                       je   exit
                       cmp  bx, 47
                       je   exit
                       cmp  bx, 37
                       je   exit
                       jmp  error

    ; Exit

    exit:              
                       pop  bp
                       pop  di
                       pop  si
                       pop  dx
                       pop  cx
                       pop  bx
                       pop  ax
                       ret  4

    ; Error

    error:             
                       mov  dx, offset msg5
                       mov  ah, 9
                       int  21h
                       jmp  exit

ErrorHandling endp


    



END main