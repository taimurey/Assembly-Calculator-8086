;Interactive program to input/output a char and displays it

.8086
.model small
.stack 100h
.data

    Message  db 10,13,"Enter a character : $"
    Message1 db 10,13,"The character entered is : $"
.code

main proc

         mov ax,@data
         mov ds,ax

         mov ah,9
         lea dx,Message
         int 21h

         mov ah,1
         int 21h

         mov ah,9
         lea dx,Message1
         int 21h

         mov ah,2
         mov dl,al
         int 21h

         mov ah,4ch
         int 21h

main endp
end main


