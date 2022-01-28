global input

input:
    push rbp            
    mov rbp, rsp        

    mov rax, 0              ; specify stdin syscall
    mov rdi, 0              ; specify stdin file descriptor
    mov rsi, [rbp+16]        ; get buffer from stack
    mov rdx, [rbp+24]       ; get buffer size from stack
    syscall                 ; execute syscall

    mov rsp, rbp        
    pop rbp             
    ret 