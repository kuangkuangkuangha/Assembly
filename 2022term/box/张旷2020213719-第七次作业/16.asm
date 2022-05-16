; 冒泡排序, 这道题参考了同学的，自己敲了一遍
.386
data segment use16
    buf1 db 30h, 10h, 40h, 20h, 50h, 70h, 60h, 90h, 80h, 0, 0ffh
    n1 = $ - buf1
    buf2 db 22h, 11h, 33h, 55h, 44h, 77h, 66h, 99h, 88h, 0aah, 0eeh, 0
    n2 = $ - buf2
    bufa db 150 dup(0)
    endl db 0dh, 0ah, '$'
data ends

stack segment use16 stack
    db 200 dup(0)
stack ends

code segment use16
    assume cs:code, ds:data, ss:stack
start:
    mov ax, data
    mov ds, ax

    lea bx, buf1
    mov cx, n1
    call sort
    mov bx, 0
    xor eax, eax

l1: lea si, bufa
    mov al, buf1[bx]
    call radix
    inc bx
    loop l1

    push ax
    push dx
    lea dx, endl
    mov ah, 9
    int 21h
    pop dx
    pop ax

    lea bx, buf2
    mov cx, n2
    call sort
    mov bx, 0
    xor eax, eax

l2: lea si, bufa
    mov al, buf2[bx]
    call radix
    inc bx
    loop l2

    mov ah, 4ch
    int 21h


sort proc
    push ax     
    push cx
    push dx
    
s0: xor si, si

s1: inc si          
    cmp si, cx
    jae s3
    dec si
    mov al, byte ptr [bx + si]
    mov dl, byte ptr [bx + si + 1]
    cmp al, dl
    jbe s2
    mov byte ptr [bx + si], dl
    mov byte ptr [bx + si + 1], al

s2: inc si
    jmp s1

s3: loop s0

    pop dx
    pop cx
    pop ax

    ret

sort endp


padix proc          ;eax 待转换数字  
    push eax       ;bufa 存答案的  si 相应的指针
    push ebx
    push ecx         
    push edx 
    mov ebx, 10h     ;ebx 基数
    xor cx, cx

    mov byte ptr [si], ' '
    add si, 1

lop1:xor edx, edx
    div ebx
    push dx
    inc cx
    or eax, eax
    jnz lop1

lop2:pop ax
    cmp al, 10
    jb l3
    add al, 7

l3: add al, 30h
    mov [si], al
    inc si
    loop lop2

    mov byte ptr [si], '$'
    lea dx, bufa
    mov ah, 9
    int 21h

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret 
radix endp

    
code ends
	end start
