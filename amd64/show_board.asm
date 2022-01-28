global show_board
extern print

section .data
    column_separator db "|"
    new_line db `\n`

section .text
show_board:
    push rbp            
    mov rbp, rsp   

    ; show top row
    mov rax, [rbp+16]
    push rax
    call display_row
    pop rax

    ; show midde row
    mov rax, [rbp+24]
    push rax
    call display_row
    pop rax

    ; show bottom row
    mov rax, [rbp+32]
    push rax
    call display_row
    pop rax

    mov rsp, rbp        
    pop rbp             
    ret 

display_row:
    push rbp            
    mov rbp, rsp

    push byte 1

    push column_separator
    call print
    pop rdx

    ; show column 1
    mov rax, [rbp+16]
    push rax
    call print
    pop rdx

    push column_separator
    call print
    pop rdx

    ; show column 2
    mov rax, [rbp+16]
    add rax, 1
    push rax
    call print
    pop rdx

    push column_separator
    call print
    pop rdx

    ; show column 3
    mov rax, [rbp+16]
    add rax, 2
    push rax
    call print
    pop rdx

    push column_separator
    call print
    pop rdx

    push new_line
    call print
    pop rdx
    pop rdx

    mov rsp, rbp        
    pop rbp             
    ret