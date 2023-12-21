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

    MSG7 DB 10,13, 'Enter your choice: $'

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


    char          db   ?


putchar proc
                  mov  ah,2
                  mov  dl,al
                  int  21h
                  ret
putchar endp


displayresult proc
    ; Load the address of char into dx
                  mov  dx, offset char
    ; Print the character
                  mov  ah, 9
                  int  21h
                  ret
displayresult endp

    ;------------------------------------------------------------------------

main proc
                  mov  ax, @data
                  mov  ds, ax
                  call displaymsg
                  call getchar
    ; call putchar

                  mov  ah, 4ch
                  int  21h
main endp
    ;------------------------------------------------------------------------

end main



