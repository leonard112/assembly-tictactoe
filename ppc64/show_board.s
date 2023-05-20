# ------------------------------- Description --------------------------------
#
# Display the tictactoe board to the console.
#
# -------------------------------- Parameters --------------------------------
#
# %r6       Address of top row
# %r7       Address of middle row
# %r8       Address of bottom row
#
# ------------------------------ Register Usage ------------------------------
#
# %r4       Used to supply the address of a buffer to 'print' subroutine
# %r5       Used to supply a length to the 'print' subroutine
# %r9       Used to store the address of a row
#
# --------------------------- Memory Manipulation ----------------------------
#
# None
#
# ------------------------------ Return Values -------------------------------
#
# None
#
# ----------------------------------------------------------------------------


.global show_board
.include "macros/la.s"

.data
    column_separator: 
        .asciz "|"
    new_line: 
        .asciz "\n"

.text
show_board:
    mflr    %r0	                
    stw     %r0, 20(%r1)

    # show top row
    mr      %r9, %r6
    bl      display_row

    # show middle row
    mr      %r9, %r7
    bl      display_row

    # show bottom row
    mr      %r9, %r8
    bl      display_row

    lwz     %r0, 20(%r1)
    mtlr    %r0
    blr

display_row:
    # Create new stack frame so that caller's preserved
    # link register doesn't get overwitten.
    stwu    %r1, -16(%r1)       
    mflr    %r0	                
    stw     %r0, 20(%r1)

    # length of each string to print
    li      %r5, 1

    la      %r4, column_separator
    bl      print

    # show column 1
    mr      %r4, %r9
    bl      print

    la      %r4, column_separator
    bl      print

    # show column 2
    mr      %r4, %r9
    addi    %r4, %r4, 1
    bl      print

    la      %r4, column_separator
    bl      print

    # show column 3
    mr      %r4, %r9
    addi    %r4, %r4, 2
    bl      print

    la      %r4, column_separator
    bl      print

    la      %r4, new_line
    bl      print

    lwz     %r0, 20(%r1)
    mtlr    %r0
    addi    %r1, %r1, 16
    blr
