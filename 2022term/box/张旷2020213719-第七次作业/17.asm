; 比较找出3个字符串不同的地方

.386
data segment use16
buf dw 000H, 100H, 200H ;存放3个字符串的首地址
A dw 0
B dw 0
data ends

stack segment use16 stack
DB 200 dup(0)
stack ends

code segment use16
assume ds: data, cs: code, ss: stack

start:  mov ax, data
        mov ds, ax
        mov ax, buf

        cmp, buf+2
        jne L1

        mov ax, buf+4

        mov A, ax
        mov B, offset buf+4

        jmp exit

L1:     cmp ax, buf+4
        jne L2

        mov ax, buf+2

        mov ax, buf+2
        mov A, ax

        mov B, offset buf+2

        jmp exit

L2:     mov A, ax
        mov B, offset buf

exit:   mov ah, 4ch
        int 21h


code ends
    end start