// ------------------------------- Description -------------------------------
//
// Terminate the program with an exit status code specified by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// r0       Exit status code of the program
//
// ----------------------------- Register Usage ------------------------------
//
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

.global exit

exit:
    mov     r7, #1	            // specify exit syscall
    swi     0
