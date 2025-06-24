    push rbx
    push rcx
    push rdx

    mov rax, rsi
    mov rbx, 10
    xor rcx, rcx

.divide_loopnumber_to_string:
    xor rdx, rdx
    div rbx
    push rdx
    inc rcx
    test rax, rax
    jnz .divide_loopnumber_to_string

.store_loopnumber_to_string:
    pop rax
    add al, '0'
    mov [rdi], al
    inc rdi
    dec rcx
    jnz .store_loopnumber_to_string

    mov byte [rdi], 0

    pop rdx
    pop rcx
    pop rbx
