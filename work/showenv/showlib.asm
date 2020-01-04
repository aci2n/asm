section .bss

section .data

section .text

global WriteStdout, WriteStderr

; %1: output file
%macro Write 1 
    push eax
    push ebx
    mov eax,4
    mov ebx,%1
    int 80h
    pop ebx
    pop eax
%endmacro

; IN:
;  ecx: buffer address
;  edx: buffer length
WriteStdout:
    Write 1
    ret
    
; IN:
;  ecx: buffer address
;  edx: buffer length
WriteStderr:
    Write 2
    ret
