global print

print:
    push ebp            
    mov ebp, esp        

    mov eax, 4                                  ; specify stdout syscall
    mov ebx, 1                                  ; specify stdout file descriptor
    mov ecx, [ebp+8]                            ; get buffer from stack
    mov edx, [ebp+12]                           ; get buffer size from stack
    int 0x80                                    ; execute syscall

    mov esp, ebp        
    pop ebp             
    ret 