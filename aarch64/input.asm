// ------------------------------- Description -------------------------------
//
// This subroutine reads user input from stdin and stores it in the input
// buffer provided by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// x1       address of buffer that user input will be read to
// x2       Size of the buffer that user input will be read to
//
// ----------------------------- Register Usage ------------------------------
//
// x0       Used to store the file descriptor
// x8       Used to store the syscall number
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
    mov     x0, 0	            // specify stdin file descriptor
    mov     x8, 63	            // specify stdin syscall
    svc     0		            // execute syscall
    ret
