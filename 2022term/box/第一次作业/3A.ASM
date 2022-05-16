.386
data segment use16
buf db '96541833209881'

data ends

code segment use16
assume ds: data, cs: code

start:  mov ax, data
        mov ds, ax

        mov bx, 0

next:   mov al, [bx + buf]

        cmp al, '$'
        jmp retu

        add al, 16
        mov [bx + buf], al

        inc bx
        jmp next

retu:   mov ah, 4ch
        int 21h

code ends
        end start
