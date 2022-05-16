.386
data segment use16
buf db 'JJBDAHCFFGA'

data ends

code segment use16
assume ds: data, cs: code

start:  mov ax, data
        mov ds, ax

        mov bx, 0

next:   mov ah, [buf + bx]
        cmp ah, '$'
        je retu

        sub ah, 16
        mov [buf + bx], ah
        inc bx

retu:   mov ah, 4ch
        int 21h

code ends
       end start 

