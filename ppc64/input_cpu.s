# ------------------------------- Description --------------------------------
#
# This subroutine is the brains of the computer player that the user plays 
# against. The computer player will specify a row and column in the input 
# buffer that it determines to be strategic to winning or at least preventing 
# the player from winning. If the computer player cannot find a move that
# it considers to be stategic, a random empty cell will be chosen.
#
# ------------------------------- Parameters ---------------------------------
#
# %r6       Address of user input buffer
# %r7       Address of first row
# %r8       Address of second row
# %r9       Address of third row
#
# ------------------------------ Register Usage ------------------------------
#
# %r3       Used for byte comparisons
#           Used for storing data in the input buffer
#           Used for getting random numbers 0-3 from the random subroutine
# %r4       Used to store the addresses of the win key buffers
# %r5       Used for row addresses
#           Used to store address of 'col_diag_tmp' buffer
# %r10      Used to load the contents of the row buffers
#           Used to load 4-byte segments from the win key buffers
#           Used to load bytes into the 'col_diag_tmp' buffer
# %r11      Used to preserve %r5 when making call to random subroutine
#
# --------------------------- Memory Manipulation ----------------------------
#
# The input buffer and the local 'col_diag_tmp' buffer should be the only 
# memory that is manipulated by this subroutine.
#
# ------------------------------ Return Values -------------------------------
#
# None
#
# ----------------------------------------------------------------------------


.globl input_cpu
.include "macros/la.s"

.data
    col_diag_tmp: 
        .asciz "    "
    o_win_keys: 
        .asciz " OO O O OO  "
    x_win_keys: 
        .asciz " XX X X XX  "

.text
input_cpu:
    mflr    %r0	                
    stw     %r0, 20(%r1)

    li      %r3, 10
    stb     %r3, 0(%r6)         # set new line as input terminator

find_row_win:
    la      %r4, o_win_keys
    b       find_stop_row_1_win

find_col_win:
    b       find_stop_col_1_win

find_backward_diag_win:
    b       find_stop_backward_diag_win

stop_row_win:
    la      %r4, x_win_keys
    b       find_stop_row_1_win

stop_col_win:
    b      find_stop_col_1_win

stop_backward_diag_win:
    b      find_stop_backward_diag_win

find_stop_row_1_win:
    mr      %r5, %r7                    # row 1
    li      %r3, 49
    stb     %r3, 0(%r6)
    bl      find_stop_row_win

find_stop_row_2_win:
    mr      %r5, %r8                    # row 2
    li      %r3, 50
    stb     %r3, 0(%r6)
    bl      find_stop_row_win

find_stop_row_3_win:
    mr      %r5, %r9                    # row 3
    li      %r3, 51
    stb     %r3, 0(%r6)
    bl      find_stop_row_win

    # check if second byte in win key is O
    lbz     %r3, 1(%r4)
    cmpi    0, 0, %r3, 79
    beq     find_col_win                # if O
    b       stop_col_win                # if X

find_stop_row_win:
    # Create new stack frame so that caller's preserved
    # link register doesn't get overwitten.
    stwu    %r1, -16(%r1)       
    mflr    %r0	                
    stw     %r0, 20(%r1)

    lwz     %r5, 0(%r5)

    # is row ' OO ' or ' XX '?
    lwz     %r10, 0(%r4)
    li      %r3, 49
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    # is row 'O O ' or 'X X '?
    lwz     %r10, 4(%r4)
    li      %r3, 50
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    # is row 'OO  ' or 'XX  '?
    lwz     %r10, 8(%r4)
    li      %r3, 51
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    lwz     %r0, 20(%r1)
    mtlr    %r0
    addi    %r1, %r1, 16
    blr

find_stop_col_1_win:
    la      %r5, col_diag_tmp
    li      %r3, 49
    stb     %r3, 2(%r6)

    # build column 1
    lbz     %r10, 0(%r7)                # row 1
    stb     %r10, 0(%r5)

    lbz     %r10, 0(%r8)                # row 2
    stb     %r10, 1(%r5)

    lbz     %r10, 0(%r9)                # row 3
    stb     %r10, 2(%r5)
    bl      find_stop_col_win

find_stop_col_2_win:
    la      %r5, col_diag_tmp
    li      %r3, 50
    stb     %r3, 2(%r6)

    # build column 2
    lbz     %r10, 1(%r7)                # row 1
    stb     %r10, 0(%r5)

    lbz     %r10, 1(%r8)                # row 2
    stb     %r10, 1(%r5)

    lbz     %r10, 1(%r9)                # row 3
    stb     %r10, 2(%r5)
    bl      find_stop_col_win

find_stop_col_3_win:
    la      %r5, col_diag_tmp
    li      %r3, 51
    stb     %r3, 2(%r6)

    # build column 3
    lbz     %r10, 2(%r7)                # row 1
    stb     %r10, 0(%r5)

    lbz     %r10, 2(%r8)                # row 2
    stb     %r10, 1(%r5)

    lbz     %r10, 2(%r9)                # row 3
    stb     %r10, 2(%r5)
    bl      find_stop_col_win

    # check if second byte in win key is O
    lbz     %r3, 1(%r4)
    cmpi    0, 0, %r3, 79
    beq     find_backward_diag_win      # if O
    b       stop_backward_diag_win      # if X

find_stop_col_win:
    # Create new stack frame so that caller's preserved
    # link register doesn't get overwitten.
    stwu    %r1, -16(%r1)       
    mflr    %r0	                
    stw     %r0, 20(%r1)

    lwz     %r5, 0(%r5)

    # is column ' OO ' or ' XX '?
    lwz     %r10, 0(%r4)
    li      %r3, 49
    stb     %r3, 0(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    # is column 'O O ' or 'X X '?
    lwz     %r10, 4(%r4)
    li      %r3, 50
    stb     %r3, 0(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    # is column 'OO  ' or 'XX  '?
    lwz     %r10, 8(%r4)
    li      %r3, 51
    stb     %r3, 0(%r6)
    cmp     0, 0, %r5, %r10
    beq     pop_return

    lwz     %r0, 20(%r1)
    mtlr    %r0
    addi    %r1, %r1, 16
    blr

find_stop_backward_diag_win:
    la      %r5, col_diag_tmp

    # build backward diagonal
    lbz     %r10, 0(%r7)                # row 1
    stb     %r10, 0(%r5)

    lbz     %r10, 1(%r8)                # row 2
    stb     %r10, 1(%r5)

    lbz     %r10, 2(%r9)                # row 3
    stb     %r10, 2(%r5)

    lwz     %r5, 0(%r5)

    # is backward diagonal ' OO ' or ' XX '?
    lwz     %r10, 0(%r4)
    li      %r3, 49
    stb     %r3, 0(%r6)
    li      %r3, 49
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

    # is backward diagonal 'O O ' or 'X X '?
    lwz     %r10, 4(%r4)
    li      %r3, 50
    stb     %r3, 0(%r6)
    li      %r3, 50
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

    # is backward diagonal 'OO  ' or 'XX  '?
    lwz     %r10, 8(%r4)
    li      %r3, 51
    stb     %r3, 0(%r6)
    li      %r3, 51
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

find_stop_forward_diag_win:
    la      %r5, col_diag_tmp

    # build backward diagonal
    lbz     %r10, 2(%r7)                # row 1
    stb     %r10, 0(%r5)

    lbz     %r10, 1(%r8)                # row 2
    stb     %r10, 1(%r5)

    lbz     %r10, 0(%r9)                # row 3
    stb     %r10, 2(%r5)

    lwz     %r5, 0(%r5)

    # is backward diagonal ' OO ' or ' XX '?
    lwz     %r10, 0(%r4)
    li      %r3, 49
    stb     %r3, 0(%r6)
    li      %r3, 51
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

    # is backward diagonal 'O O ' or 'X X '?
    lwz     %r10, 4(%r4)
    li      %r3, 50
    stb     %r3, 0(%r6)
    li      %r3, 50
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

    # is backward diagonal 'OO  ' or 'XX  '?
    lwz     %r10, 8(%r4)
    li      %r3, 51
    stb     %r3, 0(%r6)
    li      %r3, 49
    stb     %r3, 2(%r6)
    cmp     0, 0, %r5, %r10
    beq     return

    # check if second byte in win key is O
    lbz     %r3, 1(%r4)
    cmpi    0, 0, %r3, 79
    beq     stop_row_win                # if O

take_middle_space:
    lbz     %r3, 1(%r8)                 # row 2
    cmpi    0, 0, %r3, 32
    bne     take_random_space

    # randomize this move to create unpredictability
    bl      random
    cmpi    0, 0, %r3, 0
    bne     take_random_space
    li      %r3, 50
    stb     %r3, 0(%r6)
    stb     %r3, 2(%r6)
    b       return

take_random_space:
    bl      random
    cmpi    0, 0, %r3, 0
    beq     take_random_row_1
    cmpi    0, 0, %r3, 1
    beq     take_random_row_2
    cmpi    0, 0, %r3, 2
    beq     take_random_row_3

take_random_row_1:
    li      %r3, 49
    stb     %r3, 0(%r6)
    mr      %r5, %r7                    # row 1
    b       take_random_row_space

take_random_row_2:
    li      %r3, 50
    stb     %r3, 0(%r6)
    mr      %r5, %r8                    # row 2
    b       take_random_row_space

take_random_row_3:
    li      %r3, 51
    stb     %r3, 0(%r6)
    mr      %r5, %r9                    # row 3

take_random_row_space:
    mr      %r11, %r5                   # preserve %r5
    bl      random
    mr      %r5, %r11                   # restore %r5
    add     %r5, %r5, %r3
    lbz     %r5, 0(%r5)
    cmpi    0, 0, %r5, 32
    bne     take_random_space
    addi    %r3, %r3, 49                # convert to ascii
    stb     %r3, 2(%r6)

return:
    lwz     %r0, 20(%r1)
    mtlr    %r0
    blr

pop_return:
    lwz     %r0, 20(%r1)
    mtlr    %r0
    addi    %r1, %r1, 16
    b       return
    