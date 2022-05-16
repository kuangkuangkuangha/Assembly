.386
DATA SEGMENT USE16
BUF DW 25 DUP(0)
DDO DW 0
DATA ENDS

CODE SEGMENT USE16
ASSUME DS: DATA, CS: CODE

START: MOV AX, DATA
       MOV DS, AX

       MOV CX, 0
       MOV AX, 0
       MOV ESI, 4
       
next:  MOV DX, CX
       IMUL DX, 10
       MOV BX, DX

       
       ADD AX, [BUF + BX + ESI*2]
       INC CX

       CMP CX, 5
       JNE next



       MOV DDO, AX

       MOV AH, 4CH
       INT 21H

CODE ENDS
       END START
