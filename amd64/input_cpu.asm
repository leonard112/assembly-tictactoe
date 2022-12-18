; ------------------------------- Description --------------------------------
;
; This subroutine is the brains of the computer player that the user plays 
; against. The computer player will specify a row and column in the input 
; buffer that it determines to be strategic to winning or at least preventing 
; the player from winning. If the computer player cannot find a move that
; it considers to be stategic, a random empty cell will be chosen.
;
; ------------------------------- Parameters ---------------------------------
;
; rbp+16    Address of user input buffer
; rbp+24    Address of first row
; rbp+32    Address of second row
; rbp+40    Address of third row
;
; ------------------------------ Register Usage ------------------------------
;
; rax-al    Used to store the addresses of the win key buffers
;           Used for getting random numbers 0-3 from the random subroutine
; rbx-ebx-bl
;           Used for row addresses
;           Used to store address of 'col_diag_tmp' buffer
;           Used to store 4-byte values stored row and 'col_diag_tmp' buffers
;           Used to store 1-byte values stored in row buffers
; rcx       Used for user input buffer address
; rdx-edx   Used to store 4-byte values stored in win key buffers
;
; --------------------------- Memory Manipulation ----------------------------
;
; The input buffer and the local 'col_diag_tmp' buffer should be the only 
; memory that is manipulated by this subroutine.
;
; ------------------------------ Return Values -------------------------------
;
; None
;
; ----------------------------------------------------------------------------


global input_cpu
extern random

section .data
    col_diag_tmp    db "    "
    o_win_keys      db " OO O O OO  "
    x_win_keys      db " XX X X XX  "

section .text
input_cpu:
    push    rbp            
    mov     rbp, rsp

    mov     rcx, [rbp+16]                   ; input buffer
    mov     byte [rcx+3], byte `\n`         ; set new line as input terminator

find_row_win:
    lea     rax, [o_win_keys]
    jmp     find_stop_row_1_win

find_col_win:
    jmp     find_stop_col_1_win

find_backward_diag_win:
    jmp     find_stop_backward_diag_win

stop_row_win:
    lea     rax, [x_win_keys]
    jmp     find_stop_row_1_win

stop_col_win:
    jmp     find_stop_col_1_win

stop_backward_diag_win:
    jmp     find_stop_backward_diag_win

find_stop_row_1_win:
    mov     rbx, [rbp+24]                   ; row 1
    mov     byte [rcx], byte "1"
    jmp     find_stop_row_win

find_stop_row_2_win:
    mov     rbx, [rbp+32]                   ; row 2
    mov     byte [rcx], byte "2"
    jmp     find_stop_row_win

find_stop_row_3_win:
    mov     rbx, [rbp+40]                   ; row 3
    mov     byte [rcx], byte "3"

find_stop_row_win:
    mov     ebx, dword [rbx]

    ; is row ' OO ' or ' XX '?
    mov     edx, dword [rax]
    mov     byte [rcx+2], byte "1"
    cmp     ebx, edx
    je      return

    ; is row 'O O ' or 'X X '?
    mov     edx, dword [rax+4]
    mov     byte [rcx+2], byte "2"
    cmp     ebx, edx
    je      return

    ; is row 'OO  ' or 'XX  '?
    mov     edx, dword [rax+8]
    mov     byte [rcx+2], byte "3"
    cmp     ebx, edx
    je      return

    cmp     byte [rcx], byte "1"
    je      find_stop_row_2_win
    cmp     byte [rcx], byte "2"
    je      find_stop_row_3_win

    cmp     dword [rax], dword " OO "
    je      find_col_win
    jmp     stop_col_win

find_stop_col_1_win:
    mov     byte [rcx+2], byte "1"

    ; build column 1
    mov     rbx, [rbp+24]                   ; row 1
    mov     bl, [rbx]
    mov     byte [col_diag_tmp], bl

    mov     rbx, [rbp+32]                   ; row 2
    mov     bl, [rbx]
    mov     byte [col_diag_tmp+1], bl

    mov     rbx, [rbp+40]                   ; row 3
    mov     bl, [rbx]
    mov     byte [col_diag_tmp+2], bl
    jmp     find_stop_col_win

find_stop_col_2_win:
    mov     byte [rcx+2], byte "2"

    ; build column 2
    mov     rbx, [rbp+24]                   ; row 1
    mov     bl, [rbx+1]
    mov     byte [col_diag_tmp], bl

    mov     rbx, [rbp+32]                   ; row 2
    mov     bl, [rbx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     rbx, [rbp+40]                   ; row 3
    mov     bl, [rbx+1]
    mov     byte [col_diag_tmp+2], bl
    jmp     find_stop_col_win

find_stop_col_3_win:
    mov     byte [rcx+2], byte "3"

    ; build column 3
    mov     rbx, [rbp+24]                   ; row 1
    mov     bl, [rbx+2]
    mov     byte [col_diag_tmp], bl

    mov     rbx, [rbp+32]                   ; row 2
    mov     bl, [rbx+2]
    mov     byte [col_diag_tmp+1], bl

    mov     rbx, [rbp+40]                   ; row 3
    mov     bl, [rbx+2]
    mov     byte [col_diag_tmp+2], bl

find_stop_col_win:
    lea     rbx, [col_diag_tmp]
    mov     ebx, dword [rbx]

    ; is column ' OO ' or ' XX '?
    mov     edx, dword [rax]
    mov     byte [rcx], byte "1"
    cmp     ebx, edx
    je      return

    ; is column 'O O ' or 'X X '?
    mov     edx, dword [rax+4]
    mov     byte [rcx], byte "2"
    cmp     ebx, edx
    je      return

    ; is column 'OO  ' or 'XX  '?
    mov     edx, dword [rax+8]
    mov     byte [rcx], byte "3"
    cmp     ebx, edx
    je      return

    cmp     byte [rcx+2], byte "1"
    je      find_stop_col_2_win
    cmp     byte [rcx+2], byte "2"
    je      find_stop_col_3_win

    cmp     dword [rax], dword " OO "
    je      find_backward_diag_win
    jmp     stop_backward_diag_win

find_stop_backward_diag_win:
    ; build  backward diagonal
    mov     rbx, [rbp+24]                   ; row 1
    mov     bl, [rbx]
    mov     byte [col_diag_tmp], bl

    mov     rbx, [rbp+32]                   ; row 2
    mov     bl, [rbx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     rbx, [rbp+40]                   ; row 3
    mov     bl, [rbx+2]
    mov     byte [col_diag_tmp+2], bl

    lea     rbx, [col_diag_tmp]
    mov     ebx, dword [rbx]

    ; is backward diagonal ' OO ' or ' XX '?
    mov     edx, dword [rax]
    mov     byte [rcx], byte "1"
    mov     byte [rcx+2], byte "1"
    cmp     ebx, edx
    je      return

    ; is backward diagonal 'O O ' or 'X X '?
    mov     edx, dword [rax+4]
    mov     byte [rcx], byte "2"
    mov     byte [rcx+2], byte "2"
    cmp     ebx, edx
    je      return

     ; is backward diagonal 'OO  ' or 'XX  '?
    mov     edx, dword [rax+8]
    mov     byte [rcx], byte "3"
    mov     byte [rcx+2], byte "3"
    cmp     ebx, edx
    je      return

find_stop_forward_diag_win:
    ; build forward diagonal
    mov     rbx, [rbp+24]                   ; row 1
    mov     bl, [rbx+2]
    mov     byte [col_diag_tmp], bl

    mov     rbx, [rbp+32]                   ; row 2
    mov     bl, [rbx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     rbx, [rbp+40]                   ; row 3
    mov     bl, [rbx]
    mov     byte [col_diag_tmp+2], bl

    lea     rbx, [col_diag_tmp]
    mov     ebx, dword [rbx]

    ; is forward diagonal ' OO ' or ' XX '?
    mov     edx, dword [rax]
    mov     byte [rcx], byte "1"
    mov     byte [rcx+2], byte "3"
    cmp     ebx, edx
    je      return

    ; is forward diagonal 'O O ' or 'X X '?
    mov     edx, dword [rax+4]
    mov     byte [rcx], byte "2"
    mov     byte [rcx+2], byte "2"
    cmp     ebx, edx
    je      return

    ; is forward diagonal 'OO  ' or 'XX  '?
    mov     edx, dword [rax+8]
    mov     byte [rcx], byte "3"
    mov     byte [rcx+2], byte "1"
    cmp     ebx, edx
    je      return
    
    cmp     dword [rax], dword " OO "
    je      stop_row_win

take_middle_space:
    mov     rbx, [rbp+32]                   ; row 2
    cmp     byte [rbx+1], byte " "
    jne     take_random_space
    
    ; randomize this move to create unpredictability
    call    random
    cmp     rax, 0
    jne     take_random_space
    mov     rcx, [rbp+16]                   ; input buffer
    mov     dword [rcx], dword `2 2\n`
    jmp     return

take_random_space:
    call    random
    mov     rcx, [rbp+16]                   ; input buffer
    cmp     rax, 0
    je      take_random_row_1
    cmp     rax, 1
    je      take_random_row_2
    cmp     rax, 2
    je      take_random_row_3

take_random_row_1:
    mov     byte [rcx], byte "1"
    jmp     take_random_row_space

take_random_row_2:
    mov     byte [rcx], byte "2"
    jmp     take_random_row_space

take_random_row_3:
    mov     byte [rcx], byte "3"

take_random_row_space:
    call    random
    mov     rcx, [rbp+16]                   ; input buffer
    mov     rbx, [rbp+24]                   ; row 1
    cmp     byte [rcx], byte "1"
    je      take_column
    mov     rbx, [rbp+32]                   ; row 2
    cmp     byte [rcx], byte "2"
    je      take_column
    mov     rbx, [rbp+40]                   ; row 3

take_column:
    add     rbx, rax
    cmp     byte [rbx], byte " "
    jne     take_random_space
    add     rax, 49                         ; convert number to ascii
    mov     byte [rcx+2], al                ; store ascii column

return:
    mov     rsp, rbp        
    pop     rbp             
    ret 