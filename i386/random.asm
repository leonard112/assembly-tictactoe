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
; eax       Used to store the syscall number
;           Used to get syscall return value
; ebx       Used as argument for syscall
;           Used for deriving random number between 0 and 3 from seed
; edx       Used for deriving random number between 0 and 3 from seed    
;
; --------------------------- Memory Manipulation ----------------------------
;
; None
;
; ------------------------------ Return Values -------------------------------
;
; eax       A random number between 0 and 3
;
; ----------------------------------------------------------------------------


global random

random:
    push    ebp            
    mov     ebp, esp 

    ; get sys_time as seed for random number generation
    ; result of syscall gets stored in eax
    mov     eax, 13
    mov     ebx, 0                          ; clear ebx
    int     0x80

    ; generate random number between 0 and 2
    mov     edx, 0                          ; clear edx
    mov     ebx, 3
    div     ebx                             ; divide eax by 3
    mov     eax, edx                        ; move remainder into eax

    mov     esp, ebp        
    pop     ebp             
    ret 