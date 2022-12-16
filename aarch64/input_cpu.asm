// Parameters:
// x3 (Address of user input buffer)
// x4 (Address of first row)
// x5 (Address of second row)
// x6 (address of third row)

.global input_cpu

.data
    col_diag_tmp: .asciz "    "
    o_win_1: .asciz " OO "
    o_win_2: .asciz "O O "
    o_win_3: .asciz "OO  "
    x_win_1: .asciz " XX "
    x_win_2: .asciz "X X "
    x_win_3: .asciz "XX  "

.text
input_cpu:
    stp x29, x30, [sp, #-16]!

    mov x0, #10
    strb w0, [x3, #3]               // set new line as input terminator

find_row_1_win:
    ldr w9, [x4]                    // row 1
    mov x0, #49
    strb w0, [x3]
    bl find_row_win

find_row_2_win:
    ldr w9, [x5]                    // row 2
    mov x0, #50
    strb w0, [x3]
    bl find_row_win

find_row_3_win:
    ldr w9, [x6]                    // row 3
    mov x0, #51
    strb w0, [x3]
    bl find_row_win

    b find_col_1_win

find_row_win:
    ldr w10, =o_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ret

find_col_1_win:
    ldr w9, =col_diag_tmp
    mov x0, #49
    strb w0, [x3, #2]
    ldrb w10, [x4]                  // row 1
    strb w10, [x9]                  
    ldrb w10, [x5]                  // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6]                  // row 3
    strb w10, [x9, #2]
    bl find_col_win

find_col_2_win:
    ldr w9, =col_diag_tmp
    mov x0, #50
    strb w0, [x3, #2]
    ldrb w10, [x4, #1]              // row 1
    strb w10, [x9]
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #1]              // row 3
    strb w10, [x9, #2]
    bl find_col_win

find_col_3_win:
    ldr w9, =col_diag_tmp
    mov x0, #51
    strb w0, [x3, #2]
    ldrb w10, [x4, #2]              // row 1
    strb w10, [x9]
    ldrb w10, [x5, #2]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #2]              // row 3
    strb w10, [x9, #2]
    bl find_col_win

    b find_backward_diag_win

find_col_win:
    ldr w9, [x9]
    ldr w10, =o_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    cmp w9, w10
    beq return
    ldr w10, =o_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    cmp w9, w10
    beq return
    ldr w10, =o_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    cmp w9, w10
    beq return
    ret

find_backward_diag_win:
    ldr w9, =col_diag_tmp
    ldrb w10, [x4]                  // row 1
    strb w10, [x9]                  
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #2]              // row 3
    strb w10, [x9, #2]
    ldr w9, [x9]
    ldr w10, =o_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
find_forward_diag_win:
    ldr w9, =col_diag_tmp
    ldrb w10, [x4, #2]              // row 1
    strb w10, [x9]                  
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6]                  // row 3
    strb w10, [x9, #2]
    ldr w9, [x9]
    ldr w10, =o_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =o_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return

stop_row_1_win:
    ldr w9, [x4]                    // row 1
    mov x0, #49
    strb w0, [x3]
    bl stop_row_win

stop_row_2_win:
    ldr w9, [x5]                    // row 2
    mov x0, #50
    strb w0, [x3]
    bl stop_row_win

stop_row_3_win:
    ldr w9, [x6]                    // row 3
    mov x0, #51
    strb w0, [x3]
    bl stop_row_win

    b stop_col_1_win

stop_row_win:
    ldr w10, =x_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ret

stop_col_1_win:
    ldr w9, =col_diag_tmp
    mov x0, #49
    strb w0, [x3, #2]
    ldrb w10, [x4]                  // row 1
    strb w10, [x9]                  
    ldrb w10, [x5]                  // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6]                  // row 3
    strb w10, [x9, #2]
    bl stop_col_win

stop_col_2_win:
    ldr w9, =col_diag_tmp
    mov x0, #50
    strb w0, [x3, #2]
    ldrb w10, [x4, #1]              // row 1
    strb w10, [x9]
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #1]              // row 3
    strb w10, [x9, #2]
    bl stop_col_win

stop_col_3_win:
    ldr w9, =col_diag_tmp
    mov x0, #51
    strb w0, [x3, #2]
    ldrb w10, [x4, #2]              // row 1
    strb w10, [x9]
    ldrb w10, [x5, #2]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #2]              // row 3
    strb w10, [x9, #2]
    bl stop_col_win

    b stop_backward_diag_win

stop_col_win:
    ldr w9, [x9]
    ldr w10, =x_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    cmp w9, w10
    beq return
    ldr w10, =x_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    cmp w9, w10
    beq return
    ldr w10, =x_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    cmp w9, w10
    beq return
    ret

stop_backward_diag_win:
    ldr w9, =col_diag_tmp
    ldrb w10, [x4]                  // row 1
    strb w10, [x9]                  
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6, #2]              // row 3
    strb w10, [x9, #2]
    ldr w9, [x9]
    ldr w10, =x_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
stop_forward_diag_win:
    ldr w9, =col_diag_tmp
    ldrb w10, [x4, #2]              // row 1
    strb w10, [x9]                  
    ldrb w10, [x5, #1]              // row 2
    strb w10, [x9, #1]
    ldrb w10, [x6]                  // row 3
    strb w10, [x9, #2]
    ldr w9, [x9]
    ldr w10, =x_win_1
    ldr w10, [x10]
    mov x0, #49
    strb w0, [x3]
    mov x0, #51
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_2
    ldr w10, [x10]
    mov x0, #50
    strb w0, [x3]
    mov x0, #50
    strb w0, [x3, #2]
    cmp w9, w10
    beq return
    ldr w10, =x_win_3
    ldr w10, [x10]
    mov x0, #51
    strb w0, [x3]
    mov x0, #49
    strb w0, [x3, #2]
    cmp w9, w10
    beq return

take_middle_space:
    ldrb w0, [x5, #1]
    cmp w0, #32
    bne take_random_space
    bl random
    cmp w0, 0
    bne take_random_space
    mov x0, #50
    strb w0, [x3]
    strb w0, [x3, #2]
    b return

take_random_space:
    bl random
    cmp w0, 0
    beq take_random_row_1
    cmp w0, 1
    beq take_random_row_2
    cmp w0, 2
    beq take_random_row_3

take_random_row_1:
    mov x0, #49
    strb w0, [x3]
    mov x9, x4                      // row 1
    b take_random_row_space

take_random_row_2:
    mov x0, #50
    strb w0, [x3]
    mov x9, x5                      // row 2
    b take_random_row_space

take_random_row_3:
    mov x0, #51
    strb w0, [x3]
    mov x9, x6                      // row 3

take_random_row_space:
    bl random
    add w9, w9, w0
    ldrb w9, [x9]                   
    cmp w9, #32
    bne take_random_space
    add w0, w0, #49                 // convert to ascii
    strb w0, [x3, #2]

return:
    ldp x29, x30, [sp], #16
    ret
