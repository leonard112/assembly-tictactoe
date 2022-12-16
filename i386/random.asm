global random

random:
    push ebp            
    mov ebp, esp 

    ; get sys_time as seed for random number generation
    ; result of syscall gets stored in eax
    mov eax, 13
    mov ebx, 0
    int 0x80

    ; generate random number between 0 and 2
    mov ebx, 3
    div ebx                                     ; divide eax by 3
    mov eax, edx                                ; move remainder into eax

    mov esp, ebp        
    pop ebp             
    ret 