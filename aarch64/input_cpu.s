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
// x3       Address of user input buffer
// x4       Address of first row
// x5       Address of second row
// x6       Address of third row
//
// ----------------------------- Register Usage ------------------------------
//
// w0-x0    Used for byte comparisons
//          Used for storing data in the input buffer
//          Used for getting random numbers 0-3 from the random subroutine
// w1-x1    Used to store the addresses of the win key buffers
// w9-x9    Used for row addresses
//          Used to store address of 'col_diag_tmp' buffer
// w10      Used to load the contents of the row buffers
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
    stp     x29, x30, [sp, -16]!

    mov     x0, 10
    strb    w0, [x3, 3]                // set new line as input terminator

find_row_win:
    ldr     w1, =o_win_keys
    b       find_stop_row_1_win

find_col_win:
    b       find_stop_col_1_win

find_backward_diag_win:
    b       find_stop_backward_diag_win

stop_row_win:
    ldr     w1, =x_win_keys
    b       find_stop_row_1_win

stop_col_win:
    b       find_stop_col_1_win

stop_backward_diag_win:
    b       find_stop_backward_diag_win

find_stop_row_1_win:
    ldr     w9, [x4]                    // row 1
    mov     x0, 49
    strb    w0, [x3]
    bl      find_stop_row_win

find_stop_row_2_win:
    ldr     w9, [x5]                    // row 2
    mov     x0, 50
    strb    w0, [x3]
    bl      find_stop_row_win

find_stop_row_3_win:
    ldr     w9, [x6]                    // row 3
    mov     x0, 51
    strb    w0, [x3]
    bl      find_stop_row_win

    // check if second byte in win key is O
    ldrb    w0, [x1, 1]
    cmp     w0, 79
    beq     find_col_win                // if O
    b       stop_col_win                // if X

find_stop_row_win:
    // is row ' OO ' or ' XX '?
    ldr     w10, [x1]
    mov     x0, 49
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is row 'O O ' or 'X X '?
    ldr     w10, [x1, 4]
    mov     x0, 50
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is row 'OO  ' or 'XX  '?
    ldr     w10, [x1, 8]
    mov     x0, 51
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return
    ret

find_stop_col_1_win:
    ldr     w9, =col_diag_tmp
    mov     x0, 49
    strb    w0, [x3, 2]

    // build column 1
    ldrb    w10, [x4]                   // row 1
    strb    w10, [x9]

    ldrb    w10, [x5]                   // row 2
    strb    w10, [x9, 1]

    ldrb    w10, [x6]                   // row 3
    strb    w10, [x9, 2]    
    bl      find_stop_col_win

find_stop_col_2_win:
    ldr     w9, =col_diag_tmp
    mov     x0, 50
    strb    w0, [x3, 2]

    // build column 2
    ldrb    w10, [x4, 1]                // row 1
    strb    w10, [x9]

    ldrb    w10, [x5, 1]                // row 2
    strb    w10, [x9, 1]        

    ldrb    w10, [x6, 1]                // row 3
    strb    w10, [x9, 2]
    bl      find_stop_col_win

find_stop_col_3_win:
    ldr     w9, =col_diag_tmp
    mov     x0, 51
    strb    w0, [x3, 2]

    // build column 3
    ldrb    w10, [x4, 2]                // row 1
    strb    w10, [x9]

    ldrb    w10, [x5, 2]                // row 2
    strb    w10, [x9, 1]

    ldrb    w10, [x6, 2]                // row 3
    strb    w10, [x9, 2]
    bl      find_stop_col_win

    // check if second byte in win key is O
    ldrb    w0, [x1, 1]
    cmp     w0, 79
    beq     find_backward_diag_win      // if O
    b       stop_backward_diag_win      // if X

find_stop_col_win:
    ldr     w9, [x9]

    // is column ' OO ' or ' XX '?
    ldr     w10, [x1]
    mov     x0, 49
    strb    w0, [x3]
    cmp     w9, w10
    beq     return

    // is column 'O O ' or 'X X '?
    ldr     w10, [x1, 4]
    mov     x0, 50
    strb    w0, [x3]
    cmp     w9, w10
    beq     return

    // is column 'OO  ' or 'XX  '?
    ldr     w10, [x1, 8]
    mov     x0, 51
    strb    w0, [x3]
    cmp     w9, w10
    beq     return

    ret

find_stop_backward_diag_win:
    ldr     w9, =col_diag_tmp

    // build backward diagonal
    ldrb    w10, [x4]                   // row 1
    strb    w10, [x9]

    ldrb    w10, [x5, 1]                // row 2
    strb    w10, [x9, 1]

    ldrb    w10, [x6, 2]                // row 3
    strb    w10, [x9, 2]

    ldr     w9, [x9]

    // is backward diagonal ' OO ' or ' XX '?
    ldr     w10, [x1]
    mov     x0, 49
    strb    w0, [x3]
    mov     x0, 49
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is backward diagonal 'O O ' or 'X X '?
    ldr     w10, [x1, 4]
    mov     x0, 50
    strb    w0, [x3]
    mov     x0, 50
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is backward diagonal 'OO  ' or 'XX  '?
    ldr     w10, [x1, 8]
    mov     x0, 51
    strb    w0, [x3]
    mov     x0, 51
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

find_stop_forward_diag_win:
    ldr     w9, =col_diag_tmp

    // build forward diagonal
    ldrb    w10, [x4, 2]                // row 1
    strb    w10, [x9]

    ldrb    w10, [x5, 1]                // row 2
    strb    w10, [x9, 1]

    ldrb    w10, [x6]                   // row 3
    strb    w10, [x9, 2]

    ldr     w9, [x9]

    // is forward diagonal ' OO ' or ' XX '?
    ldr     w10, [x1]
    mov     x0, 49
    strb    w0, [x3]
    mov     x0, 51
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is forward diagonal 'O O ' or 'X X '?
    ldr     w10, [x1, 4]
    mov     x0, 50
    strb    w0, [x3]
    mov     x0, 50
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // is forward diagonal 'OO  ' or 'XX  '?
    ldr     w10, [x1, 8]
    mov     x0, 51
    strb    w0, [x3]
    mov     x0, 49
    strb    w0, [x3, 2]
    cmp     w9, w10
    beq     return

    // check if second byte in win key is O
    ldrb    w0, [x1, 1]
    cmp     w0, 79
    beq     stop_row_win                // if O

take_middle_space:
    ldrb    w0, [x5, 1]
    cmp     w0, 32
    bne     take_random_space

    // randomize this move to create unpredictability
    bl      random
    cmp     w0, 0
    bne     take_random_space
    mov     x0, 50
    strb    w0, [x3]
    strb    w0, [x3, 2]
    b       return

take_random_space:
    bl      random
    cmp     w0, 0
    beq     take_random_row_1
    cmp     w0, 1
    beq     take_random_row_2
    cmp     w0, 2
    beq     take_random_row_3

take_random_row_1:
    mov     x0, 49
    strb    w0, [x3]
    mov     x9, x4                      // row 1
    b       take_random_row_space

take_random_row_2:
    mov     x0, 50
    strb    w0, [x3]
    mov     x9, x5                      // row 2
    b       take_random_row_space

take_random_row_3:
    mov     x0, 51
    strb    w0, [x3]
    mov     x9, x6                      // row 3

take_random_row_space:
    bl      random
    add     w9, w9, w0
    ldrb    w9, [x9]                   
    cmp     w9, 32
    bne     take_random_space
    add     w0, w0, 49                  // convert to ascii
    strb    w0, [x3, 2]

return:
    ldp     x29, x30, [sp], 16
    ret
