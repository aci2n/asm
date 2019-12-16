section .data
    BoyMsg: db "Boy Sminem",10
    BoyLen: equ $-BoyMsg
    
section .text
    
global _start

_start:
    nop
    
    ; stuff goes between the two nops
    mov ax,067FEh
    mov bx,ax
    mov cl,bh
    mov ch,bl
    xchg cl,ch
    
    mov ax,[BoyMsg] ; move the first two characters of the message into ax (ah: msg[1], al: msg[0])
    mov [BoyMsg],byte 'G' 
    mov bx,[BoyMsg]
    
    nop
    
section .bss
