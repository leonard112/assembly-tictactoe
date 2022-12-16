// Parameters: (None)

.global random

random:
    push {lr}

    // get sys_time as seed for random number generation
    // result of syscall gets stored in r0
    mov r0, #0
    mov r7, #13
    swi 0

    mov r1, #3
    udiv r2, r0, r1     // divide result of syscall stored in r0 by 3 and store the result in r2
    mul r2, r2, r1      // multiply the quotiant from by 3 and store the result in r2
    sub r2, r0, r2      // subtract the product from the result of the syscall

    mov r0, r2          // move remainder into r0
    pop {lr}
    bx lr
