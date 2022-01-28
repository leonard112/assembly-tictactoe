// Parameters:
// x3 (Address of top row)
// x4 (Address of middle row)
// x5 (Address of bottem row)

.global show_board

.data
    column_separator: .asciz "|"
    new_line: .asciz "\n"

.text
show_board:
    // show top row
    mov x6, x3
    bl display_row

    // show middle row
    mov x6, x4
    bl display_row

    // show bottom row
    mov x6, x5
    bl display_row	

    ret

display_row:
    // Parameters:
    // r6 (Address or row)

    mov x2, #1
    
    ldr x1, =column_separator
    bl print
    
    // show column 1
    mov x1, x6
    bl print

    ldr x1, =column_separator
    bl print

    // show column 2
    mov x1, x6
    add x1, x1, #1
    bl print

    ldr x1, =column_separator
    bl print

    // show column 3
    mov x1, x6
    add x1, x1, #2
    bl print

    ldr x1, =column_separator
    bl print

    ldr x1, =new_line
    bl print
    
    ret
