// Parameters:
// x1 (address of buffer where user input will be read to)
// x2 (size of the buffer where user input will be read to)

.global input

input:
    mov x0, #0	        // specify stdin file descriptor
    mov x8, #63	        // specify stdin syscall
    svc 0		        // execute syscall
    ret
