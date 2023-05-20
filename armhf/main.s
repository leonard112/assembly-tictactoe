// ------------------------------- Description -------------------------------
//
// This is the main entrypoint to the application.
//
// ---------------------------------------------------------------------------


.global _start

.data
    input_buffer: 
        .space 70
    input_buffer_size: 
        .word 70
    welcome_message: 
        .asciz "Welcome to ARM (armhf) assembly language Tic Tac Toe!\n"
    welcome_message_length: 
        .word 54
    x_prompt: 
        .asciz "It's X's turn: "
    x_prompt_length: 
        .word 15
    x_win_message: 
        .asciz "\nPlayer X is the winner!\n\n"
    x_win_message_length: 
        .word 26
    o_win_message: 
        .asciz "\nPlayer O is the winner!\n\n"
    o_win_message_length: 
        .word 26
    tie_message: 
        .asciz "\nTie!\n\n"
    tie_message_length: 
        .word 7
    player_symbol: 
        .asciz "X"
    player_symbol_length: 
        .word 1
    row_1: 
        .asciz "    "
    row_2: 
        .asciz "    "
    row_3: 
        .asciz "    "
    col_diag_tmp: 
        .asciz "    "
    x_win_key: 
        .asciz "XXX "
    o_win_key: 
        .asciz "OOO "

.text
_start:
    // counter tells check winner to only check for win after 5 turns.
    mov     r10, #0

    ldr     r1, =welcome_message
    ldr     r2, =welcome_message_length
    ldr     r2, [r2]
    bl      print
    
loop:
    ldr     r0, =player_symbol
    ldrb    r0, [r0]
    cmp     r0, #79
    bne     display_prompt

get_input_cpu:
    // Player O is the computer
    ldr     r3, =input_buffer
    ldr     r4, =row_1
    ldr     r5, =row_2
    ldr     r6, =row_3
    bl      input_cpu
    b       call_fill_space

display_prompt:
    // Player X is the user
    ldr     r3, =row_1
    ldr     r4, =row_2
    ldr     r5, =row_3
    bl      show_board

    ldr     r1, =x_prompt
    ldr     r2, =x_prompt_length
    ldr     r2, [r2]   
    bl      print

    ldr     r1, =input_buffer
    ldr     r2, =input_buffer_size
    ldr     r2, [r2]
    bl      input

call_fill_space:
    ldr     r0, =input_buffer
    ldr     r1, =player_symbol
    ldr     r2, =row_1
    ldr     r3, =row_2
    ldr     r4, =row_3
    bl      fill_space
    // if there was an error, make player enter input again.
    cmp     r0, #0		
    bne     loop
    
change_turn:
    add     r10, r10, #1
    ldrb    r0, [r1]
    cmp     r0, #88
    beq     change_turn_o

change_turn_x:
    mov     r0, #88
    strb    r0, [r1]
    b       check_winner

change_turn_o:
    mov     r0, #79
    strb    r0, [r1]

check_winner:
    // if counter is less than less than 5 don't waste clock cycles looking for winner.
    // a player can only win in a minimum of 5 turns.
    cmp     r10, #5
    blt     loop

    ldr     r0, =x_win_key
    ldr     r0, [r0]
    ldr     r1, =o_win_key
    ldr     r1, [r1]
    ldr     r2, =col_diag_tmp

    // check rows
    ldr     r3, =row_1
    bl      check_row_col_diag_for_winner
    ldr     r3, =row_2
    bl      check_row_col_diag_for_winner
    ldr     r3, =row_3
    bl      check_row_col_diag_for_winner
    
    // check first column
    ldr     r3, =row_1
    ldrb    r3, [r3]
    strb    r3, [r2]
    ldr     r3, =row_2
    ldrb    r3, [r3]
    strb    r3, [r2, #1]
    ldr     r3, =row_3
    ldrb    r3, [r3]
    strb    r3, [r2, #2]
    ldr     r3, =col_diag_tmp
    bl      check_row_col_diag_for_winner
    
    // check second column
    ldr     r3, =row_1
    ldrb    r3, [r3, #1]
    strb    r3, [r2]
    ldr     r3, =row_2
    ldrb    r3, [r3, #1]
    strb    r3, [r2, #1]
    ldr     r3, =row_3
    ldrb    r3, [r3, #1]
    strb    r3, [r2, #2]
    ldr     r3, =col_diag_tmp
    bl      check_row_col_diag_for_winner

    // check third column
    ldr     r3, =row_1
    ldrb    r3, [r3, #2]
    strb    r3, [r2]
    ldr     r3, =row_2
    ldrb    r3, [r3, #2]
    strb    r3, [r2, #1]
    ldr     r3, =row_3
    ldrb    r3, [r3, #2]
    strb    r3, [r2, #2]
    ldr     r3, =col_diag_tmp
    bl      check_row_col_diag_for_winner

    // check top-left to bottom-right diagonal
    ldr     r3, =row_1
    ldrb    r3, [r3]
    strb    r3, [r2]
    ldr     r3, =row_2
    ldrb    r3, [r3, #1]
    strb    r3, [r2, #1]
    ldr     r3, =row_3
    ldrb    r3, [r3, #2]
    strb    r3, [r2, #2]
    ldr     r3, =col_diag_tmp
    bl      check_row_col_diag_for_winner

    // check bottom-left to top-right diagonal
    ldr     r3, =row_1
    ldrb    r3, [r3, #2]
    strb    r3, [r2]
    ldr     r3, =row_2
    ldrb    r3, [r3, #1]
    strb    r3, [r2, #1]
    ldr     r3, =row_3
    ldrb    r3, [r3]
    strb    r3, [r2, #2]
    ldr     r3, =col_diag_tmp
    bl      check_row_col_diag_for_winner

    ldr     r1, =row_1
    ldr     r2, =row_2
    ldr     r3, =row_3
    push    {r1,r2,r3}
    mov     r0, #0
    b       start_new_turn_if_at_least_one_cell_is_empty
    b       tie

start_new_turn_if_at_least_one_cell_is_empty:
    add     r0, r0, #1
    pop     {r2}
    ldrb    r3, [r2]
    cmp     r3, #32
    beq     loop
    ldrb    r3, [r2, #1]
    cmp     r3, #32
    beq     loop
    ldrb    r3, [r2, #2]
    cmp     r3, #32
    beq     loop
    cmp     r0, #3
    bge     tie
    b       start_new_turn_if_at_least_one_cell_is_empty
    

check_row_col_diag_for_winner:
    push    {lr}
    ldr     r3, [r3]
    cmp     r3, r0
    beq     x_win
    cmp     r3, r1
    beq     o_win
    pop     {lr}
    bx      lr

x_win:
    ldr     r3, =row_1
    ldr     r4, =row_2
    ldr     r5, =row_3
    bl      show_board
    ldr     r1, =x_win_message
    ldr     r2, =x_win_message_length
    ldr     r2, [r2]
    bl      print
    mov     r0, #0
    bl      exit

o_win:
    ldr     r3, =row_1
    ldr     r4, =row_2
    ldr     r5, =row_3
    bl      show_board
    ldr     r1, =o_win_message
    ldr     r2, =o_win_message_length
    ldr     r2, [r2]
    bl      print
    mov     r0, #0
    bl      exit

tie:
    ldr     r3, =row_1
    ldr     r4, =row_2
    ldr     r5, =row_3
    bl      show_board
    ldr     r1, =tie_message
    ldr     r2, =tie_message_length
    ldr     r2, [r2]
    bl      print
    mov     r0, #0
    bl      exit
    