// ------------------------------- Description -------------------------------
//
// Print the contents of a buffer to stdout.
//
// ------------------------------- Parameters --------------------------------
//
// r1       Address of buffer containing message to be printed
// r2       Size of buffer to be printed
//
// ----------------------------- Register Usage ------------------------------
//
// r0       Used to store the file descriptor
// r7       Used to store the syscall number
//
// --------------------------- Memory Manipulation ---------------------------
//
// None
//
// ------------------------------ Return Values ------------------------------
//
// None
//
// ---------------------------------------------------------------------------


.global     print

print:
    push    {lr}
    mov     r0, #1	            // specify stdout file descriptor
    mov     r7, #4	            // specify stdout syscall
    swi     0		            // execute syscall
    pop     {lr}
    bx      lr
