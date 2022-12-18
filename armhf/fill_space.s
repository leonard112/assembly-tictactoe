// ------------------------------- Description -------------------------------
//
// Fill a cell on the board based input specified by the caller.
//
// ------------------------------- Parameters --------------------------------
//
// r0       Address of input buffer
// r1       Address of current player symbol
// r2       Address of first row
// r3       Address of second row
// r4       address of third row
//
// ----------------------------- Register Usage ------------------------------
//
// r5       Used for byte comparisons
// r6       Used for row addresses
// r7       Used to store current player symbol
// r8       Used to load cell values from rows
//
// --------------------------- Memory Manipulation ---------------------------
//
// One of the cells in the tictactoe board will be changed if the subroutine
// is successful.
//
// ------------------------------ Return Values ------------------------------
//
// r0       Boolean indicator of whether subroutine was successful
//
// ---------------------------------------------------------------------------

.global fill_space

.data
    bad_row_col_message: 
        .asciz "\n\033[31mBad row and column specificed.\n\tSyntax: <row> <col>\n\t<row> and <col> may only be integers within the range 1-3.\n\tCells that are already occupied may not be specified.\033[0m\n\n"
    bad_row_col_message_length: 
        .word 178

.text
fill_space:
    push    {lr}
    
    ldrb    r5, [r0, #1]
    cmp     r5, #32		        // ensure row and colum are delimited with space
    bne     bad_row_col

    ldrb    r5, [r0, #3]
    cmp     r5, #10		        // ensure user input is only 4 bytes long (byte 4 is new line character)
    bne     bad_row_col	

    ldrb    r5, [r0]
    cmp     r5, #49		        // did user specify row '1'?
    beq     set_row_1
    cmp     r5, #50		        // did user specify row '2'?
    beq     set_row_2
    cmp     r5, #51		        // did sure specify row '3'?
    beq     set_row_3
    b       bad_row_col

fill_column:
    ldrb    r5, [r0, #2]
    ldrb    r7, [r1]
    cmp     r5, #49		        // did user specify row '1'?
    beq     set_col_1
    cmp     r5, #50		        // did user specify row '2'?
    beq     set_col_2
    cmp     r5, #51		        // did user specify now '3'?
    beq     set_col_3
    b       bad_row_col

set_row_1:
    mov     r6, r2
    b       fill_column

set_row_2:
    mov     r6, r3
    b       fill_column

set_row_3:
    mov     r6, r4
    b       fill_column
    
set_col_1:
    ldrb    r8, [r6]
    cmp     r8, #32		        // return if column already contains a value
    bne     bad_row_col
    strb    r7, [r6]
    b       return_success
    
set_col_2:
    ldrb    r8, [r6, #1]
    cmp     r8, #32		        // return if column already contains a value
    bne     bad_row_col
    strb    r7, [r6, #1]
    b       return_success

set_col_3:
    ldrb    r8, [r6, #2]
    cmp     r8, #32		        // return if column already contains a value
    bne     bad_row_col
    strb    r7, [r6, #2]
    b       return_success

bad_row_col:
    ldr     r1, =bad_row_col_message
    ldr     r2, =bad_row_col_message_length
    ldr     r2, [r2]
    bl      print
    b       return_error

return_error:
    mov     r0, #1		        // set error return code
    b       return

return_success:
    mov     r0, #0
    b       return

return:
    pop     {lr}
    bx      lr
