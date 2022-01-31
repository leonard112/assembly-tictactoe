// Parameters:
// r0 (Return value of the program)

.global exit

exit:
    mov r7, #1	        // specify exit syscall
    swi 0
