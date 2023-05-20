# ------------------------------- Description --------------------------------
#
# Fill a cell on the board based on input provided by the caller.
#
# -------------------------------- Parameters --------------------------------
#
# %r1       Address of input buffer
# %r2       Address of current player symbol
# %r3       Address of first row
# %r4       Address of second row
# %r5       Address of third row
#
# ------------------------------ Register Usage ------------------------------
#
# %r6      Used for byte comparisons
# %r7      Used for row addresses
# %r8      Used to store current player symbol
# %r9      Used to load cell values from rows
#
# --------------------------- Memory Manipulation ----------------------------
#
# One of the cells in the tictactoe board will be changed if the subroutine
# is successful.
#
# ------------------------------ Return Values -------------------------------
#
# %r1       Boolean indicator of whether subroutine was successful
#
# ----------------------------------------------------------------------------


.globl fill_space

# .data must be byte aligned for this program to work properly!
.data
.p2align 4
    bad_row_col_message: 
        .asciz "\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n"
        .p2align 1

.text
.p2align 4
fill_space:
    # preserve return address on stack
    aghi    %r15, -8
    stg	    %r14, 0(%r15)

    lb      %r6, 1(%r1)
    chi     %r6, 32                 # ensure row and column are delimited with space
    jne     bad_row_col

    lb      %r6, 3(%r1)
    chi     %r6, 10                 # ensure input is only 4 bytes long (ascii 10 is new line character)
    jne     bad_row_col

    lb      %r6, 0(%r1)
    chi     %r6, 49                 # did player specify row '1'?
    je      set_row_1
    chi     %r6, 50                 # did player specify row '2'?
    je      set_row_2
    chi     %r6, 51                 # did player specify row '3'?
    je      set_row_3
    j       bad_row_col

set_row_1:
    lgr     %r7, %r3
    j       fill_column

set_row_2:
    lgr     %r7, %r4
    j       fill_column

set_row_3:
    lgr     %r7, %r5
    j       fill_column

fill_column:
    lb      %r6, 2(%r1)
    lb      %r8, 0(%r2)
    chi     %r6, 49                 # did player specify column '1'?
    je      set_col_1
    chi     %r6, 50                 # did player specify column '2'?
    je      set_col_2
    chi     %r6, 51                 # did player specify column '3'?
    je      set_col_3
    j       bad_row_col

set_col_1:
    lb      %r9, 0(%r7)
    chi     %r9, 32                 # return if column already contains a value
    jne     bad_row_col
    stc     %r8, 0(%r7)
    j       return_success

set_col_2:
    lb      %r9, 1(%r7)
    chi     %r9, 32                 # return if column already contains a value
    jne     bad_row_col
    stc     %r8, 1(%r7)
    j       return_success

set_col_3:
    lb      %r9, 2(%r7)
    chi     %r9, 32                 # return if column already contains a value
    jne     bad_row_col
    stc     %r8, 2(%r7)
    j       return_success

bad_row_col:
    # since bad_row_col_message is long, split into two separate prints
    # message will not show up if message is not split into two separate prints
    larl    %r3, bad_row_col_message
    lghi    %r4, 100
    brasl   %r14, print
    aghi    %r3, 100
    lghi    %r4, 79
    brasl   %r14, print

    j       return_error

return_error:
    lghi    %r1, 1
    j       return

return_success:
    lghi    %r1, 0
    j       return

return:
    # restore return address from stack and return
    lg	    %r14, 0(%r15)
    aghi    %r15, 8	
    br      %r14
