section .data
    EditBuff: db 'abcdefghijklm        '
    ENDPOS equ 12
    INSERTPOS equ 5
    
section .text
    
global _start

_start:
    nop
    
    ; stuff goes between the two nops
    mov ebx,EditBuff+INSERTPOS
    
    std
    mov esi,EditBuff+ENDPOS
    mov edi,EditBuff+ENDPOS+1
    mov ecx,ENDPOS-INSERTPOS+1
    rep movsb
    
    mov byte[ebx],'X'
    
    nop
    
section .bss
