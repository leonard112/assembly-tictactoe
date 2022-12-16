global exit

exit:
    mov eax, 1                                  ; specify exit syscall
    mov ebx, [esp+4]                            ; read return code from stack
    int 0x80