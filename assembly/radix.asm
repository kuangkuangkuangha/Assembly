;start
; 将二进制数转换成其他制定进制的书，并转换成易于显示的ASCII码形式
; P135例4.10
.386
data segment use16
num dd 123
scale dd 16
buf db 10 dup(0)

data ends

stack segment use16 stack
db 200 dup(0)
stack ends

code segment use16
assume ds: data, cs: code, ss: stack
start:  mov ax, data
        mov ds, ax

        mov eax, num
        mov ebx, scale
        lea si, buf

        call radix

        lea dx, buf
        mov ah, 9
        int 21h

        mov ah, 4ch
        int 21h


;eax is the data   待转换的数
;ebx is the format  16进制
radix proc
        push cx
        push edx

        xor cx, cx

lop1:   xor edx, edx
        
        div ebx

        push dx
        inc cx  ; remenber the times of remain

        or eax, eax
        jne lop1

lop2:   pop ax
        cmp al, 10

        jb tostr
        add al, 7

tostr:  add al, 30h
        mov [si], al
        inc si

        loop lop2

        mov byte ptr[si], '$'

        pop edx
        pop cx

        ret

radix endp


code ends
        end start

