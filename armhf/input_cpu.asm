// Parameters:
// r3 (Address of user input buffer)
// r4 (Address of first row)
// r5 (Address of second row)
// r6 (address of third row)

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
    push {lr}

    mov r0, #10
    strb r0, [r3, #3]               // set new line as input terminator

find_row_1_win:
    ldr r8, [r4]                    // row 1
    mov r0, #49
    strb r0, [r3]
    bl find_row_win

find_row_2_win:
    ldr r8, [r5]                    // row 2
    mov r0, #50
    strb r0, [r3]
    bl find_row_win

find_row_3_win:
    ldr r8, [r6]                    // row 3
    mov r0, #51
    strb r0, [r3]
    bl find_row_win

    b find_col_1_win

find_row_win:
    push {lr}
    ldr r9, =o_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    ldr r9, =o_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    ldr r9, =o_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    pop {lr}
    bx lr

find_col_1_win:
    ldr r8, =col_diag_tmp
    mov r0, #49
    strb r0, [r3, #2]
    ldrb r9, [r4]                  // row 1
    strb r9, [r8]                  
    ldrb r9, [r5]                  // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6]                  // row 3
    strb r9, [r8, #2]
    bl find_col_win

find_col_2_win:
    ldr r8, =col_diag_tmp
    mov r0, #50
    strb r0, [r3, #2]
    ldrb r9, [r4, #1]              // row 1
    strb r9, [r8]
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #1]              // row 3
    strb r9, [r8, #2]
    bl find_col_win

find_col_3_win:
    ldr r8, =col_diag_tmp
    mov r0, #51
    strb r0, [r3, #2]
    ldrb r9, [r4, #2]              // row 1
    strb r9, [r8]
    ldrb r9, [r5, #2]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #2]              // row 3
    strb r9, [r8, #2]
    bl find_col_win

    b find_backward_diag_win

find_col_win:
    push {lr}
    ldr r8, [r8]
    ldr r9, =o_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    ldr r9, =o_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    ldr r9, =o_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    pop {lr}
    bx lr

find_backward_diag_win:
    ldr r8, =col_diag_tmp
    ldrb r9, [r4]                  // row 1
    strb r9, [r8]                  
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #2]              // row 3
    strb r9, [r8, #2]
    ldr r8, [r8]
    ldr r9, =o_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =o_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =o_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
find_forward_diag_win:
    ldr r8, =col_diag_tmp
    ldrb r9, [r4, #2]              // row 1
    strb r9, [r8]                  
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6]                  // row 3
    strb r9, [r8, #2]
    ldr r8, [r8]
    ldr r9, =o_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =o_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =o_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq return

stop_row_1_win:
    ldr r8, [r4]                    // row 1
    mov r0, #49
    strb r0, [r3]
    bl stop_row_win

stop_row_2_win:
    ldr r8, [r5]                    // row 2
    mov r0, #50
    strb r0, [r3]
    bl stop_row_win

stop_row_3_win:
    ldr r8, [r6]                    // row 3
    mov r0, #51
    strb r0, [r3]
    bl stop_row_win

    b stop_col_1_win

stop_row_win:
    push {lr}
    ldr r9, =x_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    ldr r9, =x_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    ldr r9, =x_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq pop_return
    pop {lr}
    bx lr

stop_col_1_win:
    ldr r8, =col_diag_tmp
    mov r0, #49
    strb r0, [r3, #2]
    ldrb r9, [r4]                  // row 1
    strb r9, [r8]                  
    ldrb r9, [r5]                  // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6]                  // row 3
    strb r9, [r8, #2]
    bl stop_col_win

stop_col_2_win:
    ldr r8, =col_diag_tmp
    mov r0, #50
    strb r0, [r3, #2]
    ldrb r9, [r4, #1]              // row 1
    strb r9, [r8]
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #1]              // row 3
    strb r9, [r8, #2]
    bl stop_col_win

stop_col_3_win:
    ldr r8, =col_diag_tmp
    mov r0, #51
    strb r0, [r3, #2]
    ldrb r9, [r4, #2]              // row 1
    strb r9, [r8]
    ldrb r9, [r5, #2]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #2]              // row 3
    strb r9, [r8, #2]
    bl stop_col_win

    b stop_backward_diag_win

stop_col_win:
    push {lr}
    ldr r8, [r8]
    ldr r9, =x_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    ldr r9, =x_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    ldr r9, =x_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    cmp r8, r9
    beq pop_return
    pop {lr}
    bx lr

stop_backward_diag_win:
    ldr r8, =col_diag_tmp
    ldrb r9, [r4]                  // row 1
    strb r9, [r8]                  
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6, #2]              // row 3
    strb r9, [r8, #2]
    ldr r8, [r8]
    ldr r9, =x_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =x_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =x_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
stop_forward_diag_win:
    ldr r8, =col_diag_tmp
    ldrb r9, [r4, #2]              // row 1
    strb r9, [r8]                  
    ldrb r9, [r5, #1]              // row 2
    strb r9, [r8, #1]
    ldrb r9, [r6]                  // row 3
    strb r9, [r8, #2]
    ldr r8, [r8]
    ldr r9, =x_win_1
    ldr r9, [r9]
    mov r0, #49
    strb r0, [r3]
    mov r0, #51
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =x_win_2
    ldr r9, [r9]
    mov r0, #50
    strb r0, [r3]
    mov r0, #50
    strb r0, [r3, #2]
    cmp r8, r9
    beq return
    ldr r9, =x_win_3
    ldr r9, [r9]
    mov r0, #51
    strb r0, [r3]
    mov r0, #49
    strb r0, [r3, #2]
    cmp r8, r9
    beq return

take_middle_space:
    ldrb r0, [r5, #1]
    cmp r0, #32
    bne take_random_space
    bl random
    cmp r0, #0
    bne take_random_space
    mov r0, #50
    strb r0, [r3]
    strb r0, [r3, #2]
    b return

take_random_space:
    bl random
    cmp r0, #0
    beq take_random_row_1
    cmp r0, #1
    beq take_random_row_2
    cmp r0, #2
    beq take_random_row_3

take_random_row_1:
    mov r0, #49
    strb r0, [r3]
    mov r8, r4                      // row 1
    b take_random_row_space

take_random_row_2:
    mov r0, #50
    strb r0, [r3]
    mov r8, r5                      // row 2
    b take_random_row_space

take_random_row_3:
    mov r0, #51
    strb r0, [r3]
    mov r8, r6                      // row 3

take_random_row_space:
    bl random
    add r8, r8, r0
    ldrb r8, [r8]                   
    cmp r8, #32
    bne take_random_space
    add r0, r0, #49                 // convert to ascii
    strb r0, [r3, #2]

return:
    pop {lr}
    bx lr

pop_return:
    pop {lr}
    b return
