; ------------------------------- Description --------------------------------
;
; Generate a random number between 0 and 3.
;
; -------------------------------- Parameters --------------------------------
;
; None
;
; ------------------------------ Register Usage ------------------------------
;
; rax       Used to store the syscall number
;           Used to get syscall return value
; rbx       Used for deriving random number between 0 and 3 from seed
; rdx       Used for deriving random number between 0 and 3 from seed
; rdi       Used as argument for syscall
;
; --------------------------- Memory Manipulation ----------------------------
;
; None
;
; ------------------------------ Return Values -------------------------------
;
; rax       A random number between 0 and 3
;
; ----------------------------------------------------------------------------


global random

random:
    push    rbp            
    mov     rbp, rsp 

    ; get sys_time as seed for random number generation
    ; result of syscall gets stored in rax
    mov     rax, 201
    mov     rdi, 0                          ; tells sys_time to store result in rax
    syscall

    mov     rdx, 0                          ; clear rdx
    mov     rbx, 3
    div     rbx                             ; divide rax by 3
    mov     rax, rdx                        ; move remainder into rax

    mov     rsp, rbp        
    pop     rbp             
    ret 