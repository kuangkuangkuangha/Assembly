OUT_STR  MACRO A
    mov dl, A
    mov ah, 2
    int 21h
ENDM

OUT_STR MACRO   A, B
        LOCAL   C
        mov cx, B

C:      OUT_STR A
        loop    C
        ENDM


.386
data segment use16
buf1 db "enter nums:", 0DH, 0AH, '$
error db    "error", 0DH, 0AH, '$'
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

;
code segment use16
assume ds: data, cs: code, ss: stack
Start:  mov ax, data
        mov ds, ax

l1:     lea dx, buf1
        mov ah, 9

        int 21h
        mov ah, 1
        int 21h

        cmp al, '1'
        jb  err
        cmp al, '9'
        ja  err
        sub al, 30h

        movzx ax, al
        OUT_STR '*', ax
        mov ah, 4ch
        int 21h

err:    lea dx, error
        mov ah, 9
        int 21h
        jmp l1

code ends
    end Start

