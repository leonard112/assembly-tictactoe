.global _start

.data
    input_buffer: .space 70
    input_buffer_size = . - input_buffer
    welcome_message: .asciz "Welcome to ARM (aarch64) assembly language Tic Tac Toe!\n"
    welcome_message_length = . - welcome_message
    x_prompt: .asciz "It's X's turn: "
    x_prompt_length = . - x_prompt
    x_win_message: .asciz "\nPlayer X is the winner!\n\n"
    x_win_message_length = . - x_win_message
    o_win_message: .asciz "\nPlayer O is the winner!\n\n"
    o_win_message_length = . - o_win_message
    tie_message: .asciz "\nTie!\n\n"
    tie_message_length = . - tie_message
    player_symbol: .asciz "X"
    player_symbol_length= . - player_symbol
    row_1: .asciz "    "
    row_2: .asciz "    "
    row_3: .asciz "    "
    col_diag_tmp: .asciz "    "
    x_win_key: .asciz "XXX "
    o_win_key: .asciz "OOO "

.text
_start:
    // counter tells check winner to only check for win after 5 turns.
    mov x11, #0

    ldr x1, =welcome_message
    ldr x2, =welcome_message_length
    bl print
loop:
    ldr w0, =player_symbol
    ldrb w0, [x0]
    cmp w0, #79
    beq get_input_cpu

    ldr x3, =row_1
    ldr x4, =row_2
    ldr x5, =row_3
    bl show_board

    ldr x1, =player_symbol
    ldrb w1, [x1]
    cmp w1, #88
    beq display_x_prompt
    
    // Player O is the computer
get_input_cpu:
    ldr x3, =input_buffer
    ldr x4, =row_1
    ldr x5, =row_2
    ldr x6, =row_3
    bl input_cpu
    b call_fill_space

display_prompt:
    bl print

    ldr x1, =input_buffer
    ldr x2, =input_buffer_size
    bl input

call_fill_space:
    ldr x0, =input_buffer
    ldr x1, =player_symbol
    ldr x2, =row_1
    ldr x3, =row_2
    ldr x4, =row_3
    bl fill_space
    // if there was an error, make player enter input again.
    cmp x0, #0		
    bne loop
    
change_turn:
    add x11, x11, #1
    ldrb w0, [x1]
    cmp w0, #88
    beq change_turn_o
    cmp w0, #79
    beq change_turn_x

display_x_prompt:
    ldr x1, =x_prompt
    ldr x2, =x_prompt_length
    b display_prompt

change_turn_x:
    mov w0, #88
    strb w0, [x1]
    b check_winner

change_turn_o:
    mov w0, #79
    strb w0, [x1]
    b check_winner

check_winner:
    // if counter is less than less than 5 don't waste clock cycles looking for winner.
    // a player can only win in a minimum of 5 turns.
    cmp w11, #5
    blt loop

    ldr x0, =x_win_key
    ldr w0, [x0]
    ldr x1, =o_win_key
    ldr w1, [x1]
    ldr x2, =col_diag_tmp

    // check rows
    ldr x3, =row_1
    bl check_row_col_diag_for_winner
    ldr x3, =row_2
    bl check_row_col_diag_for_winner
    ldr x3, =row_3
    bl check_row_col_diag_for_winner
    
    // check first column
    ldr x3, =row_1
    ldrb w3, [x3]
    strb w3, [x2]
    ldr x3, =row_2
    ldrb w3, [x3]
    strb w3, [x2, #1]
    ldr x3, =row_3
    ldrb w3, [x3]
    strb w3, [x2, #2]
    ldr x3, =col_diag_tmp
    bl check_row_col_diag_for_winner
    
    // check second column
    ldr x3, =row_1
    ldrb w3, [x3, #1]
    strb w3, [x2]
    ldr x3, =row_2
    ldrb w3, [x3, #1]
    strb w3, [x2, #1]
    ldr x3, =row_3
    ldrb w3, [x3, #1]
    strb w3, [x2, #2]
    ldr x3, =col_diag_tmp
    bl check_row_col_diag_for_winner

    // check third column
    ldr x3, =row_1
    ldrb w3, [x3, #2]
    strb w3, [x2]
    ldr x3, =row_2
    ldrb w3, [x3, #2]
    strb w3, [x2, #1]
    ldr w3, =row_3
    ldrb w3, [x3, #2]
    strb w3, [x2, #2]
    ldr x3, =col_diag_tmp
    bl check_row_col_diag_for_winner

    // check top-left to bottom-right diagonal
    ldr x3, =row_1
    ldrb w3, [x3]
    strb w3, [x2]
    ldr x3, =row_2
    ldrb w3, [x3, #1]
    strb w3, [x2, #1]
    ldr x3, =row_3
    ldrb w3, [x3, #2]
    strb w3, [x2, #2]
    ldr x3, =col_diag_tmp
    bl check_row_col_diag_for_winner

    // check bottom-left to top-right diagonal
    ldr x3, =row_1
    ldrb w3, [x3, #2]
    strb w3, [x2]
    ldr x3, =row_2
    ldrb w3, [x3, #1]
    strb w3, [x2, #1]
    ldr x3, =row_3
    ldrb w3, [x3]
    strb w3, [x2, #2]
    ldr x3, =col_diag_tmp
    bl check_row_col_diag_for_winner

    ldr x1, =row_1
    ldr x2, =row_2
    ldr x3, =row_3
    str x1, [sp, #-16]!
    str x2, [sp, #-16]!
    str x3, [sp, #-16]!
    mov x0, #0
    b start_new_turn_if_at_least_one_cell_is_empty
    b tie

start_new_turn_if_at_least_one_cell_is_empty:
    add x0, x0, #1
    ldr x2, [sp], #16
    ldrb w3, [x2]
    cmp w3, #32
    beq loop
    ldrb w3, [x2, #1]
    cmp w3, #32
    beq loop
    ldrb w3, [x2, #2]
    cmp w3, #32
    beq loop
    cmp x0, #3
    bge tie
    b start_new_turn_if_at_least_one_cell_is_empty


check_row_col_diag_for_winner:
    ldr w3, [x3]
    cmp w3, w0
    beq x_win
    cmp w3, w1
    beq o_win
    ret

x_win:
    ldr x3, =row_1
    ldr x4, =row_2
    ldr x5, =row_3
    bl show_board
    ldr x1, =x_win_message
    ldr x2, =x_win_message_length
    bl print
    mov x0, #0
    bl exit

o_win:
    ldr x3, =row_1
    ldr x4, =row_2
    ldr x5, =row_3
    bl show_board
    ldr x1, =o_win_message
    ldr x2, =o_win_message_length
    bl print
    mov x0, #0
    bl exit

tie:
    ldr x3, =row_1
    ldr x4, =row_2
    ldr x5, =row_3
    bl show_board
    ldr x1, =tie_message
    ldr x2, =tie_message_length
    bl print
    mov x0, #0
    bl exit
    
