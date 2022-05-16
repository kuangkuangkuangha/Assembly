.386
DATA SEGMENT USE16
N    DW  23
DDO  DW  0  
DATA ENDS

CODE SEGMENT USE16
ASSUME DS: DATA, CS: CODE

START:  MOV AX, DATA
        MOV DS, AX

        MOV AL, 1
        MOV CX, N
        MOV DX, 0

NEXT:   IMUL 2
        SUB AX, 1
    
        ADD DX, AX
        
        INC AL

        DEC CX
        JNE NEXT

        MOV DDO, DX
        
CODE ENDS
        END START