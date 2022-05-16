.386
data segment use16
buf DB 80   ;第一个字节
    DB ?    ;第二个字节
    DB 80 DUP(0)  ;分配80个单元

real DW 0   ; 存储转换后的真值（10进制）
res DB 10 DUP(0)  ; 存放最后输出的结果
data ends

stack segment use16 stack
      DB 200 DUP(0)
stack ENDS

code segment use16
assume ds: data, cs: code, ss: stack


start:  mov ax, data
        mov ds, ax

        lea dx, buf     ;输入字符串 "123"
        mov ah, 10
        int 21H

        mov cl, buf+1         ; 字符串的长度
        lea bx, buf         ; 字符串的起始地址
        add bx, 2

; 使用的方法不是ppt上的（Ax）*10+X，还是比较平常的每一位乘以该位的权值然后算出总和real
; "123" = 1*100 + 2*10 +3
; 开始转化为真值
L1:     mov ax, [bx]
        sub ax, 30H       ; 得到“1”的真值1
         
        mov dx, cx            ; 1*10的（cx-1）次方
        sub dx, 1

L2:     imul ax, 10
        dec dx
        jne L2
                       
        add real, ax          ; 把数加到总和当中
        xor ax, ax
        xor dx, dx

        inc bl

        dec cl
        jne L1


; 至此已经得到了字符串的真值, 现在开始将它转化为16进制
; 可以尝试复用书上的代码
        xor cx, cx
        lea si, res 

        lea eax, DWORD PTR real
        mov ebx, 16

lop1:   xor edx, edx
        div ebx
        push dx
        inc cx
        or eax, eax
        jne lop1

lop2:   pop ax
        cmp al, 10
        jb  l3
        add al, 7

l3:     add  al, 30H
        mov [si], al
        inc si
        loop lop2

;在末尾添‘$’, 然后显示
        mov byte PTR [si], '$'

        lea dx, res
        mov ah, 9
        int 21H

        mov ah, 4CH
        int 21H

code ends
    end start