global input

input:
    push ebp            
    mov ebp, esp        

    mov eax, 3              ; specify stdin syscall
	mov ebx, 0              ; specify stdin file descriptor
	mov ecx, [ebp+8]        ; get buffer from stack
	mov edx, [ebp+12]       ; get buffer size from stack
	int 0x80                ; execute syscall

    mov esp, ebp        
    pop ebp             
    ret 