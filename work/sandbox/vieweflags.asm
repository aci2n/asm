section .data
section .text
    
global _start

_start:
    nop
    
    ; stuff goes between the two nops
    mov eax,0xFFFFFFFF
    mov ebx,0x2D
    dec ebx
    inc eax
    
    nop
    
section .bss
