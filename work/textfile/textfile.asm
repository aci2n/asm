section .data
    HelpMsg:
        db "Usage: ./textfile [inputfile]",10
        db "After executing, enter the name of the output file.",10,0
    InputFileErrMsg:
        db "Could not find the input file: %s",10
        db "Please try again with a valid file.",10,0
    EnterAnOutputFilename:
        db "Please enter an output filename: ",0
    InvalidOutputFilename:
        db "Please enter a valid output filename (%d tries remaining): ",0
    OutputFileErrMsg:
        db "Cannot open output file %s.",10,0
    WriteErrorMsg:
        db "Something went wrong while writing to the output file :(",10,0
    HelpFile: db "help.txt",0
    ReadMode: db "r",0
    WriteMode: db "w",0
    NumberedLine: db "%d: %s",0

section .bss
    READBUFFERLEN equ 100
    ReadBuffer: resb READBUFFERLEN
    InputFile: resd 1
    OUTPUTFILENAMELEN equ 100
    OutputFilename: resb OUTPUTFILENAMELEN
    OutputFile: resd 1
    
section .text

global main
extern fopen
extern fgets
extern printf
extern stdin
extern stdout
extern PrintInt
extern RemoveTrailing
extern fprintf
extern fclose

main:
    push ebp
    mov ebp,esp
    push ebx
    push esi
    push edi
    call CheckArgs
    cmp eax,0
    je .done
    call RequestOutputFilename
    cmp eax,0
    je .done
    call InitInputFile
    cmp eax,0
    je .done
    call InitOuputFile
    cmp eax,0
    je .done
    call WriteNumberedLines
.done:
    pop edi
    pop esi
    pop ebx
    mov esp,ebp
    pop ebp
    ret
    
CheckArgs:
    mov eax,dword[ebp+8]
    cmp eax,2
    jne .showHelp
    mov eax,1
    ret
.showHelp:
    call ShowHelp
    mov eax,0
    ret
    
ShowHelp:
    push ReadMode
    push HelpFile
    call fopen
    add esp,8
    cmp eax,0
    je .fromMemory
    push eax
    push READBUFFERLEN
    push ReadBuffer
.readLine:
    call fgets
    cmp eax,0
    je .doneReading
    call printf
    jmp .readLine
.doneReading:
    add esp,12
    ret
.fromMemory:
    push HelpMsg
    call printf
    add esp,4
    ret
    
InitInputFile:
    mov ebx,[ebp+12]
    push ReadMode
    push dword[ebx+4]
    call fopen
    cmp eax,0
    je .readError
    add esp,8
    mov [InputFile],eax
    mov eax,1
    ret
.readError:
    push InputFileErrMsg
    call printf
    add esp,12
    mov eax,0
    ret
    
RequestOutputFilename:
    push EnterAnOutputFilename
    call printf
    add esp,4
    mov edi,3 ; max tries
    push dword[stdin]
    push OUTPUTFILENAMELEN
    push OutputFilename
.try:
    call fgets
    cmp eax,0
    je .error
    cmp byte[OutputFilename],10
    je .error
    mov edi,OutputFilename
    mov ecx,OUTPUTFILENAMELEN
    mov eax,10
    call RemoveTrailing
    jmp .done
.error:
    cmp edi,0
    jna .abort
    push edi
    push InvalidOutputFilename
    call printf
    add esp,8
    dec edi
    jmp .try
.abort:
    mov eax,0
.done:
    add esp,12
    ret

InitOuputFile:
    push WriteMode
    push OutputFilename
    call fopen
    add esp,8
    cmp eax,0
    je .error
    mov [OutputFile],eax
    mov eax,1
    ret
.error:
    push OutputFilename
    push OutputFileErrMsg
    call printf
    add esp,8
    mov eax,0
    ret

WriteNumberedLines:
    mov ebx,1
.line:
    push dword[InputFile]
    push READBUFFERLEN
    push ReadBuffer
    call fgets
    add esp,12
    cmp eax,0
    je .success
    push ReadBuffer
    push ebx
    push NumberedLine
    push dword[OutputFile]
    call fprintf
    add esp,16
    cmp eax,0
    je .error
    inc ebx
    jmp .line
.error:
    push WriteErrorMsg
    call printf
    add esp,4
    mov eax,0
    jmp .done
.success:
    mov eax,1
.done:
    push dword[InputFile]
    call fclose
    push dword[OutputFile]
    call fclose
    add esp,8
    ret
