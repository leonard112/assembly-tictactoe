; ------------------------------- Description --------------------------------
;
; Display the tictactoe board to the console.
;
; -------------------------------- Parameters --------------------------------
;
; ebp+8     Address of top row
; ebp+12    Address of middle row
; ebp+16    Address of bottom row
;
; ------------------------------ Register Usage ------------------------------
;
; eax       Used to supply the address of a buffer to 'print' subroutine
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


global show_board
extern print

section .data
    column_separator    db "|"
    new_line            db `\n`

section .text
show_board:
    push    ebp            
    mov     ebp, esp   

    ; show top row
    mov     eax, [ebp+8]
    push    eax
    call    display_row
    pop     eax

    ; show midde row
    mov     eax, [ebp+12]
    push    eax
    call    display_row
    pop     eax

    ; show bottom row
    mov     eax, [ebp+16]
    push    eax
    call    display_row
    pop     eax

    mov     esp, ebp        
    pop     ebp             
    ret 

display_row:
    push    ebp            
    mov     ebp, esp

    push    byte 1

    push    column_separator
    call    print
    pop     edx

    ; show column 1
    mov     eax, [ebp+8]
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    ; show column 2
    mov     eax, [ebp+8]
    add     eax, 1
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    ; show column 3
    mov     eax, [ebp+8]
    add     eax, 2
    push    eax
    call    print
    pop     edx

    push    column_separator
    call    print
    pop     edx

    push    new_line
    call    print
    pop     edx
    pop     edx

    mov     esp, ebp        
    pop     ebp             
    ret