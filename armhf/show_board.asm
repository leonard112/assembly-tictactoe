// Parameters:
// r3 (Address of top row)
// r4 (Address of middle row)
// r5 (Address of bottem row)

.global show_board

.data
    column_separator: .asciz "|"
    new_line: .asciz "\n"

.text
show_board:
    push {lr}

    // show top row
    mov r6, r3
    bl display_row

    // show middle row
    mov r6, r4
    bl display_row

    // show bottom row
    mov r6, r5
    bl display_row	

    pop {lr}
    bx lr

display_row:
    // Parameters:
    // r6 (Address or row)

    push {lr}

    mov r2, #1
    
    ldr r1, =column_separator
    bl print
    
    // show column 1
    mov r1, r6
    bl print

    ldr r1, =column_separator
    bl print

    // show column 2
    mov r1, r6
    add r1, r1, #1
    bl print

    ldr r1, =column_separator
    bl print

    // show column 3
    mov r1, r6
    add r1, r1, #2
    bl print

    ldr r1, =column_separator
    bl print

    ldr r1, =new_line
    bl print
    
    pop {lr}
    bx lr
