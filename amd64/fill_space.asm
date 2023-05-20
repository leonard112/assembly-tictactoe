; ------------------------------- Description --------------------------------
;
; Fill a cell on the board based on input provided by the caller.
;
; -------------------------------- Parameters --------------------------------
;
; rbp+16    Address of input buffer
; rbp+24    Address of current player symbol
; rbp+32    Address of first row
; rbp+40    Address of second row
; rbp+48    Address of third row
;
; ------------------------------ Register Usage ------------------------------
;
; rax       Used for input buffer address
; rbx       Used to store player symbol
; rcx       Used for row addresses
;
; --------------------------- Memory Manipulation ----------------------------
;
; One of the cells in the tictactoe board will be changed if the subroutine
; is successful.
;
; ------------------------------ Return Values -------------------------------
;
; rdx-dl    Boolean indicator of whether subroutine was successful
;
; ----------------------------------------------------------------------------


global fill_space
extern print

section .data
    bad_row_col_message db `\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n`
    bad_row_col_message_length equ $-bad_row_col_message

section .text
fill_space:
    push    rbp            
    mov     rbp, rsp

    mov     rax, [rbp+16]                   ; input buffer
    mov     rbx, [rbp+24]
    mov     rbx, [rbx]                      ; player symbol
    
    cmp     byte [rax+1], byte " "          ; ensure row and column are delimited with space
    jne     bad_row_col 
    
    cmp     byte [rax+3], byte `\n`         ; ensure input is only 4 bytes long
    jne     bad_row_col
    
    cmp     byte [rax], byte "1"            ; did the player specify row '1'?
    je      set_row_1
    cmp     byte [rax], byte "2"            ; did the player specify row '2'?
    je      set_row_2
    cmp     byte [rax], byte "3"            ; did the player specify row '3'?
    je      set_row_3
    jmp     bad_row_col

set_row_1:
    mov     rcx, [rbp+32]
    jmp     fill_column
    
set_row_2:
    mov     rcx, [rbp+40]
    jmp     fill_column

set_row_3:
    mov     rcx, [rbp+48]
    jmp     fill_column
    
fill_column:
    cmp     byte [rax+2], byte "1"          ; did the player specify column '1'?
    je      set_col_1
    cmp     byte [rax+2], byte "2"          ; did the player specify column '2'?
    je      set_col_2
    cmp     byte [rax+2], byte "3"          ; did the player specify column '3'?
    je      set_col_3
    jmp     bad_row_col

set_col_1:
    cmp     byte [rcx], byte " "            ; return if column already contains a value
    jne     bad_row_col
    mov     [rcx], bl
    jmp     return_sucess

set_col_2:
    cmp     byte [rcx+1], byte " "          ; return if column already contains a value
    jne     bad_row_col
    mov     [rcx+1], bl
    jmp     return_sucess

set_col_3:
    cmp     byte [rcx+2], byte " "          ; return if column already contains a value
    jne     bad_row_col
    mov     [rcx+2], bl
    jmp     return_sucess

bad_row_col:
    push    bad_row_col_message_length
    push    bad_row_col_message
    call    print
    pop     rax
    pop     rax
    jmp     return_error

return_error:
    mov     dl, 1                           ; set error return code
    jmp     return

return_sucess:
    mov     dl, 0                           ; set success return code
    jmp     return

return:
    mov     rsp, rbp        
    pop     rbp             
    ret 
