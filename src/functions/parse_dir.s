    PUSH_ALLr




    mov     rdi, [rbp + 16]
    add     rdi, mydata.path_buffer


    ;lea     rdi, [rel path_buffer]
    xor     rax, rax
    mov     rcx, 64


    NOP
    rep     stosq
    NOP




    mov     rdi, [rbp + 16]
    add     rdi, mydata.path_buffer

    ;lea     rdi, [rel path_buffer]

    mov     rsi, [rbp + 16]
    add     rsi, mydata.proc_prefix

    ;lea     rsi, [rel proc_prefix]
    mov     rcx, 6
    rep     movsb


    mov     rsi, r15

.copy_pid:
    lodsb
    test    al, al
    jz      .pid_done
    stosb
    jmp     .copy_pid
.pid_done:

    mov     rsi, [rbp + 16]
    add     rsi, mydata.comm_path

    ;lea     rsi, [rel comm_path]
    mov     rcx, 6
    rep     movsb

    mov     rax, SYS_open
    mov     rdi, [rbp + 16]
    add     rdi, mydata.path_buffer
    ;lea     rdi, [rel path_buffer]
    xor     rsi, rsi
    xor     rdx, rdx
    syscall

    test    rax, rax
    js      .ret_not_found0
    mov     r8, rax

    mov     rax, SYS_read
    mov     rdi, r8
    mov     rsi, [rbp + 16]
    add     rsi, mydata.comm_buff
    ;lea     rsi, [rel comm_buff]
    mov     rdx, 15
    syscall

    push    rax
    mov     rax, SYS_close
    mov     rdi, r8
    syscall
    pop     rax

    test    rax, rax
    jle     .ret_not_found0

    mov     rdi, [rbp + 16]
    add     rdi, mydata.comm_buff

    ;lea     rdi, [rel comm_buff]
    add     rdi, rax
    mov     byte [rdi], 0

    dec     rdi
    cmp     byte [rdi], 10
    jne     .no_newline
    mov     byte [rdi], 0
.no_newline:

    mov     rsi, [rbp + 16]
    add     rsi, mydata.comm_buff

    ;lea     rsi, [rel comm_buff]
    mov     rdi, [rbp + 16]
    add     rdi, mydata.forbidden_process

    ;lea     rdi, [rel forbidden_process]

    push    rdi
    push    rsi
    push    rdx
    xor     eax, eax
    .loopa:
        mov     al, [rdi]
        mov     dl, [rsi]
        cmp     al, dl
        jne     .diffa
        test    al, al
        je      .donea
        inc     rdi
        inc     rsi
        jmp     .loopa
    .diffa:
        sub     eax, edx
    .donea:
        pop     rdx
        pop     rsi
        pop     rdi

    test    eax, eax
    jz      .found_forbidden

.ret_not_found0:
    xor     rax, rax
    jmp     .retf1

.found_forbidden:
    mov     rax, 1

.retf1:
    POP_ALLr
