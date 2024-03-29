; ------------------------------- Description --------------------------------
;
; Fill a cell on the board based on input provided by the caller.
;
; -------------------------------- Parameters --------------------------------
;
; ebp+8     Address of input buffer
; ebp+12    Address of current player symbol
; ebp+16    Address of first row
; ebp+20    Address of second row
; ebp+24    Address of third row
;
; ------------------------------ Register Usage ------------------------------
;
; eax       Used for input buffer address
; ebx       Used to store player symbol
; ecx       Used for row addresses
;
; --------------------------- Memory Manipulation ----------------------------
;
; One of the cells in the tictactoe board will be changed if the subroutine
; is successful.
;
; ------------------------------ Return Values -------------------------------
;
; edx-dl    Boolean indicator of whether subroutine was successful
;
; ----------------------------------------------------------------------------


global fill_space
extern print

section .data
    bad_row_col_message db `\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n`
    bad_row_col_message_length equ $-bad_row_col_message

section .text
fill_space:
    push    ebp            
    mov     ebp, esp

    mov     eax, [ebp+8]                    ; input buffer
    mov     ebx, [ebp+12]
    mov     ebx, [ebx]                      ; player symbol

    cmp     byte [eax+1], byte " "          ; ensure row and column are delimited with space
    jne     bad_row_col 

    cmp     byte [eax+3], byte `\n`         ; ensure input is only 4 bytes long.
    jne     bad_row_col

    cmp     byte [eax], byte "1"            ; did the player specify row '1'?
    je      set_row_1
    cmp     byte [eax], byte "2"            ; did the player specify row '2'?
    je      set_row_2
    cmp     byte [eax], byte "3"            ; did the player specify row '3'?
    je      set_row_3
    jmp     bad_row_col

set_row_1:
    mov     ecx, [ebp+16]
    jmp     fill_column

set_row_2:
    mov     ecx, [ebp+20]
    jmp     fill_column

set_row_3:
    mov     ecx, [ebp+24]
    jmp     fill_column

fill_column:
    cmp     byte [eax+2], byte "1"          ; did the player specify column '1'?
    je      set_col_1
    cmp     byte [eax+2], byte "2"          ; did the player specify column '2'?
    je      set_col_2
    cmp     byte [eax+2], byte "3"          ; did the player specify column '3'?
    je      set_col_3
    jmp     bad_row_col

set_col_1:
    cmp     byte [ecx], byte " "            ; return if column already contains a value
    jne     bad_row_col
    mov     [ecx], bl
    jmp     return_sucess

set_col_2:
    cmp     byte [ecx+1], byte " "          ; return if column already contains a value
    jne     bad_row_col
    mov     [ecx+1], bl
    jmp     return_sucess

set_col_3:
    cmp     byte [ecx+2], byte " "          ; return if column already contains a value
    jne     bad_row_col
    mov     [ecx+2], bl
    jmp     return_sucess

bad_row_col:
    push    bad_row_col_message_length
    push    bad_row_col_message
    call    print
    pop     eax
    pop     eax
    jmp     return_error

return_error:
    mov     dl, 1                           ; set error return code
    jmp     return

return_sucess:
    mov     dl, 0                           ; set success return code
    jmp     return

return:
    mov     esp, ebp        
    pop     ebp             
    ret 
