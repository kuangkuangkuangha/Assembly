; P141 T4.11
.386
data segment use16
bufB dd 20H
buf db 12 dup(0), '$' ;存放着最终输出到屏幕的字符串
data ends
stack segment use16 stack
db 200 dup(0)
stack ends

code segment use16
assume ds: data, cs: code, ss: stack
Start:  mov ax, data
        mov ds, ax

        mov eax, bufB
        mov dx, 32

        call F2T10

Exit:   mov  ah, 4ch
        int  21h




; -------------------------------------------------------------
; 将eax中的32位有符号二进制数 以10进制数形式显示(字符)输出子程序F2T10
; 入口参数
; ax/eax 里存放着待转换的数（真值）, dx中存放着是16位还是32位
; si-buf的指针
F2T10 proc 

        lea si, buf
        ; push, si

        cmp dx, 32
        je  change

        movsx eax, ax   ; 如果是16位的，就扩展到32位

change: or  eax, eax
        jns ra

        neg eax     ; 直接把待转换的数取绝对值，然后输出的buf中添一个‘-’号

        mov byte ptr [si], '-'
        inc si

        mov ebx, 10

ra:     call radix

        ; pop si

        lea dx, buf
        mov ah, 9
        int 21h

        ret

F2T10  endp
; ------------------------------------------------------------

; ------------------------------------------------------------
;eax is the data   待转换的数
;ebx is the format  16进制
;并最终转换为字符输出在屏幕上

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
; ------------------------------------------------------------

code ends
        end Start
