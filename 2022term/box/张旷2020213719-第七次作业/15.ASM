.386
data segment use16
N DW 4
sum DW 1
res DB '123$'
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

code segment use16
assume ds: code, cs: code, ss: stack

start: mov ax, data
       mov ds, ax

       mov ax, N
       call rc
       mov sum, ax

       lea si, res

       mov ax, dx

       mov cx, 100

       div cx
       add ah, 30h
       mov [si+2], ah

       mov ah, 0
       mov cx, 10
       div cx

       add ah, 30h
       add al, 30h
       mov [si], al
       mov [si+1], ah


       lea dx, res
       mov ah, 9
       int 21h

       mov ah, 4ch
       int 21h

rc proc near                                                  

begin:  cmp ax, 1
        je return

        push ax
        sub ax, 1
        call rc

return: pop  bx
        imul dx, bx
        ret

rc endp
        

code ends
        end start


