.386
data segment use16
aa dw 1000h
data ends

code segment use16
assume ds: data, cs: code

start:  mov ax, data
        mov ds, ax

        mov ax, aa
        mov bh, 1
        div bh

        mov ah, 4ch
        int 21h

code ends
        end start
