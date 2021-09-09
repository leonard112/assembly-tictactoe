// Parameters:
// r1 (address of buffer where user input will be read to)
// r2 (size of the buffer where user input will be read to)

.global input

input:
    push {lr}
    mov r0, #0	// specify stdin file descriptor
    mov r7, #3	// specify stdin syscall
    swi 0		// execute syscall
    pop {lr}
    bx lr
