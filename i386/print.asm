; ------------------------------- Description --------------------------------
;
; Print the contents of a buffer to stdout.
;
; -------------------------------- Parameters --------------------------------
;
; ebp+8     Address of buffer containing message to be printed
; ebp+12    Size of buffer to be printed
;
; ------------------------------ Register Usage ------------------------------
;
; eax       Used to store the syscall number
; ebx       Used to store the file descriptor
; ecx       Used to store address of buffer
; edx       Used to store size of buffer
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
    push    ebp            
    mov     ebp, esp        

    mov     eax, 4                          ; specify stdout syscall
    mov     ebx, 1                          ; specify stdout file descriptor
    mov     ecx, [ebp+8]                    ; get buffer from stack
    mov     edx, [ebp+12]                   ; get buffer size from stack
    int     0x80                            ; execute syscall

    mov     esp, ebp        
    pop     ebp             
    ret
     