; ------------------------------- Description --------------------------------
;
; This subroutine reads user input from stdin and stores it in the input
; buffer provided by the caller.
;
; ------------------------------- Parameters ---------------------------------
;
; ebp+8     Address of buffer that user input will be read to
; ebp+12    Size of the buffer that user input will be read to
;
; ------------------------------ Register Usage ------------------------------
;
; eax       Used to store the syscall number
; ebx       Used to store the file descriptor
; ecx       Used to store address of input buffer
; edx       Used to store size of buffer
; rdi       
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
    push    ebp            
    mov     ebp, esp        

    mov     eax, 3                          ; specify stdin syscall
    mov     ebx, 0                          ; specify stdin file descriptor
    mov     ecx, [ebp+8]                    ; get buffer from stack
    mov     edx, [ebp+12]                   ; get buffer size from stack
    int     0x80                            ; execute syscall

    mov     esp, ebp        
    pop     ebp             
    ret 