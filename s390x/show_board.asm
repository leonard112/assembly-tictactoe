# Parameters
# %r0 (Address of top row)
# %r6 (Address of middle row)
# %r7 (Address of bottom row)

.globl show_board

.data
.p2align 4
    column_separator: 
        .asciz "|"
        .p2align 1
    new_line: 
        .asciz "\n"
        .p2align 1

.text
.p2align 4
show_board:
    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    # show top row
    lgr %r8, %r5
    brasl %r14, display_row

    # show middle row
    lgr %r8, %r6
    brasl %r14, display_row

    # show bottom row
    lgr %r8, %r7
    brasl %r14, display_row

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14


display_row:
    # Parameters:
    # %r8 (Address of row)

    # preserve return address on stack
    aghi %r15, -8
	stg	%r14, 0(%r15)

    # length of each string to print
    lghi %r4, 1

    larl %r3, column_separator
    brasl %r14, print

    # show column 1
    lgr %r3, %r8
    brasl %r14, print

    larl %r3, column_separator
    brasl %r14, print

    # show column 2
    lgr %r3, %r8
    aghi %r3, 1
    brasl %r14, print

    larl %r3, column_separator
    brasl %r14, print

    # show column 3
    lgr %r3, %r8
    aghi %r3, 2
    brasl %r14, print

    larl %r3, column_separator
    brasl %r14, print

    larl %r3, new_line
    brasl %r14, print

    # restore return address from stack and return
    lg	%r14, 0(%r15)
    aghi %r15, 8	
	br %r14
