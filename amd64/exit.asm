global exit

exit:
    mov rax, 60                                 ; specify exit syscall
    mov rdi, [rsp+8]                            ; read return code from stack
    syscall