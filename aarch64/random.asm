// Parameters: (None)

.global random

random:
    // get sys_times/compat_sys_times as seed for random number generation
    // result of syscall gets stored in x0
    mov x0, #0
    mov x8, #153
    svc 0

    mov x1, #3
    udiv x2, x0, x1     // divide result of syscall stored in x0 by 3 and store the result in x2
    mul x2, x2, x1      // multiply the quotiant from by 3 and store the result in x2
    sub x2, x0, x2      // subtract the product from the result of the syscall

    mov x0, x2          // move remainder into x0
    ret
