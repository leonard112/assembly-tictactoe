global input_cpu
extern random

section .data
    col_diag_tmp db "    "

section .text
input_cpu:
    push rbp            
    mov rbp, rsp

    mov rcx, [rbp+16]                           ; input buffer
    mov byte [rcx+3], byte `\n`                 ; set new line as input terminator

find_row_1_win:
    mov rbx, [rbp+24]                           ; row 1
    mov byte [rcx], byte "1"
    jmp find_row_win
find_row_2_win:
    mov rbx, [rbp+32]                           ; row 2
    mov byte [rcx], byte "2"
    jmp find_row_win
find_row_3_win:
    mov rbx, [rbp+40]                           ; row 3
    mov byte [rcx], byte "3"

find_row_win:
    mov byte [rcx+2], byte "1"
    cmp dword [rbx], dword " OO "
    je return
    mov byte [rcx+2], byte "2"
    cmp dword [rbx], dword "O O "
    je return
    mov byte [rcx+2], byte "3"
    cmp dword [rbx], dword "OO  "
    je return
    cmp byte [rcx], byte "1"
    je find_row_2_win
    cmp byte [rcx], byte "2"
    je find_row_3_win

find_col_1_win:
    mov byte [rcx+2], byte "1"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx]
    mov byte [col_diag_tmp+2], bl
    jmp find_col_win
find_col_2_win:
    mov byte [rcx+2], byte "2"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+1]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+2], bl
    jmp find_col_win
find_col_3_win:
    mov byte [rcx+2], byte "3"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+2]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+2], bl

find_col_win:
    mov byte [rcx], byte "1"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [rcx], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [rcx], byte "3"
    cmp dword [col_diag_tmp], dword "OO  "
    je return
    cmp byte [rcx+2], byte "1"
    je find_col_2_win
    cmp byte [rcx+2], byte "2"
    je find_col_3_win

find_backward_diag_win:
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+2], bl
    mov byte [rcx], byte "1"
    mov byte [rcx+2], byte "1"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [rcx], byte "2"
    mov byte [rcx+2], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [rcx], byte "3"
    mov byte [rcx+2], byte "3"
    cmp dword [col_diag_tmp], dword "OO  "
    je return
find_forward_diag_win:
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+2]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx]
    mov byte [col_diag_tmp+2], bl
    mov byte [rcx], byte "1"
    mov byte [rcx+2], byte "3"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [rcx], byte "2"
    mov byte [rcx+2], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [rcx], byte "3"
    mov byte [rcx+2], byte "1"
    cmp dword [col_diag_tmp], dword "OO  "
    je return

stop_row_1_win:
    mov rbx, [rbp+24]                           ; row 1
    mov byte [rcx], byte "1"
    jmp stop_row_win
stop_row_2_win:
    mov rbx, [rbp+32]                           ; row 2
    mov byte [rcx], byte "2"
    jmp stop_row_win
stop_row_3_win:
    mov rbx, [rbp+40]                           ; row 3
    mov byte [rcx], byte "3"
    jmp stop_row_win

stop_row_win:
    mov byte [rcx+2], byte "1"
    cmp dword [rbx], dword " XX "
    je return
    mov byte [rcx+2], byte "2"
    cmp dword [rbx], dword "X X "
    je return
    mov byte [rcx+2], byte "3"
    cmp dword [rbx], dword "XX  "
    je return
    cmp byte [rcx], byte "1"
    je stop_row_2_win
    cmp byte [rcx], byte "2"
    je stop_row_3_win

stop_col_1_win:
    mov byte [rcx+2], byte "1"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx]
    mov byte [col_diag_tmp+2], bl
    jmp stop_col_win
stop_col_2_win:
    mov byte [rcx+2], byte "2"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+1]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+2], bl
    jmp stop_col_win
stop_col_3_win:
    mov byte [rcx+2], byte "3"
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+2]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+2], bl

stop_col_win:
    mov byte [rcx], byte "1"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [rcx], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [rcx], byte "3"
    cmp dword [col_diag_tmp], dword "XX  "
    je return
    cmp byte [rcx+2], byte "1"
    je stop_col_2_win
    cmp byte [rcx+2], byte "2"
    je stop_col_3_win

stop_backward_diag_win:
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx+2]
    mov byte [col_diag_tmp+2], bl
    mov byte [rcx], byte "1"
    mov byte [rcx+2], byte "1"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [rcx], byte "2"
    mov byte [rcx+2], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [rcx], byte "3"
    mov byte [rcx+2], byte "3"
    cmp dword [col_diag_tmp], dword "XX  "
    je return
stop_forward_diag_win:
    mov rbx, [rbp+24]                           ; row 1
    mov bl, [rbx+2]
    mov byte [col_diag_tmp], bl
    mov rbx, [rbp+32]                           ; row 2
    mov bl, [rbx+1]
    mov byte [col_diag_tmp+1], bl
    mov rbx, [rbp+40]                           ; row 3
    mov bl, [rbx]
    mov byte [col_diag_tmp+2], bl
    mov byte [rcx], byte "1"
    mov byte [rcx+2], byte "3"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [rcx], byte "2"
    mov byte [rcx+2], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [rcx], byte "3"
    mov byte [rcx+2], byte "1"
    cmp dword [col_diag_tmp], dword "XX  "
    je return

take_middle_space:
    mov rbx, [rbp+32]                           ; row 2
    cmp byte [rbx+1], byte " "
    jne take_random_space
    call random                                 ; randomize this move to create unpredictability
    cmp rax, 0
    jne take_random_space
    mov rcx, [rbp+16]                           ; input buffer
    mov dword [rcx], dword `2 2\n`
    jmp return

take_random_space:
    call random
    mov rcx, [rbp+16]                           ; input buffer
    cmp rax, 0
    je take_random_row_1
    cmp rax, 1
    je take_random_row_2
    cmp rax, 2
    je take_random_row_3

take_random_row_1:
    mov byte [rcx], byte "1"
    jmp take_random_row_space

take_random_row_2:
    mov byte [rcx], byte "2"
    jmp take_random_row_space

take_random_row_3:
    mov byte [rcx], byte "3"

take_random_row_space:
    call random
    mov rcx, [rbp+16]                           ; input buffer
    mov rbx, [rbp+24]                           ; row 1
    cmp byte [rcx], byte "1"
    je take_column
    mov rbx, [rbp+32]                           ; row 2
    cmp byte [rcx], byte "2"
    je take_column
    mov rbx, [rbp+40]                           ; row 3

take_column:
    add rbx, rax
    cmp byte [rbx], byte " "
    jne take_random_space
    add rax, 49                                 ; convert number to ascii
    mov byte [rcx+2], al                        ; store ascii column

return:
    mov rsp, rbp        
    pop rbp             
    ret 