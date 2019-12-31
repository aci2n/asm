section .data
section .text
    
global _start

_start:
    nop
    
    ; stuff goes between the two nops
    mov al,01h
    shl al,1
    nop
    
section .bss
