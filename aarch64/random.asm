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
// x0       Used to get syscall return value
// x1       Used for deriving random number between 0 and 3 from seed
// x2       Used for deriving random number between 0 and 3 from seed
// x8       Used to store the syscall number
//
// --------------------------- Memory Manipulation ---------------------------
//
// None
//
// ------------------------------ Return Values ------------------------------
//
// x0       A random number between 0 and 3
//
// ---------------------------------------------------------------------------


.global random

random:
    // get sys_times/compat_sys_times as seed for random number generation
    // result of syscall gets stored in x0
    mov     x0, 0
    mov     x8, 153
    svc     0

    // divide result of syscall stored in x0 by 3 and store the result in x2
    // multiply the quotiant from by 3 and store the result in x2
    // subtract the product from the result of the syscall
    mov     x1, 3
    udiv    x2, x0, x1      
    mul     x2, x2, x1          
    sub     x2, x0, x2 

    mov     x0, x2              // move remainder into x0
    ret
