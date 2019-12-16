section .bss
    Buff resb 1

section .data
    
section .text
    global _start
    
_start:
    nop
    
read:
    mov eax,3
    mov ebx,0
    mov ecx,Buff
    mov edx,1
    int 80h
    
    cmp eax,0
    je exit
    cmp byte [Buff],61h
    jb write
    cmp byte [Buff],7Ah
    ja write
    
    sub byte [Buff],20h
    
write:
    mov eax,4
    mov ebx,1
    mov ecx,Buff
    mov edx,1
    int 80h
    jmp read
    
exit:
    mov eax,1
    mov ebx,0
    int 80h
