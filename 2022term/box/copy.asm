.386
DATA SEGMENT USE16
    BUFA DB 15 DUP(0)
    BUFFER  DB 80
            DB ?
            DB 80 DUP(0)
    BEAUTY  DB 0DH, 0AH, '$'
DATA ENDS

STACK SEGMENT USE16 
    DB 200 DUP(0)
STACK ENDS

CODE SEGMENT USE16
    ASSUME CS:CODE, DS:DATA, SS:STACK
START:
    MOV AX, DATA
    MOV DS, AX

    LEA DX, BUFFER      ;输入
    MOV AH, 10
    INT 21H

    LEA DX, BEAUTY      ;换行好看
    MOV AH, 9
    INT 21H

    XOR EAX, EAX  
    XOR EBX, EBX
    XOR CX, CX
    MOV CL, BUFFER + 1   ;字符串大小
    LEA SI, BUFFER + 2      ; 字符串首址

L:  IMUL EAX, 10
    MOV BL, [SI]
    SUB BL, '0' - 0
    ADD EAX, EBX
    INC SI
    LOOP L

    MOV EBX, 16
    LEA SI, BUFA
    CALL PADIX

    MOV AH, 4CH
    INT 21H

PADIX PROC          ;EAX 待转换数字  
    PUSH CX         ;EBX 基数
    PUSH EDX        ;BUFA 存答案的  SI 相应的指针
    XOR CX, CX

LOP1:XOR EDX, EDX
    DIV EBX
    PUSH DX
    INC CX
    OR EAX, EAX
    JNZ LOP1

LOP2:POP AX
    CMP AL, 10
    JB L1
    ADD AL, 7

L1: ADD AL, 30H
    MOV [SI], AL
    INC SI
    LOOP LOP2

    MOV BYTE PTR [SI], 'H'
    MOV BYTE PTR [SI + 1], 0DH
    MOV BYTE PTR [SI + 2], 0AH
    MOV BYTE PTR [SI + 3], '$'
    LEA DX, BUFA
    MOV AH, 9
    INT 21H

    POP EDX
    POP CX
    RET 
PADIX ENDP

CODE ENDS
	END START