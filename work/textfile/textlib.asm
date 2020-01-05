section .data
    IntStr: db "%d",10,0
    
section .bss

section .text

extern printf
global PrintInt
global RemoveTrailing

; usage:
; push {dword}
; call PrintInt
; add esp,4
PrintInt:
    push dword[esp+4]
    push IntStr
    call printf
    add esp,8
    ret

; usage:
; mov eax,{searchchar}
; mov edi,{stringaddr}
; mov ecx,{maxreps}
; call RemoveTrailing
RemoveTrailing:
    repne scasb
    mov byte[edi-1],0 ; scasb increases edi even in the last iteration when [edi] == eax 
    ret
