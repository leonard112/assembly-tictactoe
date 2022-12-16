global input_cpu
extern random
extern print

section .data
    col_diag_tmp db "    "

section .text
input_cpu:
    push ebp            
    mov ebp, esp

    mov ecx, [ebp+8]                            ; input buffer
    mov byte [ecx+3], byte `\n`                 ; set new line as input terminator

find_row_1_win:
    mov ebx, [ebp+12]                           ; row 1
    mov byte [ecx], byte "1"
    jmp find_row_win
find_row_2_win:
    mov ebx, [ebp+16]                           ; row 2
    mov byte [ecx], byte "2"
    jmp find_row_win
find_row_3_win:
    mov ebx, [ebp+20]                           ; row 3
    mov byte [ecx], byte "3"

find_row_win:
    mov byte [ecx+2], byte "1"
    cmp dword [ebx], dword " OO "
    je return
    mov byte [ecx+2], byte "2"
    cmp dword [ebx], dword "O O "
    je return
    mov byte [ecx+2], byte "3"
    cmp dword [ebx], dword "OO  "
    je return
    cmp byte [ecx], byte "1"
    je find_row_2_win
    cmp byte [ecx], byte "2"
    je find_row_3_win

find_col_1_win:
    mov byte [ecx+2], byte "1"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx]
    mov byte [col_diag_tmp+2], bl
    jmp find_col_win
find_col_2_win:
    mov byte [ecx+2], byte "2"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+1]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+2], bl
    jmp find_col_win
find_col_3_win:
    mov byte [ecx+2], byte "3"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+2]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+2], bl

find_col_win:
    mov byte [ecx], byte "1"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [ecx], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [ecx], byte "3"
    cmp dword [col_diag_tmp], dword "OO  "
    je return
    cmp byte [ecx+2], byte "1"
    je find_col_2_win
    cmp byte [ecx+2], byte "2"
    je find_col_3_win

find_backward_diag_win:
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+2], bl
    mov byte [ecx], byte "1"
    mov byte [ecx+2], byte "1"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [ecx], byte "2"
    mov byte [ecx+2], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [ecx], byte "3"
    mov byte [ecx+2], byte "3"
    cmp dword [col_diag_tmp], dword "OO  "
    je return
find_forward_diag_win:
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+2]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx]
    mov byte [col_diag_tmp+2], bl
    mov byte [ecx], byte "1"
    mov byte [ecx+2], byte "3"
    cmp dword [col_diag_tmp], dword " OO "
    je return
    mov byte [ecx], byte "2"
    mov byte [ecx+2], byte "2"
    cmp dword [col_diag_tmp], dword "O O "
    je return
    mov byte [ecx], byte "3"
    mov byte [ecx+2], byte "1"
    cmp dword [col_diag_tmp], dword "OO  "
    je return

stop_row_1_win:
    mov ebx, [ebp+12]                           ; row 1
    mov byte [ecx], byte "1"
    jmp stop_row_win
stop_row_2_win:
    mov ebx, [ebp+16]                           ; row 2
    mov byte [ecx], byte "2"
    jmp stop_row_win
stop_row_3_win:
    mov ebx, [ebp+20]                           ; row 3
    mov byte [ecx], byte "3"
    jmp stop_row_win

stop_row_win:
    mov byte [ecx+2], byte "1"
    cmp dword [ebx], dword " XX "
    je return
    mov byte [ecx+2], byte "2"
    cmp dword [ebx], dword "X X "
    je return
    mov byte [ecx+2], byte "3"
    cmp dword [ebx], dword "XX  "
    je return
    cmp byte [ecx], byte "1"
    je stop_row_2_win
    cmp byte [ecx], byte "2"
    je stop_row_3_win

stop_col_1_win:
    mov byte [ecx+2], byte "1"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx]
    mov byte [col_diag_tmp+2], bl
    jmp stop_col_win
stop_col_2_win:
    mov byte [ecx+2], byte "2"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+1]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+2], bl
    jmp stop_col_win
stop_col_3_win:
    mov byte [ecx+2], byte "3"
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+2]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+2], bl

stop_col_win:
    mov byte [ecx], byte "1"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [ecx], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [ecx], byte "3"
    cmp dword [col_diag_tmp], dword "XX  "
    je return
    cmp byte [ecx+2], byte "1"
    je stop_col_2_win
    cmp byte [ecx+2], byte "2"
    je stop_col_3_win

stop_backward_diag_win:
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx+2]
    mov byte [col_diag_tmp+2], bl
    mov byte [ecx], byte "1"
    mov byte [ecx+2], byte "1"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [ecx], byte "2"
    mov byte [ecx+2], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [ecx], byte "3"
    mov byte [ecx+2], byte "3"
    cmp dword [col_diag_tmp], dword "XX  "
    je return
stop_forward_diag_win:
    mov ebx, [ebp+12]                           ; row 1
    mov bl, [ebx+2]
    mov byte [col_diag_tmp], bl
    mov ebx, [ebp+16]                           ; row 2
    mov bl, [ebx+1]
    mov byte [col_diag_tmp+1], bl
    mov ebx, [ebp+20]                           ; row 3
    mov bl, [ebx]
    mov byte [col_diag_tmp+2], bl
    mov byte [ecx], byte "1"
    mov byte [ecx+2], byte "3"
    cmp dword [col_diag_tmp], dword " XX "
    je return
    mov byte [ecx], byte "2"
    mov byte [ecx+2], byte "2"
    cmp dword [col_diag_tmp], dword "X X "
    je return
    mov byte [ecx], byte "3"
    mov byte [ecx+2], byte "1"
    cmp dword [col_diag_tmp], dword "XX  "
    je return

take_middle_space:
    mov ebx, [ebp+16]                           ; row 2
    cmp byte [ebx+1], byte " "
    jne take_random_space
    call random                                 ; randomize this move to create unpredictability
    cmp eax, 0
    jne take_random_space
    mov ecx, [ebp+8]                            ; input buffer
    mov dword [ecx], dword `2 2\n`
    jmp return

take_random_space:
    call random
    mov ecx, [ebp+8]                            ; input buffer
    cmp eax, 0
    je take_random_row_1
    cmp eax, 1
    je take_random_row_2
    cmp eax, 2
    je take_random_row_3

take_random_row_1:
    mov byte [ecx], byte "1"
    jmp take_random_row_space

take_random_row_2:
    mov byte [ecx], byte "2"
    jmp take_random_row_space

take_random_row_3:
    mov byte [ecx], byte "3"

take_random_row_space:
    call random
    mov ecx, [ebp+8]                            ; input buffer
    mov ebx, [ebp+12]                           ; row 1
    cmp byte [ecx], byte "1"
    je take_column
    mov ebx, [ebp+16]                           ; row 2
    cmp byte [ecx], byte "2"
    je take_column
    mov ebx, [ebp+20]                           ; row 3

take_column:
    add ebx, eax
    cmp byte [ebx], byte " "
    jne take_random_space
    add eax, 49                                 ; convert number to ascii
    mov byte [ecx+2], al                        ; store ascii column

return:
    mov esp, ebp        
    pop ebp             
    ret 