# ------------------------------- Description --------------------------------
#
# Fill a cell on the board based on input provided by the caller.
#
# -------------------------------- Parameters --------------------------------
#
# %r3       Address of input buffer
# %r4       Address of current player symbol
# %r5       Address of first row
# %r6       Address of second row
# %r7       Address of third row
#
# ------------------------------ Register Usage ------------------------------
#
# %r8      Used for byte comparisons
# %r9      Used for row addresses
# %r10     Used to store current player symbol
# %r11     Used to load cell values from rows
#
# --------------------------- Memory Manipulation ----------------------------
#
# One of the cells in the tictactoe board will be changed if the subroutine
# is successful.
#
# ------------------------------ Return Values -------------------------------
#
# %r3       Boolean indicator of whether subroutine was successful
#
# ----------------------------------------------------------------------------


.global fill_space
.include "macros/la.s"

.data
    bad_row_col_message: 
        .asciz "\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n"
    bad_row_col_message_length = . - bad_row_col_message

.text
fill_space:
    mflr    %r0	                
    stw     %r0, 20(%r1)

    lbz     %r8, 1(%r3)
    cmpi    0, 0, %r8, 32               # ensure row and column are delimited with space
    bne     bad_row_col

    lbz     %r8, 3(%r3)
    cmpi    0, 0, %r8, 10               # ensure input is only 4 bytes long (ascii 10 is new line character)
    bne     bad_row_col

    lbz     %r8, 0(%r3)
    cmpi    0, 0, %r8, 49               # did player specify row '1'?
    beq     set_row_1
    cmpi    0, 0, %r8, 50               # did player specify row '2'?
    beq     set_row_2
    cmpi    0, 0, %r8, 51               # did player specify row '3'?
    beq     set_row_3
    b       bad_row_col

set_row_1:
    mr      %r9, %r5
    b       fill_column

set_row_2:
    mr      %r9, %r6
    b       fill_column

set_row_3:
    mr      %r9, %r7
    b       fill_column

fill_column:
    lbz     %r8, 2(%r3)
    lbz     %r10, 0(%r4)
    cmpi    0, 0, %r8, 49               # did player specify column '1'?
    beq     set_col_1
    cmpi    0, 0, %r8, 50               # did player specify column '2'?
    beq     set_col_2
    cmpi    0, 0, %r8, 51               # did player specify column '3'?
    beq     set_col_3
    b       bad_row_col

set_col_1:
    lbz     %r11, 0(%r9)
    cmpi    0, 0, %r11, 32              # return if column already contains a value
    bne     bad_row_col
    stb     %r10, 0(%r9)
    b       return_success

set_col_2:
    lbz     %r11, 1(%r9)
    cmpi    0, 0, %r11, 32              # return if column already contains a value
    bne     bad_row_col
    stb     %r10, 1(%r9)
    b       return_success

set_col_3:
    lbz     %r11, 2(%r9)
    cmpi    0, 0, %r11, 32              # return if column already contains a value
    bne     bad_row_col
    stb     %r10, 2(%r9)
    b       return_success

bad_row_col:
    la      %r4, bad_row_col_message
    li      %r5, bad_row_col_message_length
    bl      print
    b       return_error

return_error:
    li      %r0, 1                      # set error return code
    b       return

return_success:
    li      %r3, 0
    b       return

return:
    lwz     %r0, 20(%r1)
    mtlr    %r0
    blr
