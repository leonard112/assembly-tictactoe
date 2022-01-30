.globl _start

.data
.p2align 4
    input_buffer: 
        .byte (70) 
        .p2align 1
	input_buffer_size: 
        .byte 70
        .p2align 1
	welcome_message: 
        .asciz "Welcome to s390x (IBMZ) assembly language Tic Tac Toe!\n"
        .p2align 1
	welcome_message_length: 
        .byte 55
        .p2align 1
    x_prompt: 
        .asciz "It's X's turn: "
        .p2align 1
    x_prompt_length: 
        .byte 15
        .p2align 1
    o_prompt: 
        .ascii "It's O's turn: "
        .p2align 1
    o_prompt_length: 
        .byte 15
        .p2align 1
    x_win_message: 
        .asciz "\nPlayer X is the winner!\n\n"
        .p2align 1
    x_win_message_length: 
        .byte 27 
        .p2align 1
    o_win_message: 
        .asciz "\nPlayer O is the winner!\n\n"
        .p2align 1
    o_win_message_length: 
        .byte 27
        .p2align 1
    tie_message: 
        .asciz "\nTie!\n\n"
        .p2align 1
    tie_message_length: 
        .byte 7
        .p2align 1
    player_symbol: 
        .asciz "X"
        .p2align 1
    player_symbol_length: 
        .byte 1
        .p2align 1
    row_1: 
        .asciz "    "
        .p2align 1
    row_2: 
        .asciz "    "
        .p2align 1
    row_3: 
        .asciz "    "
        .p2align 1
    col_diag_tmp: 
        .asciz "    "
        .p2align 1
    x_win_key: 
        .asciz "XXX "
        .p2align 1
    o_win_key: 
        .asciz "OOO "
        .p2align 1

.text
.p2align 4
_start:
    # counter tells check winner to only check for win after 5 turns.
    la %r10, 0

    larl %r3, welcome_message
    larl %r4, welcome_message_length
    lb %r4, 0(%r4)
    brasl %r14, print
loop:
    larl %r5, row_1
    larl %r6, row_2
    larl %r7, row_3
    brasl %r14, show_board
    
    larl %r1, player_symbol
    lb %r1, 0(%r1)
    chi %r1, 88
    je display_x_prompt
    chi %r1, 79
    je display_o_prompt

display_prompt:
    brasl %r14, print

    larl %r3, input_buffer
    larl %r4, input_buffer_size
    lb %r4, 0(%r4)
    brasl %r14, input
    larl %r1, input_buffer
    larl %r2, player_symbol
    larl %r3, row_1
    larl %r4, row_2
    larl %r5, row_3
    brasl %r14, fill_space
    chi %r1, 0
    jne loop

change_turn:
    aghi %r10, 1
    lb %r1, 0(%r2)
    chi %r1, 88
    je change_turn_o
    chi %r1, 79
    je change_turn_x

display_x_prompt:
    larl %r3, x_prompt
    larl %r4, x_prompt_length
    lb %r4, 0(%r4)
    j display_prompt

display_o_prompt:
    larl %r3, o_prompt
    larl %r4, o_prompt_length
    lb %r4, 0(%r4)
    j display_prompt

change_turn_x:
    la %r1, 88
    stc %r1, 0(%r2)
    j check_winner

change_turn_o:
    la %r1, 79
    stc %r1, 0(%r2)
    j check_winner

check_winner:
    # when counter is less than 5 don't waste clock cycles looking for winner.
    # a player can only win in a minimum of 5 turns.
    chi %r10, 5
    jl loop

    larl %r1, x_win_key
    l %r1, 0(%r1)
    larl %r2, o_win_key
    l %r2, 0(%r2)
    larl %r3, col_diag_tmp

    # check rows
    larl %r4, row_1
    brasl %r14, check_row_col_diag_for_winner
    larl %r4, row_2
    brasl %r14, check_row_col_diag_for_winner
    larl %r4, row_3
    brasl %r14, check_row_col_diag_for_winner
    
    # check first column
    larl %r4, row_1
    lb %r4, 0(%r4)
    stc %r4, 0(%r3)
    larl %r4, row_2
    lb %r4, 0(%r4)
    stc %r4, 1(%r3)
    larl %r4, row_3
    lb %r4, 0(%r4)
    stc %r4, 2(%r3)
    larl %r4, col_diag_tmp
    brasl %r14, check_row_col_diag_for_winner

    # check second column
    larl %r4, row_1
    lb %r4, 1(%r4)
    stc %r4, 0(%r3)
    larl %r4, row_2
    lb %r4, 1(%r4)
    stc %r4, 1(%r3)
    larl %r4, row_3
    lb %r4, 1(%r4)
    stc %r4, 2(%r3)
    larl %r4, col_diag_tmp
    brasl %r14, check_row_col_diag_for_winner

    # check third column
    larl %r4, row_1
    lb %r4, 2(%r4)
    stc %r4, 0(%r3)
    larl %r4, row_2
    lb %r4, 2(%r4)
    stc %r4, 1(%r3)
    larl %r4, row_3
    lb %r4, 2(%r4)
    stc %r4, 2(%r3)
    larl %r4, col_diag_tmp
    brasl %r14, check_row_col_diag_for_winner

    # check top-left to bottom-right diagonal
    larl %r4, row_1
    lb %r4, 0(%r4)
    stc %r4, 0(%r3)
    larl %r4, row_2
    lb %r4, 1(%r4)
    stc %r4, 1(%r3)
    larl %r4, row_3
    lb %r4, 2(%r4)
    stc %r4, 2(%r3)
    larl %r4, col_diag_tmp
    brasl %r14, check_row_col_diag_for_winner

    # check bottom-left to top-right diagonal
    larl %r4, row_1
    lb %r4, 2(%r4)
    stc %r4, 0(%r3)
    larl %r4, row_2
    lb %r4, 1(%r4)
    stc %r4, 1(%r3)
    larl %r4, row_3
    lb %r4, 0(%r4)
    stc %r4, 2(%r3)
    larl %r4, col_diag_tmp
    brasl %r14, check_row_col_diag_for_winner

    larl %r1, row_1
    larl %r2, row_2
    larl %r3, row_3
    aghi %r15, -8
    stg %r1, 0(%r15)
    aghi %r15, -8
    stg %r2, 0(%r15)
    aghi %r15, -8
    stg %r3, 0(%r15)
    la %r1, 0
    j start_new_turn_if_at_least_one_cell_is_empty
    j tie

start_new_turn_if_at_least_one_cell_is_empty:
    aghi %r1, 1
    lg %r2, 0(%r15)
    aghi %r15, 8
    lb %r3, 0(%r2)
    chi %r3, 32
    je loop
    lb %r3, 1(%r2)
    chi %r3, 32
    je loop
    lb %r3, 2(%r2)
    chi %r3, 32
    je loop
    chi %r1, 3
    je tie
    j start_new_turn_if_at_least_one_cell_is_empty

check_row_col_diag_for_winner:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    l %r4, 0(%r4)
    cr %r4, %r1
    je x_win
    cr %r4, %r2
    je o_win

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14

x_win:
    larl %r5, row_1
    larl %r6, row_2
    larl %r7, row_3
    brasl %r14, show_board
    larl %r3, x_win_message
    larl %r4, x_win_message_length
    lb %r4, 0(%r4)
    brasl %r14, print
    la %r2, 0
    j exit 

o_win:
    larl %r5, row_1
    larl %r6, row_2
    larl %r7, row_3
    brasl %r14, show_board
    larl %r3, o_win_message
    larl %r4, o_win_message_length
    lb %r4, 0(%r4)
    brasl %r14, print
    la %r2, 0
    j exit

tie:
    larl %r5, row_1
    larl %r6, row_2
    larl %r7, row_3
    brasl %r14, show_board
    larl %r3, tie_message
    larl %r4, tie_message_length
    lb %r4, 0(%r4)
    brasl %r14, print
    la %r2, 0
    j exit
