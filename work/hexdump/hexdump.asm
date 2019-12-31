section .bss
    BUFFLEN equ 16
    Buff: resb BUFFLEN
    
section .data
    HexStr: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
    HEXLEN equ $-HexStr
    
    Digits: db "0123456789ABCDEF"

section .text

global _start

_start:
    nop
    
Read:
    mov eax,3 ; sys_read syscall
    mov ebx,0 ; stdin
    mov ecx,Buff
    mov edx,BUFFLEN
    int 80h
    
    ; eof?
    cmp eax,0
    je End
    
    ; save number of bytes read this time
    mov ebp,eax
    
    ; reset counter (goes from 0 to what's held in ebp)
    xor ecx,ecx
    
Scan:
    ; clear eax (we are going to move to al so we need everything else in 0)
    xor eax,eax
    
    ; read current position in buffer to al
    mov al,byte [Buff+ecx]
    ; clone to ebx, we are gonna get the second nybble from there
    mov ebx,eax
    
    ; keep only first nybbles in al and bl
    and al,0Fh
    shr bl,4
    
    ; multiply by 3: edx ends up being 3*ecx
    mov edx,ecx
    shl edx,1
    add edx,ecx
    
    ; edx has the offset into HexStr: edx+1 for the higher nybble and edx+2 for the lower one
    ; we can use ax and bx to keep the digits (since we can't move from memory to memory)
    mov al,byte [Digits+eax]
    mov [HexStr+edx+2],al
    
    mov bl,byte [Digits+ebx]
    mov [HexStr+edx+1],bl
    
    ; increment the counter, and if it's still less than ebp we keep scanning
    inc ecx
    cmp ecx,ebp
    ; book uses jna but that would overflow afaik (would go from 0 to 16 instead of 15)
    jb Scan
    
    ; if we're done scanning the buffer, write it to stdout and try to get the next chunk from the file
    mov eax,4 ; sys_write
    mov ebx,1 ; stdout
    mov ecx,HexStr
    add edx,3
    int 80h
    
    jmp Read
    
End:
    mov eax,1 ; exit syscall
    mov ebx,0 ; return code
    int 80h
    
    nop
