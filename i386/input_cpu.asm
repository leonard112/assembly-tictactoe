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
; ebp+8     Address of user input buffer
; ebp+12    Address of first row
; ebp+16    Address of second row
; ebp+20    Address of third row
;
; ------------------------------ Register Usage ------------------------------
;
; eax-al    Used to store the addresses of the win key buffers
;           Used for getting random numbers 0-3 from the random subroutine
; ebx-bl    Used for row addresses
;           Used to store address of 'col_diag_tmp' buffer
;           Used to store 4-byte values stored row and 'col_diag_tmp' buffers
;           Used to store 1-byte values stored in row buffers
; ecx       Used for user input buffer address
; edx       Used to store 4-byte values stored in win key buffers
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
    push    ebp            
    mov     ebp, esp

    mov     ecx, [ebp+8]                    ; input buffer
    mov     byte [ecx+3], byte `\n`         ; set new line as input terminator

find_row_win:
    lea     eax, [o_win_keys]
    jmp     find_stop_row_1_win

find_col_win:
    jmp     find_stop_col_1_win

find_backward_diag_win:
    jmp     find_stop_backward_diag_win

stop_row_win:
    lea     eax, [x_win_keys]
    jmp     find_stop_row_1_win

stop_col_win:
    jmp     find_stop_col_1_win

stop_backward_diag_win:
    jmp     find_stop_backward_diag_win

find_stop_row_1_win:
    mov     ebx, [ebp+12]                   ; row 1
    mov     byte [ecx], byte "1"
    jmp     find_stop_row_win

find_stop_row_2_win:
    mov     ebx, [ebp+16]                   ; row 2
    mov     byte [ecx], byte "2"
    jmp     find_stop_row_win

find_stop_row_3_win:
    mov     ebx, [ebp+20]                   ; row 3
    mov     byte [ecx], byte "3"

find_stop_row_win:
    mov     ebx, dword [ebx]

    ; is row ' OO ' or ' XX '?
    mov     edx, dword [eax]
    mov     byte [ecx+2], byte "1"
    cmp     ebx, edx
    je      return

    ; is row 'O O ' or 'X X '?
    mov     edx, dword [eax+4]
    mov     byte [ecx+2], byte "2"
    cmp     ebx, edx
    je      return

    ; is row 'OO  ' or 'XX  '?
    mov     edx, dword [eax+8]
    mov     byte [ecx+2], byte "3"
    cmp     ebx, edx
    je      return

    cmp     byte [ecx], byte "1"
    je      find_stop_row_2_win
    cmp     byte [ecx], byte "2"
    je      find_stop_row_3_win

    cmp     dword [eax], dword " OO "
    je      find_col_win
    jmp     stop_col_win

find_stop_col_1_win:
    mov     byte [ecx+2], byte "1"

    ; build column 1
    mov     ebx, [ebp+12]                   ; row 1
    mov     bl, [ebx]
    mov     byte [col_diag_tmp], bl

    mov     ebx, [ebp+16]                   ; row 2
    mov     bl, [ebx]
    mov     byte [col_diag_tmp+1], bl

    mov     ebx, [ebp+20]                   ; row 3
    mov     bl, [ebx]
    mov     byte [col_diag_tmp+2], bl
    jmp     find_stop_col_win

find_stop_col_2_win:
    mov     byte [ecx+2], byte "2"

    ; build column 2
    mov     ebx, [ebp+12]                   ; row 1
    mov     bl, [ebx+1]
    mov     byte [col_diag_tmp], bl

    mov     ebx, [ebp+16]                   ; row 2
    mov     bl, [ebx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     ebx, [ebp+20]                   ; row 3
    mov     bl, [ebx+1]
    mov     byte [col_diag_tmp+2], bl

    jmp     find_stop_col_win
find_stop_col_3_win:
    mov     byte [ecx+2], byte "3"

    ; build column 3
    mov     ebx, [ebp+12]                   ; row 1
    mov     bl, [ebx+2]
    mov     byte [col_diag_tmp], bl

    mov     ebx, [ebp+16]                   ; row 2
    mov     bl, [ebx+2]
    mov     byte [col_diag_tmp+1], bl

    mov     ebx, [ebp+20]                   ; row 3
    mov     bl, [ebx+2]
    mov     byte [col_diag_tmp+2], bl

find_stop_col_win:
    lea     ebx, [col_diag_tmp]
    mov     ebx, dword [ebx]

    ; is column ' OO ' or ' XX '?
    mov     edx, dword [eax]
    mov     byte [ecx], byte "1"
    cmp     ebx, edx
    je      return

    ; is column 'O O ' or 'X X '?
    mov     edx, dword [eax+4]
    mov     byte [ecx], byte "2"
    cmp     ebx, edx
    je      return

    ; is column 'OO  ' or 'XX  '?
    mov     edx, dword [eax+8]
    mov     byte [ecx], byte "3"
    cmp     ebx, edx
    je      return

    cmp     byte [ecx+2], byte "1"
    je      find_stop_col_2_win
    cmp     byte [ecx+2], byte "2"
    je      find_stop_col_3_win

    cmp     dword [eax], dword " OO "
    je      find_backward_diag_win
    jmp     stop_backward_diag_win

find_stop_backward_diag_win:
    ; build backward diagonal
    mov     ebx, [ebp+12]                   ; row 1
    mov     bl, [ebx]
    mov     byte [col_diag_tmp], bl

    mov     ebx, [ebp+16]                   ; row 2
    mov     bl, [ebx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     ebx, [ebp+20]                   ; row 3
    mov     bl, [ebx+2]
    mov     byte [col_diag_tmp+2], bl

    lea     ebx, [col_diag_tmp]
    mov     ebx, dword [ebx]

    ; is backward diagonal 'OO  ' or 'XX  '?
    mov     edx, dword [eax]
    mov     byte [ecx], byte "1"
    mov     byte [ecx+2], byte "1"
    cmp     ebx, edx
    je      return

    ; is backward diagonal 'O O ' or 'X X '?
    mov     edx, dword [eax+4]
    mov     byte [ecx], byte "2"
    mov     byte [ecx+2], byte "2"
    cmp     ebx, edx
    je      return

    ; is backward diagonal 'OO  ' or 'XX  '?
    mov     edx, dword [eax+8]
    mov     byte [ecx], byte "3"
    mov     byte [ecx+2], byte "3"
    cmp     ebx, edx
    je      return

find_stop_forward_diag_win:
    ; build forward diagonal
    mov     ebx, [ebp+12]                   ; row 1
    mov     bl, [ebx+2]
    mov     byte [col_diag_tmp], bl

    mov     ebx, [ebp+16]                   ; row 2
    mov     bl, [ebx+1]
    mov     byte [col_diag_tmp+1], bl

    mov     ebx, [ebp+20]                   ; row 3
    mov     bl, [ebx]
    mov     byte [col_diag_tmp+2], bl

    lea     ebx, [col_diag_tmp]
    mov     ebx, dword [ebx]

    ; is forward diagonal ' OO ' or ' XX '?
    mov     edx, dword [eax]
    mov     byte [ecx], byte "1"
    mov     byte [ecx+2], byte "3"
    cmp     ebx, edx
    je      return

    ; is forward diagonal 'O O ' or ' XX '?
    mov     edx, dword [eax+4]
    mov     byte [ecx], byte "2"
    mov     byte [ecx+2], byte "2"
    cmp     ebx, edx
    je      return

    ; is forward diagonal 'OO  ' or 'XX  '?
    mov     edx, dword [eax+8]
    mov     byte [ecx], byte "3"
    mov     byte [ecx+2], byte "1"
    cmp     ebx, edx
    je      return

    cmp     dword [eax], dword " OO "
    je      stop_row_win

take_middle_space:
    mov     ebx, [ebp+16]                   ; row 2
    cmp     byte [ebx+1], byte " "
    jne     take_random_space
    
    ; randomize this move to create unpredictability
    call    random
    cmp     eax, 0
    jne     take_random_space
    mov     ecx, [ebp+8]                    ; input buffer
    mov     dword [ecx], dword `2 2\n`
    jmp     return

take_random_space:
    call    random
    mov     ecx, [ebp+8]                    ; input buffer
    cmp     eax, 0
    je      take_random_row_1
    cmp     eax, 1
    je      take_random_row_2
    cmp     eax, 2
    je      take_random_row_3

take_random_row_1:
    mov     byte [ecx], byte "1"
    jmp     take_random_row_space

take_random_row_2:
    mov     byte [ecx], byte "2"
    jmp     take_random_row_space

take_random_row_3:
    mov     byte [ecx], byte "3"

take_random_row_space:
    call    random
    mov     ecx, [ebp+8]                    ; input buffer
    mov     ebx, [ebp+12]                   ; row 1
    cmp     byte [ecx], byte "1"
    je      take_column
    mov     ebx, [ebp+16]                   ; row 2
    cmp     byte [ecx], byte "2"
    je      take_column
    mov     ebx, [ebp+20]                   ; row 3

take_column:
    add     ebx, eax
    cmp     byte [ebx], byte " "
    jne     take_random_space
    add     eax, 49                         ; convert number to ascii
    mov     byte [ecx+2], al                ; store ascii column

return:
    mov     esp, ebp        
    pop     ebp             
    ret 