// ------------------------------- Description -------------------------------
//
// This subroutine is the brains of the computer player that the user plays 
// against. The computer player will specify a row and column in the input 
// buffer that it determines to be strategic to winning or at least preventing 
// the player from winning. If the computer player cannot find a move that
// it considers to be stategic, a random empty cell will be chosen.
//
// ------------------------------- Parameters --------------------------------
//
// r3       Address of user input buffer
// r4       Address of first row
// r5       Address of second row
// r6       Address of third row
//
// ----------------------------- Register Usage ------------------------------
//
// r0       Used for byte comparisons
//          Used for storing data in the input buffer
//          Used for getting random numbers 0-3 from the random subroutine
// r1       Used to store the addresses of the win key buffers
// r8       Used for row addresses
//          Used to store address of 'col_diag_tmp' buffer
// r9       Used to load the contents of the row buffers
//          Used to load 4-byte segments from the win key buffers
//          Used to load bytes into the 'col_diag_tmp' buffer
//
// --------------------------- Memory Manipulation ---------------------------
//
// The input buffer and the local 'col_diag_tmp' buffer should be the only 
// memory that is manipulated by this subroutine.
//
// ------------------------------ Return Values ------------------------------
//
// None
//
// ---------------------------------------------------------------------------


.global input_cpu

.data
    col_diag_tmp: 
        .asciz "    "
    o_win_keys: 
        .asciz " OO O O OO  "
    x_win_keys: 
        .asciz " XX X X XX  "

.text
input_cpu:
    push    {lr}

    mov     r0, #10
    strb    r0, [r3, #3]                // set new line as input terminator

find_row_win:
    ldr     r1, =o_win_keys
    b       find_stop_row_1_win

find_col_win:
    b       find_stop_col_1_win

find_backward_diag_win:
    b       find_stop_backward_diag_win

stop_row_win:
    ldr     r1, =x_win_keys
    b       find_stop_row_1_win

stop_col_win:
    b       find_stop_col_1_win

stop_backward_diag_win:
    b       find_stop_backward_diag_win

find_stop_row_1_win:
    ldr     r8, [r4]                    // row 1
    mov     r0, #49
    strb    r0, [r3]
    bl      find_stop_row_win

find_stop_row_2_win:
    ldr     r8, [r5]                    // row 2
    mov     r0, #50
    strb    r0, [r3]
    bl      find_stop_row_win

find_stop_row_3_win:
    ldr     r8, [r6]                    // row 3
    mov     r0, #51
    strb    r0, [r3]
    bl      find_stop_row_win

    // check if second byte in win key is O
    ldrb    r0, [r1, #1]
    cmp     r0, #79
    beq     find_col_win                // if O
    b       stop_col_win                // if X

find_stop_row_win:
    push    {lr}
    ldr     r9, [r1]

    // is row ' OO ' or ' XX '?
    mov     r0, #49
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     pop_return

    // is row 'O O ' or 'X X '?
    ldr     r9, [r1, #4]
    mov     r0, #50
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     pop_return

    // is row 'OO  ' or 'XX  '?
    ldr     r9, [r1, #8]
    mov     r0, #51
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     pop_return

    pop     {lr}
    bx      lr

find_stop_col_1_win:
    ldr     r8, =col_diag_tmp
    mov     r0, #49
    strb    r0, [r3, #2]

    // build column 1
    ldrb    r9, [r4]                    // row 1
    strb    r9, [r8]

    ldrb    r9, [r5]                    // row 2
    strb    r9, [r8, #1]

    ldrb    r9, [r6]                    // row 3
    strb    r9, [r8, #2]
    bl  find_stop_col_win

find_stop_col_2_win:
    ldr     r8, =col_diag_tmp
    mov     r0, #50
    strb    r0, [r3, #2]

    // build column 2
    ldrb    r9, [r4, #1]                // row 1
    strb    r9, [r8]

    ldrb    r9, [r5, #1]                // row 2
    strb    r9, [r8, #1]

    ldrb    r9, [r6, #1]                // row 3
    strb    r9, [r8, #2]
    bl      find_stop_col_win

find_stop_col_3_win:
    ldr     r8, =col_diag_tmp
    mov     r0, #51
    strb    r0, [r3, #2]

    // build column 3
    ldrb    r9, [r4, #2]                // row 1
    strb    r9, [r8]

    ldrb    r9, [r5, #2]                // row 2
    strb    r9, [r8, #1]

    ldrb    r9, [r6, #2]                // row 3
    strb    r9, [r8, #2]
    bl      find_stop_col_win

    // check if second byte in win key is O
    ldrb    r0, [r1, #1]
    cmp     r0, #79
    beq     find_backward_diag_win      // if O
    b       stop_backward_diag_win      // if X

find_stop_col_win:
    push    {lr}

    ldr     r8, [r8]

    // is column ' OO ' or ' XX '?
    ldr     r9, [r1]
    mov     r0, #49
    strb    r0, [r3]
    cmp     r8, r9
    beq     pop_return

    // is column 'O O ' or 'X X '?
    ldr     r9, [r1, #4]
    mov     r0, #50
    strb    r0, [r3]
    cmp     r8, r9
    beq     pop_return

    // is column 'OO  ' or 'XX  '?
    ldr     r9, [r1, #8]
    mov     r0, #51
    strb    r0, [r3]
    cmp     r8, r9
    beq     pop_return

    pop     {lr}
    bx      lr

find_stop_backward_diag_win:
    ldr     r8, =col_diag_tmp

    // build backward diagonal
    ldrb    r9, [r4]                    // row 1
    strb    r9, [r8]

    ldrb    r9, [r5, #1]                // row 2
    strb    r9, [r8, #1]

    ldrb    r9, [r6, #2]                // row 3
    strb    r9, [r8, #2]

    ldr     r8, [r8]

    // is backward diagonal ' OO ' or ' XX '?
    ldr     r9, [r1]
    mov     r0, #49
    strb    r0, [r3]
    mov     r0, #49
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

    // is backward diagonal 'O O ' or 'X X '?
    ldr     r9, [r1, #4]
    mov     r0, #50
    strb    r0, [r3]
    mov     r0, #50
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

    // is backward diagonal 'OO  ' or 'XX  '?
    ldr     r9, [r1, #8]
    mov     r0, #51
    strb    r0, [r3]
    mov     r0, #51
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

find_forward_diag_win:
    ldr     r8, =col_diag_tmp

    // build forward diagonal
    ldrb    r9, [r4, #2]                // row 1
    strb    r9, [r8]

    ldrb    r9, [r5, #1]                // row 2
    strb    r9, [r8, #1]

    ldrb    r9, [r6]                    // row 3
    strb    r9, [r8, #2]

    ldr     r8, [r8]

    // is forward diagonal ' OO ' or ' XX '?
    ldr     r9, [r1]
    mov     r0, #49
    strb    r0, [r3]
    mov     r0, #51
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

    // is forward diagonal 'O O ' or 'X X '?
    ldr     r9, [r1, #4]
    mov     r0, #50
    strb    r0, [r3]
    mov     r0, #50
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

    // is forward diagonal 'OO  ' or 'XX  '?
    ldr     r9, [r1, #8]
    mov     r0, #51
    strb    r0, [r3]
    mov     r0, #49
    strb    r0, [r3, #2]
    cmp     r8, r9
    beq     return

    // check if second byte in win key is O
    ldrb    r0, [r1, #1]
    cmp     r0, #79
    beq     stop_row_win                // if O

take_middle_space:
    ldrb    r0, [r5, #1]
    cmp     r0, #32
    bne     take_random_space

    // randomize this move to create unpredictability
    bl      random
    cmp     r0, #0
    bne     take_random_space
    mov     r0, #50
    strb    r0, [r3]
    strb    r0, [r3, #2]
    b   return

take_random_space:
    bl      random
    cmp     r0, #0
    beq     take_random_row_1
    cmp     r0, #1
    beq     take_random_row_2
    cmp     r0, #2
    beq     take_random_row_3

take_random_row_1:
    mov     r0, #49
    strb    r0, [r3]
    mov     r8, r4                      // row 1
    b       take_random_row_space

take_random_row_2:
    mov     r0, #50
    strb    r0, [r3]
    mov     r8, r5                      // row 2
    b   take_random_row_space

take_random_row_3:
    mov     r0, #51
    strb    r0, [r3]
    mov     r8, r6                      // row 3

take_random_row_space:
    bl      random
    add     r8, r8, r0
    ldrb    r8, [r8]                   
    cmp     r8, #32
    bne     take_random_space
    add     r0, r0, #49                 // convert to ascii
    strb    r0, [r3, #2]

return:
    pop     {lr}
    bx      lr

pop_return:
    pop     {lr}
    b       return
