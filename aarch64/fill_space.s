// ------------------------------- Description -------------------------------
//
// Fill a cell on the board based on input provided by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// x0       Address of input buffer
// x1       Address of current player symbol
// x2       Address of first row
// x3       Address of second row
// x4       address of third row
//
// ----------------------------- Register Usage ------------------------------
//
// w5       Used for byte comparisons
// x6       Used for row addresses
// w7       Used to store current player symbol
// w8       Used to load cell values from rows
//
// --------------------------- Memory Manipulation ---------------------------
//
// One of the cells in the tictactoe board will be changed if the subroutine
// is successful.
//
// ------------------------------ Return Values ------------------------------
//
// x0       Boolean indicator of whether subroutine was successful
//
// ---------------------------------------------------------------------------


.global fill_space

.data
    bad_row_col_message: 
        .asciz "\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n"
    bad_row_col_message_length = . - bad_row_col_message

.text
fill_space:
    stp     x29, x30, [sp, -16]!

    ldrb    w5, [x0, 1]
    cmp     w5, 32		        // ensure row and column are delimited with space
    bne     bad_row_col

    ldrb    w5, [x0, 3]
    cmp     w5, 10		        // ensure input is only 4 bytes long (ascii 10 is new line character)
    bne     bad_row_col	

    ldrb    w5, [x0]
    cmp     w5, 49		        // did player specify row '1'?
    beq     set_row_1
    cmp     w5, 50		        // did player specify row '2'?
    beq     set_row_2
    cmp     w5, 51		        // did player specify row '3'?
    beq     set_row_3
    b       bad_row_col

set_row_1:
    mov     x6, x2
    b       fill_column

set_row_2:
    mov     x6, x3
    b       fill_column

set_row_3:
    mov     x6, x4
    b       fill_column

fill_column:
    ldrb    w5, [x0, 2]
    ldrb    w7, [x1]
    cmp     w5, 49		        // did player specify row '1'?
    beq     set_col_1
    cmp     w5, 50		        // did player specify row '2'?
    beq     set_col_2
    cmp     w5, 51		        // did player specify now '3'?
    beq     set_col_3
    b       bad_row_col
    
set_col_1:
    ldrb    w8, [x6]
    cmp     w8, 32		        // return if column already contains a value
    bne     bad_row_col
    strb    w7, [x6]
    b       return_success
    
set_col_2:
    ldrb    w8, [x6, 1]
    cmp     w8, 32		        // return if column already contains a value
    bne     bad_row_col
    strb    w7, [x6, 1]
    b       return_success

set_col_3:
    ldrb    w8, [x6, 2]
    cmp     w8, 32		        // return if column already contains a value
    bne     bad_row_col
    strb    w7, [x6, 2]
    b       return_success

bad_row_col:
    ldr     x1, =bad_row_col_message
    ldr     x2, =bad_row_col_message_length
    bl      print
    b       return_error

return_error:
    mov     x0, 1		        // set error return code
    b       return

return_success:
    mov     x0, 0
    b       return

return:
    ldp     x29, x30, [sp], 16
    ret
