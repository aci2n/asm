section .bss

section .data
    ErrMsg: db "Something went wrong :(",10
    ERRLEN equ $-ErrMsg
    EOL: db 10

section .text

global _start
extern WriteStdout, WriteStderr

_start:
    nop
    
    ; save address of first env var in ebp
    mov ebp,esp
    
    ; ebx is going to hold the doubleword-size offset from the top of the stack
    ; the offset to the first env var is
    ;  - dword[ebp]: the arg count held at the top of the stack 
    ;  - 2: the arg count itself and the null pointer between the args and the env vars
    mov ebx,dword[ebp]
    add ebx,2
    
    ; prepare for repne scasb (only needed once)
    cld
    xor eax,eax ; we are going to look for a null in the env var strings
.Next:
    mov esi,dword[ebp+ebx*4] ; keep the address to the env var in esi
    cmp esi,0 ; check if we found the null pointer
    je .End ; finish if we found the null pointer
    
    mov edi,esi ; copy the address to edi (setup for scasb)
    mov ecx,0FFFFh ; set a cap on how many chars we are going to check with repne
    repne scasb ; increase edi and decrease ecx until ecx is 0 or [edi] equals eax (0)
    jnz .Error ; if we found a 0 in the string, ZF should have been set to 1
    
    sub edi,esi ; calculate the env var string length
    sub edi,1 ; ignore the 0 at the end of the string (we are gonna print an EOL later)
    
    ; write string and EOL
    mov ecx,esi
    mov edx,edi
    call WriteStdout
    mov ecx,EOL
    mov edx,1
    call WriteStdout
    
    ; increase the offset into the stack
    inc ebx
    jmp .Next

.Error:
    mov ecx,ErrMsg
    mov edx,ERRLEN
    call WriteStderr
    
.End:
    mov eax,1
    mov ebx,0
    int 80h
    
    nop
