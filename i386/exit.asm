; ------------------------------- Description --------------------------------
;
; Terminate the program with an exit status code specified by the caller.
;
; -------------------------------- Parameters --------------------------------
;
; esp+4    	Exit status code of the program
;
; ------------------------------ Register Usage ------------------------------
;
; eax		Used to store the syscall number
; ebx		Used to specify exit status code of the program
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
    mov     eax, 1                          ; specify exit syscall
    mov     ebx, [esp+4]                    ; read return code from stack
    int     0x80