section .bss
    BUFFLEN equ 1024
    Buff resb BUFFLEN

section .data
    
section .text
    global _start
    
_start:
    nop
    
Read:
    mov eax,3
    mov ebx,0
    mov ecx,Buff
    mov edx,BUFFLEN
    int 80h
    ; the book does mov esi,eax here for some reason, gonna keep it but i'm not seeing the point rn
    mov esi,eax
    
    cmp eax,0 ; eax has the amount of read bytes
    je Exit
    
    mov ecx,esi
    mov ebp,Buff ; we're going to be running through the buffer, gotta save the address in a reg
    dec ebp ; prevent off-by-one when adding the # of bytes read
Scan:
    cmp byte [ebp+ecx],61h
    jb Next
    
    cmp byte [ebp+ecx],7Ah
    ja Next
    
    sub byte [ebp+ecx],20h
Next:
    dec ecx
    jnz Scan
Write:
    mov eax,4
    mov ebx,1
    mov ecx,Buff
    mov edx,BUFFLEN
    int 80h
    
    jmp Read
Exit:
    mov eax,1
    mov ebx,0
    int 80h
