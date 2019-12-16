section .data
section .text
    
global _start

_start:
    nop
    
    ; stuff goes between the two nops
    mov al,01h
    mov ah,0h
    mov bl,0h
    div bl
    nop
    
section .bss
