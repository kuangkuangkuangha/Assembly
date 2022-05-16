.386
data segment use16
buf db '11111', 0DH, 0AH
    db '22222', 0DH, 0AH
    db '333', 0DH, 0AH
    db '4444', 0DH, 0AH
    db '55555', 0DH, 0AH
    db '666666', 0DH, 0AH, '$', '0H'
data ends

code segment use16
assume ds: data, cs: code
;si存BUF索引 cx存遇到的回车换行数量 di用来记住滴五行开始的内容 dx存第六行开始的地址
;当si到了第六行的内容时开始将第六行上的字母挪到第五行的位置上直到碰到了0H结束符号

start:  mov ax, data
        mov ds, ax

        mov si, offset buf
        mov cx, 0

Next:   cmp byte ptr[si], 0H
        je copy

        cmp byte ptr[si], 0AH
        jne l1
        inc cx

l1:     cmp cx, 4
        jne l2
        add si, 1
        mov di, si  ;寄存器si里的值（是个地址）+2后存到di， [si]+2才是里面的内容加2

l2:     cmp cx, 5
        jne l3
        add si, 1
        mov dx, si

l3:     inc si
        jmp Next

;记住了第五行和第六行的值，现在开始复制（删除）
        mov si, dx
copy:   cmp byte ptr[si], 0DH
        je last

        mov al, [si]
        mov [di], al
        inc si
        inc di

        jmp copy

last:   mov byte ptr [di], 0DH
        mov byte ptr [di+1], 0AH
        mov byte ptr [di+2], '$'
        mov byte ptr [di+3], 0H

output: lea dx, buf
        mov ah, 9
        int 21h

        mov ah, 4ch
        int 21h

code ends
    end start
