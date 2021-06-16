global fill_space

fill_space:
    push ebp            
    mov ebp, esp

    mov eax, [ebp+8]    ; user input
    mov ebx, [ebp+12]   ; player symbol

    ; set row
    cmp eax, 0x31
    je set_row_1
    cmp eax, 0x32
    je set_row_2
    cmp eax, 0x33
    je set_row_3

fill_column:
    cmp byte [eax+2], 0x31
    je set_col_1
    cmp byte [eax+2], 0x32
    je set_col_2
    cmp byte [eax+2], 0x33
    je set_col_3

return:
    mov esp, ebp        
    pop ebp             
    ret 

set_row_1:
    mov ecx, [ebp+16]
    jmp fill_column

set_row_2:
    mov ecx, [ebp+20]
    jmp fill_column

set_row_3:
    mov ecx, [ebp+24]
    jmp fill_column

set_col_1:
    add [ecx], ebx
    jmp return

set_col_2:
    add [ecx+1], ebx
    jmp return

set_col_3:
    add [ecx+2], ebx
    jmp return