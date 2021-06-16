global print

print:
    push ebp            
    mov ebp, esp        

    mov eax, 4              ; stdout syscall
	mov ebx, 1              ; file descriptor
	mov ecx, [ebp+8]        ; buffer
	mov edx, [ebp+12]       ; buffer size
	int 0x80


    mov esp, ebp        
    pop ebp             
    ret 