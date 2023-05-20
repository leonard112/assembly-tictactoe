# ------------------------------- Description --------------------------------
#
# This is the main entrypoint to the application.
#
# ----------------------------------------------------------------------------


.global _start
.localentry _start, 0
.include "macros/la.s"

.data
    input_buffer: 
        .space 70
    input_buffer_size = . - input_buffer
    welcome_message: 
        .asciz "Welcome to PowerPC (ppc64) assembly language Tic Tac Toe!\n"
	welcome_message_length = . -welcome_message
    x_prompt: 
        .asciz "It's X's turn: "
    x_prompt_length = . - x_prompt
    x_win_message:
        .asciz "\nPlayer X is the winner!\n\n"
    x_win_message_length = . - x_win_message
    o_win_message:
        .asciz "\nPlayer O is the winner!\n\n"
    o_win_message_length = . - o_win_message
    tie_message:
        .asciz "\nTie!\n\n"
    tie_message_length = . - tie_message
    player_symbol: 
        .asciz "X"
    player_symbol_length= . - player_symbol
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
    la      %r4, welcome_message
    li      %r5, welcome_message_length
    bl      print
    li      %r3, 0

loop:
    addi    %r13, %r13, 1
    la      %r3, player_symbol
    lbz     %r3, 0(%r3)
    cmpi    0, 0, %r3, 79
    bne     display_prompt

get_input_cpu:
    # Player O is the computer
    la      %r6, input_buffer
    la      %r7, row_1
    la      %r8, row_2
    la      %r9, row_3
    bl      input_cpu
    b       call_fill_space

display_prompt:
    # Player X is the user
    la      %r6, row_1
    la      %r7, row_2
    la      %r8, row_3
    bl      show_board

    la      %r4, x_prompt
    li      %r5, x_prompt_length
    bl      print

    la      %r4, input_buffer
    li      %r5, input_buffer_size
    bl      input

call_fill_space:
    la      %r3, input_buffer
    la      %r4, player_symbol
    la      %r5, row_1
    la      %r6, row_2
    la      %r7, row_3
    bl      fill_space
    cmpi    0, 0, %r3, 0
    bne     loop

change_turn:
    lbz     %r3, 0(%r4)
    cmpi    0, 0, %r3, 88
    beq     change_turn_o

change_turn_x:
    li      %r3, 88
    stb     %r3, 0(%r4)
    b       check_winner

change_turn_o:
    li      %r3, 79
    stb     %r3, 0(%r4)

check_winner:
    la      %r4, x_win_key
    lwz     %r4, 0(%r4)
    la      %r5, o_win_key
    lwz     %r5, 0(%r5)
    la      %r6, col_diag_tmp

    # check rows
    la      %r7, row_1
    bl      check_row_col_diag_for_winner
    la      %r7, row_2
    bl      check_row_col_diag_for_winner
    la      %r7, row_3
    bl      check_row_col_diag_for_winner

    # check first column
    la      %r7, row_1
    lbz     %r7, 0(%r7)
    stb     %r7, 0(%r6)
    la      %r7, row_2
    lbz     %r7, 0(%r7)
    stb     %r7, 1(%r6)
    la      %r7, row_3
    lbz     %r7, 0(%r7)
    stb     %r7, 2(%r6)
    la      %r7, col_diag_tmp
    bl      check_row_col_diag_for_winner

    # check second column
    la      %r7, row_1
    lbz     %r7, 1(%r7)
    stb     %r7, 0(%r6)
    la      %r7, row_2
    lbz     %r7, 1(%r7)
    stb     %r7, 1(%r6)
    la      %r7, row_3
    lbz     %r7, 1(%r7)
    stb     %r7, 2(%r6)
    la      %r7, col_diag_tmp
    bl      check_row_col_diag_for_winner

    # check third column
    la      %r7, row_1
    lbz     %r7, 2(%r7)
    stb     %r7, 0(%r6)
    la      %r7, row_2
    lbz     %r7, 2(%r7)
    stb     %r7, 1(%r6)
    la      %r7, row_3
    lbz     %r7, 2(%r7)
    stb     %r7, 2(%r6)
    la      %r7, col_diag_tmp
    bl      check_row_col_diag_for_winner

    # check top-left to bottom-right diagonal
    la      %r7, row_1
    lbz     %r7, 0(%r7)
    stb     %r7, 0(%r6)
    la      %r7, row_2
    lbz     %r7, 1(%r7)
    stb     %r7, 1(%r6)
    la      %r7, row_3
    lbz     %r7, 2(%r7)
    stb     %r7, 2(%r6)
    la      %r7, col_diag_tmp
    bl      check_row_col_diag_for_winner

    # check bottom-left to top-right diagonal
    la      %r7, row_1
    lbz     %r7, 2(%r7)
    stb     %r7, 0(%r6)
    la      %r7, row_2
    lbz     %r7, 1(%r7)
    stb     %r7, 1(%r6)
    la      %r7, row_3
    lbz     %r7, 0(%r7)
    stb     %r7, 2(%r6)
    la      %r7, col_diag_tmp
    bl      check_row_col_diag_for_winner

    # push each row to stack
    la      %r3, row_1
    lwz     %r3, 0(%r3)
    la      %r4, row_2
    lwz     %r4, 0(%r4)
    la      %r5, row_3
    lwz     %r5, 0(%r5)
    stwu    %r3, -4(%r1)
    stwu    %r4, -4(%r1)
    stwu    %r5, -4(%r1)
    li      %r6, 0

start_new_turn_if_at_least_one_cell_is_empty:
    addi    %r6, %r6, 1
    lbz     %r7, 0(%r1)         # load row from stack
    addi    %r1, %r1, 4         # increment stack pointer
    cmpi    0, 0, %r7, 32
    beq     loop
    lbz     %r7, 1(%r1)
    cmpi    0, 0, %r7, 32
    beq     loop
    lbz     %r7, 2(%r1)
    cmpi    0, 0, %r7, 32
    beq     loop
    cmpi    0, 0, %r6, 3
    beq     tie
    b       start_new_turn_if_at_least_one_cell_is_empty

check_row_col_diag_for_winner:
    lwz     %r7, 0(%r7)
    cmp     0, 0, %r7, %r4
    beq     x_win
    cmp     0, 0, %r7, %r5
    beq     o_win

    blr

x_win:
    la      %r6, row_1
    la      %r7, row_2
    la      %r8, row_3
    bl      show_board
    la      %r4, x_win_message
    li      %r5, x_win_message_length
    bl      print
    li      %r3, 0
    b       exit

o_win:
    la      %r6, row_1
    la      %r7, row_2
    la      %r8, row_3
    bl      show_board
    la      %r4, o_win_message
    li      %r5, o_win_message_length
    bl      print
    li      %r3, 0
    b       exit

tie:
    la      %r6, row_1
    la      %r7, row_2
    la      %r8, row_3
    bl      show_board
    la      %r4, tie_message
    li      %r5, tie_message_length
    bl      print
    li      %r3, 0
    b       exit
