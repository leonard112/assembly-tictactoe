// ------------------------------- Description -------------------------------
//
// This subroutine reads user input from stdin and stores it in the input
// buffer provided by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// r1       address of buffer that user input will be read to
// r2       Size of the buffer that user input will be read to
//
// ----------------------------- Register Usage ------------------------------
//
// r0       Used to store the file descriptor
// r7       Used to store the syscall number
//
// --------------------------- Memory Manipulation ---------------------------
//
// The input buffer should be the only memory that is manipulated by this 
// subroutine.
//
// ------------------------------ Return Values ------------------------------
//
// None
//
// ---------------------------------------------------------------------------


.global input

input:
    push    {lr}
    mov     r0, #0	            // specify stdin file descriptor
    mov     r7, #3	            // specify stdin syscall
    swi     0		            // execute syscall
    pop     {lr}
    bx      lr
