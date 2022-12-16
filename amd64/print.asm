global print

print:
    push rbp            
    mov rbp, rsp        

    mov rax, 1                                  ; specify stdout syscall
    mov rdi, 1                                  ; specify stdout file descriptor
    mov rsi, [rbp+16]                           ; get buffer from stack
    mov rdx, [rbp+24]                           ; get buffer size from stack
    syscall                                     ; execute syscall

    mov rsp, rbp        
    pop rbp             
    ret 