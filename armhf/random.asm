// ------------------------------- Description -------------------------------
//
// Generate a random number between 0 and 3.
//
// ------------------------------- Parameters --------------------------------
//
// None
//
// ----------------------------- Register Usage ------------------------------
//
// r0       Used to get syscall return value
// r1       Used for deriving random number between 0 and 3 from seed
// r2       Used for deriving random number between 0 and 3 from seed
// r7       Used to store the syscall number
//
// --------------------------- Memory Manipulation ---------------------------
//
// None
//
// ------------------------------ Return Values ------------------------------
//
// r0       A random number between 0 and 3
//
// ---------------------------------------------------------------------------


.global random

random:
    push    {lr}

    // get sys_time as seed for random number generation
    // result of syscall gets stored in r0
    mov     r0, #0
    mov     r7, #13
    swi     0

    // divide result of syscall stored in r0 by 3 and store the result in r2
    // multiply the quotiant from by 3 and store the result in r2
    // subtract the product from the result of the syscall
    mov     r1, #3
    udiv    r2, r0, r1
    mul     r2, r2, r1
    sub     r2, r0, r2

    mov     r0, r2              // move remainder into r0
    pop     {lr}
    bx      lr
