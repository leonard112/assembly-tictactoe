global _start
extern show_board
extern fill_space
extern input
extern print
extern exit

section .bss
    stdin resb 70 
    stdin_length equ $-stdin

section .data
    welcome_message db `Welcome to x86 (i386) assembly language Tic Tac Toe!\n`
    welcome_message_length equ $-welcome_message
    x_prompt db "It's X's turn: "
    x_prompt_length equ $-x_prompt
    o_prompt db "It's O's turn: "
    o_prompt_length equ $-o_prompt
    x_win_message db `\nPlayer X is the winner!\n\n`
    x_win_message_length equ $-x_win_message
    o_win_message db `\nPlayer O is the winner!\n\n`
    o_win_message_length equ $-o_win_message
    tie_message db `\nTie!\n\n`
    tie_message_length equ $-tie_message
    player_symbol db "X"
    player_symbol_length equ 1
    row_1 db "    "
    row_2 db "    "
    row_3 db "    "
    col_diag_tmp db "    "

section .text
_start:
    push welcome_message_length
    push welcome_message
    call print
    pop eax
    pop eax
loop:
    push row_3
    push row_2
    push row_1
    call show_board
    pop eax
    pop eax
    pop eax

    cmp [player_symbol], byte "X"
    je push_x_prompt
    cmp [player_symbol], byte "O"
    je push_o_prompt

display_prompt:
    call print
    pop eax
    pop eax

    push stdin_length
    push stdin
    call input
    pop eax
    pop eax

    push row_3
    push row_2
    push row_1
    push player_symbol
    push stdin
    call fill_space
    pop eax
    pop eax
    pop eax
    pop eax
    pop eax
    ; if there was an error, make player enter input again.
    cmp dl, 0x00
    jne loop

change_turn:
    cmp [player_symbol], byte "X"
    je change_turn_to_o
    cmp [player_symbol], byte "O"
    je change_turn_to_x

push_x_prompt:
    push x_prompt_length
    push x_prompt
    jmp display_prompt

push_o_prompt:
    push o_prompt_length
    push o_prompt
    jmp display_prompt

change_turn_to_x:
    mov [player_symbol], byte "X"
    jmp check_winner

change_turn_to_o:
    mov [player_symbol], byte "O"
    jmp check_winner

check_winner:
    ; check rows for x win
    cmp dword [row_1], dword "XXX "
    je x_win
    cmp dword [row_2], dword "XXX "
    je x_win
    cmp dword [row_3], dword "XXX "
    je x_win

    ; check rows for y win
    cmp dword [row_1], dword "OOO "
    je o_win
    cmp dword [row_2], dword "OOO "
    je o_win
    cmp dword [row_3], dword "OOO "
    je o_win

    ; check first column for x or y win
    mov al, byte [row_1]
    mov [col_diag_tmp], al
    mov al, byte [row_2]
    mov [col_diag_tmp+1], al
    mov al, byte [row_3]
    mov [col_diag_tmp+2], al
    cmp dword [col_diag_tmp], dword "XXX "
    je x_win
    cmp dword [col_diag_tmp], dword "OOO "
    je o_win

    ; check second column for x or y win
    mov al, byte [row_1+1]
    mov [col_diag_tmp], al
    mov al, byte [row_2+1]
    mov [col_diag_tmp+1], al
    mov al, byte [row_3+1]
    mov [col_diag_tmp+2], al
    cmp dword [col_diag_tmp], dword "XXX "
    je x_win
    cmp dword [col_diag_tmp], dword "OOO "
    je o_win

    ; check third column for x or y win
    mov al, byte [row_1+2]
    mov [col_diag_tmp], al
    mov al, byte [row_2+2]
    mov [col_diag_tmp+1], al
    mov al, byte [row_3+2]
    mov [col_diag_tmp+2], al
    cmp dword [col_diag_tmp], dword "XXX "
    je x_win
    cmp dword [col_diag_tmp], dword "OOO "
    je o_win

    ; check top-left to bottom-right diagnal for x or y win
    mov al, byte [row_1]
    mov [col_diag_tmp], al
    mov al, byte [row_2+1]
    mov [col_diag_tmp+1], al
    mov al, byte [row_3+2]
    mov [col_diag_tmp+2], al
    cmp dword [col_diag_tmp], dword "XXX "
    je x_win
    cmp dword [col_diag_tmp], dword "OOO "
    je o_win

    ; check bottom-left to top-right diagnal for x or y win
    mov al, byte [row_1+2]
    mov [col_diag_tmp], al
    mov al, byte [row_2+1]
    mov [col_diag_tmp+1], al
    mov al, byte [row_3]
    mov [col_diag_tmp+2], al
    cmp dword [col_diag_tmp], dword "XXX "
    je x_win
    cmp dword [col_diag_tmp], dword "OOO "
    je o_win

    ; if all cells are occupied, end game as a tie
    cmp [row_1], byte " "
    je loop
    cmp [row_1+1], byte " "
    je loop
    cmp [row_1+2], byte " "
    je loop
    cmp [row_2], byte " "
    je loop
    cmp [row_2+1], byte " "
    je loop
    cmp [row_2+2], byte " "
    je loop
    cmp [row_3], byte " "
    je loop
    cmp [row_3+1], byte " "
    je loop
    cmp [row_3+2], byte " "
    je loop

tie:
    push row_3
    push row_2
    push row_1
    call show_board
    pop eax
    pop eax
    pop eax
    push tie_message_length
    push tie_message
    call print
    pop eax
    pop eax
    push 0
    call exit

x_win:
    push row_3
    push row_2
    push row_1
    call show_board
    pop eax
    pop eax
    pop eax
    push x_win_message_length
    push x_win_message
    call print
    pop eax
    pop eax
    push 0
    call exit

o_win:
    push row_3
    push row_2
    push row_1
    call show_board
    pop eax
    pop eax
    pop eax
    push o_win_message_length
    push o_win_message
    call print
    pop eax
    pop eax
    push 0
    call exit
