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
    welcome_message db "Welcome to x86 (i386) assembler Tic Tac Toe!", 0xA
    welcome_message_length equ $-welcome_message
    x_prompt db "It's X's turn: "
    x_prompt_length equ $-x_prompt
    o_prompt db "It's O's turn: "
    o_prompt_length equ $-o_prompt
    player_symbol db "X"
    player_symbol_length equ 1
    winner db 0x0
    winner_length equ 1
    row_1 db "   "
    row_2 db "   "
    row_3 db "   "

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

change_turn:
    cmp [player_symbol], byte "X"
    je change_turn_to_o
    cmp [player_symbol], byte "O"
    je change_turn_to_x

check_winner:
    cmp [winner], byte 0x0
    je loop

    push 0
    call exit	

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
