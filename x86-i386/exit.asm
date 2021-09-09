global exit

exit:
    mov eax, 0x1
    mov ebx, [esp+4]
    int 0x80