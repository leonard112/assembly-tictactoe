global show_board
extern print

section .data
    column_separator db "|"
    new_line db 0xA

section .text
show_board:
    push ebp            
    mov ebp, esp   

    ; show top row
    mov eax, [ebp+8]
    push eax
    call display_row
    pop eax

    ; show midde row
    mov eax, [ebp+12]
    push eax
    call display_row
    pop eax

    ; show bottom row
    mov eax, [ebp+16]
    push eax
    call display_row
    pop eax

    mov esp, ebp        
    pop ebp             
    ret 

display_row:
    push ebp            
    mov ebp, esp

    push byte 0x1

    push column_separator
    call print
    pop edx

    ; show column 1
    mov eax, [ebp+8]
    push eax
    call print
    pop edx

    push column_separator
    call print
    pop edx

    ; show column 2
    mov eax, [ebp+8]
    add eax, 1
    push eax
    call print
    pop edx

    push column_separator
    call print
    pop edx

    ; show column 3
    mov eax, [ebp+8]
    add eax, 2
    push eax
    call print
    pop edx

    push column_separator
    call print
    pop edx

    push new_line
    call print
    pop edx
    pop edx

    mov esp, ebp        
    pop ebp             
    ret