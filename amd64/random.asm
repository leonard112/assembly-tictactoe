global random

random:
    push rbp            
    mov rbp, rsp 

    ; get sys_time as seed for random number generation
    ; result of syscall gets stored in rax
    mov rax, 201
    mov rdi, 0
    syscall

    ; generate random number between 0 and 2
    mov rbx, 3
    div rbx                                     ; divide rax by 3
    mov rax, rdx                                ; move remainder into rax

    mov rsp, rbp        
    pop rbp             
    ret 