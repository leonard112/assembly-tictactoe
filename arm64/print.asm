// Parameters:
// x1 (Address of buffer containing message to be printed)
// x2 (size of buffer containing message to be printed)

.global print

print:
    mov x0, #1	// specify stdout file descriptor
    mov x8, #64	// specify stdout syscall
    svc 0		// execute syscall
    ret
