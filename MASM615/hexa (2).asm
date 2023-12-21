.DATA
k      DWORD ?
n      DWORD ?
x      DWORD ?
y      DWORD ?
z      DWORD ?
yes    BYTE "Yes", 0
no     BYTE "No", 0
maybe  BYTE "Maybe", 0

.CODE

; 1. if (k < n)
    cmp k, n
    jl PrintYes1
    jge PrintNo1

PrintYes1:
    ; Code to print "Yes"
    mov dx, OFFSET yes
    call PrintString
    jmp End1

PrintNo1:
    ; Code to print "No"
    mov dx, OFFSET no
    call PrintString

End1:

; 2. if (k < n)
    cmp k, n
    jl PrintMaybe
    jge Else2

PrintMaybe:
    ; Code to print "Maybe"
    mov dx, OFFSET maybe
    call PrintString
    jmp End2

Else2:
    cmp k, n
    jg PrintNo2
    jle PrintYes2

PrintNo2:
    ; Code to print "No"
    mov dx, OFFSET no
    call PrintString
    jmp End2

PrintYes2:
    ; Code to print "Yes"
    mov dx, OFFSET yes
    call PrintString

End2:

; 3. if ((x < y) AND (y < z))
    cmp x, y
    jge Else3
    cmp y, z
    jge Else3

    ; Code to print "Yes"
    mov dx, OFFSET yes
    call PrintString
    jmp End3

Else3:
    ; Code to print "Yes"
    mov dx, OFFSET yes
    call PrintString

End3:

; 4. if ((x < y) OR (x >= z))
    cmp x, y
    jl PrintNo3
    cmp x, z
    jge PrintNo3
    jmp Else4

PrintNo3:
    ; Code to print "No"
    mov dx, OFFSET no
    call PrintString
    jmp End4

Else4:
    ; Code to print "Maybe"
    mov dx, OFFSET maybe
    call PrintString

End4:

; PrintString Procedure (example)
PrintString PROC
    ; Your implementation to print a string using dx as the address
    ret
PrintString ENDP

END
