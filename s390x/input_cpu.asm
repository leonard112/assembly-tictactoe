# Parameters:
# %r3 (Address of user input buffer)
# %r4 (Address of first row)
# %r5 (Address of second row)
# %r6 (Address of third row)

.globl input_cpu

# .data must be byte aligned for this program to work properly!
.data
.p2align 4
    col_diag_tmp: 
        .asciz "    "
        .p2align 1
    o_win_1: 
        .asciz " OO "
        .p2align 1
    o_win_2: 
        .asciz "O O "
        .p2align 1
    o_win_3: 
        .asciz "OO  "
        .p2align 1
    x_win_1: 
        .asciz " XX "
        .p2align 1
    x_win_2: 
        .asciz "X X "
        .p2align 1
    x_win_3: 
        .asciz "XX  "
        .p2align 1

.text
.p2align 4
input_cpu:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    lghi %r0, 10
    stc %r0, 3(%r3)                         # set new line as input terminator

find_row_1_win:
    lgr %r7, %r4                            # row 1
    lghi %r0, 49
    stc %r0, 0(%r3)
    brasl %r14, find_row_win

find_row_2_win:
    lgr %r7, %r5                            # row 2
    lghi %r0, 50
    stc %r0, 0(%r3)
    brasl %r14, find_row_win

find_row_3_win:
    lgr %r7, %r6                            # row 1
    lghi %r0, 51
    stc %r0, 0(%r3)
    brasl %r14, find_row_win

    j find_col_1_win

find_row_win:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    l %r7, 0(%r7)
    larl %r8, o_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, o_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, o_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14

find_col_1_win:
    larl %r7, col_diag_tmp
    lghi %r0, 49
    stc %r0, 2(%r3)
    lb %r8, 0(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 0(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 0(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, find_col_win

find_col_2_win:
    larl %r7, col_diag_tmp
    lghi %r0, 50
    stc %r0, 2(%r3)
    lb %r8, 1(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 1(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, find_col_win

find_col_3_win:
    larl %r7, col_diag_tmp
    lghi %r0, 51
    stc %r0, 2(%r3)
    lb %r8, 2(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 2(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 2(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, find_col_win

    j find_backward_diag_win

find_col_win:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    l %r7, 0(%r7)
    larl %r8, o_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, o_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, o_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14

find_backward_diag_win:
    larl %r7, col_diag_tmp
    lb %r8, 0(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 2(%r6)                          # row 2
    stc %r8, 2(%r7)
    l %r7, 0(%r7)
    larl %r8, o_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, o_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, o_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
find_forward_diag_win:
    larl %r7, col_diag_tmp
    lb %r8, 2(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 0(%r6)                          # row 2
    stc %r8, 2(%r7)
    l %r7, 0(%r7)
    larl %r8, o_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, o_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, o_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return

stop_row_1_win:
    lgr %r7, %r4                            # row 1
    lghi %r0, 49
    stc %r0, 0(%r3)
    brasl %r14, stop_row_win

stop_row_2_win:
    lgr %r7, %r5                            # row 2
    lghi %r0, 50
    stc %r0, 0(%r3)
    brasl %r14, stop_row_win

stop_row_3_win:
    lgr %r7, %r6                            # row 1
    lghi %r0, 51
    stc %r0, 0(%r3)
    brasl %r14, stop_row_win

    j stop_col_1_win

stop_row_win:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    l %r7, 0(%r7)
    larl %r8, x_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, x_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, x_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je pop_return

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8
	br %r14

stop_col_1_win:
    larl %r7, col_diag_tmp
    lghi %r0, 49
    stc %r0, 2(%r3)
    lb %r8, 0(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 0(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 0(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, stop_col_win

stop_col_2_win:
    larl %r7, col_diag_tmp
    lghi %r0, 50
    stc %r0, 2(%r3)
    lb %r8, 1(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 1(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, stop_col_win

stop_col_3_win:
    larl %r7, col_diag_tmp
    lghi %r0, 51
    stc %r0, 2(%r3)
    lb %r8, 2(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 2(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 2(%r6)                          # row 2
    stc %r8, 2(%r7)
    brasl %r14, stop_col_win

    j stop_backward_diag_win

stop_col_win:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    l %r7, 0(%r7)
    larl %r8, x_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, x_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return
    larl %r8, x_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    cr %r7, %r8
    je pop_return

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14

stop_backward_diag_win:
    larl %r7, col_diag_tmp
    lb %r8, 0(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 2(%r6)                          # row 2
    stc %r8, 2(%r7)
    l %r7, 0(%r7)
    larl %r8, x_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, x_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, x_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
stop_forward_diag_win:
    larl %r7, col_diag_tmp
    lb %r8, 2(%r4)                          # row 1
    stc %r8, 0(%r7)
    lb %r8, 1(%r5)                          # row 2
    stc %r8, 1(%r7)
    lb %r8, 0(%r6)                          # row 2
    stc %r8, 2(%r7)
    l %r7, 0(%r7)
    larl %r8, x_win_1
    l %r8, 0(%r8)
    lghi %r0, 49
    stc %r0, 0(%r3)
    lghi %r0, 51
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, x_win_2
    l %r8, 0(%r8)
    lghi %r0, 50
    stc %r0, 0(%r3)
    lghi %r0, 50
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return
    larl %r8, x_win_3
    l %r8, 0(%r8)
    lghi %r0, 51
    stc %r0, 0(%r3)
    lghi %r0, 49
    stc %r0, 2(%r3)
    cr %r7, %r8
    je return

take_middle_space:
    lb %r0, 1(%r5)
    chi %r0, 32
    jne take_random_space
    lr %r9, %r3                             # preserve %r3
    brasl %r14, random
    lr %r3, %r9                             # restore %r3
    chi %r0, 0
    jne take_random_space
    lghi %r0, 50
    stc %r0, 0(%r3)
    stc %r0, 2(%r3)
    j return

take_random_space:
    lr %r9, %r3                             # preserve %r3
    brasl %r14, random
    lr %r3, %r9                             # restore %r3
    chi %r0, 0
    je take_random_row_1
    chi %r0, 1
    je take_random_row_2
    chi %r0, 3
    je take_random_row_3

take_random_row_1:
    lghi %r0, 49
    stc %r0, 0(%r3)
    lgr %r7, %r4                            # row 1
    j take_random_row_space

take_random_row_2:
    lghi %r0, 50
    stc %r0, 0(%r3)
    lgr %r7, %r5                            # row 2
    j take_random_row_space

take_random_row_3:
    lghi %r0, 51
    stc %r0, 0(%r3)
    lgr %r7, %r6                            # row 3

take_random_row_space:
    lr %r9, %r3                             # preserve %r3
    brasl %r14, random
    lr %r3, %r9                             # restore %r3
    ar %r7, %r0
    lb %r7, 0(%r7)
    chi %r7, 32
    jne take_random_space
    aghi %r0, 49                            # convert to ascii
    stc %r0, 2(%r3)

return:
    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14

pop_return:
    lg	%r14, 0(%r15)
    aghi %r15, 8
    j return
