; Calculator Menu

.8086
.MODEL small

.stack 100h

.DATA

    MSG1 DB 10,13, 'Addition............1 $'
    MSG2 DB 10,13, 'Subtraction.........2 $'
    MSG3 DB 10,13, 'Multiplication......3 $'
    MSG4 DB 10,13, 'Divider(Remainder)..4 $'
    MSG5 DB 10,13, 'Divide(Quotient)....5 $'
    MSG6 DB 10,13, 'Exit................6 $'

    MSG7 DB 10,13, 'Enter First Number : $'
    MSG8 DB 10,13, 'Enter Second Number : $'
    MSG9 DB 10,13, 'Result : $'

.CODE

displaymsg proc

                   mov  ah,9
                   lea  dx, MSG1
                   int  21h


                   mov  ah,9
                   lea  dx, MSG2
                   int  21h

                   mov  ah,9
                   lea  dx, MSG3
                   int  21h

                   mov  ah,9
                   lea  dx, MSG4
                   int  21h

                   mov  ah,9
                   lea  dx, MSG5
                   int  21h

                   mov  ah,9
                   lea  dx, MSG6
                   int  21h

                   mov  ah,9
                   lea  dx, MSG7
                   int  21h

                   ret

displaymsg endp

getchar proc

                   mov  ah,1
                   int  21h
                   ret

getchar endp


    num2           db   ?
    num1           db   ?
    result         db   ?
    char           db   ?


putchar proc
                   mov  ah,2
                   mov  dl,al
                   int  21h
                   ret

                   mov  ah,9
                   lea  dx, MSG8
                   int  21h
putchar endp


displayresult proc
    ; Load the address of char into dx
                   mov  dx, offset char
    ; Print the character
                   mov  ah, 9
                   int  21h
                   ret
displayresult endp


    ;Calculation
    ;Addition proc
Addition proc
    ; Perform addition
                   mov  al, num1
                   add  al, num2
                   mov  result, al
                   ret
Addition endp


    ;Subtraction proc
Subtraction proc

                   mov  ah,9
                   lea  dx, MSG2
                   int  21h

Subtraction endp


    ;Multiplication proc
Multiplication proc

                   mov  ah,9
                   lea  dx, MSG3
                   int  21h

Multiplication endp


    ;     ;Divider(Remainder) proc
    ; Divider(Remainder) proc

    ;                    mov  ah,9
    ;                    lea  dx, MSG4
    ;                    int  21h

    ; Remainder endp


    ;     ;Divide(Quotient) proc
    ; Quotient proc

    ;                    mov  ah,9
    ;                    lea  dx, MSG5
    ;                    int  21h

    ; Divide(Quotient) endp

    ;------------------------------------------------------------------------

main proc
                   mov  ax, @data
                   mov  ds, ax
                   call displaymsg
                   call getchar
                   mov  char, al
                   call putchar
                   call getchar
                   mov  num1, al
                   call putchar
                   call getchar
                   mov  num2, al
                   call putchar

                        

    ; Call Addition procedure
                   call Addition

    ; Display result
                   mov  ah, 9
                   lea  dx, MSG8
                   int  21h
                   mov  ah, 2
                   mov  dl, result
                   int  21h

                   mov  ah, 4ch
                   int  21h
main endp
    ;------------------------------------------------------------------------

end main


