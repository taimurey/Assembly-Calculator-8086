;Task 2
; Perform the above task 1 using procedures display, getchar, putchar
; (note: use AL and Ax for parameter passing)

.8086
.model small
.stack 100h
.data

    Message  db 10,13,"Enter a character : $"
    Message1 db 10,13,"The character entered is : $"

.code

display proc
            mov  ah,9
            lea  dx,Message
            int  21h
            ret
display endp

getchar proc
            mov  ah,1
            int  21h
            ret
getchar endp

putchar proc
            mov  ah,2
            mov  dl,al
            int  21h
            ret
putchar endp

main proc

            mov  ax,@data
            mov  ds,ax

            call display
            call getchar
            call putchar

            mov  ah,9
            lea  dx,Message1
            int  21h

            mov  ah,2
            mov  dl,al
            int  21h

            mov  ah,4ch
            int  21h

main endp
end main

