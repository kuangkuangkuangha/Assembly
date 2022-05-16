.386
data segment use16
buf db 100 dup(0)
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

; cx-计数，si-指针
code segment use16
assume ds: data, cs: code, ss: stack
Start:  mov ax, data
        mov ds, ax

        lea si, buf
        mov cx, 100

s1:     mov byte ptr[si], 0
        inc si
        loop s1

Exit:   mov ah, 4ch
        int 21h

code ends
    end Start