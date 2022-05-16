.386

DATA SEGMENT USE16
W DW 20
X DW 30
Y DW 12
BB DW 10
Z DW 2
DATA ENDS

CODE SEGMENT USE16
     ASSUME CS: CODE, DS: DATA

START: MOV AX, DATA
       MOV DS, AX

       MOV AX, W
       SUB AX, X
       CWD
       IDIV BB
       IMUL AX, Y
       IMUL AX, AX

       MOV AH, 4CH
       INT 21H

CODE ENDS
       END START
