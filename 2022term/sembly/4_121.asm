.386
DATA SEGMENT USE16
BUF DB 80   :/第一个字节
    DB ?    :/第二个字节
    DB 80 DUP(0)  :/分配80个单元

REAL DW 0   :/ 存储转换后的真值（10进制）

RES DB 10 DUP(0)  :/ 存放最后输出的结果

DATA ENDS

CODE SEGMENT USE16
ASSUME DS: DATA, CS: CODE, SS: STACK


:/ AL 存每个位然后乘10的次方到ax， bx字符串‘123’的索引， cx字符串的个数， 每个字符乘10的个数
START:   MOV AX, DATA
         MOV DS, AX

         LEA DX, BUF+2       :/输入字符串 "123"
         MOV AH, 10
         INT 21H

         MOV CX, BUF+1;
         MOV BX, BUF+2;

L1:      MOV AX, [BX];
         SUB AX, 30H;       :/ 得到“1”的真值1
         
         MOV DL, CX            :/ 1*10的（cx-1）次方
         SUB DL, 1

L2       IMUL AX, 10
         DEC DL
         JNE L2               

         ADD REAL, AX          :/ 把数加到总和当中
         OR AX, AX

         DEC CX
         JNE L1

:/ 至此已经得到了字符串的真值, 现在开始将它转化为16进制
:/ 可以尝试复用书上的代码
        XOR CX, CX
        MOV SI, RES 

        MOV EAX,DWORD PTR REAL
        MOV EBX, 16

LOP1:   XOR EDX, EDX
        DIV EBX
        PUSH DX
        INC CX
        OR EAX, EAX
        JNE LOP1

LOP2:   POP AX
        CMP AL, 10
        JB  L3
        ADD AL, 7

L3:     ADD  AL, 30H
        MOV  [SI], AL
        INC SI
        LOOP LOP2

:/在末尾添‘$’, 然后显示
        MOV, [SI], '$'

        LEA DX, RES
        MOV AH, 9
        INT 21H

CODE ENDS
    END START