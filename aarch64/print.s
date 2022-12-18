// ------------------------------- Description -------------------------------
//
// Print the contents of a buffer to stdout.
//
// ------------------------------- Parameters --------------------------------
//
// x1       Address of buffer containing message to be printed
// x2       Size of buffer to be printed
//
// ----------------------------- Register Usage ------------------------------
//
// x0       Used to store the file descriptor
// x8       Used to store the syscall number
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


.global print

print:
    mov     x0, 1	            // specify stdout file descriptor
    mov     x8, 64	            // specify stdout syscall
    svc     0		            // execute syscall
    ret
