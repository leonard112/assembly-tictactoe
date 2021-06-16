global input

input:
    ;prologue
    push ebp            
    mov ebp, esp        

    mov eax, 3
	mov ebx, 0              ; specify stdout file descriptor
    ; get fuction arguments
	mov ecx, [ebp+8]        ; buffer
	mov edx, [ebp+12]       ; buffer size
	int 0x80

    ;epologue
    mov esp, ebp        
    pop ebp             
    ret 