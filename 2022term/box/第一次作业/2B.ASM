.386
DATA SEGMENT USE16

BUF DW 25 DUP(0)
DDO DW 0
AA  DW 10

DATA ENDS

CODE SEGMENT USE16
ASSUME DS: DATA, CS: CODE

START: MOV AX, DATA
       MOV DS, AX

       MOV BX, 0
       MOV AX, 0

NEXT:  ADD AX, [BX*2 + AA]
       INC BX
       CMP BX, 5
       JNE NEXT

       MOV AX, DDO

       MOV AH, 4CH
       INT 21H

CODE ENDS
       END START
