.386

DATA SEGMENT USE16
BUF DW 20 DUP(0)
DOO DB d
DATA ENDS

CDOE SEGMENT USE16
ASSUME DS:DATA, CS CODE
START:
        MOV AX, DATA
        MOV DS, AX
        MOV CX, 0
        MOV AX, BUF

NEXT:   ADD AX, [5*CX+CX]



        MOV DOO, AX

        MOV AH, 4CH
        INT 21H

CDOE ENDS
        END START


