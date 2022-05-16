.386
DATA SEGMENT USE16
MESS    DB  0DH, 0AH, "input some text plesae:$"
OUTMESS DB  0DH, 0AH, 'the text after convert:'
BUFFER  DB  80
        DB  ?
        DB  80  DUP(0)
DATA ENDS

CODE SEGMENT USE16
START:  MOV AX, DATA
        MOV DS, AX

        LEA DX, MESS
        MOV AH, 9
        INT 21H

        LEA DX, BUFFER
        MOV AH, 10
        INT 21H

        MOV CX, BUFFER+1 //字符串的长度
        LEA BX, BUFFER+2

NEXT:   MOV AX DS:[BX]
        ADD AX, 17
        MOV DS:[BX], AX

        DEC CX
        JNE NEXT

        LEA DX, OUTMESS    // 输出
        MOV AH, 9
        INT 21H

        LEA DX, BUFFER+2    // 输出
        MOV AH, 9
        INT 21H

        MOV AH, 4CH
        INT 21H
CODE ENDS
    END START