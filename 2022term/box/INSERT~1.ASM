;P125 例4.9
.386
data segment use16
buf db  '111111111', 0DH, 0AH
    db  '222222', 0DH, 0AH
    db  '333333333', 0DH, 0AH
    db  '4444444444', 0DH, 0AH
    db  '5555555', 0DH, 0AH, '$', 1AH
    db  2048-($-buf) dup(0)

tt  db  0DH, 0AH, '****************************', 0DH, 0AH, '$'
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

code segment use16
assume ds: data, cs: code, ss: stack


; register distribute
; si-遍历， cx-记录行数， bx-行尾指针，

Start:  mov ax, data
        mov ds, ax

        lea si, buf
        mov cx, 0

Rows:   cmp byte ptr[si], 1AH
        je move

        cmp byte ptr[si], 0AH
        jne ro1
        inc cx

ro1:    inc si
        jmp rows

Move:   mov bx, 2047
        sub cx, 2

m1:     cmp byte ptr[si], 0AH    ; 这里要分两步写吗
        jne m2

        dec cx      
        je insert   ; cx=cx-1; cx=0转insert

m2:     mov al, [si]
        mov [bx], al         

        dec bx
        dec si
        jmp m1

Insert: mov ah, 1
        int 21h

        cmp al, 1AH   ; 如果是control+Z, 直接退出
        je Exit

        inc si
        mov byte ptr[si], al

        cmp al, 0DH   ; 如果是0DH（回车），就在尾部加入0AH（貌似键盘上没有换行键）
        je i1

        jmp Insert      

i1:     inc si
        mov byte ptr[si], 0AH
        

UP:     inc si
        inc bx
        
        mov al, [bx]
        mov [si], al

        cmp al, 1AH
        je  Output

        jmp UP

Output: lea dx, tt
        mov ah, 9
        int 21h

        lea dx, buf
        mov ah, 9
        int 21h

        jmp Exit


Exit:   mov ah, 4ch
        int 21h

code ends
        end Start
