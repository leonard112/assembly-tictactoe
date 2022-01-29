// Parameters
// x0 (Return value of the program)

.global exit

exit:
    mov x8, #93	        // specify exit syscall
    svc 0
