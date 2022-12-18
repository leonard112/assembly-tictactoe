; ------------------------------- Description --------------------------------
;
; Print the contents of a buffer to stdout.
;
; -------------------------------- Parameters --------------------------------
;
; rbp+16    Address of buffer containing message to be printed
; rbp+24    Size of buffer to be printed
;
; ------------------------------ Register Usage ------------------------------
;
; rax       Used to store the syscall number
; rdi       Used to store the file descriptor
; rdx       Used to store size of buffer
; rsi       Used to store address of buffer
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


global print

print:
    push    rbp            
    mov     rbp, rsp        

    mov     rax, 1                          ; specify stdout syscall
    mov     rdi, 1                          ; specify stdout file descriptor
    mov     rsi, [rbp+16]                   ; get buffer from stack
    mov     rdx, [rbp+24]                   ; get buffer size from stack
    syscall                                 ; execute syscall

    mov     rsp, rbp        
    pop     rbp             
    ret 
    