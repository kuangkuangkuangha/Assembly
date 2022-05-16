.386
data segment use16
buf dw 1000 dup(?)
count  equ  $-buf
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

; cx-计数，si,di-指针
code segment use16
assume ds: data, cs: code, ss: stack
Start:  mov ax, data
        mov es, ax

        mov si  buf
        lea di, buf
        mov cx, count

    

Next:   lodsw
        cmp ax, 0
        je  A

        stosw

A:      loop Next
        mov  ax, 4ch
        int  21h


code segment ends
        end Start