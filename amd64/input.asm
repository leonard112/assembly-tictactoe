; ------------------------------- Description --------------------------------
;
; This subroutine reads user input from stdin and stores it in the input
; buffer provided by the caller.
;
; ------------------------------- Parameters ---------------------------------
;
; rbp+16    Address of buffer that user input will be read to
; rbp+24    Size of the buffer that user input will be read to
;
; ------------------------------ Register Usage ------------------------------
;
; rax       Used to store the syscall number
; rdx       Used to store size of buffer
; rsi       Used to store address of input buffer
; rdi       Used to store the file descriptor
;
; --------------------------- Memory Manipulation ----------------------------
;
; The input buffer should be the only memory that is manipulated by this 
; subroutine.
;
; ------------------------------ Return Values -------------------------------
;
; None
;
; ----------------------------------------------------------------------------


global input

input:
    push    rbp            
    mov     rbp, rsp        

    mov     rax, 0                          ; specify stdin syscall
    mov     rdi, 0                          ; specify stdin file descriptor
    mov     rsi, [rbp+16]                   ; get buffer from stack
    mov     rdx, [rbp+24]                   ; get buffer size from stack
    syscall                                 ; execute syscall

    mov     rsp, rbp        
    pop     rbp             
    ret 
    