; P109 T4.3 秋立方数

.386
data segment use16
crlf db  0AH, '$'
input db 'please enter a num: $', 0DH, 0AH
buf db '1  $','8  $','27 $','64 $','125$','216$','343$','512$','729$'
error db 'input not between 1 and 9 $'
count dw 4
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

; 寄存器分配
; si-寻址指针

code segment use16
assume ds: data, cs: code, ss: stack
Start:  mov ax, data
        mov ds, ax

        lea dx, input
        mov ah, 9
        int 21h

; 还要转换为真值
imput:  mov ah, 1
        int 21h

        cmp al, '9'
        ja  err

        cmp al, '1'
        jb  err


conver: sub al, '1'-1   ; 也可以直接AND 0FH 得到真值
        sub al, 1
        mov ah, 0

        imul count
        lea cx, buf 
        add cx, ax

output:
        lea dx, crlf
        mov ah, 9
        int 21h

        mov dx, cx
        mov ah, 9
        int 21h
        jmp Exit

err:    lea dx, error
        mov ah, 9
        int 21h

Exit:   mov  ah, 4ch
        int  21h

code ends
        end Start
