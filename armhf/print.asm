// Parameters:
// r1 (Address of buffer containing message to be printed)
// r2 (size of buffer containing message to be printed)

.global print

print:
    push {lr}
    mov r0, #1	        // specify stdout file descriptor
    mov r7, #4	        // specify stdout syscall
    swi 0		        // execute syscall
    pop {lr}
    bx lr
