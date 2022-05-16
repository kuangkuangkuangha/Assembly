.386
data segment use16
buf0 db 'the ascii code of $'
buf1 db ' is $'
crlf db 0dh, 0ah, '$'
data ends

stack segment use16 stack
db 200 dup(0)
stack ends

code segment use16
assume cs: code, ds: data, ss: stack

begin: 	mov ax, data
		mov ds, ax

loop1:	mov ax, 0
	 	lea dx, buf0
		mov ah, 9
		int 21h
		mov ah, 1
		int 21h
		cmp al, 0dh
		je exit
		lea dx, buf1
		mov ah, 9
		int 21h

		mov bl, al
		mov bh, al
		shr bl, 4
		and bl, 0fh
		jmp 1

l1:		mov dl, bl
		mov ah, 2
		int 21h
		and bh, 0fh
		jmp change2

l2:		mov dl, bh
		mov ah, 2
		int 21h
		mov dl, 'h'
		mov ah, 2
		int 21h
		lea dx, crlf
		mov ah, 9
		int 21h
		jmp loop1

change1:cmp bl, 9
		ja loop2
		add bl, 30h
		jmp l1
loop2: 	add bl, 37h
		jmp l1

change2:cmp bh, 9
		ja loop3
		add bh, 30h
		jmp l2
loop3: 	add bh, 37h
		jmp l2
	
return: mov ah, 4ch
		int 21h
code ends
	end begin