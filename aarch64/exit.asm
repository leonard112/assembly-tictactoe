// ------------------------------- Description -------------------------------
//
// Terminate the program with an exit status code specified by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// x0       Exit status code of the program
//
// ----------------------------- Register Usage ------------------------------
//
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


.global exit

exit:
    mov     x8, 93	            // specify exit syscall
    svc     0
