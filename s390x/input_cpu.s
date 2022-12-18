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
# %r3       Address of user input buffer
# %r4       Address of first row
# %r5       Address of second row
# %r6       Address of third row
#
# ------------------------------ Register Usage ------------------------------
#
# %r0       Used for byte comparisons
#           Used for storing data in the input buffer
#           Used for getting random numbers 0-3 from the random subroutine
# %r1       Used to store the addresses of the win key buffers
# %r7       Used for row addresses
#           Used to store address of 'col_diag_tmp' buffer
# %r8       Used to load the contents of the row buffers
#           Used to load 4-byte segments from the win key buffers
#           Used to load bytes into the 'col_diag_tmp' buffer
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

# .data must be byte aligned for this program to work properly!
.data
.p2align 4
    col_diag_tmp: 
        .asciz "    "
        .p2align 1
    o_win_keys: 
        .asciz " OO O O OO  "
        .p2align 1
    x_win_keys: 
        .asciz " XX X X XX  "
        .p2align 1

.text
.p2align 4
input_cpu:
    # preserve return address on stack
    aghi    %r15, -8
	stg	    %r14, 0(%r15)

    lghi    %r0, 10
    stc     %r0, 3(%r3)                         # set new line as input terminator

find_row_win:
    larl    %r1, o_win_keys
    j       find_stop_row_1_win

find_col_win:
    j       find_stop_col_1_win

find_backward_diag_win:
    j       find_stop_backward_diag_win

stop_row_win:
    larl    %r1, x_win_keys
    j       find_stop_row_1_win

stop_col_win:
    j       find_stop_col_1_win

stop_backward_diag_win:
    j       find_stop_backward_diag_win

find_stop_row_1_win:
    lgr     %r7, %r4                            # row 1
    lghi    %r0, 49
    stc     %r0, 0(%r3)
    brasl   %r14, find_stop_row_win

find_stop_row_2_win:
    lgr     %r7, %r5                            # row 2
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    brasl   %r14, find_stop_row_win

find_stop_row_3_win:
    lgr     %r7, %r6                            # row 3
    lghi    %r0, 51
    stc     %r0, 0(%r3)
    brasl   %r14, find_stop_row_win

    # check if second byte in win key is O
    lb      %r2, 1(%r1)
    chi     %r0, 79
    je      find_col_win                        # if O
    j       stop_col_win                        # if X

find_stop_row_win:
    # preserve return address on stack
    aghi    %r15, -8
	stg	    %r14, 0(%r15)

    l       %r7, 0(%r7)

    # is row ' OO ' or ' XX '?
    l       %r8, 0(%r1)
    lghi    %r0, 49
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      pop_return

    # is row 'O O ' or 'X X '?
    l       %r8, 4(%r1)
    lghi    %r0, 50
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      pop_return

    # is row 'OO  ' or 'XX  '?
    l       %r8, 8(%r1)
    lghi    %r0, 51
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      pop_return

    # restore return address from stack and return
    lg	    %r14, 0(%r15)
    aghi    %r15, 8	
	br      %r14

find_stop_col_1_win:
    larl    %r7, col_diag_tmp
    lghi    %r0, 49
    stc     %r0, 2(%r3)

    # build column 1
    lb      %r8, 0(%r4)                         # row 1
    stc     %r8, 0(%r7)

    lb      %r8, 0(%r5)                         # row 2
    stc     %r8, 1(%r7)

    lb      %r8, 0(%r6)                         # row 3
    stc     %r8, 2(%r7)
    brasl   %r14, find_stop_col_win

find_stop_col_2_win:
    larl    %r7, col_diag_tmp
    lghi    %r0, 50
    stc     %r0, 2(%r3)

    # build column 2
    lb      %r8, 1(%r4)                         # row 1
    stc     %r8, 0(%r7)

    lb      %r8, 1(%r5)                         # row 2
    stc     %r8, 1(%r7)

    lb      %r8, 1(%r6)                         # row 3
    stc     %r8, 2(%r7)
    brasl   %r14, find_stop_col_win

find_stop_col_3_win:
    larl    %r7, col_diag_tmp
    lghi    %r0, 51
    stc     %r0, 2(%r3)

    # build column 3
    lb      %r8, 2(%r4)                         # row 1
    stc     %r8, 0(%r7)

    lb      %r8, 2(%r5)                         # row 2
    stc     %r8, 1(%r7)

    lb      %r8, 2(%r6)                         # row 3
    stc     %r8, 2(%r7)
    brasl   %r14, find_stop_col_win

    # check if second byte in win key is O
    lb      %r2, 1(%r1)
    chi     %r0, 79
    je      find_backward_diag_win              # if O
    j       stop_backward_diag_win              # if X

find_stop_col_win:
    # preserve return address on stack
    aghi    %r15, -8
	stg	    %r14, 0(%r15)

    l       %r7, 0(%r7)

    # is column ' OO ' or ' XX '?
    l       %r8, 0(%r1)
    lghi    %r0, 49
    stc     %r0, 0(%r3)
    cr      %r7, %r8
    je      pop_return

    # is column 'O O ' or 'X X '?
    l       %r8, 4(%r1)
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    cr      %r7, %r8
    je      pop_return

    # is column 'OO  ' or 'XX  '?
    l       %r8, 8(%r1)
    lghi    %r0, 51
    stc     %r0, 0(%r3)
    cr      %r7, %r8
    je      pop_return

    # restore return address from stack and return
    lg	    %r14, 0(%r15)
    aghi    %r15, 8	
	br      %r14

find_stop_backward_diag_win:
    larl    %r7, col_diag_tmp

    # build backward diagonal
    lb      %r8, 0(%r4)                         # row 1
    stc     %r8, 0(%r7)

    lb      %r8, 1(%r5)                         # row 2
    stc     %r8, 1(%r7)

    lb      %r8, 2(%r6)                         # row 2
    stc     %r8, 2(%r7)

    l       %r7, 0(%r7)

    # is backward diagonal ' OO ' or ' XX '?
    l       %r8, 0(%r1)
    lghi    %r0, 49
    stc     %r0, 0(%r3)
    lghi    %r0, 49
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

    # is backward diagonal 'O O ' or 'X X '?
    l       %r8, 4(%r1)
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    lghi    %r0, 50
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

    # is backward diagonal 'OO  ' or 'XX  '?
    l       %r8, 8(%r1)
    lghi    %r0, 51
    stc     %r0, 0(%r3)
    lghi    %r0, 51
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

find_stop_forward_diag_win:
    larl    %r7, col_diag_tmp

    # build forward diagonal
    lb      %r8, 2(%r4)                         # row 1
    stc     %r8, 0(%r7)

    lb      %r8, 1(%r5)                         # row 2
    stc     %r8, 1(%r7)

    lb      %r8, 0(%r6)                         # row 2
    stc     %r8, 2(%r7)

    l       %r7, 0(%r7)

    # is forward diagonal ' OO ' or ' XX '?
    l       %r8, 0(%r1)
    lghi    %r0, 49
    stc     %r0, 0(%r3)
    lghi    %r0, 51
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

    # is forward diagonal 'O O ' or 'X X '?
    l       %r8, 4(%r1)
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    lghi    %r0, 50
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

    # is forward diagonal 'OO  ' or 'XX  '?
    l       %r8, 8(%r1)
    lghi    %r0, 51
    stc     %r0, 0(%r3)
    lghi    %r0, 49
    stc     %r0, 2(%r3)
    cr      %r7, %r8
    je      return

    # check if second byte in win key is O
    lb      %r0, 1(%r1)
    chi     %r0, 79
    je      stop_row_win                        # if O

take_middle_space:
    lb      %r0, 1(%r5)
    chi     %r0, 32
    jne     take_random_space

    # randomize this move to create unpredictability
    lr      %r9, %r3                            # preserve %r3
    brasl   %r14, random
    lr      %r3, %r9                            # restore %r3
    chi     %r0, 0
    jne     take_random_space
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    stc     %r0, 2(%r3)
    j       return

take_random_space:
    lr      %r9, %r3                            # preserve %r3
    brasl   %r14, random
    lr      %r3, %r9                            # restore %r3
    chi     %r0, 0
    je      take_random_row_1
    chi     %r0, 1
    je      take_random_row_2
    chi     %r0, 3
    je      take_random_row_3

take_random_row_1:
    lghi    %r0, 49
    stc     %r0, 0(%r3)
    lgr     %r7, %r4                            # row 1
    j       take_random_row_space

take_random_row_2:
    lghi    %r0, 50
    stc     %r0, 0(%r3)
    lgr     %r7, %r5                            # row 2
    j       take_random_row_space

take_random_row_3:
    lghi    %r0, 51
    stc     %r0, 0(%r3)
    lgr     %r7, %r6                            # row 3

take_random_row_space:
    lr      %r9, %r3                            # preserve %r3
    brasl   %r14, random
    lr      %r3, %r9                            # restore %r3
    ar      %r7, %r0
    lb      %r7, 0(%r7)
    chi     %r7, 32
    jne     take_random_space
    aghi    %r0, 49                             # convert to ascii
    stc     %r0, 2(%r3)

return:
    # restore return address from stack and return
    lg	    %r14, 0(%r15)
    aghi    %r15, 8	
	br      %r14

pop_return:
    lg	    %r14, 0(%r15)
    aghi    %r15, 8
    j       return
