; ------------------------------- Description --------------------------------
;
; Terminate the program with an exit status code specified by the caller.
;
; -------------------------------- Parameters --------------------------------
;
; rsp+8    	Exit status code of the program
;
; ------------------------------ Register Usage ------------------------------
;
; rax		Used to store the syscall number
; rdi		Used to specify exit status code of the program
;
; --------------------------- Memory Manipulation ----------------------------
;
; None
;
; ------------------------------ Return Values -------------------------------
;
; None
;
; ----------------------------------------------------------------------------


global exit

exit:
    mov     rax, 60                         ; specify exit syscall
    mov     rdi, [rsp+8]                    ; read return code from stack
    syscall